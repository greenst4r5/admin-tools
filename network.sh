#!/bin/bash

usage="Usage: $0 <file>"

not_admin() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" 
        return 1
    else
        return 0
    fi
}


file_exists() {
    # check if has args
    if [[ -z $1 ]]; then
        echo $usage
        return 1
    fi

    # check if file exists
    if [[ -f $1 ]]; then
        return 0
    else
        echo "file not exists"
        return 1
    fi
}



main() {
    if not_admin; then
        return 0
    fi

    # check if has args
    if file_exists; then
        return 0
    fi

    cp $1 ./test
}


main