#!/bin/bash

after_op="none"

handle_args() {
    if [ $# -eq 1 ]; then
        if [[ "$1" = "--help" || "$1" = "-h" ]]; then
            echo "Usage: [AFTER_OP]"
            echo -e "\tAFTER_OP:"
            echo -e "\t\t- none: No after operation. Exits the script after execution."
            echo -e "\t\t- s / sd / shut: Shut down the system after upgrading."
            echo -e "\t\t- r / rt / restart: Restart the system after upgrading."
            exit
        else
            extract_after_op "$1"
        fi
    elif [ $# -eq 0 ]; then
        echo "Defaulting to no after operation mode."
        echo "See $0 --help for more options."
    else
        echo "Invalid arguments."
        echo "See $0 --help for more options."
        exit
    fi
}

extract_after_op() {
    if [ "$1" = "none" ]; then
        :
    elif [[ "$1" = "s" || "$1" = "sd" || "$1" = "shut" ]]; then
        after_op="shut"
    elif [[ "$1" = "r" || "$1" = "rt" || "$1" = "restart" ]]; then
        after_op="restart"
    else
        echo "Invalid arguments."
        echo "See $0 --help for more options."
    fi
}

handle_after_op() {
    if [ "$after_op" = "none" ]; then
        exit
    elif [ "$after_op" = "shut" ]; then
        shutdown now
    elif [ "$after_op" = "restart" ]; then
        reboot
    fi
}

handle_args "$@"

dnf check-upgrade
sudo dnf upgrade -y

handle_after_op
