#!/bin/bash

#Remember to run "chmod 755" or "chmod +x" on this file for it to work.

#This will display usage options of the script for the user:
function display_usage {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Single user options:"
    echo "  -c, --create    Create a new user account"
    echo "  -d, --delete    Delete an existing user account."
    echo "  -r, --reset     Reset password for an existing user account."
    echo "  -l, --list      List all user accounts on the system."
    echo "  -h, --help      Display this help and exit."
    echo "  -a, --audit     Audit logs for a selected user"
    echo "       "
    echo "User Groups options:"
    echo "  -cg, --create-group  Creates a new user group"
    echo "  -ga, --group-add     Adds a user to a group"
    echo "  -gr, --group-remove  Removes a user from a group"
}

# -------------------------------------------------------------------------
# Single user functions 
# -------------------------------------------------------------------------

#Function to create a user
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

# Function to delete existing user
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


    if id "$username" &>/dev/null; then
        read -p -s "Enter the new password for $username: " password

        # Set the new password
        echo "$username:$password" | sudo chpasswd

        echo "Password for user '$username' reset successfully."
    else
        echo "Error: The username '$username' does not exist. Please enter a valid username."
    fi
}

function user_audit {
    read -p "Enter the username you wish to user:   " username

    if id "$username" &>/dev/null; then
    echo "Audit log for user '$username':"
    echo ""

    echo "Last login:"
    lastlog -u "$username"
    echo ""

    echo "Login/logout history:"
    last "$username"
    echo ""

    echo "User '$username' command history:"
    history_file="home/$username/.bash_history"

        if [[ -f "$history_file" ]]; then
            tail -n 10 "$history_file" 
        else 
            echo "No command history can be found for $username."
        fi

    else 
        echo "Error: User $username does not exist. Please check the username and try again"
    fi
}

# -----------------------------------------------------------------------
# User Group Functions 
# -----------------------------------------------------------------------

function create_group {
    read -p "Enter the name of the group you would like to create:  " groupname

    # Check if group already exists
    if getent group "$group_name" > /dev/null 2>&1; then
        echo "Group name already exists. Please enter a diffrent name"
        return 1
    else 
        if sudo groupadd "$groupname"; then
            echo "User Group '$groupname' has been created"
        else 
            echo "User group could not be created"
        fi
    fi
}

function add_user_to_group {
    read -p "Enter the username you want to use:  " username
    read -p "Enter the group name:  " groupname

        # Check if the group exists
    if ! getent group "$groupname" > /dev/null 2>&1; then
        echo "Group '$groupname' does not exist."
        return 1
    fi

    # Check if the username exists
    if ! id "$username" > /dev/null 2>&1; then
        echo "User '$username' does not exist."
        return 1
    fi

    if sudo usermod -a -G $groupname $username; then
        echo "User '$username' has been added to the user gropu '$groupname'"
    else
        echo "An error occoured, please check the username and groupname you are using"
        return 1
    fi
}

# Removes user form a user group:
function remove_user_from_group {
    read -p "Enter the username you would like to remove:   " username
    read -p "Please enter the user group you would like to remove this user from:   " groupname

    if ! getent group "$groupname" > /dev/null 2>&1; then
        echo "The group '$groupname' does not exist."
        return 1
    fi 

    if sudo deluser $username $gropuname; then
        echo "User '$username' has been removed from the user gropu '$groupname"
    else 
        echo "An error occourd. Please check permissions and the names of your user and group."
        return 1
    fi
}

# Function to list all user accounts on the system
function list_users {
    echo "User accounts on the system:"
    cat /etc/passwd | awk -F: '{print "- " $1 " (UID: " $3 ")"}'
}

# Check the passed option
if [[ $# -eq 0 ]]; then
    echo "Error: No options provided. Use -h or --help for usage."
    exit 1
fi

#Uncomment the line below to enable debuging output
#echo "Option passed: $1"  # Debugging line to check what argument is passed

case "$1" in
    -c|--create)
        create_user
        ;;
    -d|--delete)
        delete_user
        ;;
    -r|--reset)
        reset_password
        ;;
    -l|--list)
        list_users
        ;;
    -h|--help)
        display_usage
        ;;
    -cg|--create-group)
        create_group
        ;;
    -ga|--group-add)
        add_user_to_group
        ;;
    -gr|--group-remove)
        remove_user_from_group
        ;;
    -a|--audit)
        user_audit
        ;;
    *)
        echo "Invalid option. Use -h or --help for usage."
        exit 1
        ;;
    
esac

