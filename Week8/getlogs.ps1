# Storyline: Review the Security Event Log

# Directory to save files:
$myDir = ".\"

# List all the available Windows Event logs
Get-EventLog -List

# Create a prompt to allow user to select the Log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above"

# Create a prompt to allow user to select the keyword to search for
$findMessage = Read-Host -Prompt "Please enter a keyword or phrase to search for"


# Print the results for the log
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*$findMessage*" } | export-csv -NoTypeInformation `
-Path "$myDir\securityLogs.csv"

# Task: Create a prompt that allows the user to specify a keyword or phrase to search on.
# Find a string from your event logs to search on

