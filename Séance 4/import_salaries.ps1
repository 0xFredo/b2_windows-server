$csv = Import-Csv -Path (Read-Host "Chemin CSV") -Delimiter ';' -Encoding UTF8
$mdp = ConvertTo-SecureString 'Bienvenue2026!' -AsPlainText -Force

foreach ($s in $csv) {
    $ou = "OU=$($s.Service),OU=Utilisateurs,OU=BELLECOUR CONSEIL,DC=bellecour,DC=lan"
    $nom = "$($s.Prenom) $($s.Nom)"
    if (Get-ADUser -Filter "Name -eq '$nom'" -SearchBase $ou) { $nom = "$nom ($($s.Login))" }
    try {
        New-ADUser -Name $nom `
            -DisplayName $nom `
            -GivenName $s.Prenom -Surname $s.Nom `
            -SamAccountName $s.Login `
            -UserPrincipalName "$($s.Login)@bellecour.lan" `
            -Title $s.Fonction `
            -OfficePhone $s.Telephone `
            -Path $ou `
            -AccountPassword $mdp -Enabled $true -ChangePasswordAtLogon $true

        Add-ADGroupMember -Identity "GG_$($s.Service)" -Members $s.Login
    }
    catch {
        Write-Host "ERREUR ligne $($s.Prenom) $($s.Nom) ($($s.Login)) : $($_.Exception.Message)" -ForegroundColor Red
    }
}