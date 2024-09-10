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
    cp $1 /etc/openvpn/client.ovpn
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
    # check if has args
    if (file_exists $1); then
        return 0
    fi

    
}


main $1