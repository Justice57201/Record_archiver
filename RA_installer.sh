#!/bin/bash
#
# By -- WRQC343 -- www.gmrs-link.com
#
# Ver 1.0 - 
#

# ===== CONFIGURE THIS URL =====
SCRIPT_URL="https://raw.githubusercontent.com/Justice57201/Record_archiver/main/Rec-arc.sh"

# Must be root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

echo "Downloading Rec-arc.sh..."
curl -fsSL "$SCRIPT_URL" -o /root/Rec-arc.sh
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to download Rec-arc.sh"
    exit 1
fi

chmod +x /root/Rec-arc.sh

echo "Installing cron job..."
# Remove any existing job
crontab -l | grep -v "Rec-arc.sh" > /tmp/cron_tmp 2>/dev/null
echo "59 23 * * * /root/Rec-arc.sh" >> /tmp/cron_tmp
crontab /tmp/cron_tmp
rm -f /tmp/cron_tmp

echo "Installation complete."
