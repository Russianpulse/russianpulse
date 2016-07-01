#!/bin/sh


echo "`date`: Dump DB.." >> /var/log/backup.log
pg_dump -Fc --no-acl --no-owner -U postgres -h db  $BACKUP_DB_NAME > /backup/database.dump

echo "`date`: Uploading to FTP.." >> /var/log/backup.log

export PASSPHRASE=$BACKUP_PASSPHRASE

duplicity /backup/database.dump $BACKUP_FTP_URL$BACKUP_FTP_DIR --allow-source-mismatch --full-if-older-than=7D

echo "`date`: Done!" >> /var/log/backup.log
