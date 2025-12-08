####Sqlite

#!/bin/bash

DB="servers.db"

# Initialisation de la base si elle n’existe pas
if [ ! -f "$DB" ]; then
    sqlite3 "$DB" "
    CREATE TABLE servers (
        id INTEGER PRIMARY KEY,
        hostname TEXT UNIQUE,
        ip TEXT,
        os TEXT,
        status TEXT,
        last_check TIMESTAMP
    );
    "
fi

# ----- Fonction : Ajouter un serveur -----
add_server() {
    hostname="$1"
    ip="$2"
    os="$3"

    sqlite3 "$DB" "
        INSERT INTO servers (hostname, ip, os, status, last_check)
        VALUES ('$hostname', '$ip', '$os', 'unknown', datetime('now'));
    "
    echo "Serveur ajouté : $hostname"
}

# ----- Fonction : Lister les serveurs -----
list_servers() {
    sqlite3 -column -header "$DB" "SELECT * FROM servers;"
}

# ----- Fonction : Mettre à jour le statut -----
update_status() {
    hostname="$1"
    new_status="$2"

    sqlite3 "$DB" "
        UPDATE servers
        SET status='$new_status', last_check=datetime('now')
        WHERE hostname='$hostname';
    "

    echo "Statut mis à jour : $hostname → $new_status"
}

# ----- Fonction : Rapport par OS -----
report_os() {
    sqlite3 -column -header "$DB" "
        SELECT os, COUNT(*) AS total
        FROM servers
        GROUP BY os;
    "
}

# ----- Fonction : Supprimer un serveur -----
delete_server() {
    hostname="$1"

    sqlite3 "$DB" "
        DELETE FROM servers WHERE hostname='$hostname';
    "
    echo "Serveur supprimé : $hostname"
}

# ----- Interface CLI -----
case "$1" in
    add)
        add_server "$2" "$3" "$4"
        ;;
    list)
        list_servers
        ;;
    status)
        update_status "$2" "$3"
        ;;
    report)
        report_os
        ;;
    delete)
        delete_server "$2"
        ;;
    *)
        echo "Usage :"
        echo "./inventory.sh add <hostname> <ip> <os>"
        echo "./inventory.sh list"
        echo "./inventory.sh status <hostname> <online|offline>"
        echo "./inventory.sh report"
        echo "./inventory.sh delete <hostname>"
        ;;
esac


