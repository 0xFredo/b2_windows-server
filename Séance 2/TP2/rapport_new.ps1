$date = Get-Date -Format yyyy-MM-dd
New-Item -Path C:\Reports -ItemType Directory -Force

Start-Transcript -Path "C:\Logs\$date.txt"



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



Stop-Transcript
notepad C:\Scripts\$date.txt