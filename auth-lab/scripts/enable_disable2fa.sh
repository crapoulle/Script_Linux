##testsss


read -p "nom de l'utilisateur : " userdisablemfa

echo "Le 2fa va être désactivé pour l'utilisateur" $userdisablemfa

rm /home/$userdisablemfa/.google_authenticator
