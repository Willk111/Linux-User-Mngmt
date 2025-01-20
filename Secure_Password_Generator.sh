#!/bin/bash

# Secure password generator - Written by William Kingston

function display_usage() {
    echo "Usage: $) [OPTIONS]"
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