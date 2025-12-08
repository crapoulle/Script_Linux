#aaa

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'


tail -F /var/log/auth.log | while read -r line; do
	if echo "$line" | grep -q "Accepted"; then
		echo -e "${GREEN}[SSH OK]${NC} $line"
	fi

	if echo "$line" | grep -q "Failed password"; then
		echo -e "${RED}[SSH FAIL]${NC} $line"
	fi

	if echo "$line" | grep -q "sudo:"; then
		echo -e "${YELLOW}[SUDO]${NC} $line"
	fi

	if echo "$line" | grep -Eqi "invalid user|authentication failure"; then
		echo -e "${RED}[ALERTE]${NC} $line"
	fi
done
