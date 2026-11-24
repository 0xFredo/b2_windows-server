$base = "OU=Utilisateurs,OU=BELLECOUR CONSEIL,DC=bellecour,DC=lan"

# 1. Total (attendu : 40)
"`nTotal de comptes utilisateur : $((Get-ADUser -Filter * -SearchBase $base).Count)"

# 2. Comptes dans l'OU Commercial
"`nNombre de comptes Commercial : $((Get-ADUser -Filter * -SearchBase "OU=Commercial,$base").Count)"

# 3. Membres de GG_Informatique
"`nMembres de GG_Informatique :"
Get-ADGroupMember GG_Informatique | Select-Object Name, SamAccountName | Format-Table -AutoSize

# 4. Comptes de Comptabilite
"Comptes de Comptabilite :"
Get-ADUser -Filter * -SearchBase "OU=Comptabilite,$base" -Properties Title, OfficePhone | Select-Object Name, Title, OfficePhone | Format-Table -AutoSize