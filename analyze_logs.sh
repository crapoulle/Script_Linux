#### compter les requetes par code de statut

echo "--------------------"
echo "Compter les requetes par code de statut"
awk '{print $9}' access.log | sort | uniq -c

echo "----------------"


### bande passante totale

echo "Calculer la bande passante totale"
#awk '{sum+=$(NF)} END {print "La bande passante totale est = " sum}' access.log 
awk '{SUM=SUM+$(NF); print "Ligne : "NR " "$(NF)} END {print "La bande passante totale est : "SUM}' access.log

echo "----------------"


echo "Lister les ip uniques avec le nombre de requetes"

#awk {print $1} access.log | sort | uniq -c
#awk {print FNR, $9}' access.log
awk '{if($1 != "$1") print "Ligne : "NR " "$1;}' access.log

echo "--------------------------------"

echo "Filtrer les erreurs (codes 4xx et 5xx)"


awk '{if($9 ~ /^4/) print "Erreur ligne "NR " : "$9;}' access.log

echo "--------------------------"


