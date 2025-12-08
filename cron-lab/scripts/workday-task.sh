###workdaytask
#!/bin/bash
# workday-task.sh - Rapport quotidien pour jours ouvrables

REPORT_FILE="/root/cron-lab/reports/daily_report_$(date +%Y%m%d).txt"

	{
		echo "=== RAPPORT QUOTIDIEN ==="
		echo "Date: $(date)"
		echo ""

		echo "--- Uptime ---"
		uptime
		echo ""

		echo "--- Charge CPU ---"
		top -bn1 | head -5
		echo ""

		echo "--- Top 5 processus mémoire ---"
		ps aux --sort=-%mem | head -6
		echo ""

		echo "--- Espace disque ---"
		df -h
		echo ""

		echo "--- Connexions récentes ---"
		last | head -10

} > "$REPORT_FILE"

