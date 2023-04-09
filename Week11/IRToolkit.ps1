# This script gets and saves a variety of artifacts

$startTime = Get-Date -Format FileDateTimeUniversal

# Ask user where to save
$userPath = Read-Host -Prompt "Enter the path to save to"
$savePath = "$($userPath)$("\artifacts")$($startTime)"

New-Item -Path $savePath -ItemType Directory

Write-Host "$($savePath)$("\Processes.csv")"


# Get running processes with paths
Get-Process | Export-Csv -Path "$($savePath)$("\Processes.csv")" -NoTypeInformation


# Get registered services with paths
Get-WmiObject -Class Win32_Service | Export-Csv -Path "$($savePath)$("\Services.csv")" -NoTypeInformation


# Get TCP sockets
Get-NetTCPConnection | Export-Csv -Path "$($savePath)$("\TCPConnections.csv")" -NoTypeInformation


# Get user accound info
Get-WmiObject -Class Win32_Account | Export-Csv -Path "$($savePath)$("\Users.csv")" -NoTypeInformation

# Get network adapter information
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Export-Csv -Path "$($savePath)$("\NetrworkAdapter.csv")" -NoTypeInformation

# four more things

# Create a file containing checksums of each file

Get-FileHash "$($savePath)$("\*")" | Set-Content -Path "$($savePath)$("\hashfile.txt")"

# Zip the directory

Compress-Archive -Path "$($savePath)$("\*")" -DestinationPath "$($userPath)$("\artifacts")$($startTime)$(".zip")" -CompressionLevel Fastest

# Create a file containing a checksum of the zipped file

Get-FileHash "$($userPath)$("\artifacts")$($startTime)$(".zip")" | Set-Content -Path "$($userPath)$("\artifactshash")$($startTime)$(".txt")"