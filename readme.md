# Vrising DevOps

### Whats that you dont want to run a game server on windows? Well i got just the thing for you: Linux ⮕ Docker ⮕ Wine ⮕ VRISING
### This wont run on WSL. Don't ask me why

## Installing Docker
### Install Docker from https://docs.docker.com/engine/install/debian/

## Pre build

### Docker is not built for persistent data and in particular, heavy write and what you essentially want to do, if you want to be serious is to create a volume and bind it to the container
```bash
sudo docker volume create vrising
```

### The image will create a non root user called dockeruser(I know, im very imaginative), with uid 2500 so we need to give that user the right permissions.
```bash
sudo su
chown -R 2500:2500 /var/lib/docker/volumes/vrising/_data
```
### If this uid conflicts with an id on your machine you can change it in the image, but make sure to make chown it

sudo docker run -itd \
  --name vrising \
  -p 9876:9876/udp \
  -p 9877:9877/udp \
  -v vrising:/home/dockeruser/persistent \
  -v ./ServerHostSettings.json:/home/dockeruser/ServerHostSettings.json \
  -v ./ServerGameSettings.json:/home/dockeruser/ServerGameSettings.json \
  vrising

sudo docker volume create vrising
create dirs data and logs inside vrising volume
chown the volume