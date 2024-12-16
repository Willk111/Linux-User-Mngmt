#!/bin/bash

#Remember to run "chmod 755" on this file for it to work.

#This will display usage options of the script for the user:
function display_usage {
    echo "Usage: $0 [OPTIONS]"
    echo "options"
    echo "  -c, --create Create a new user account"
    echo "  -d, --delete  Delete an existing user account."
    echo "  -r, --reset   Reset password for an existing user account."
    echo "  -l, --list    List all user accounts on the system."
    echo "  -h, --help    Display this help and exit."
}

function create_user {
    read -p "Enter the new users username please: " username

    if id "$username" &>dev/null; then
        echo "Error: This username already exists, please choose another one"
        return 1
    fi

    read -p "Enter the password for the new user $username" password

    if sudo useradd -m -p "$password" "$username"; then
        echo "Congratulations! YOur new user '$useranme' has been created"
    else 
        echo "Error, orry this user account could not be created."
        return 1
    fi
}

function delete_user {
    read -p "Enter the username of the user you want to delete: " username

    if id "$username" &>/dev/null; then
        if sudo userdel -r "$username" 2>/dev/null; then
            echo "User account '$username' has been deleted"
        else 
            echo "Error: Could not delete the user: '$username' "
        fi
    else 
        echo "Error:  Could not find account by the name '$username' "
        return 1
    fi

}

# Function to reset the password for an existing user account
function reset_password {
    read -p "Enter the username to reset password: " username

    # Check if the username exists
    if id "$username" &>/dev/null; then
        # Prompt for password (Note: you might want to use 'read -s' to hide the password input)
        read -p "Enter the new password for $username: " password

        # Set the new password
        echo "$username:$password" | sudo chpasswd

        echo "Password for user '$username' reset successfully."
    else
        echo "Error: The username '$username' does not exist. Please enter a valid username."
    fi
}

# Function to list all user accounts on the system
function list_users {
    echo "User accounts on the system:"
    cat /etc/passwd | awk -F: '{print "- " $1 " (UID: " $3 ")"}'
}
