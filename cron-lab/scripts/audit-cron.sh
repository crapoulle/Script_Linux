###audit-cron
#!/bin/bash
# audit-cron.sh - Audit de la configuration cron

echo "=== AUDIT CRON ==="
echo "Date: $(date)"
echo ""

echo "--- Service cron ---"
systemctl is-active cron
echo ""

echo "--- Crontabs utilisateurs ---"
for user in $(cut -d: -f1 /etc/passwd); do
 if crontab -l -u "$user" 2>/dev/null | grep -v "^#" | grep -v "^$" > /dev/null; then
   echo "Utilisateur: $user"
   crontab -l -u "$user"
   echo ""
 fi
done

echo "--- Tâches système dans /etc/cron.* ---"
for dir in /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.weekly /etc/cron.monthly; do
  if [ -d "$dir" ]; then
    echo "Contenu de $dir :"
    ls -la "$dir"
    echo ""
  fi
done

echo "--- Permissions des fichiers cron ---"
ls -la /etc/crontab 2>/dev/null
ls -la /etc/cron.d 2>/dev/null
ls -la /etc/cron.allow 2>/dev/null
ls -la /etc/cron.deny 2>/dev/null
echo ""

echo "--- Contenu de /etc/cron.allow et /etc/cron.deny ---"
[ -f /etc/cron.allow ] && echo "== /etc/cron.allow ==" && cat /etc/cron.allow && echo ""
[ -f /etc/cron.deny ] && echo "== /etc/cron.deny ==" && cat /etc/cron.deny && echo ""

echo "--- Logs cron (si disponibles) ---"
if [ -f /var/log/cron ]; then
  echo "== /var/log/cron =="
  tail -n 50 /var/log/cron
elif [ -f /var/log/syslog ]; then
  echo "== /var/log/syslog (extrait cron) =="
  grep cron /var/log/syslog | tail -n 50
else
  echo "Aucun journal système cron trouvé."
fi

echo ""
echo "=== FIN AUDIT CRON ==="
