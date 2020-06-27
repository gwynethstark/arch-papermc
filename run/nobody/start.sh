#!/bin/bash

# if spigot folder doesnt exist then copy default to host config volume
if [ ! -d "/config/spigot" ]; then

	echo "[info] spigot folder doesnt exist, copying default to '/config/spigot/'..."

	mkdir -p /config/spigot
	if [[ -d "/srv/craftbukkit" ]]; then
		cp -R /srv/craftbukkit/* /config/spigot/ 2>/dev/null || true
	fi

else

	echo "[info] Spigot folder '/config/spigot' already exists, rsyncing newer files..."
	rsync -rlt --exclude 'world' --exclude '/server.properties' --exclude '/*.json' /srv/craftbukkit/ /config/spigot

fi

if [ ! -f /config/spigot/eula.txt ]; then

	echo "[info] Starting Java (spigot) process to force creation of eula.txt..."
	/usr/bin/spigot start

	echo "[info] Waiting for Minecraft Java process to abort (expected, due to eula flag not set)..."
	while pgrep -fa "java" > /dev/null; do
		sleep 0.1
	done
	echo "[info] Minecraft Java process ended"

	echo "[info] Setting EULA to true..."
	sed -i -e 's~eula=false~eula=true~g' '/config/spigot/eula.txt'
	echo "[info] EULA set to true"

fi

echo "[info] Starting Minecraft Java process..."
/usr/bin/spigot start
echo "[info] Minecraft Java process started, successful start"

# /usr/bin/spigot is daemonised, thus we need to run something in foreground to prevent exit of script
cat