#!/bin/bash
# monitoring-dashboard.sh

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

clear

while true; do
	clear
	echo -e
"${BLUE}╔════════════════════════════════════════════════════╗${NC}"
	echo -e "${BLUE}║ DASHBOARD DE MONITORING - SecureTech ║${NC}"
	echo -e
"${BLUE}╚════════════════════════════════════════════════════╝${NC}"
	echo ""


	# Uptime
	echo -e "${GREEN}■ Uptime:${NC} $(uptime -p)"
	echo ""


	# CPU
	cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
	echo -e "${GREEN}■ CPU:${NC} ${cpu_usage}%"



# Mémoire
	mem_info=$(free -h | awk 'NR==2{printf "Utilisée: %s/%s (%.2f%%)", $3,$2,$3*100/$2}')
	echo -e "${GREEN}■ Mémoire:${NC} $mem_info"

# Disque
	echo -e "${GREEN}■ Disque:${NC}"
	df -h / /home | tail -2 | awk '{printf " %s: %s/%s (%s)\n", $6, $3, $2, $5}'
	echo ""


	# Charge système
	load=$(uptime | awk -F'load average:' '{print $2}')
	echo -e "${GREEN}■ Charge système:${NC}$load"
	echo ""


	# Tâches cron
	echo -e "${GREEN}■ Prochaines exécutions:${NC}"
	systemctl list-timers --no-pager | head -5 | tail -4
	echo ""


	# Dernières alertes
	echo -e "${YELLOW}■ Dernières alertes:${NC}"
	tail -5 /root/cron-lab/logs/*-check.log 2>/dev/null | grep "ALERTE" || echo " Aucune alerte récente"
	sleep 5
done
