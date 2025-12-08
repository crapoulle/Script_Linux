###nnnn
#!/bin/bash
# Script simple : create-user-advanced.sh
if [ $# -lt 3 ]; then
 echo "Usage : $0 <username> <fullname> <department> [groups_supplémentaires]"
 exit 1
fi
USER="$1"
FULLNAME="$2"
DEPT="$3"
GROUPS1="$4"
GROUPS2="$5"

# UID de base selon le département
case "$DEPT" in
 dev_team) BASEUID=10100 ;;
 ops_team) BASEUID=10200 ;;
 sec_team) BASEUID=10300 ;;
 #*) echo "Département inconnu (dev, ops, sec)"; exit 1 ;;
esac
# Trouver le prochain UID dispo dans la plage du département
UID=$(awk -F: -v min="$BASEUID" -v max="$((BASEUID+99))" \
       '$3>=min && $3<=max {u=$3} END{print u+1}' /etc/passwd)
[ -z "$UID" ] && UID=$BASEUID

# Générer un mot de passe temporaire
PASS=$(openssl rand -base64 12)
# Créer l’utilisateur
#useradd -u $UID -m -s /bin/bash -c $FULLNAME -g ${DEPT}_team -G $GROUPS1 $GROUPS2 $USER

EXTRA=""
[ -n "$GROUPS1" ] && EXTRA="$GROUPS1"
[ -n "$GROUPS2" ] && EXTRA="${EXTRA},$GROUPS2"

# Création de l’utilisateur
if [ -n "$EXTRA" ]; then
    useradd -u "$UID" -m -s /bin/bash -c "$FULLNAME" \
        -g "${DEPT}" -G "$EXTRA" "$USER"
else
    useradd -u "$UID" -m -s /bin/bash -c "$FULLNAME" \
        -g "${DEPT}" "$USER"
fi




# Définir le mot de passe et forcer le changement
echo "$USER:$PASS" | chpasswd
chage -d 0 "$USER"

# Créer une structure simple dans le home
mkdir -p /home/"$USER"/{projects,docs,tmp}
chown -R "$USER":"${DEPT}" /home/"$USER"

# Affichage
echo "Utilisateur : $USER"
echo "Département : $DEPT"
echo "UID : $UID"
echo "Mot de passe temporaire : $PASS"
echo "Créé avec succès"
