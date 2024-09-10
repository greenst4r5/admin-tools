#!/bin/bash

usage="Usage: $0 <file>.ovpn"

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

    # check if file not exists
    if [[ ! -f $1 ]]; then
        echo "File not found"
        return 0
    fi


    #check if file is ovpn
    if [[ $1 != *.ovpn ]]; then
        echo $usage
        return 0
    fi

    return 1
}

install() {
    apt update
    apt install openvpn -y
}

config() {
    # copy ovpn file to /etc/openvpn
    cp $1 /etc/openvpn/client.conf

    # create service
    echo '[Unit]
Description=OpenVPN service for client
After=network.target

[Service]
Type=forking
User=root
Group=root
ExecStart=/usr/sbin/openvpn --daemon ovpn-client --status /run/openvpn/client.status 10 --cd /etc/openvpn --config client.conf
ExecStop=/usr/sbin/openvpn --killsignal SIGINT --config client.conf
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/openvpn-client.service

    systemctl enable openvpn-client
    systemctl start openvpn-client
}



main() {
    #check if root
    if (not_admin); then
        return 0
    fi

    # check if has args and file exists
    if (file_exists $1); then
        return 0
    fi

    # install openvpn
    echo -e "\e[45mInstalling....\e[0m"
    install
    echo -e "\e[32mDone\e[0m"

    # config openvpn
    echo -e "\e[45mConfiguring....\e[0m"
    config $1
    echo -e "\e[32mDone\e[0m"
}


main $1