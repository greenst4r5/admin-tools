#!/bin/bash


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

if ! command -v docker >/dev/null; then 
    boleanQuestion "install docker?" "y"
    install=$?

    if [[ $install -eq 0 ]]; then
        exit 0
    fi

    echo -e "\e[32mInstalling docker\e[0m"


    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do 
        sudo apt-get remove $pkg;
    done

    echo -e "\e[31m

    _____   ________________    __    __ 
   /  _/ | / / ___/_  __/   |  / /   / / 
   / //  |/ /\__ \ / / / /| | / /   / /  
 _/ // /|  /___/ // / / ___ |/ /___/ /___
/___/_/ |_//____//_/ /_/  |_/_____/_____/
                                        \e[0m"

    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    
    boleanQuestion "add current user in docker group?" "y"
    grouping=$?
    
    if [[ $grouping -eq 1 ]]; then
        sudo usermod -aG docker $USER
        echo "added $USER to docker group"
    fi

    echo -e "\e[32mDocker installed\e[0m"
else
    boleanQuestion "remove docker?" "n"
    remove=$?

    if [[ $remove -eq 1 ]]; then
        sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras -y
        sudo apt-get autoremove -y
        
        sudo rm -rf /var/lib/docker
        sudo rm -rf /var/lib/containerd

        sudo rm /etc/apt/sources.list.d/docker.list
        sudo rm /etc/apt/keyrings/docker.asc

        echo -e "\e[31mDocker removed\e[0m"
    fi
fi