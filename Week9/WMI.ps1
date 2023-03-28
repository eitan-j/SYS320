# Use the Get-WmiObject cmdlet
# Get-WmiObject -Class Win32_service | Select-Object Name, Pathname, processId

# Get-WmiObject -List | Where-Object { $_.Name -ilike "Win32_[n-z]*" } | Sort-Object

# Get-WmiObject -Class Win32_Account | Get-Member

# Task: Grab the network adapter information using the WMI class
# Get the IP address, default gateway, and the DNS servers
# BONUS: get the DHCP server

