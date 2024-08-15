<h1 align="center">passWifi - Scripts para Ataques de Deauth y Captura de Hashcap</h1>

<p align="center">
  <img src="https://github.com/Gerijacki.png" width="100" alt="Logo"/><br/>
  Hi 👋, I'm <a href="https://github.com/Gerijacki">Gerijacki</a>
</p>

<p align="center">
  <a href="https://github.com/Gerijacki/passWifi/stargazers"><img src="https://img.shields.io/github/stars/Gerijacki/passWifi?colorA=363a4f&colorB=b7bdf8&style=for-the-badge"></a>
  <a href="https://github.com/Gerijacki/passWifi/issues"><img src="https://img.shields.io/github/issues/Gerijacki/passWifi?colorA=363a4f&colorB=f5a97f&style=for-the-badge"></a>
  <a href="https://github.com/Gerijacki/passWifi/contributors"><img src="https://img.shields.io/github/contributors/Gerijacki/passWifi?colorA=363a4f&colorB=a6da95&style=for-the-badge"></a>
</p>

## Introducción

**passWifi** es un conjunto de scripts diseñados para realizar ataques de deautenticación (deauth) a puntos de acceso (AP) y capturar hashcaps para su posterior desencriptación. Estos scripts están destinados a pruebas de seguridad en redes Wi-Fi dentro de un entorno controlado y legal.

## Advertencia Legal

El uso de estos scripts para realizar ataques de deauth o capturar hashcaps en redes o dispositivos sin el consentimiento expreso del propietario es ilegal y puede tener graves consecuencias legales. Este proyecto se proporciona únicamente con fines educativos. El autor no se hace responsable del uso indebido de la información proporcionada.

## Requisitos Previos

- Una máquina con Debian o derivada.
- Acceso de superusuario (root) o permisos `sudo`.
- Una tarjeta de red Wi-Fi compatible con el modo monitor.
- Herramientas de airecrack-ng instaladas (`airmon-ng`, `aireplay-ng`, `airodump-ng`).

## Instalación

Para instalar **passWifi** y configurar las herramientas necesarias, sigue estos pasos:

### Paso 1: Actualizar los Repositorios

Primero, actualiza los repositorios de tu sistema:

```bash
sudo apt update
```

### Paso 2: Instalar Aircrack-ng

Instala el paquete completo de `aircrack-ng`, que incluye `airmon-ng`, `aireplay-ng`, `airodump-ng`, entre otras herramientas:

```bash
sudo apt install aircrack-ng
```

### Paso 3: Clonar el Repositorio

Clona el repositorio **passWifi** desde GitHub:

```bash
git clone https://github.com/Gerijacki/passWifi.git
cd passWifi
```

### Paso 4: Dar Permisos de Ejecución

Da permisos de ejecución a los scripts incluidos:

```bash
chmod +x deauth.sh hashcap.sh
```

## Uso de los Scripts

### Script de Deauth Total (`deauth.sh`)

El script `deauth.sh` realiza un ataque de deautenticación a todos los dispositivos conectados a un punto de acceso (AP) o a un dispositivo específico.

1. Ejecuta el script:

   ```bash
   sudo ./deauth.sh
   ```

2. Sigue las instrucciones para:
   - Introducir el nombre de la interfaz Wi-Fi.
   - Habilitar el modo monitor.
   - Escanear redes Wi-Fi y seleccionar el AP objetivo.
   - Realizar el ataque de deauth a todos los dispositivos o a uno específico.

### Script de Captura de Hashcap (`hashcap.sh`)

El script `hashcap.sh` realiza un ataque de deauth y captura un hashcap para su posterior desencriptación.

1. Ejecuta el script:

   ```bash
   sudo ./hashcap.sh
   ```

2. Sigue las instrucciones para:
   - Introducir el nombre de la interfaz Wi-Fi.
   - Habilitar el modo monitor.
   - Escanear redes Wi-Fi y seleccionar el AP objetivo.
   - Capturar el handshake y, opcionalmente, realizar un ataque de deauth para forzar la captura.
   - Verificar y desencriptar el handshake utilizando un diccionario.

## Deshabilitar el Modo Monitor

Cuando hayas terminado con el uso de los scripts, desactiva el modo monitor y vuelve al modo gestionado:

```bash
sudo airmon-ng stop wlan0mon
```

Reemplaza `wlan0mon` con el nombre de tu interfaz en modo monitor si es diferente.

## Conclusión

Has aprendido cómo utilizar los scripts de **passWifi** para realizar ataques de deauth y capturar hashcaps en una máquina Debian. Recuerda siempre actuar dentro de los límites de la ley y usar este conocimiento de manera ética.

---

<p align="center">
  <a href="https://github.com/Gerijacki">
    <img src="https://github-readme-stats.vercel.app/api?username=Gerijacki&show_icons=true&theme=dark&count_private=true" alt="GitHub Stats" />
  </a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/Trilokia/Trilokia/379277808c61ef204768a61bbc5d25bc7798ccf1/bottom_header.svg" />
</p>
