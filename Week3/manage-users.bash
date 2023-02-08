#!/bin/bash

# Storyline: Script to add and delete VPN peers

while getopts 'hdacu:' OPTION ; do

    case "$OPTION" in

        d) u_del=${OPTION}
        ;;
        a) u_add=${OPTION}
        ;;
        c) u_check=${OPTION}
        ;;
        u) t_user=${OPTARG}
        ;;
        h)

            echo ""
            echo "Usage: $(basename "$0") [-a]|[-d][-c] -u username"
            echo ""
            exit 1

        ;;

        *)
            echo "Invalid value."
            exit 1

        ;;
    esac


done

# Check to see if there is exactly one of a, d, or c
if [[ $((${#u_del} + ${#u_add} + ${#u_check})) != 1 ]]
then

    echo "Please specify -a, -d, or -c and the -u and username"
    exit 1

fi

# Check to ensure -u is specified
if [[ ${t_user} == "" ]]
then

    echo "Please specify a user (-u)!"
    exit 1

fi



# Delete a user
if [[ ${u_del} ]]
then

    echo "Deleting user..."
    sed -i "/# ${t_user} begin/,/# ${t_user} end/d" wg0.conf


fi

# Add a user
if [[ ${u_add} ]]
then

    echo "Creating user..."
    bash peer.bash "${t_user}"

fi

# Check for user

if [[ ${u_check} ]]

then

    echo "Checking..."
    if [[ -n $(awk "/# ${t_user} begin/,/# ${t_user} end/" wg0.conf) ]]
    then
        echo "${t_user} exists in wg0.conf"
    else
        echo "${t_user} does not exist in wg0.conf"
    fi
fi
