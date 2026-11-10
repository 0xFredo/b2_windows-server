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