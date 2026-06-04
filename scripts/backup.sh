#!/bin/bash
# Restic backup of /mnt/pve/almacenamiento/datos to Google Drive via rclone
# Runs nightly at 03:00 via crontab (root): 00 03 * * * /root/backup.sh >> /var/log/restic_backup.log 2>&1
# Repository: rclone:gdrive:Backups/Cerebro
# Retention: 7 daily + 4 weekly snapshots

export RCLONE_TRANSFERS=4
export RCLONE_CHECKERS=8
export RCLONE_TPSLIMIT=10
export RCLONE_DRIVE_CHUNK_SIZE=64M

restic -r rclone:gdrive:Backups/Cerebro -p /root/scripts/.restic_pw \
  backup /mnt/pve/almacenamiento/datos --tag "cron-auto" -q

restic -r rclone:gdrive:Backups/Cerebro -p /root/scripts/.restic_pw \
  forget --keep-daily 7 --keep-weekly 4 --prune -q
