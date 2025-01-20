#!/bin/bash

# Secure password generator - Written by William Kingston

#Remember to run "chmod 755" or "chmod +x" on this file for it to work.

function display_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options"
    echo " -l, --length <number>        Length of the password (default: 12)."
    echo "  -n, --number <count>         Number of passwords to generate (default: 1)."
    echo "  -s, --special                Include special characters (default: enabled)."
    echo "  -x, --no-special             Exclude special characters."
    echo "  -u, --uppercase              Include uppercase letters (default: enabled)."
    echo "  -v, --no-uppercase           Exclude uppercase letters."
    echo "  -h, --help                   Display this help message."
    exit 1

}

# Default settings
LENGTH=12
COUNT=1
INCLUDE_SPECIAL=true
INCLUDE_UPPERCASE=true

while [[ "$#" -gt 0 ]]; do
    case $1 in 
        -l|--length) LENGTH="$2"; shift ;;
        -n|--number) COUNT="$2"; shift ;;
        -s|--special) INCLUDE_SPECIAL=true ;;
        -x|--no-special) INCLUDE_SPECIAL=false ;;
        -u|--uppercase) INCLUDE_UPPERCASE=true ;;
        -v|--no-uppercase) INCLUDE_UPPERCASE=false ;;
        -h|--help) display_usage ;;
        *) echo "Unknown option: $1"; display_usage ;;
    esac
    shift
done 

function generate_password() {
    local chars="abcdefghijklmnopqrstuvwxyz"
    local numbers="0123456789"
    local special="!@#$%^&*()-_=+[]{}<>?~"
    local charset="$chars"

    if $INCLUDE_UPPERCASE; then
        charset+="${chars^^}"
    fi

    if $INCLUDE_SPECIAL; then
        charset+="$special"
    fi

    charset+="$numbers"

    local password=""
    for ((i = 0; i < LENGTH; i++)); do
        password+="${charset:RANDOM%${#charset}:1}" 
    done

    echo "$password"
}

for ((i = 1; i <= COUNT; i++)); do
    generate_password
done