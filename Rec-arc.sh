#!/bin/bash
#
# By -- WRQC343 -- www.gmrs-link.com
#
# Ver 1.5 - 11/25
#
# Midnight WAV Archiver for Multi Nodes
#

# === CONFIGURE HERE ===
# Each triplet is: SOURCE:DEST:NODENAME
FOLDERS=(
    "/etc/asterisk/local/Recordings/1250/:/etc/asterisk/local/Recordings/Backups/:node-1250"
    "/etc/asterisk/local/Recordings/1450/:/etc/asterisk/local/Recordings/Backups/:node-1450"
    "/etc/asterisk/local/Recordings/1550/:/etc/asterisk/local/Recordings/Backups/:node-1550"
    "/etc/asterisk/local/Recordings/1650/:/etc/asterisk/local/Recordings/Backups/:node-1650"
    "/etc/asterisk/local/Recordings/611026/:/etc/asterisk/local/Recordings/Backups/:node-611026"
)

DATE=$(date +%Y-%m-%d)

for entry in "${FOLDERS[@]}"; do
    SRC="${entry%%:*}"
    REST="${entry#*:}"
    DEST="${REST%%:*}"
    NODE="${REST##*:}"

    ARCHIVE="$DEST/$DATE-$NODE.zip"

    # Skip if source folder doesn't exist
    [ ! -d "$SRC" ] && continue

    # Ensure destination exists
    mkdir -p "$DEST"

    cd "$SRC" || continue

    # If WAV files exist, archive & delete them (quiet mode)
    if ls *.WAV 1> /dev/null 2>&1; then
        zip -mq "$ARCHIVE" *.WAV >/dev/null 2>&1
    fi
    # Remove any .txt files
    rm -f *.txt >/dev/null 2>&1

    # Keep Only 5 Most Recent Backups Per Node
    BACKUPS=( $(ls -1t "$DEST"/*"$NODE".zip 2>/dev/null) )

    if [ ${#BACKUPS[@]} -gt 5 ]; then
        OLD_BACKUPS=( "${BACKUPS[@]:5}" )
        for OLD in "${OLD_BACKUPS[@]}"; do
            rm -f "$OLD"
        done
    fi

done
