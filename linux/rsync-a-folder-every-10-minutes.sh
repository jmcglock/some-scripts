#!/bin/bash

# Set the source and destination directories for the rsync command
SRC_DIR="/path/to/source/directory"
DST_DIR="/path/to/destination/directory"

# Set the delay between rsync commands
DELAY=600 # 10 minutes in seconds

# Log file path
LOG_FILE="/path/to/rsync_log.log"

# Check if the source and destination directories are valid
if [ ! -d "$SRC_DIR" ]; then
    echo "Source directory $SRC_DIR does not exist."
    exit 1
fi

if [ ! -d "$DST_DIR" ]; then
    echo "Destination directory $DST_DIR does not exist."
    exit 1
fi

# Trap interrupt signal (Ctrl+C) and stop the loop
trap 'echo -e "\nSync process interrupted. Exiting..."; exit' INT

# Use a loop to run the rsync command at the defined delay
while true; do
    rsync -avz "$SRC_DIR" "$DST_DIR" >> "$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        echo "rsync encountered an error. Check $LOG_FILE for details." >&2
    fi
    sleep "$DELAY"
done