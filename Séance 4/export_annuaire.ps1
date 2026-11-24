$base = "OU=Utilisateurs,OU=BELLECOUR CONSEIL,DC=bellecour,DC=lan"

Get-ADUser -Filter * -SearchBase $base -Properties Title, OfficePhone |
    Select-Object @{n='Prenom';e={$_.GivenName}},
                  @{n='Nom';e={$_.Surname}},
                  @{n='Login';e={$_.SamAccountName}},
                  @{n='Service';e={($_.DistinguishedName -split ',')[1] -replace '^OU='}},
                  @{n='Fonction';e={$_.Title}},
                  @{n='Telephone';e={$_.OfficePhone}} |
    Sort-Object Service, Nom |
    Export-Csv -Path C:\Scripts\annuaire.csv -NoTypeInformation -Delimiter ';' -Encoding UTF8