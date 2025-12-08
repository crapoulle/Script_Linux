###ssssq

### comptes inactifs depuis plus de 90 jours


LIMIT=$(date -d "-90 days" +"%Y-%m-%d")

wtmpdb lastlog | while read -r line; do
	user=$(echo "$line" | awk '{print $1}' | cut -d= -f2)
	last=$(echo "$line" | awk '{print $2}' | cut -d= -f2)

	# S'il n'y a pas de date, on ignore
	[ -z "$last" ] && continue

	# Afficher si dernière connexion < limite
	if [[ "$last" < "$LIMIT" ]]; then
		echo "$user : inactif depuis $last"
	fi
done

### mots de passe expires

sudo awk -F':' '{ system("echo " $1 " && chage -l " $1) }' /etc/passwd

### permissions incorrectes sur les home

echo "permissions qui ne sont pas 700"
find /home -type d -not -perm 700

echo "permissions qui ne sont pas 750"
find /home -type d -not -perm 750


### comptes sans repertoires home

echo "comptes sans repertoires home"

comm -3 <(getent passwd | cut -d: -f6 | sort -u) <(ls -d1 /home/*)

getent passwd | awk -F: '{printf "%s %s\n",$1,$6}' | while read i; do home=($i); if [ ! -d ${home[1]} ]; then home+=("nohome") ; fi ; echo ${home[@]}; done

### recommandations d'actions



