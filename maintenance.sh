#!/bin/bash

####script_de_maintenance###


LOGFILE="/var/log/maintenance.log"
HTML_REPORT="/var/www/html/maintenance.html"
BACKUP_DIR="/root/sys_backup_$(date +%F)"
DATE="$(date '+%Y-%m-%d %H:%M:%S')"

mkdir -p "$(dirname $LOGFILE)"

log() {
    echo "[$DATE] $1" | tee -a "$LOGFILE"
}

log "===== Début de la maintenance ====="

############################################
# 1. Vérifications système
############################################

# Espace disque
disk_use=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$disk_use" -gt 80 ]; then
    log "ALERTE : Utilisation disque = $disk_use% (>80%)"
else
    log "OK : Utilisation disque = $disk_use%"
fi

# Mémoire
mem_use=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100)}')
if [ "$mem_use" -gt 90 ]; then
    log "ALERTE : Utilisation mémoire = $mem_use% (>90%)"
else
    log "OK : Utilisation mémoire = $mem_use%"
fi

# Services critiques
services=("ssh" "cron" "systemd-networkd")

for s in "${services[@]}"; do
    if systemctl is-active --quiet "$s"; then
        log "OK : Service $s actif"
    else
        log "ALERTE : Service $s inactif"
    fi
done

# Mises à jour disponibles
updates=$(apt-get -s upgrade | grep "upgraded," | awk '{print $1}')
log "Mises à jour disponibles : $updates"

############################################
# 2. Actions de maintenance
############################################

# Nettoyage des logs > 30 jours
log "Nettoyage des logs anciens..."
find /var/log -type f -mtime +30 -exec rm -f {} \;

# Nettoyage cache système
log "Nettoyage du cache apt..."
apt-get clean

# Vérification permissions
log "Vérification des permissions critiques..."
chmod 600 /etc/shadow
chmod 644 /etc/passwd

# Sauvegarde configuration système
log "Backup configuration dans $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cp -r /etc "$BACKUP_DIR"

############################################
# 3. Reporting
############################################

# Simulation d’envoi d'email
log "Simulation : envoi du rapport par email à admin@example.com"

# Dashboard HTML
log "Génération du tableau de bord HTML..."
mkdir -p /var/www/html

cat > "$HTML_REPORT" <<EOF
<html>
<head><title>Maintenance Report</title></head>
<body>
<h1>Rapport de maintenance</h1>
<p>Date : $DATE</p>
<ul>
<li>Utilisation disque : $disk_use%</li>
<li>Utilisation mémoire : $mem_use%</li>
<li>Mises à jour disponibles : $updates</li>
</ul>
<p>Voir le log complet : /var/log/maintenance.log</p>
</body>
</html>
EOF

log "Rapport HTML généré : $HTML_REPORT"

############################################
# 4. Configuration CRON
############################################

CRON_LINE="0 2 * * * root /usr/local/bin/maintenance.sh"

if ! grep -q "maintenance.sh" /etc/crontab; then
    echo "$CRON_LINE" >> /etc/crontab
    log "Cron configuré pour 2h00 chaque jour."
else
    log "Cron déjà configuré."
fi

log "===== Fin de la maintenance ====="
