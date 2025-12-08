# --- Fichier log horodaté ---
LOGFILE="/root/auth-lab/reports/script_bulk_log_$(date '+%Y%m%d_%H%M%S').log"

# --- Fonction de log ---
log() {
    local level="$1"; shift
    local message="$*"
    local now
    now="$(date '+%Y-%m-%d %H:%M:%S')"

    # Enregistre le message dans le fichier et l affiche à l ecran
    echo "${now} [${level}] ${message}" | tee -a "$LOGFILE"
}

set -x

CSVFILE="userstestcsv.csv"

# Ignorer la première ligne (en-tête)
tail -n +2 "$CSVFILE" | while IFS=',' read -r username fullname department groups
do
    echo "Création de l'utilisateur : $username"

    # Appel du script de l'exercice 1.3
    ./userscorrige.sh "$username" "$fullname" "$department" "$groups"


### log des actions et erreurs

   # --- Utilisateur existant ---
    if getent passwd "$username" >/dev/null; then
        log "INFO" "Utilisateur existant : $username"
        echo "$username,SKIPPED,already_exists,$(date '+%Y-%m-%d %H:%M:%S')" >> "$LOGFILE"
        continue
    fi

    # --- Création utilisateur ---
    if ! useradd -m -c "$fullname" "$username" &>>"$LOGFILE"; then
        log "ERROR" "Échec création utilisateur $username"
        echo "$username,FAILED,useradd_error,$(date '+%Y-%m-%d %H:%M:%S')" >> "$LOGFILE"
        continue
    fi

    log "INFO" "Utilisateur créé : $username"
    echo "$username,CREATED,ok,$(date '+%Y-%m-%d %H:%M:%S')" >> "$LOGFILE"


log "INFO" "Traitement terminé."

done


