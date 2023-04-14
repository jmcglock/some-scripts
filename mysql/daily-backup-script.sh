#!/bin/bash
# Set the username and password for the MySQL server
MYSQL_CREDENTIALS=$1
# Set the names of the databases that you want to back up
DATABASE_NAMES=(test test1 test2 test3)
# Set the directory where the backup files should be stored
BACKUP_DIRECTORY=/var/lib/mysql-backups
# Create a backup of each database
for DATABASE_NAME in "${DATABASE_NAMES[@]}"
do
# Set the name of the backup file
BACKUP_FILE=mysql_backup_${DATABASE_NAME}$(date +'%Y-%m-%d%H-%M-%S').sql
# Create a backup of the database
mysqldump -u $MYSQL_CREDENTIALS $DATABASE_NAME > $BACKUP_FILE
# Compress and move the backup file to the backup directory
gzip $BACKUP_FILE && mv $BACKUP_FILE.gz $BACKUP_DIRECTORY
done