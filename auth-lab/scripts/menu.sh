#Menu intéractif
#!/bin/bash 

echo "###################################" 
echo "### ___  ___ _____ _   _ _   _  ###" 
echo "### |  \/  ||  ___| \ | | | | | ###"
echo "### | .  . || |__ |  \| | | | | ###"
echo "### | |\/| ||  __||     | | | | ###"
echo "### | |  | || |___| |\  | |_| | ###"
echo "### \_|  |_/\____/\_| \_/\___/  ###"
echo "###################################"
echo "###################################"
echo ""
echo ""
#Partie 1

echo "Taper 1: bulk-user-create.sh"
echo "Taper 2: enable_disable2fa.sh"
echo "Taper 3: setup-2fa.sh"
echo "Taper 4: user-maintenance.sh"
echo "Taper 5: script_verif_mdp.sh"
echo "Taper 6: user-inventory.sh"
echo "Taper 7: userscorrige.sh"
echo "Taper 8: create-org-structure.sh" 
echo "Taper E: Quitter"
read -p "Entrez votre choix: " choix
case "$choix" in
  1) /root/auth-lab/scripts/bulk-user-create.sh
    ;;
  2) /root/auth-lab/scripts/enable_disable2fa.sh
    ;;
  3) /root/auth-lab/scripts/setup-2fa.sh
    ;;
  4) /root/auth-lab/scripts/user-maintenance.sh
    ;;
  5) /root/auth-lab/scripts/script_verif_mdp.sh
    ;;
  6) /root/auth-lab/scripts/user-inventory.sh
    ;;
  7) /root/auth-lab/scripts/userscorrige.sh
    ;;
  8) /root/auth-lab/scripts/create-org-structure.sh
    ;;
  E) exit
    ;;
esac
