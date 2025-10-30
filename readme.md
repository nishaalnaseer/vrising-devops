<h1 align="center">VRising Dedicated Server DevOps 🧛‍♀️🧛</h1>
Whats that you dont want to run a game server on windows? Well I got just 
the thing for you: Linux ⮕ Docker ⮕ Wine ⮕ VRISING. This won't run on WSL. 
Don't ask me why

<h2 align="center">Installing Docker 🐋</h2>
Install Docker from https://docs.docker.com/engine/install/debian/

<h2 align="center">Building docker image 🛠️</h2>

```bash
sudo docker buildx build . -t vrising
```

<h2 align="center">Setting up data directories</h2>

Docker is not designed for persistent data, especially heavy write
operations. If you want to be serious about this, you should create a
volume and bind it to the container.


The image will create a non root user called dockeruser(I know, im very 
imaginative), with uid 2500 so we need to give that user the right 
permissions.
```bash
sudo su
chown -R 2500:2500 /var/lib/docker/volumes/vrising/_data
```
If this uid conflicts with an id on your machine you can change it in 
the image, but make sure to make chown it

<h2 align="center">Running the service ᯓ🏃🏻‍♀️‍➡️</h2>

This should take a few minutes as this will update steam and download 
VRising Dedicated Server.
```bash
sudo docker compose up -d
```
Edit ```compose.yaml```'s ```cpus:``` to a desired value as VRising with 
wine, xvfb and docker froze my SSH connection and other processes on host. 
So you might want to restrict it.
By default, as per the current compose file, it will give 2 virtual cores

<h2 align="center">Data 💾</h2>
View logs at 
```bash
/var/lib/docker/volumes/vrising/_data/logs
```
Save files at  
```bash
/var/lib/docker/volumes/vrising/_data/data
```