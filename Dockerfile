# Base image
FROM debian:bookworm-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV WINEDEBUG=-all
ENV WINEPREFIX=/home/dockeruser/.wine

# Install dependencies & Wine
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wine64 \
        wine32 \
        xvfb \
        winbind \
        cabextract \
        unzip \
        wget \
        ca-certificates \
        bash \
        gosu \
        && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m dockeruser
USER dockeruser
WORKDIR /home/dockeruser

# Copy your V Rising server files (or mount later)
COPY VRisingServer/ ./VRisingServer/

# Expose default ports
EXPOSE 9876/udp
EXPOSE 9877/udp

# Run the server via Wine
CMD ["wine64", "./VRisingServer/VRisingServer.exe"]

