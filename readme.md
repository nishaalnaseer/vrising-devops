# Vrising DevOps

### Whats that you dont want to run a game server on windows? Well i got just the thing for you: Linux ⮕ Docker ⮕ Wine ⮕ VRISING
### This wont run on WSL. Don't ask me why

## Installing Docker
### Install Docker from https://docs.docker.com/engine/install/debian/

## Building docker image

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

## Running the service

### This should take a few minutes as this will update steam and download VRising Dedicated Server.
```bash
sudo docker compose up -d
```
### Edit ```compose.yaml```'s ```cpus:``` to a desired value as VRising with wine, xvfb and docker froze my SSH connection and other processes on host. So you might want to restrict it.
### By default as per the current compose file it will give 2 virtual cores


## Data
### View logs at ```/var/lib/docker/volumes/vrising/_data/logs```

### Game files at  ```/var/lib/docker/volumes/vrising/_data/data```