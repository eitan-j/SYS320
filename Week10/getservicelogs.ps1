
function main() {

    $statuses = @('All','Stopped','Running')

    Write-Host "Enter which services to view."
    $userInput = Read-Host "All, Stopped, Running, or q to quit"

    if ($userInput -match "^[qQ]$") {

        # Stop executing the program and close the script
        break

        }

    if ($statuses -icontains $userInput) {
        if ("All" -ieq $userInput) {
        
            Get-Service
            Break

            }
    
        Get-Service | Where-Object { $_.Status -eq $userInput }

        Break

        }

    Write-Host -ForegroundColor White -BackgroundColor Red "Invalid input"
    main


    }


# TODO: check if input is valid & restart if invalid

main