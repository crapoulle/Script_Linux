#network setup

#!/bin/bash

### 1. Sauvegarde de la configuration actuelle
echo "Sauvegarde de la configuration réseau actuelle..."
cp /etc/netplan/*.yaml /etc/netplan/backup_$(date +%F_%H-%M-%S).yaml
echo "Sauvegarde effectuée."

### 2. Nouvelle configuration à appliquer (À PERSONNALISER)
# Remplace les valeurs par ta configuration IP réelle !
cat <<EOF > /etc/netplan/*.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens192:
      dhcp4: no
      addresses:
        - 192.168.1.33/24
      gateway4: 192.168.1.254
      nameservers:
        addresses:
        - 213.186.33.99
EOF

echo "Nouvelle configuration appliquée."

### 3. Application de la configuration
echo "Application de la configuration..."
netplan apply

### 4. Test de connectivité
echo "Test de connectivité vers 8.8.8.8..."
ping -c 4 8.8.8.8

### 5. Affichage de la configuration résultante
echo "Configuration réseau actuelle :"
ip a
ip route
