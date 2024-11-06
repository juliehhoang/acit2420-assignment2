#!/bin/bash

# Script to install essential packages on an Arch Linux system.
# This script checks if it is run with root privileges, verifies if each package
# is already installed, and installs it if necessary.

# Define the list of packages to install
PACKAGES=("kakoune" "tmux")

# Check if the script is being run as root.
# $EUID is the effective user ID of the current user.
# If the user is not root, the script displays a message and exits.
# Reference: https://stackoverflow.com/questions/18215973/how-to-check-if-running-as-root-in-a-bash-script
if [[ $EUID -ne 0 ]]; then
    # Inform the user that the script needs to be run as root
    echo "Please try using 'sudo'. This script needs to be run as root."
    exit 1  # Exit with a status of 1 to indicate an error
fi

# Loop through each package in the list to check if it's installed
for package in "${PACKAGES[@]}"; do
    # Use pacman -Qi to check if the package is already installed
    # It will return a non-zero exit code if the package is not installed
    if ! pacman -Qi "$package"; then
        echo "Installing $package..."
        
        # Install the package using pacman, Arch Linux's package manager
        # -S option installs the specified packages
        if pacman -S "$package"; then
            echo "$package installed successfully."
        else
            echo "Failed to install $package. Please check for any issues and try again."
            exit 1  # Exit status of 1 to indicate an error
        fi
    else
        echo "$package is already installed."
    fi
done


