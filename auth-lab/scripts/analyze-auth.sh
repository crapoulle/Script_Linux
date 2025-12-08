#hhh
#!/bin/bash

echo "======================================="
echo " Rapport d'analyse des logs d'auth"
echo "======================================="
echo

###############################################
# 1. Connexions SSH réussies des dernières 24h
###############################################
echo "[1] Connexions SSH réussies (24h)"
journalctl -u ssh --since "24 hours ago" | grep "Accepted" || echo "Aucune entrée."
echo

###############################################
# 2. Top 10 des tentatives échouées
###############################################
echo "[2] Top 10 des tentatives SSH échouées"
journalctl -u ssh --since "24 hours ago" | grep "Failed password" | \
    awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -10
echo

###############################################
# 3. Commandes sudo exécutées
###############################################
echo "[3] Commandes sudo exécutées (via auditd)"
ausearch -k priv_cmd -ts recent | aureport -x --summary 2>/dev/null
echo

###############################################
# 4. Détection brute-force : >5 échecs / IP
###############################################
echo "[4] Détection brute-force (plus de 5 échecs/IP)"
journalctl -u ssh --since "24 hours ago" | grep "Failed password" | \
    awk '{print $(NF-3)}' | sort | uniq -c | awk '$1 > 5 {print}'
echo

echo "=== Fin du rapport ==="
