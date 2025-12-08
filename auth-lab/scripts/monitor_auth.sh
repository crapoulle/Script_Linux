###djdf

#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "${YELLOW}Monitoring auth en temps réel (Ctrl+C pour arrêter)...${NC}"

journalctl -f -n 0 /var/log/auth.log | while read -r line; do

    # Connexion SSH réussie
    if echo "$line" | grep -q "Accepted"; then
        echo -e "${GREEN}[SSH OK]${NC} $line"
    fi

    # Connexion SSH échouée
    if echo "$line" | grep -q "Failed password"; then
        echo -e "${RED}[SSH FAIL]${NC} $line"
    fi

    # Appels sudo
    if echo "$line" | grep -q "sudo:"; then
        echo -e "${YELLOW}[SUDO]${NC} $line"
    fi

    # Patterns suspects
    if echo "$line" | grep -Eqi "invalid user|authentication failure"; then
        echo -e "${RED}[ALERTE]${NC} $line"
    fi

done
