#!/bin/bash

usage="Usage: $0 <file>"

not_admin() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" 
        return 0
    else
        return 1
    fi
}


file_exists() {
    # check if has args
    if [[ -z $1 ]]; then
        echo $usage
        return 0
    fi

    # check if file exists
    if [[ -f $1 ]]; then
        return 1
    else
        echo "file not exists"
        return 0
    fi
}

install() {
    apt update
    apt install openvpn -y
}

config() {
    cp $1 /etc/openvpn/config.ovpn
    

}



main() {
    # check if has args
    if (file_exists $1); then
        return 0
    fi

    cp $1 /
}


main $1