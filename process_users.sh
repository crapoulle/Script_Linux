#!/bin/bash

# Fichier d'entrée
INPUT="users.txt"

# Traitement
sed -e 's/users/standard_users/' \
    -e 's/:\([0-9]\+\):/:ID:\1:/' \
    -e '/^#/d' "$INPUT" | cut -d':' -f4
