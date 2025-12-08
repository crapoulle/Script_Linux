#!/bin/bash
# rotate-logs.sh

LOG_DIR="/root/cron-lab/logs"
MAX_SIZE=$((10 * 1024 * 1024)) # 10MB
MAX_FILES=5

rotate_log() {
	local logfile=$1

	if [ ! -f "$logfile" ]; then
		return
	fi


	# Vérifier la taille
	size=$(stat -c%s "$logfile")

	if [ $size -ge $MAX_SIZE ]; then
		echo "Rotation de $logfile (taille: $size octets)"

		# Décaler les anciens logs
		for i in $(seq $((MAX_FILES-1)) -1 1); do
			if [ -f "${logfile}.$i" ]; then
				mv "${logfile}.$i" "${logfile}.$((i+1))"
			fi
		done


		# Compresser et archiver le log actuel
		mv "$logfile" "${logfile}.1"
		gzip "${logfile}.1"

		# Créer un nouveau fichier de log
		touch "$logfile"

		# Supprimer les anciens fichiers
		find "$(dirname $logfile)" -name "$(basename $logfile).*" -type f | \

			sort -r | tail -n +$((MAX_FILES+1)) | xargs rm -f
	fi
}

# Parcourir tous les logs
for log in "$LOG_DIR"/*.log; do
	rotate_log "$log"
done
