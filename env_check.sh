#!/bin/bash

## Script pour vérifier les variables dans .profile

echo "HOME = $HOME"
echo "USER = $USER"
echo "PATH = $PATH"

####

if [ -z "$EDITOR" ]; then
	echo "La variable EDITOR n'est pas définie"
else
	echo "EDITOR = $EDITOR"
fi


####

if [ ! -d "$MYAPP_HOME" ]; then
	echo "Erreur, le répertoire MYAPP_HOME ($MYAPP_HOME) n'existe pas"
else
	echo "MYAPP_HOME = $MYAPP_HOME"
fi

exit

###


