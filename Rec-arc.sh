#!/bin/bash
#
# By -- WRQC343 -- www.gmrs-link.com
#
# Ver 1.5 - 11/25
#
# Midnight WAV Archiver for Multi Nodes
#

# === CONFIGURE HERE ===
# Each triplet is: SOURCE:DEST:NODENAME    Example: "/PATH-TO-YOUR-RECORDINGS/1234/:/PATH-TO-YOUR-BACKUPS/Backups/:node-1234"
FOLDERS=(
    "/etc/asterisk/local/Recordings/1234/:/etc/asterisk/local/Recordings/Backups/:node-1234"
)

DATE=$(date +%Y-%m-%d)

for entry in "${FOLDERS[@]}"; do
    SRC="${entry%%:*}"
    REST="${entry#*:}"
    DEST="${REST%%:*}"
    NODE="${REST##*:}"

    ARCHIVE="$DEST/$DATE-$NODE.zip"

    [ ! -d "$SRC" ] && continue

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
