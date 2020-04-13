**Application**

[Minecraft Server](https://www.minecraft.net/en-us/download/server/)

[PaperMC](https://papermc.io/)

**Description**

Minecraft is a sandbox video game created by Swedish game developer Markus Persson and released by Mojang in 2011. The game allows players to build with a variety of different blocks in a 3D procedurally generated world, requiring creativity from players. Other activities in the game include exploration, resource gathering, crafting, and combat. Multiple game modes that change gameplay are available, including—but not limited to—a survival mode, in which players must acquire resources to build the world and maintain health, and a creative mode, where players have unlimited resources to build with.


Paper is the next generation of Minecraft server, compatible with Spigot plugins and offering uncompromising performance.

**Build notes**

Latest stable Minecraft release from Arch Linux AUR.

**Usage**
```
docker run -d \
    -p 25565:25565 \
    --name=<container name> \
    -v <path for config files>:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e MAX_BACKUPS=<max number of minecraft backups> \
    -e JAVA_INITIAL_HEAP_SIZE=<java initial heap size in megabytes> \
    -e JAVA_MAX_HEAP_SIZE=<java max heap size in megabytes> \
    -e JAVA_MAX_THREADS=<java max number of threads> \
    -e UMASK=<umask for created files> \
    -e PUID=<uid for user> \
    -e PGID=<gid for user> \
    gwynethstark/arch-papermc
```

Please replace all user variables in the above command defined by <> with the correct values.

**Example**
```
docker run -d \
    -p 25565:25565 \
    --name=papermc \
    -v /apps/docker/minecraftserver:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e MAX_BACKUPS=10 \
    -e JAVA_INITIAL_HEAP_SIZE=1024M \
    -e JAVA_MAX_HEAP_SIZE=2048M \
    -e JAVA_MAX_THREADS=1 \
    -e UMASK=000 \
    -e PUID=0 \
    -e PGID=0 \
    gwynethstark/papermc
```

**Notes**

JAVA_INITIAL_HEAP_SIZE value and JAVA_MAX_HEAP_SIZE values must be a multiple of 1024 and greater than 2MB.

If you want to connect to the minecraft server console then issue the following command, use CTRL+a and then press 'd' to disconnect from the session, leaving it running.

```
docker exec -u nobody -it <name of container> /usr/bin/papermc console
```

User ID (PUID) and Group ID (PGID) can be found by issuing the following command for the user you want to run the container as:-

```
id <username>
```
___
This project is based on [binhex's minecraftserver](https://github.com/binhex/arch-minecraftserver) Docker package.