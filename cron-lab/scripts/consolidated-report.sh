#!/bin/bash
# consolidated-report.sh

REPORT="/root/cron-lab/reports/consolidated_$(date +%Y%m%d).html"

cat > "$REPORT" << 'HTML_HEADER'
<!DOCTYPE html>
<html>
<head>
	<title>Rapport Système SecureTech</title>
	<style>
		body { font-family: Arial, sans-serif; margin: 20px; }
		h1 { color: #2c3e50; }
		.section { margin: 20px 0; padding: 15px; background: #ecf0f1; border-radius: 5px; }
		.warning { color: #e74c3c; }
		.success { color: #27ae60; }
		table { border-collapse: collapse; width: 100%; }
		th, td { border: 1px solid #bdc3c7; padding: 8px; text-align: left;
}
		th { background-color: #34495e; color: white; }
	</style>
</head>
<body>
	<h1>Rapport Systeme Consolide</h1>
	<p>Genere le $(date)</p>
HTML_HEADER



# Ajouter les sections
cat >> "$REPORT" << EOF
	<div class="section">
		<h2>Etat du Systeme</h2>
		<p>Uptime: $(uptime -p)</p>
		<p>Charge: $(uptime | awk -F'load average:' '{print $2}')</p>
	</div>
EOF

# Tâches planifiées
echo ' <div class="section">' >> "$REPORT"
echo ' <h2>Taches Planifiees</h2>' >> "$REPORT"
echo ' <table>' >> "$REPORT"
echo ' <tr><th>Next</th><th>Left</th><th>Unit</th></tr>' >> "$REPORT"

systemctl list-timers --no-pager | tail -n +2 | head -10 | while read line; do
	echo " <tr><td>$(echo $line | awk '{print $1" "$2}')</td><td>$(echo $line | awk '{print $3}')</td><td>$(echo $line | awk '{print $NF}')</td></tr>" >> "$REPORT"
done

echo ' </table>' >> "$REPORT"
echo ' </div>' >> "$REPORT"


# Alertes récentes
echo ' <div class="section">' >> "$REPORT"
echo ' <h2>Alertes Recentes</h2>' >> "$REPORT"
echo ' <ul>' >> "$REPORT"
grep "ALERTE\|WARNING\|CRITICAL" /root/cron-lab/logs/*.log 2>/dev/null |

tail -10 | while read alert; do
	echo " <li class=\"warning\">$alert</li>" >> "$REPORT"
done

echo ' </ul>' >> "$REPORT"
echo ' </div>' >> "$REPORT"

cat >> "$REPORT" << 'HTML_FOOTER'
</body>
</html>
HTML_FOOTER

echo "Rapport généré: $REPORT"
