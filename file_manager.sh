#!/bin/bash

### menu interactif

PS3="Quel est votre choix ? : "
options=("Lister des fichiers du répertoire courant" "Compter les fichiers par extension" "Rechercher un fichier" "Nettoyer les fichiers temporaires" "Quitter")

select choix in "${options[@]}"; do
	case $REPLY in
	1)
		echo "Lister les fichiers......:"
		ls -a
		;;

	2)
		echo "Compter les fichiers par extension"
		find . -type f | sed -n 's/..*.//p' | sort | uniq -c
		;;

	3)
		echo "Rechercher un fichier:"
		read -p "entrer le nom du fichier :" nomfichier
		find -name "$nomfichier"
		;;

	4)
		echo "nettoyer les fichiers temp:"
		if [ -f "/tmp/*" ]
			then rm /tmp/*
				echo "fichiers temp ont ete supprimes"
			else
				echo "le fichier tmp est vide, rien a supprimer"
		fi
		;;
	5)
		echo "quitter"
		break
		;;

	esac
done
