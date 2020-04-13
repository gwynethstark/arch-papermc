#!/bin/bash

# if papermc folder doesnt exist then copy default to host config volume
if [ ! -d "/config/papermc" ]; then

	echo "[info] papermc folder doesnt exist, copying default to '/config/papermc/'..."

	mkdir -p /config/papermc
	if [[ -d "/srv/papermc" ]]; then
		cp -R /srv/papermc/* /config/papermc/ 2>/dev/null || true
	fi

else

	echo "[info] PaperMC folder '/config/papermc' already exists, rsyncing newer files..."
	rsync -rlt --exclude 'world' --exclude '/server.properties' --exclude '/*.json' /srv/papermc/ /config/papermc

fi

if [ ! -f /config/papermc/eula.txt ]; then

	echo "[info] Starting Java (papermc) process to force creation of eula.txt..."
	/usr/bin/papermc start

	echo "[info] Waiting for Minecraft Java process to abort (expected, due to eula flag not set)..."
	while pgrep -fa "java" > /dev/null; do
		sleep 0.1
	done
	echo "[info] Minecraft Java process ended"

	echo "[info] Setting EULA to true..."
	sed -i -e 's~eula=false~eula=true~g' '/config/papermc/eula.txt'
	echo "[info] EULA set to true"

fi

echo "[info] Starting Minecraft Java process..."
/usr/bin/papermc start
echo "[info] Minecraft Java process started, successful start"

# /usr/bin/papermc is daemonised, thus we need to run something in foreground to prevent exit of script
cat