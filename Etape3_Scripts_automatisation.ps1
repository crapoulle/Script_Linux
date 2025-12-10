# === FONCTION DE CRÉATION D'UTILISATEUR AVANCÉE ===

$GroupNumber = "3"
$CSVPath = "C:\Import\users.csv"

Write-Host ""
Write-Host "test"

function New-EfreiUser {
	param(
		[Parameter(Mandatory=$true)]$FirstName,
		[Parameter(Mandatory=$true)]$LastName,
		[Parameter(Mandatory=$true)][ValidateSet("IT","Finance","RH","Direction","Commercial","Production")]$Department,
		[Parameter(Mandatory=$false)][ValidateSet("Manager","Senior","Junior","Stagiaire")]$Role = "Junior",
		[Parameter(Mandatory=$false)]$Manager,
		[Parameter(Mandatory=$false)]$Mobile,
		[Parameter(Mandatory=$false)]$GroupNumber = "3"
	)

	Write-Host "firtname = $FirstName"
	Write-Host "LASTname = $LastName"

	# Générer le login
	$cleanFirst = $FirstName.ToLower() -replace "[éèêë]","e" -replace "[àâä]","a" -replace "[^a-z]",""
	$cleanLast = $LastName.ToLower() -replace "[éèêë]","e" -replace "[àâä]","a" -replace "[^a-z]",""
	$baseLogin = "$($cleanFirst[0]).$cleanLast"


	Write-Host "baseLogin = $baseLogin"

	# Vérifier l'unicité
	$counter = 1
	$login = $baseLogin
	while (Get-ADUser -Filter "SamAccountName -eq '$login'" -ErrorAction Continue) {
		$counter++
		$login = "$baseLogin$counter"
	}
	
	Write-Host "test1"


	# Définir les chemins
	$domain = "DC=efreiG3,DC=local"
	$userPath = "OU=$Department,OU=Utilisateurs,OU=EFREI_G3,$domain"
	
	# Attributs utilisateur
	$userParams = @{
		Name = "$FirstName $LastName"
		GivenName = $FirstName
		Surname = $LastName
		DisplayName = "$LastName $FirstName".ToUpper()
		SamAccountName = $login
		UserPrincipalName = "$login@efreiG$GroupNumber.local"
		EmailAddress = "$login@efreiG$GroupNumber.local"
		Department = $Department
		Title = "$Role - $Department"
		Description = "Créé le $(Get-Date -Format 'dd/MM/yyyy') - $Role - $Department"
		AccountPassword = (ConvertTo-SecureString "Welcome@G$GroupNumber!" -AsPlainText -Force)
		Enabled = $true
		ChangePasswordAtLogon = $true
		Path = $userPath
	}

	# Ajouter les attributs optionnels
	if ($Manager) { $userParams.Manager = $Manager }
	if ($Mobile) { $userParams.MobilePhone = $Mobile }

	# Créer l'utilisateur
	try {
		$newUser = New-ADUser @userParams -PassThru
		Write-Host "Utilisateur créé : $login" -ForegroundColor Green

		# Ajouter aux groupes appropriés
		$groups = @("GG_$($Department)_Tous_G$GroupNumber")

		if ($Role -eq "Manager") {
			$groups += "GG_$($Department)_Managers_G$GroupNumber"
			$groups += "GG_Managers_Tous_G$GroupNumber"
		}



		foreach ($group in $groups) {
			if (Get-ADGroup -Filter "Name -eq '$group'" -ErrorAction Continue) {
				Add-ADGroupMember -Identity $group -Members $newUser
				Write-Host " → Ajouté au groupe : $group" -ForegroundColor Gray
			}
		}


	# Créer le dossier personnel
	$homeBase = "C:\Homes\$GroupNumber"
	if (-not (Test-Path $homeBase)) {
		New-Item -Path $homeBase -ItemType Directory -Force
	}

	$homePath = "$homeBase\$login"
	New-Item -Path $homePath -ItemType Directory -Force | Out-Null
	Write-Host "homeBase = $homeBase"
	# Configurer les permissions
	$acl = Get-Acl $homePath
	$permission = "efreiG$GroupNumber\$login","FullControl","ContainerInherit,ObjectInherit","None","Allow"
	$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
	$acl.SetAccessRule($accessRule)
	Set-Acl $homePath $acl


	# Retourner les informations
	return @{
		Login = $login
		Password = "Welcome@G$GroupNumber!"
		Email = "$login@efreiG$GroupNumber.local"
		HomePath = $homePath
		Groups = $groups -join ", "
	}

	} catch {
		Write-Host "Erreur : $_" -ForegroundColor Red
		return $null
	}
}




# === SCRIPT D'IMPORT CSV ===
function Import-UsersFromCSV {
	param(
		[string]$CSVPath = "C:\Import\users.csv",
		[string]$GroupNumber = "3"
	)

	if (-not (Test-Path $CSVPath)) {
		Write-Host "Fichier CSV introuvable : $CSVPath" -ForegroundColor Red
	return
	}

	$users = Import-Csv $CSVPath
	$results = @()

	foreach ($user in $users) {
		Write-Host "`nTraitement : $($user.FirstName) $($user.LastName)" -ForegroundColor Yellow

		$params = @{
			FirstName = $user.FirstName
			LastName = $user.LastName
			Department = $user.Department
			Role = $user.Role
			GroupNumber = $GroupNumber
		}


	if ($user.Manager) { $params.Manager = $user.Manager }
	if ($user.Mobile) { $params.Mobile = $user.Mobile }

	$result = New-EfreiUser @params
	$results += $result
	}



	# Générer un rapport

	$reportPath = "C:\Import\Import_Report_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
	$results | Export-Csv $reportPath -NoTypeInformation

	Write-Host "Import terminé. Rapport : $reportPath" -ForegroundColor Green
}



