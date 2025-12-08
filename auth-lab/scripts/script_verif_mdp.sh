#script verif mdp

#!/usr/bin/env bash
# Usage: ./pwscore-simple.sh passwords.txt

if ! command -v pwscore >/dev/null 2>&1; then
  echo "Erreur : pwscore introuvable" >&2
  exit 1
fi

while IFS= read -r pw || [[ -n "$pw" ]]; do
  [[ -z "$pw" ]] && continue
  score=$(printf "%s\n" "$pw" | pwscore 2>/dev/null)
  echo "$pw : $score"
done < "${1:-/dev/stdin}"
