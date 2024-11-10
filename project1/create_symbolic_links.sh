#!/bin/bash
# Script to create symbolic links for configuration files and executables

# Ensure bin and config directories exist
# The -p option makes sure the directory is created if it doesn't already exist
mkdir -p ~/bin ~/.config/kak ~/.config/tmux

# Create a symbolic link for the 'sayhi' executable file in the current directory's 'bin' folder
# $(pwd) returns the absolute path of the current directory
# The -s flag creates a symbolic link instead of copying the file
# The -f flag forces the link to overwrite any existing file or link at the target location
ln -sf "$(pwd)/bin/sayhi" ~/bin/sayhi

# Create a symbolic link for the 'install-fonts' executable file in the current directory's 'bin' folder
ln -sf "$(pwd)/bin/install-fonts" ~/bin/install-fonts

# Create symbolic links for configuration files for Kakoune (kak) and tmux
ln -sf "$(pwd)/config/kak/kakrc" ~/.config/kak/kakrc
ln -sf "$(pwd)/config/tmux/tmux.conf" ~/.config/tmux/tmux.conf

# Create a symbolic link for the bashrc configuration file
ln -sf "$(pwd)/home/bashrc" ~/.bashrc

# Check if the ~/bin directory already exists
if [ ! -d ~/bin ]; then
    # If ~/bin doesn't exist, create the symbolic link for ~/bin to the original bin directory
    ln -sf "$(pwd)/bin" ~/bin
    echo "Created symbolic link for ~/bin"
else
    echo "~/bin already exists, skipping symbolic link creation"
fi

# Check if the ~/.config directory already exists
if [ ! -d ~/.config ]; then
    # If ~/.config doesn't exist, create the symbolic link for ~/.config to the original config directory
    ln -sf "$(pwd)/config" ~/.config
    echo "Created symbolic link for ~/.config"
else
    echo "~/.config already exists, skipping symbolic link creation"
fi

echo "Symbolic links created successfully"


