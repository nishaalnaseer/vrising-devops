#!/bin/bash
#
winecfg -v win10
xvfb-run -a wine  ./steamcmd.exe \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir "C:\\VRisingServer" \
    +login anonymous \
    +app_update 1829350 validate \
    +quit
cp /home/dockeruser/ServerHostSettings.json /home/dockeruser/.wine/drive_c/vrisingserver/.
cp /home/dockeruser/ServerGameSettings.json /home/dockeruser/.wine/drive_c/vrisingserver/.

xvfb-run -a wine "C:\\vrisingserver\\VRisingServer.exe" \
  -persistentDataPath "Z:\\home\\dockeruser\\persistent\\data" \
  -serverName "My V Rising Server" \
  -logFile "Z:\\home\\dockeruser\\persistent\\logs\\log.txt" \
  -nographics -batchmode