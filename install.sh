#!/bin/bash


not_admin() {
    code=$(id -u)
    if [[ "$code" == "0" ]]; then
        return 1
    else
        return 0
    fi

}

update() {
    echo -e "\e[32m
   __  ______  ____  ___  ____________
  / / / / __ \/ __ \/   |/_  __/ ____/
 / / / / /_/ / / / / /| | / / / __/   
/ /_/ / ____/ /_/ / ___ |/ / / /___   
\____/_/   /_____/_/  |_/_/ /_____/   
                                      \e[0m"

    apt update
    apt upgrade -y
}


install_tools() {

    echo -e "\e[35m
  __________  ____  __   _____
 /_  __/ __ \/ __ \/ /  / ___/
  / / / / / / / / / /   \__ \ 
 / / / /_/ / /_/ / /______/ / 
/_/  \____/\____/_____/____/  
                              \e[0m"
    apt install git curl vim sudo openssh-server -y
}

create_user() {
    echo -e "\e[36m
    
   __  _______ __________ 
  / / / / ___// ____/ __ \
 / / / /\__ \/ __/ / /_/ /
/ /_/ /___/ / /___/ _, _/ 
\____//____/_____/_/ |_|  
                          \e[0m"
    echo 
    read -p "enter username:" name
    echo $name

    if [[ $name =~ ^[a-z][-a-z0-9_]{2,15}$ ]]; then
        useradd $name -m -s /bin/bash -G sudo
        passwd $name
        echo "user created ($name is sudo)"
        return 1
    else
        return 0
    fi
}

main() {
    if not_admin; then
        return 0
    fi
    
    echo -e "\e[31m

    _____   ________________    __    __ 
   /  _/ | / / ___/_  __/   |  / /   / / 
   / //  |/ /\__ \ / / / /| | / /   / /  
 _/ // /|  /___/ // / / ___ |/ /___/ /___
/___/_/ |_//____//_/ /_/  |_/_____/_____/
                                        \e[0m"

    update
    echo done

    install_tools
    echo done
    
    if create_user; then
        return 0
    fi

    echo done

    ehco rebooting.....
    systemctl reboot
}


main