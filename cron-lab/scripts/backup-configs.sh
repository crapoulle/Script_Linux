### sauvegarde quotidienne des configs systemes
#!/bin/bash
# backup-configs.sh
BACKUP_DIR="/root/cron-lab/backup"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="etc_backup_${TIMESTAMP}.tar.gz"
LOGFILE="/root/cron-lab/logs/backup.log"

echo "$(date): Début de la sauvegarde" >> "$LOGFILE"

# Créer la sauvegarde
sudo tar -czf "${BACKUP_DIR}/${BACKUP_FILE}" /etc 2>> "$LOGFILE"

if [ $? -eq 0 ]; then
	echo "$(date): Sauvegarde réussie - ${BACKUP_FILE}" >> "$LOGFILE"
else
	echo "$(date): ERREUR lors de la sauvegarde" >> "$LOGFILE"
	exit 1
fi

# Nettoyer les anciennes sauvegardes (garder 7 dernières)
cd "$BACKUP_DIR"
ls -t etc_backup_*.tar.gz | tail -n +8 | xargs rm -f 2>/dev/null

echo "$(date): Nettoyage effectué" >> "$LOGFILE"
