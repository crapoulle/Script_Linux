#!/bin/bash
# monitor-timers.sh

echo "=== ÉTAT DES TIMERS SYSTEMD ==="
echo "Date: $(date)"
echo ""


echo "--- Timers actifs ---"
systemctl list-timers --all
echo ""


echo "--- Dernières exécutions ---"
journalctl -u "*.timer" --since "24 hours ago" --no-pager | tail -20
echo ""


echo "--- Services en échec ---"
systemctl --failed --type=service | grep -E "disk-check|backup|maintenance"
