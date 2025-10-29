#!/bin/bash
set -e

mkdir -p /home/dockeruser/persistent/logs
mkdir -p /home/dockeruser/persistent/data

echo "[*] Configuring Wine..."
winecfg -v win10

echo "[*] Installing V Rising Dedicated Server via SteamCMD..."
xvfb-run -a wine ./steamcmd.exe \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir "C:\\vrisingserver" \
    +login anonymous \
    +app_update 1829350 validate \
    +quit || true

echo "[*] Copying server configs..."
cp /home/dockeruser/ServerHostSettings.json /home/dockeruser/.wine/drive_c/vrisingserver/ || true
cp /home/dockeruser/ServerGameSettings.json /home/dockeruser/.wine/drive_c/vrisingserver/ || true

echo "[*] Launching V Rising Server..."

# Start Xvfb manually with a specific display
Xvfb :99 -screen 0 1024x768x16 &
XVFB_PID=$!
export DISPLAY=:99

# Give Xvfb time to start
sleep 2

wine "C:\\vrisingserver\\VRisingServer.exe" \
  -persistentDataPath "Z:\\home\\dockeruser\\persistent\\data" \
  -logFile "Z:\\home\\dockeruser\\persistent\\logs\\vrising.log" \
  -nographics -batchmode