FROM debian:bookworm-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV WINEDEBUG=-all
ENV WINEPREFIX=/home/dockeruser/.wine
ENV APP_ID=1829350
WORKDIR /home/dockeruser/steamcmd

# Install dependencies & Wine
RUN useradd -m -u 2500 -s /bin/bash dockeruser \
    && dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wine64 \
        wine32 \
        wine \
        xvfb \
        xauth \
        winbind \
        cabextract \
        unzip \
        wget \
        ca-certificates \
        bash \
        gosu \
        libc6:i386 \
        libgcc-s1:i386 \
        libstdc++6:i386 \
        libx11-6:i386 \
        libxext6:i386 \
        libxrender1:i386 \
        libxrandr2:i386 \
        libfreetype6:i386 \
        libglu1-mesa:i386 \
        && rm -rf /var/lib/apt/lists/* \
        && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip \
        && unzip steamcmd \
        && chown -R dockeruser:dockeruser /home/dockeruser \
        && ln -s /usr/bin/wine64 /usr/local/bin/wine64 \
        && wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
        chmod +x winetricks && \
        mv winetricks /usr/local/bin/ && \
        mkdir -p /home/dockeruser/.wine \
        && chown -R dockeruser:dockeruser /home/dockeruser/.wine && \
        rm steamcmd.zip

# Copy your V Rising server files (or mount later)
USER dockeruser

RUN rm -rf ~/.wine && \
        WINEARCH=win64 WINEPREFIX=/home/dockeruser/.wine wineboot && \
        winecfg -v win10 && \
        winetricks -q dotnet48 && \
        winecfg -v win10

USER root
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

USER dockeruser

CMD ["./entrypoint.sh"]