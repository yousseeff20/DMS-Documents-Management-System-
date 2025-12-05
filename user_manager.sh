#!/bin/bash
# user_manager.sh - Add / Remove users for DMS

set -euo pipefail

USERS_FILE="/home/usef/Desktop/dms_final/users.txt"

if [ ! -f "$USERS_FILE" ]; then
    echo "ERROR: users.txt not found!"
    exit 1
fi

cmd="${1:-}"

case "$cmd" in

    add)
        # Read args OR interactive
        username="${2:-}"
        password="${3:-}"
        role="${4:-}"

        if [ -z "$username" ]; then
            read -p "Enter username: " username
        fi
        if [ -z "$password" ]; then
            read -p "Enter password: " password
        fi
        if [ -z "$role" ]; then
            read -p "Enter role (admin/staff/viewer): " role
        fi

        # Validate empty fields
        if [ -z "$username" ]  [ -z "$password" ]  [ -z "$role" ]; then
            echo "ERROR: Missing fields!"
            exit 2
        fi

        if grep -q "^$username:" "$USERS_FILE"; then
            echo "User already exists!"
            exit 3
        fi

        echo "$username:$password:$role" >> "$USERS_FILE"
        echo "User added successfully!"
    ;;

    remove)
        username="${2:-}"

        if [ -z "$username" ]; then
            read -p "Enter username to remove: " username
        fi

        if ! grep -q "^$username:" "$USERS_FILE"; then
            echo "User not found!"
            exit 3
        fi

        sed -i "/^$username:/d" "$USERS_FILE"
        echo "User removed successfully!"
    ;;

    *)
        echo "Usage: user_manager.sh {add|remove}"
        exit 4
    ;;
esac
