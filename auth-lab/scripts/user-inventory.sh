### SCript GÉNÉration INVENtaire comPLET
#!/bin/bash
# Script : user-inventory.sh
# Objectif : Générer un inventaire des utilisateurs du système

echo "===== INVENTAIRE DES UTILISATEURS ====="
echo


### 1. Statistiques sur les utilisateurs ###
echo "---- Statistiques ----"
UID_MIN=$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)
if [ -z "$UID_MIN" ]; then
  UID_MIN=1000
fi

TOTAL=$(getent passwd | wc -l)
SYSTEME=$(getent passwd | awk -F: -v min="$UID_MIN" '$3 < min {count++} END{print count}')
HUMAINS=$(getent passwd | awk -F: -v min="$UID_MIN" '$3 >= min {count++} END{print count}')

echo "Total d'utilisateurs : $TOTAL"
echo "Comptes système (UID < $UID_MIN) : $SYSTEME"
echo "Comptes humains (UID >= $UID_MIN) : $HUMAINS"
echo


### 2. Liste des utilisateurs avec leur shell ###
echo "---- Liste des utilisateurs ----"
getent passwd | awk -F: '{print $1 " -> " $7}'
echo


### 3. Groupes avec des membres ###
echo "---- Groupes avec membres ----"
getent group | awk -F: 'length($4) > 0 {print $1 " : " $4}'
echo


### 4. Utilisateurs sans mot de passe ###
echo "---- Utilisateurs sans mot de passe ----"
sudo awk -F: '($2 == "" || $2 == "!") {print $1}' /etc/shadow


echo
echo "===== Fin de l'inventaire ====="
