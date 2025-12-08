###CREATION STRUCTURE GROUPE ENTREPRISE

echo "===== Création de la structure d'organisation ====="

### --- Départements ---
echo "Création des groupes de départements..."
sudo groupadd -g 2001 dev_team
sudo groupadd -g 2002 ops_team
sudo groupadd -g 2003 sec_team
sudo groupadd -g 2004 finance
sudo groupadd -g 2005 rh

### --- Privilèges ---
#echo "Création des groupes de privilèges..."
#sudo groupadd -g 3001 sudo_users
#sudo groupadd -g 3002 docker_users
#sudo groupadd -g 3003 backup_users
#sudo groupadd -g 3004 audit_users

### --- Projets ---
#echo "Création des groupes de projets..."
#sudo groupadd -g 4001 projet_alpha
#sudo groupadd -g 4002 projet_beta

#echo "===== Structure de groupes créée avec succès ! ====="
