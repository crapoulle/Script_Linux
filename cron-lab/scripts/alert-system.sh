#!/bin/bash
#alert-system.sh

ALERT_LOG="/root/cron-lab/logs/alerts.log"
ALERT_LEVEL=$1 # info, warning, critical
ALERT_MESSAGE=$2

# Couleurs pour les niveaux
case $ALERT_LEVEL in
	info)
		PREFIX="[INFO]"
		;;
	warning)
		PREFIX="[WARNING]"
		;;
 	critical)
 		PREFIX="[CRITICAL]"
 		;;
 	*)
 		PREFIX="[UNKNOWN]"
 		;;
esac

# Logger l'alerte
echo "[$(date +'%Y-%m-%d %H:%M:%S')] $PREFIX $ALERT_MESSAGE" >> "$ALERT_LOG"

# Notifier selon le niveau
case $ALERT_LEVEL in
 	critical)
 		# Simulation d'envoi d'email
 		echo "EMAIL CRITIQUE envoyé: $ALERT_MESSAGE" >> "$ALERT_LOG"
 		# En production: mail -s "ALERTE CRITIQUE" admin@securtech.com <<<
"$ALERT_MESSAGE"
 	;;
 	warning)
# Log dans un fichier spécial

		echo "$ALERT_MESSAGE" >> "/root/cron-lab/logs/warnings.log"
 	;;
esac
