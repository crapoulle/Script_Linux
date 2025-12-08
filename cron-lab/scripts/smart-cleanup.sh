#!/bin/bash
# smart-cleanup.sh

LOGFILE="/root/cron-lab/logs/smart-cleanup.log"
REPORT="/root/cron-lab/reports/smartcleanup_report_$(date +%Y%m%d).txt"


# Fonction pour obtenir l'espace disque

get_disk_usage() {
	df -h / | awk 'NR==2 {print $3}'
}


# Espace avant nettoyage

SPACE_BEFORE=$(get_disk_usage)

{
	echo "=== RAPPORT DE NETTOYAGE ==="
	echo "Date: $(date)"
	echo "Espace utilisé avant: $SPACE_BEFORE"
	echo ""

	# Nettoyer /tmp
	echo "--- Nettoyage de /tmp ---"
	find /tmp -type f -atime +7 -delete 2>/dev/null
	echo "Fichiers temporaires supprimés"
	echo ""

	# Nettoyer apt cache
	echo "--- Nettoyage du cache APT ---"
	apt clean
	apt autoremove -y
	echo ""


	# Nettoyer journaux
	echo "--- Nettoyage des journaux ---"
	journalctl --vacuum-time=30d
	find /var/log -type f -name "*.gz" -mtime +30 -delete 2>/dev/null
	echo ""


	# Nettoyer anciens kernels (garder 2)
	echo "--- Nettoyage des anciens kernels ---"
	# À COMPLÉTER : logique pour supprimer anciens kernels
	echo ""


	# Espace après nettoyage
	SPACE_AFTER=$(get_disk_usage)
	echo "=== RÉSUMÉ ==="
	echo "Espace utilisé après: $SPACE_AFTER"


} | tee "$REPORT" >> "$LOGFILE"
