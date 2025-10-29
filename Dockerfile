FROM debian:bookworm-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV WINEDEBUG=-all
ENV WINEPREFIX=/home/dockeruser/.wine
ENV APP_ID=1829350
WORKDIR /home/dockeruser/steamcmd

RUN useradd -m -u 2500 -s /bin/bash dockeruser && \
    dpkg --add-architecture i386 && apt-get update && \
    apt-get install -y wine64 wine curl \
        xvfb \
        xauth \
        winbind && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - && \
    chmod +x steamcmd.sh && \
    chown -R 2500:2500 /home/dockeruser && \
    curl -o winetricks \
    https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x winetricks && \
    mv winetricks /usr/local/bin/

USER dockeruser

RUN ./steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir "/home/dockeruser/.wine/drive_c/vrisingserver" \
    +login anonymous \
    +app_update 1829350 validate \
    +quit

USER root
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

USER dockeruser

CMD ["./entrypoint.sh"]