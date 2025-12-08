#!/bin/bash
# safe-update.sh

LOGFILE="/root/cron-lab/logs/security-updates.log"
CRITICAL_SERVICES=("ssh" "cron" "rsyslog")

log() {
	echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

check_services() {
	local failed=0
	for service in "${CRITICAL_SERVICES[@]}"; do
		if ! systemctl is-active --quiet "$service"; then
			log "ERREUR: Le service $service n'est pas actif"
			failed=1
		fi
	done
	return $failed
}


# Créer un point de restauration (simulation)
log "Création du point de restauration..."
# Ici vous pourriez utiliser LVM snapshots, Timeshift, etc.


# Mettre à jour
log "Début des mises à jour..."
apt update >> "$LOGFILE" 2>&1
apt upgrade -y >> "$LOGFILE" 2>&1

if [ $? -eq 0 ]; then
	log "Mises à jour installées avec succès"
else
	log "ERREUR lors des mises à jour"
	# Logique de restauration
	exit 1
fi



# Vérifier les services critiques
log "Vérification des services critiques..."
if check_services; then
	log "Tous les services critiques sont opérationnels"
	log "Mise à jour terminée avec succès"
else
	log "ALERTE: Certains services critiques sont en échec"
	# Notification d'alerte
	exit 1
fi
