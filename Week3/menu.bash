#!/bin/bash

# Storyline: Menu for admin, VPN, and Security functions

invalid_opt () {

    echo ""
    echo "Invalid option"
    echo ""
    sleep 2

}

menu () {

    clear

    echo "[1] Admin Menu"
    echo "[2] Security Menu"
    echo "[3] Exit"
    read -p "Please enter a choice above: " choice

    case "$choice" in

        1) admin_menu
        ;;
        2) security_menu
        ;;
        3) exit 0
        ;;
        *)
            invalid_opt
            menu
        ;;

    esac

}

admin_menu () {

    clear

    echo "[L]ist Running Processes"
    echo "[N]etwork Sockets"
    echo "[V]PN Menu"
    echo "[4] Exit"
    read -p "Please enter a choice above: " choice

    case "$choice" in

        L|l) ps -ef | less
        ;;
        N|n) netstat -an --inet | less
        ;;
        V|v) vpn_menu
        ;;
        4) exit 0
        ;;
        *) invalid_opt
        ;;

    esac

admin_menu
}

vpn_menu () {

    clear

    echo "[A]dd a peer"
    echo "[D]elete a peer"
    echo "[B]ack to admin menu"
    echo "[M]ain menu"
    echo "[E]xit"
    read -p "Please enter a choice above: " choice

    case "$choice" in

        A|a)

            bash peer.bash
            tail -6 wg0.conf | less

        ;;
        D|d)

            # Create a prompt for the user
            # Call manage-user.bash and pass the proper switches and argument
            # to delete

        ;;
        B|b) admin_menu
        ;;
        M|m) menu
        ;;
        E|e) exit
        ;;
        *) invalid_opt
        ;;


    esac
vpn_menu
}


# Call the main function
menu
