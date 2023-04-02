# Storyline: View the event logs, check for a valid log, and print the results


function select_log() {

    cls

    # List all event logs
    $theLogs = Get-EventLog -list | Select Log
    $theLogs | Out-Host

    # Initialize the array to store the logs
    $arrLog = @()

    ForEach ($tempLog in $theLogs) {

        # Add each log to the array
        # NOTE: These are stored in the array as a hashtable in the format:
        # @{Log=LOGNAME}
        $arrLog += $tempLog

    }

    # Test to be sure our array is being populated
    # $arrLog

    # Prompt the user for the log to view or quit
    $readLog = Read-Host -Prompt "Please enter a log from the list above or 'q' to quit the program"

    # Check is the user wants to quit
    if ($readLog -Match "^[qQ]$") {

    # Stop executing the program and close the script
    break

    }

    log_check -logToSearch $readLog


} # ends the select_log()



function log_check() {

    # String the user types in within the select_log function
    Param([string]$logToSearch)

    # Format the user input
    # Example: @{Log=Security}
    $theLog = "^@{Log=" + $logToSearch + "}$" # TODO: what does the dollar sign do here?

    # Search the array for the exact hashtable string
    if ($arrLog -Match $theLog){ # TODO: why is $arrLog accessable from here?

        Write-Host -BackgroundColor Green -ForegroundColor White "Please wait, it may take a few moments to retrieve the log entries."
        Sleep 2

        # Call the function to view the log
        view_log -logToSearch $logToSearch


    } else {

        Write-Host -BackgroundColor Red -ForegroundColor White "The log specified doesn't exist."

        sleep 2

        select_log

    }

} # ends the log_check()



function view_log() {

    cls

    # Get the logs
    Get-EventLog -Log $logToSearch -Newest 10 -After "1/18/2020"

    # Pause the screen and wait until the user is ready to proceed
    Read-Host -Prompt "Press enter when you are done"

    # Go back to select_log
    select_log

} # ends the view_log()

# Run select_log() as the first Function
select_log
