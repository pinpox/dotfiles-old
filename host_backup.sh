#!/bin/bash
SERVER=sellerie
REPOSITORY=binaryplease@$SERVER:/mnt/backup/borgbackup/'{hostname}'
echo "Using repository $REPOSITORY"
export BORG_PASSCOMMAND="pass show borg/`hostname`"
echo $BORG_PASSCOMMAND

# Check for root
if [ "$EUID" -ne 0 ]
then echo "Please run as root"
	exit
fi

if ping -c1 -W1 sellerie; then
	echo "Backup server $server is reachable, continuing"
else
	echo "Backup server $server is down, exiting."
	exit
fi

# Backup list of installes packages
echo "Creating package list..."
pacman -Qe > /home/binaryplease/installed_packages_list.txt

echo "Creating backup..."
borg create -v --progress --stats \
	--compression lz4 \
	$REPOSITORY::'{hostname}-{now:%Y-%m-%d}' \
	/etc \
	/home \
	/root \
	--exclude '/home/*/.config/chromium' \
	--exclude '/home/*/.local/share/Trash' \
	--exclude '/home/*/.cache' \
	--exclude '*.pyc'

echo "Deleting old backups..."
borg prune -v $REPOSITORY --prefix '{hostname}-' --keep-daily=3 --keep-weekly=2 --keep-monthly=6

echo "Deleting package list..."
rm -rf /home/binaryplease/installed_packages_list.txt

