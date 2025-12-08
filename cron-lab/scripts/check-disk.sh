#!/bin/bash

THRESHOLD=5
LOGFILE="/root/cron-lab/logs/disk-check.log"

while read -r output; do
    usage=$(echo "$output" | awk '{print $1}' | sed 's/%//')
    partition=$(echo "$output" | awk '{print $2}')

    if [ "$usage" -ge "$THRESHOLD" ]; then
        echo "$(date): ALERTE - $partition utilise ${usage}%" >> "$LOGFILE"
    fi
done < <(
    df -h | grep -vE '^(Filesystem|tmpfs|cdrom)' | awk '{print $5 " " $6}'
)

echo "fini"
echo "output = $output"
echo "usage = $usage"
echo "threshold = $THRESHOLD"
echo "logfile = $LOGFILE"
echo "partition = $partition"

if [ $usage -ge $THRESHOLD ]; then
	/root/cron-lab/scripts/alert-system.sh critical "Partition $partition à ${usage}%"
fi
