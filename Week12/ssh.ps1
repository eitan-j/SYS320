﻿# Login to a remote SSH server
New-SSHSession -ComputerName '192.168.4.22' -Credential (Get-Credential sys320)


while ($true) {

    # Add a prompt to run commands
    $the_cmd = Read-Host -Prompt "Please enter a command"

    # Run command on remote SSH server
    (Invoke-SSHCommand -Index 0 $the_cmd).Output

}

Remove-SSHSession -SessionId 0


# Set-SCPItem -ComputerName '192.168.4.22' -Credential (Get-Credential sys320) `
# -Path '.\tedx.jpeg' -Destination '/home/sys320'
