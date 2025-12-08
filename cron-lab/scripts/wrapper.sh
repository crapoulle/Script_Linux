#!/bin/bash
# wrapper.sh - Wrapper pour exécuter des scripts avec logging
SCRIPT_DIR="/root/cron-lab/scripts"
LOG_DIR="/root/cron-lab/logs"
SCRIPT_NAME="$1"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

if [ -z "$SCRIPT_NAME" ]; then
	echo "Usage: $0 <script_name>"
	exit 1
fi

echo "[$TIMESTAMP] Début exécution de $SCRIPT_NAME" >> "$LOG_DIR/wrapper.log"

"$SCRIPT_DIR/$SCRIPT_NAME" >> "$LOG_DIR/${SCRIPT_NAME}.log" 2>&1

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
	echo "[$TIMESTAMP] $SCRIPT_NAME terminé avec succès" >> "$LOG_DIR/wrapper.log"
else
	echo "[$TIMESTAMP] ERREUR - $SCRIPT_NAME a échoué (code: $EXIT_CODE)" >> "$LOG_DIR/wrapper.log"
fi

exit $EXIT_CODE
