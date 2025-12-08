#!/bin/bash

### Installation ACL si nécessaire
apt-get install -y acl >/dev/null 2>&1

### 1. Création des groupes
getent group formation  >/dev/null || groupadd formation
getent group technique  >/dev/null || groupadd technique
getent group commercial >/dev/null || groupadd commercial

### 2. Création des utilisateurs
id -u nicolas  >/dev/null || useradd -m -g formation -G technique nicolas
id -u laurent  >/dev/null || useradd -m -g technique -G commercial laurent
id -u philippe >/dev/null || useradd -m -g formation philippe
id -u ali      >/dev/null || useradd -m ali

### 3. Politique mots de passe (90j max, 5j min)
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   5/' /etc/login.defs

### Mot de passe Philippe
echo "philippe:My-P@$$w0rd" | chpasswd

### 4. Répertoires
mkdir -p /shared/formation
mkdir -p /shared/technique
mkdir -p /shared/commercial

# Attribution groupes
chown :formation  /shared/formation
chown :technique  /shared/technique
chown :commercial /shared/commercial

# Permissions
chmod 770 /shared/formation
chmod 770 /shared/technique
chmod 770 /shared/commercial

### 5. ACL Ali : lecture seule (r-x)
setfacl -m u:ali:rx /shared/technique

echo "Configuration complète."
