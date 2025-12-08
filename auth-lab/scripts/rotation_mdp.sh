###vvv

#CRON_ENTRY="1 * * * * /root/auth-lab/scripts/rotation_mdp.sh"



NOTIFS="notifications.log"
SEUIL=30

echo "=== $(date) ===" >> $NOTIFS

for user in $(cut -f1 -d: /etc/passwd); do
	info=$(chage -l "$user" 2>/dev/null | grep "Password last changed")
	days=$(($(($(date +%s) - $(date -d "$(echo "$info" | cut -d: -f2)" +%s))) / 86400))

	# ignorer comptes systèmes
	[ "$days" -lt 0 ] && continue

	if [ "$days" -ge "$SEUIL" ]; then
		echo "$(date): $user doit changer son mot de passe" >> $NOTIFS

		# Forcer si > SEUIL + 10
		if [ "$days" -ge $((SEUIL + 10)) ]; then
		chage -d 0 "$user"
		echo "$(date): Changement FORCÉ pour $user" >> $NOTIFS
		fi
	fi
done
