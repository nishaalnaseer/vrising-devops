#!/bin/bash
set -e

mkdir -p /home/dockeruser/persistent/logs
mkdir -p /home/dockeruser/persistent/data

echo "[*] Copying server configs..."
cp /home/dockeruser/ServerHostSettings.json /home/dockeruser/.wine/drive_c/vrisingserver/
cp /home/dockeruser/ServerGameSettings.json /home/dockeruser/.wine/drive_c/vrisingserver/

echo "[*] Launching V Rising Server..."

# Start Xvfb manually with a specific display
Xvfb :99 -screen 0 1024x768x16 -nolisten tcp &
XVFB_PID=$!
export DISPLAY=:99

# Wait for Xvfb
sleep 3

cd /home/dockeruser/.wine/drive_c/vrisingserver
wine VRisingServer.exe \
  -persistentDataPath "Z:/home/dockeruser/persistent/data" \
  -logFile "Z:/home/dockeruser/persistent/logs/vrising.log" \
  -nographics -batchmode

#wine "C:\\vrisingserver\\VRisingServer.exe" \
#  -persistentDataPath "Z:\\home\\dockeruser\\persistent\\data" \
#  -logFile "Z:\\home\\dockeruser\\persistent\\logs\\vrising.log" \
#  -nographics -batchmode
