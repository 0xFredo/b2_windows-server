# 1. Renommer la carte réseau en LAN et vérifier la configuration IP

Rename-NetAdapter -Name "Ethernet" -NewName "lab-lan"
Get-NetIPAddress -InterfaceAlias lab-lan

# 2. Autoriser le ping entrant

Enable-NetFirewallRule -Name FPS-ICMP4-ERQ-In

# 3. Préparer le disque de 20 Go

Get-Disk
$disk = Get-Disk | Where-Object Size -eq 20GB
Initialize-Disk -Number $disk.Number -PartitionStyle GPT
New-Partition -DiskNumber $disk.Number -UseMaximumSize -DriveLetter D
Format-Volume -DriveLetter D -FileSystem NTFS -NewFileSystemLabel "Donnees"

# 4. Installer le rôle Serveur de fichiers

Install-WindowsFeature -Name FS-FileServer

# 5. Afficher les rôles et fonctionnalités installés

Get-WindowsFeature | Where-Object Installed

# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# –––––––––––––––––––– Pour aller plus loin ––––––––––––––––––––
# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

# Avec une seule commande Invoke-Command, aﬃchez le nom et la version du système des deux serveurs (-ComputerName localhost, 192.168.10.11)

Invoke-Command -ComputerName localhost, 192.168.10.11 -ScriptBlock { (Get-CimInstance Win32_OperatingSystem) | Select-Object CSName, Caption, Version }

        # CSName         : SRV-DC01
        # Caption        : Microsoft Windows Server 2025 Standard
        # Version        : 10.0.26404
        # PSComputerName : localhost
        # RunspaceId     : 58a157cc-f1ea-4774-9d36-8510995fd78b

        # CSName         : SRV-FIC01
        # Caption        : Microsoft Windows Server 2025 Standard
        # Version        : 10.0.26404
        # PSComputerName : 192.168.10.11
        # RunspaceId     : 4c803b84-3019-41f8-9af4-93781e72bf0e

# Modifiez rapport.ps1 pour qu'il enregistre son résultat dans un fichier texte daté, par exemple rapport 2026-11-04.txt (indice : Get-Date -Format yyyy-MM-dd)

$date = Get-Date -Format yyyy-MM-dd
New-Item -Path C:\Reports -ItemType Directory -Force

Start-Transcript -Path "C:\Reports\$date.txt"

        ### contenu du script

Stop-Transcript
notepad C:\Reports\$date.txt