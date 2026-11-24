$csv = Import-Csv -Path (Read-Host "Chemin CSV") -Delimiter ';' -Encoding UTF8
$mdp = ConvertTo-SecureString 'Bienvenue2026!' -AsPlainText -Force

foreach ($s in $csv) {
    $ou = "OU=$($s.Service),OU=Utilisateurs,OU=BELLECOUR CONSEIL,DC=bellecour,DC=lan"

    # 1re lettre du prénom + nom, minuscules, sans accents ni espaces
    $base = ($s.Prenom.Substring(0,1) + $s.Nom).ToLower().Normalize([Text.NormalizationForm]::FormD) -replace '[^a-z0-9]',''
    $login = $base
    $i = 2
    while (Get-ADUser -Filter "SamAccountName -eq '$login'") { $login = "$base$i"; $i++ }

    $nom = "$($s.Prenom) $($s.Nom)"
    if (Get-ADUser -Filter "Name -eq '$nom'" -SearchBase $ou) { $nom = "$nom ($login)" }
    try {
        New-ADUser -Name $nom `
            -DisplayName $nom `
            -GivenName $s.Prenom -Surname $s.Nom `
            -SamAccountName $login `
            -UserPrincipalName "$login@bellecour.lan" `
            -Title $s.Fonction `
            -OfficePhone $s.Telephone `
            -Path $ou `
            -AccountPassword $mdp -Enabled $true -ChangePasswordAtLogon $true

        Add-ADGroupMember -Identity "GG_$($s.Service)" -Members $login
    }
    catch {
        Write-Host "ERREUR ligne $($s.Prenom) $($s.Nom) ($login) : $($_.Exception.Message)" -ForegroundColor Red
    }
}