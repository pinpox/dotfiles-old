#!/bin/bash

REPOSITORY=binaryplease@sellerie:/mnt/backup/borgbackup/'{hostname}'

# Backup list of installes packages
echo "Creating package list"
pacman -Qe > /home/binaryplease/installed_packages_list.txt

# Backup all of /home and /var/www except a few
# excluded directories
echo "Creating backup"
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

echo "deleting old backups"
borg prune -v $REPOSITORY --prefix '{hostname}-' --keep-daily=3 --keep-weekly=2 --keep-monthly=6
