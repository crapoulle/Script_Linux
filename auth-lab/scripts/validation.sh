#Validation
#!/bin/bash
# ============================================================
# validate-setup.sh - Script d’audit final (Atelier n°1)
# Conforme au PDF EFREI – Gestion avancée des utilisateurs
# ============================================================

SCORE=0
TOTAL=5
ISSUES=()

echo "===================================================="
echo " VALIDATION FINAL - Atelier n°1"
echo "===================================================="

# ------------------------------------------------------------
# 1. Vérification des groupes créés
# ------------------------------------------------------------
echo -e "\n[1] Vérification des groupes obligatoires"

GROUPS_MUST_EXIST=(
	dev_team ops_team sec_team finance rh
	sudo_users docker_users backup_users audit_users
	projet_alpha projet_beta
)

GROUPS_OK=1

for g in "${GROUPS_MUST_EXIST[@]}"; do
	if getent group "$g" >/dev/null; then
		echo "[OK] Groupe : $g"
	else
		echo "[ERREUR] Groupe manquant : $g"
	GROUPS_OK=0
	ISSUES+=("Groupe manquant : $g")
	fi
done

[[ $GROUPS_OK -eq 1 ]] && ((SCORE++))


# ------------------------------------------------------------
# 2. Vérification PAM (pwquality, faillock)
# ------------------------------------------------------------
echo -e "\n[2] Vérification PAM"

PAM_OK=1

# ---- pwquality
if grep -q "minlen = 12" /etc/security/pwquality.conf 2>/dev/null && grep -q "dcredit" /etc/security/pwquality.conf && grep -q "ocredit" /etc/security/pwquality.conf && grep -q "lcredit" /etc/security/pwquality.conf && grep -q "ucredit" /etc/security/pwquality.conf; then 
	echo "[OK] Politique pwquality présente"
else
	echo "[ERREUR] Politique pwquality incorrecte ou absente"
	PAM_OK=0
	ISSUES+=("pwquality incorrect")
fi

# ---- faillock
if [[ -f /etc/security/faillock.conf ]] && grep -q "deny = 5" /etc/security/faillock.conf && grep -q "unlock_time = 900" /etc/security/faillock.conf; then
	echo "[OK] faillock configuré"
else
	echo "[ERREUR] faillock non configuré"
	PAM_OK=0
	ISSUES+=("faillock incorrect")
fi

[[ $PAM_OK -eq 1 ]] && ((SCORE++))


# ------------------------------------------------------------
# 3. Vérification 2FA (Google Authenticator)
# ------------------------------------------------------------
echo -e "\n[3] Vérification 2FA"

TFA_OK=1

# Vérifier package installé
if dpkg -l | grep -q "libpam-google-authenticator"; then
	echo "[OK] google-authenticator installé"
else
	echo "[ERREUR] 2FA non installé"
	TFA_OK=0
	ISSUES+=("Paquet Google Authenticator non installé")
fi

# Vérifier inclusion dans PAM SSH
if grep -Riq "pam_google_authenticator.so" /etc/pam.d; then
	echo "[OK] 2FA présent dans PAM"
else
	echo "[ERREUR] 2FA absent dans configuration PAM"
	TFA_OK=0
	ISSUES+=("pam_google_authenticator absent")
fi

# Vérifier fichier ~/.google_authenticator pour au moins 1 utilisateur
FOUND=0
for home in /home/*; do
	if [[ -f "$home/.google_authenticator" ]]; then
		FOUND=1
	break
	fi
done

if [[ $FOUND -eq 1 ]]; then
	echo "[OK] Fichiers 2FA utilisateurs détectés"
else
	echo "[ERREUR] Aucun utilisateur n'a configuré Google Authenticator"
	TFA_OK=0
	ISSUES+=("Aucune configuration utilisateur 2FA")
fi

[[ $TFA_OK -eq 1 ]] && ((SCORE++))


# ------------------------------------------------------------
# 4. Vérification règles auditd
# ------------------------------------------------------------
echo -e "\n[4] Vérification auditd"

AUDIT_OK=1

if systemctl is-active --quiet auditd; then
	echo "[OK] Service auditd actif"
else
	echo "[ERREUR] auditd inactif"
	AUDIT_OK=0
	ISSUES+=("auditd non actif")
fi

if [[ -f /etc/audit/rules.d/audit.rules ]] &&
	grep -q "/etc/passwd" /etc/audit/rules.d/audit.rules &&
	grep -q "sudo" /etc/audit/rules.d/audit.rules; then
	echo "[OK] Règles d'audit présentes"
else
	echo "[ERREUR] Règles d'audit manquantes"
	AUDIT_OK=0
	ISSUES+=("Règles d'audit incomplètes")
fi

[[ $AUDIT_OK -eq 1 ]] && ((SCORE++))


# ------------------------------------------------------------
# 5. Vérification services critiques
# ------------------------------------------------------------
echo -e "\n[5] Vérification services"

SERVICES_OK=1

SERVICES=("ssh" "auditd")

for s in "${SERVICES[@]}"; do
	if systemctl is-active --quiet "$s"; then
		echo "[OK] $s actif"
	else
		echo "[ERREUR] Service inactif : $s"
	SERVICES_OK=0
	ISSUES+=("Service manquant : $s")
	fi
done

[[ $SERVICES_OK -eq 1 ]] && ((SCORE++))


# ------------------------------------------------------------
# SCORE FINAL
# ------------------------------------------------------------
echo -e "\n===================================================="
echo " SCORE FINAL : $SCORE / $TOTAL"
echo "===================================================="

if [[ ${#ISSUES[@]} -eq 0 ]]; then
	echo "Configuration VALIDÉE : aucun problème détecté."
else
	echo "Problèmes détectés :"
	for i in "${ISSUES[@]}"; do
		echo " - $i"
	done
fi
echo "===================================================="
