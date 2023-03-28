# Get the IP address, default gateway, and the DNS servers

Get-WmiObject -Class Win32_NetworkAdapterConfiguration | `
Select-Object IPAddress, DefaultIPGateway, DNSServerSearchOrder, DHCPServer # The IPs are weird b/c this is a VM

# Export running proccesses and running services to seperate files

Get-Process | Select-Object ProcessName, Path, ID | Export-Csv -Path ".\runningProcesses.csv" -NoTypeInformation
Get-Service | Where-Object { $_.Status -eq "Running" } | Select-Object Name, DisplayName | Export-Csv -Path ".\runningServices.csv" -NoTypeInformation

# Start and stop calculator

Start-Process -FilePath calc.exe # I don't think it's possible to start a process just from it's process name unless it's already runnung
Start-Sleep -Seconds 2
Stop-Process -Name CalculatorApp

