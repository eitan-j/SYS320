# Storyline: Use Get-Process and Get-Service
# Get-Process | Select-Object ProcessName, Path, ID | `
# Export-Csv -Path ".\myProcesses.csv" -NoTypeInformation
# Get-Process | Get-Member
# Get-Service | Where-Object { $_.Status -eq "Stopped" }
