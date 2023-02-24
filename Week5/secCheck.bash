#!/bin/bash

# Script to perform local security checks

function checks() { # format: checks check_name policy_value current_value

    if [[ "$2" != "$3" ]]
    then

        echo -e "\e[1;31mThe $1 policy is not compliant. The current policy should be: $2. The current value is: $3\e[0m"
        echo -e "The remdiation is:\n$4\n"

    else

        echo -e "\e[1;32mThe $1 policy is compliant. The current value is: $3\e[0m"

fi
}

# Check the password max days

checks 'Password Max Days' '365' "$(grep -E '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')" 'Set "PASS_MAX_DAYS 365" in /etc/login.defs'

# Check the password min dyas

checks 'Password Min Days' '7' "$(grep -E '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')" 'Set "PASS_MIN_DAYS 7" in /etc/login.defs'

# Check the password warn age

checks 'Password Warn Age' '7' "$(grep -E '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2 } ')" 'Set "PASS_WARN_AGE 7" in /etc/login.defs'

# Check the SSH UsePAM config
chkSSHPAM=$(grep -E "^UsePAM" /etc/ssh/sshd_config | awk ' { print $2 } ')
checks 'SSH UsePAM' 'yes' "${chkSSHPAM}"

# Checks permissions on users home directories
echo ''

for eachDir in $(ls -l /home/ | grep -E '^d' | awk ' { print $3 } ')
do

    checkDir=$(ls -ld "/home/${eachDir}" | awk ' { print $1 } ' )
    checks "Home directory ${eachDir}" 'drwx------' "${checkDir}"

done

# Ensure IP forwarding is disabled

checks 'IP Forwarding' '0' "$(sysctl net.ipv4.ip_forward | awk ' { print $ 3} ')" '# sysctl -w net.ipv4.ip_forward=0\n# sysctl -w net.ipv4.route.flush=1'

# Ensure ICMP redirects are not accepted

checks 'ICMP Redirects' '0' "$(sysctl net.ipv4.conf.all.accept_redirects | awk ' { print $ 3} ')" 'Set "net.ipv4.conf.all.accept_redirects = 0" and "net.ipv4.conf.default.accept_redirects = 0" in /etc/sysctl.conf'

function checkcron() {

    checks "/etc/$1 Permissions" '////------ UID:0/root GID:0/root' "////$(stat --format='%A UID:%u/%U GID:%g/%G' "/etc/$1" | cut -c 5-)" "# chown root:root /etc/$1\n# chmod og-rwx /etc/$1"

}

function checkshadow() {

    shadow="$(stat --format='%A UID:%u/%U GID:%G' "/etc/$1")"

    checks "/etc/$1 Permissions" '-//-/----- UID:0/root GID:shadow' "${shadow:0:1}//${shadow:3:1}/${shadow:5}" "# chown root:shadow /etc/$1\n# chmod o-rwx,g-wx /etc/$1"

}


# Ensure permissions on /etc/cron(etc...) are configured

checkcron 'crontab'
checkcron 'cron.hourly'
checkcron 'cron.daily'
checkcron 'cron.weekly'
checkcron 'cron.monthly'

# Ensure permissions on /etc/shadow(etc...) are configured

checkshadow 'shadow'
checkshadow 'shadow-'
checkshadow 'gshadow'
checkshadow 'gshadow-'

# Ensure permissions on /etc/passwd are configured

checks "/etc/passwd Permissions" '-rw-r--r-- UID:0/root GID:0/root' "$(stat --format='%A UID:%u/%U GID:%g/%G' /etc/passwd)" '# chown root:root /etc/passwd\n# chmod 644 /etc/passwd'

# Ensure permissions on /etc/group are configured

checks "/etc/group Permissions" '-rw-r--r-- UID:0/root GID:0/root' "$(stat --format='%A UID:%u/%U GID:%g/%G' /etc/group)" '# chown root:root /etc/group\n# chmod 644 /etc/group'

# Ensure permissions on /etc/passwd- are configured

passwdminus="$(stat --format='%A UID:%u/%U GID:%g/%G' /etc/passwd-)"

checks "/etc/passwd- Permissions" '-//-/--/-- UID:0/root GID:0/root' "${passwdminus:0:1}//${passwdminus:3:1}/${passwdminus:5:2}/${passwdminus:8}" '# chown root:root /etc/passwd-\n# chmod u-x,go-wx /etc/passwd-'

# Ensure permissions on /etc/group- are configured

groupminus="$(stat --format='%A UID:%u/%U GID:%g/%G' /etc/group-)"

checks "/etc/group- Permissions" '-//-/--/-- UID:0/root GID:0/root' "${groupminus:0:1}//${groupminus:3:1}/${groupminus:5:2}/${groupminus:8}" '# chown root:root /etc/group-\n# chmod u-x,go-wx /etc/group-'

checks 'Ensure no legacy "+" entries exist in /etc/passwd' '' "$(grep '^\+:' /etc/passwd)" 'Remove any legacy "+" entries from /etc/passwd if they exist.'

checks 'Ensure no legacy "+" entries exist in /etc/shadow' '' "$(grep '^\+:' /etc/shadow)" 'Remove any legacy "+" entries from /etc/shadow if they exist.'

checks 'Ensure no legacy "+" entries exist in /etc/group' '' "$(grep '^\+:' /etc/group)" 'Remove any legacy "+" entries from /etc/group if they exist.'

checks 'Ensure root is the only UID 0 account' 'root' "$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }')" 'Remove any users other than root with UID 0 or assign them a new UID if appropriate.'
