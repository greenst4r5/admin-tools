#!/bin/bash

########################################################################################
# This script will install some tools and  setup a basic environment.                  #
# I wanted to automate the process of setting up a new server.                         #
#                                                                                      #  
# Author: greenst4r5                                                                   #
########################################################################################

not_admin() {
    code=$(id -u)
    if [[ "$code" == "0" ]]; then
        return 1
    else
        return 0
    fi

}

boleanQuestion() {
    question=$1
    default=$2

    defaultStr=""
    if [[ $default == 'y' ]]; then
        defaultStr="(Y/n):"
    else
        defaultStr="(y/N):"
    fi

    read -p "$question $defaultStr" answer

    if [[ -z $answer ]]; then
        answer=$default
    fi

    if [[ $answer == 'y' || $answer == 'Y' ]]; then
        return 1
    elif [[ $answer == 'n' || $answer == 'N' ]]; then
        return 0
    else
        return $(boleanQuestion "$question" "$default")
    fi
}


install() {
    app="git curl vim sudo"

    boleanQuestion "is this a server?" "n"
    server=$?

    
    if [[ $server -eq 1 ]]; then
        app=$app" openssh-server"

        boleanQuestion "install firewall (ufw)?" "y"
        firewall=$?

        if [[ $firewall -eq 1 ]]; then
            app=$app" ufw"
        fi

    fi

    apt install $app -y

}

create_user() {
    boleanQuestion "create a new user?" "y"
    create=$?

    if [[ $create -eq 0 ]]; then
        return 0
    fi

    read -p "enter username:" name

    if [[ $name =~ ^[a-z][-a-z0-9_]{2,15}$ ]]; then
        useradd $name -m -s /bin/bash
        passwd $name
        echo "user created"

        boleanQuestion "add user to sudo group?" "n"
        sudo=$?

        if [[ $sudo -eq 1 ]]; then
            usermod -aG sudo $name
            echo "user added to sudo group"
        fi
        return 1
    else
        return 0
    fi
}

main() {
    if not_admin; then
        echo "run as root"
        return 0
    fi
    
    echo -e "\e[32m
   __  ______  ____  ___  ____________
  / / / / __ \/ __ \/   |/_  __/ ____/
 / / / / /_/ / / / / /| | / / / __/   
/ /_/ / ____/ /_/ / ___ |/ / / /___   
\____/_/   /_____/_/  |_/_/ /_____/   
                                      \e[0m"

    apt update
    apt upgrade -y

    echo -e "\e[31m

    _____   ________________    __    __ 
   /  _/ | / / ___/_  __/   |  / /   / / 
   / //  |/ /\__ \ / / / /| | / /   / /  
 _/ // /|  /___/ // / / ___ |/ /___/ /___
/___/_/ |_//____//_/ /_/  |_/_____/_____/
                                        \e[0m"

    install
    echo done

    echo -e "\e[36m
    
   __  _______ __________ 
  / / / / ___// ____/ __ \
 / / / /\__ \/ __/ / /_/ /
/ /_/ /___/ / /___/ _, _/ 
\____//____/_____/_/ |_|  
                          \e[0m"
    
    if create_user; then
        return 0
    fi

    echo done

    echo for some services to work you need to reboot
}


main