#!/bin/bash
# Script to install essential packages and checks if it is run with root privileges,
# verifies if each package is already installed, and installs it if necessary.

# Defines the file that contains the user-defined list of packages
PACKAGES="packages.txt"

# Check if the script is being run as root.
# $EUID is the effective user ID of the current user.
# Reference: https://stackoverflow.com/questions/18215973/how-to-check-if-running-as-root-in-a-bash-script
if [[ $EUID -ne 0 ]]; then
    echo "This script needs to be run as root (try using sudo)"
    exit 1  # Exit status of 1 to indicate an error
fi

# Check if the package file exists
if [[ ! -f "$PACKAGES" ]]; then
    echo "Package file '$PACKAGES' not found"
    exit 1  # Exit with an error code if the file does not exist
fi

# Read the package list from the file and install each package
for package in $(cat "$PACKAGES"); do
    # Check if the package is already installed
    if ! pacman -Qi "$package"; then
        echo "Installing $package..."
        
        # Install the package using pacman
        if pacman -S "$package"; then
            echo "$package installed successfully"
        else
            echo "Failed to install $package. Please try again"
            exit 1  # Exit status of 1 to indicate an error
        fi
    else
        echo "$package is already installed"
    fi
done

