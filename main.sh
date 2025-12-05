#!/bin/bash
set -euo pipefail
SCRIPTDIR="$(cd "$(dirname "$0")" && pwd)"
USERS_FILE="$SCRIPTDIR/users.txt"
LOGGER="$SCRIPTDIR/logger.sh"
DOCS="$SCRIPTDIR/docs"
mkdir -p "$DOCS" "$SCRIPTDIR/logs" "$SCRIPTDIR/backups"

# Login
echo "Welcome to DMS (local, plain-text passwords)"
read -p "Username: " USERNAME
read -s -p "Password: " PASSWORD
echo

# Validate credentials
CRED_LINE=$(grep -E "^${USERNAME}:" "$USERS_FILE" | head -n1 || true)
if [ -z "$CRED_LINE" ]; then
    echo "User not found."
    exit 1
fi
IFS=':' read -r U P R <<< "$CRED_LINE"
if [ "$PASSWORD" != "$P" ]; then
    echo "Invalid password."
    exit 1
fi
ROLE="$R"
echo "Welcome $USERNAME ($ROLE)"
bash "$LOGGER" LOGIN "$USERNAME" SUCCESS

while true; do
    echo
    echo "===== Main Menu ($USERNAME - $ROLE) ====="
    if [ "$ROLE" = "admin" ]; then
        echo "1) Upload file"
        echo "2) Delete file"
        echo "3) List files"
        echo "4) Search"
        echo "5) Backup"
        echo "6) Restore"
        echo "7) Manage users"
        echo "8) View logs"
        echo "9) Exit"
        read -p "Choose: " opt
        case "$opt" in
            1) read -p "Full path to file: " fp; bash "$SCRIPTDIR/file_manager.sh" upload "$fp" "$USERNAME";;
            2) read -p "Relative name in docs/: " rf; bash "$SCRIPTDIR/file_manager.sh" delete "$rf" "$USERNAME";;
            3) bash "$SCRIPTDIR/file_manager.sh" list "$USERNAME";;
            4) read -p "Search term: " t; bash "$SCRIPTDIR/search.sh" "$t" "$USERNAME";;
            5) bash "$SCRIPTDIR/backup.sh" "$USERNAME";;
            6) bash "$SCRIPTDIR/restore.sh" "$USERNAME";;
            7)
    clear
    echo "===== User Manager ====="
    echo "1) Add user"
    echo "2) Remove user"
    echo "3) Back"
    read -p "Choose: " uopt

    case "$uopt" in
        1)
            read -p "Enter username: " newu
            read -p "Enter password: " newp
            read -p "Enter role (admin|staff|viewer): " newr
            bash "$SCRIPTDIR/user_manager.sh" add "$newu" "$newp" "$newr"
            read -p "Press Enter to continue..."
        ;;
        2)
            read -p "Enter username to remove: " rmu
            bash "$SCRIPTDIR/user_manager.sh" remove "$rmu"
            read -p "Press Enter to continue..."
        ;;
        3)
            
        ;;
        *)
            echo "Invalid choice"
            sleep 1
        ;;
    esac
;;
            8) bash "$SCRIPTDIR/logger.sh" SHOW;;
            9) echo "Goodbye."; exit 0;;
            *) echo "Invalid";;
        esac
    elif [ "$ROLE" = "staff" ]; then
        echo "1) Upload file"
        echo "2) Delete file (allowed for staff)"
        echo "3) List files"
        echo "4) Search"
        echo "5) view file"
        echo "6) Exit"
        read -p "Choose: " opt
        case "$opt" in
            1) read -p "Full path to file: " fp; bash "$SCRIPTDIR/file_manager.sh" upload "$fp" "$USERNAME";;
            2) read -p "Relative name in docs/: " rf; bash "$SCRIPTDIR/file_manager.sh" delete "$rf" "$USERNAME";;
            3) bash "$SCRIPTDIR/file_manager.sh" list "$USERNAME";;
            4) read -p "Search term: " t; bash "$SCRIPTDIR/search.sh" "$t" "$USERNAME";;
            5) read -p "Filename: " f; bash "$SCRIPTDIR/file_manager.sh" view "$f" "$USERNAME";;
            6) echo "Goodbye."; exit 0;;
            *) echo "Invalid";;
        esac
    elif [ "$ROLE" = "viewer" ]; then
        echo "1) List files"
        echo "2) view file"
        echo "3) Search"
        echo "4) Exit"
        read -p "Choose: " opt
        case "$opt" in
            1) bash "$SCRIPTDIR/file_manager.sh" list "$USERNAME";;
            2) read -p "Filename: " f; bash "$SCRIPTDIR/file_manager.sh" view "$f" "$USERNAME";;
            3) read -p "Search term: " t; bash "$SCRIPTDIR/search.sh" "$t" "$USERNAME";;
            4) echo "Goodbye."; exit 0;;
            *) echo "Invalid";;
        esac
    else
        echo "Unknown role: $ROLE"
        exit 1
    fi
done
