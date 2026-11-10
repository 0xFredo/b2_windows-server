# 1. Listez toutes les cmdlets dont le nom contient Service

Get-Command *Select* -CommandType Cmdlet

        # CommandType     Name                                               Version    Source                                                                          
        # -----------     ----                                               -------    ------                                                                          
        # Cmdlet          Select-Object                                      3.1.0.0    Microsoft.PowerShell.Utility                                                    
        # Cmdlet          Select-String                                      3.1.0.0    Microsoft.PowerShell.Utility                                                    
        # Cmdlet          Select-Xml                                         3.1.0.0    Microsoft.PowerShell.Utility                                                    

# 2. Combien de cmdlets ont pour nom NetIPAddress (quel que soit le verbe) ? Citez-les.

Get-Command -Noun NetIPAddress

        # CommandType     Name                                               Version    Source                                                                          
        # -----------     ----                                               -------    ------                                                                          
        # Function        Get-NetIPAddress                                   1.0.0.0    NetTCPIP                                                                        
        # Function        New-NetIPAddress                                   1.0.0.0    NetTCPIP                                                                        
        # Function        Remove-NetIPAddress                                1.0.0.0    NetTCPIP                                                                        
        # Function        Set-NetIPAddress                                   1.0.0.0    NetTCPIP                                                                        

# 3. Aﬃchez les exemples d'utilisation de Get-Service.

Get-Help Get-Service -Examples

        # NAME
        #     Get-Service
        #     
        # SYNOPSIS
        #     Gets the services on a local or remote computer.
        # 
        # [...]

# 4. Quelles propriétés possède un objet renvoyé par Get-Service ? (indice : Get-Member)

Get-Service | Get-Member -MemberType Property

        #    TypeName: System.ServiceProcess.ServiceController
        # 
        # Name                MemberType Definition                                                         
        # ----                ---------- ----------                                                         
        # CanPauseAndContinue Property   bool CanPauseAndContinue {get;}                                    
        # CanShutdown         Property   bool CanShutdown {get;}                                            
        # [...]
        # Status              Property   System.ServiceProcess.ServiceControllerStatus Status {get;}        

# 5. Les services en cours d'exécution, triés par nom aﬃché, en ne montrant que les colonnes Name et DisplayName.

Get-Service | Where-Object Status -eq 'Running' | Sort-Object DisplayName | Select-Object Name, DisplayName

        # Name                        DisplayName                                            
        # ----                        -----------                                            
        # Appinfo                     Application Information                                
        # BrokerInfrastructure        Background Tasks Infrastructure Service                
        # [...]
        # XtaCache                    XtaCache                                               

# 6. Les services de démarrage automatique qui sont pourtant arrêtés.

Get-Service | Where-Object Status -eq 'Stopped' | Where-Object StartType -eq 'Automatic'

        # Status   Name               DisplayName                           
        # ------   ----               -----------                           
        # Stopped  edgeupdate         Microsoft Edge Update Service (edge...
        # Stopped  InventorySvc       Inventory and Compatibility Apprais...
        # [...]
        # Stopped  sppsvc             Software Protection                   

# 7. Les 5 processus qui utilisent le plus de mémoire (propriété WorkingSet), avec leur nom et leur mémoire.

Get-Process | Sort-Object WorkingSet -Descending | Select-Object Name, WorkingSet | Select-Object -First 5

        # Name           WorkingSet
        # ----           ----------
        # powershell_ise  569303040
        # MsMpEng         385351680
        # explorer        228241408
        # dwm             166842368
        # SearchHost      144338944

# 8. Les 5 plus gros fichiers du dossier C:\Windows (sans les sous-dossiers), avec leur nom et leur taille.

Get-ChildItem C:\Windows -File | Sort-Object Length -Descending | Select-Object Name, Length | Select-Object -First 5

        # Name          Length
        # ----          ------
        # explorer.exe 2839624
        # HelpPane.exe 1078784
        # regedit.exe   587264
        # notepad.exe   327680
        # WMSysPr9.prx  316640

# 9. Les adresses IPv4 du serveur, avec le nom de la carte, l'adresse et la longueur du préfixe.

Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, IPAddress, PrefixLength

        # InterfaceAlias              IPAddress      PrefixLength
        # --------------              ---------      ------------
        # lab-lan                     192.168.10.10            24
        # nat-wan                     172.16.208.135           24
        # Loopback Pseudo-Interface 1 127.0.0.1                 8

# 10. La liste des comptes locaux, avec leur nom et la propriété Enabled.

Get-LocalUser | Select-Object Name, Enabled

        # Name               Enabled
        # ----               -------
        # Administrator         True
        # DefaultAccount       False
        # Guest                False
        # WDAGUtilityAccount   False

# 11. Créez un compte local stagiaire avec un mot de passe demandé à l'écran, puis désactivez-le, puis supprimez-le. (3 commandes)

New-LocalUser -Name 'stagiaire' -Password (Read-Host -AsSecureString 'Mot de passe')

        # Mot de passe: ******
        # 
        # Name      Enabled Description
        # ----      ------- -----------
        # stagiaire True

Disable-LocalUser -Name 'stagiaire'

Remove-LocalUser -Name 'stagiaire'

# 12. Écrivez le script C:\Scripts\rapport.ps1 qui aﬃche :
# - le nom de l'ordinateur ;
# - l'adresse IPv4 de la carte LAN ;
# - le nombre de services en cours d'exécution ;
# - l'espace libre du lecteur C:, en Go, arrondi à une décimale.

echo ComputerName
echo ------------
$env:COMPUTERNAME

Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias 'lab-lan' | Select-Object IPAddress
echo ''

echo ServiceCount
echo ------------
(Get-Service | Where-Object Status -eq 'Running' | Measure-Object).Count
echo ''

echo FreeSpace
echo ---------
[math]::Round((Get-PSDrive C).Free / 1GB, 1)

        # ComputerName
        # ------------
        # SRV-DC01
        #
        # IPAddress    
        # ---------    
        # 192.168.10.10
        #
        # ServiceCount
        # ------------
        # 86
        #
        # FreeSpace
        # ---------
        # 53,5

# 13. Exportez la liste des services (nom, état, type de démarrage) dans le fichier C:\Scripts\services.csv, avec un point-virgule comme séparateur. Ouvrez le fichier dans le Bloc-notes.

New-Item -Path C:\Scripts -ItemType Directory -Force
Get-Service | Select-Object Name, Status, StartType | Export-Csv -Path C:\Scripts\services.csv -Delimiter ';' -NoTypeInformation -Encoding UTF8
notepad C:\Scripts\services.csv