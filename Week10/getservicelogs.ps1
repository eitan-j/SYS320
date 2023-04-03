
$statuses = @('All','Stopped','Running')

Write-Host "Enter which services to view."
$userInput = Read-Host "All, Stopped, Running, or q to quit"

if ($userInput -Match "^[qQ]$") {

    # Stop executing the program and close the script
    break

    }

if ($statuses -match $userInput) {
    if ("All" -ilike $userInput) {
        
        Get-Service
        Break

        }
    
    Get-Service | Where-Object { $_.Status -eq $userInput }

    }

# TODO: check if input is valid & restart if invalid
# TODO: run without Where-Object if input is All

