#!/bin/bash
set -e

mkdir -p /home/dockeruser/persistent/logs
mkdir -p /home/dockeruser/persistent/data

echo "[*] Configuring Wine..."
winecfg -v win10

echo "[*] Installing V Rising Dedicated Server via SteamCMD..."
xvfb-run -a wine ./steamcmd.exe \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir "C:\\VRisingServer" \
    +login anonymous \
    +app_update 1829350 validate \
    +quit

echo "[*] Copying server configs..."
cp /home/dockeruser/ServerHostSettings.json /home/dockeruser/.wine/drive_c/vrisingserver/ || true
cp /home/dockeruser/ServerGameSettings.json /home/dockeruser/.wine/drive_c/vrisingserver/ || true

echo "[*] Launching V Rising Server..."
xvfb-run -a wine "C:\\vrisingserver\\VRisingServer.exe" \
  -persistentDataPath "Z:\\home\\dockeruser\\persistent\\data" \
  -serverName "My V Rising Server" \
  -logFile "Z:\\home\\dockeruser\\persistent\\logs\\vrising.log" \
  -nographics -batchmode


cat <<EOF > entrypoint.sh
#!/bin/bash
set -e

mkdir -p /home/dockeruser/persistent/logs
mkdir -p /home/dockeruser/persistent/data

echo "[*] Configuring Wine..."
winecfg -v win10

echo "[*] Installing V Rising Dedicated Server via SteamCMD..."
xvfb-run -a wine ./steamcmd.exe \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir "C:\\VRisingServer" \
    +login anonymous \
    +app_update 1829350 validate \
    +quit

echo "[*] Copying server configs..."
cp /home/dockeruser/ServerHostSettings.json /home/dockeruser/.wine/drive_c/vrisingserver/ || true
cp /home/dockeruser/ServerGameSettings.json /home/dockeruser/.wine/drive_c/vrisingserver/ || true

echo "Starting Xvfb"
Xvfb :0 -screen 0 1024x768x16 &
echo "Launching wine64 V Rising"
echo " "

echo "[*] Launching V Rising Server..."
DISPLAY=:0.0 wine "C:\\vrisingserver\\VRisingServer.exe" \
  -persistentDataPath "Z:\\home\\dockeruser\\persistent\\data" \
  -serverName "My V Rising Server" \
  -logFile "Z:\\home\\dockeruser\\persistent\\logs\\log.txt" \
  -nographics -batchmode -headless
EOF