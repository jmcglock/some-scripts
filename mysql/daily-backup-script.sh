#!/bin/bash

# Early exit on any error
set -e

# Accept credentials via environment variables for better security
DB_USER=${MYSQL_USER:-defaultuser}
DB_PASSWORD=${MYSQL_PASSWORD:-defaultpassword}

# You can also accept them as separate arguments if you prefer
# DB_USER=$1
# DB_PASSWORD=$2

# Set the directory where the backup files should be stored
BACKUP_DIRECTORY="/var/lib/mysql-backups"

# Ensure the backup directory exists
mkdir -p "$BACKUP_DIRECTORY"

# Set the names of the databases that you want to back up
DATABASE_NAMES=("test" "test1" "test2" "test3")

# Backup each database
for DATABASE_NAME in "${DATABASE_NAMES[@]}"; do
    # Set the name of the backup file
    BACKUP_FILE="mysql_backup_${DATABASE_NAME}_$(date +'%Y-%m-%d_%H-%M-%S').sql"
    BACKUP_PATH="${BACKUP_DIRECTORY}/${BACKUP_FILE}.gz"

    # Run mysqldump and compress output to gzipped file directly
    mysqldump -u "$DB_USER" -p"$DB_PASSWORD" "$DATABASE_NAME" | gzip > "$BACKUP_PATH"
    
    # Optional: verify successful backup and non-empty file
    if [ $? -eq 0 ] && [ -s "$BACKUP_PATH" ]; then
        echo "Backup of database '${DATABASE_NAME}' was successful."
    else
        echo "Backup of database '${DATABASE_NAME}' failed." >&2
        exit 1
    fi
done

echo "All backups completed successfully."