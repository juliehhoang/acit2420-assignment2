#!/bin/bash
# This script provides options to install packages (-i) and/or create symbolic links (-l) as part of a system setup process.

# Initialize flags to track which options are chosen
install_packages=false  
create_links=false      

# Check which options were provided by the user using getopts
# The "i" option enables package installation
# The "l" option enables symbolic link creation
while getopts "il" opt; do
  case "${opt}" in
    i)  # If -i is specified, set the install_packages flag to true
      install_packages=true
      ;;
    l)  # If -l is specified, set the create_links flag to true
      create_links=true
      ;;
    *)  # If an invalid option is provided, display usage instructions and exit
      echo "Use: $0 [-i to install packages] [-l to create symbolic links]"
      exit 1
      ;;
  esac
done

# Check if at least one valid option (-i or -l) is provided
if ! $install_packages && ! $create_links; then
  echo "You must specify at least one option (-i or -l)"
  echo "Use: $0 [-i] to install the packages, [-l] to create symbolic links for configuration files"
  exit 1
fi

# Run the package installation script if the -i option is specified
if $install_packages; then
  echo "Running package installation..."
  if ./install_packages.sh; then
    echo "Packages installed successfully"  
  else
    echo "Failed to install packages"  
    exit 1
  fi
fi

# Run the symbolic link creation script if the -l option is specified
if $create_links; then
  echo "Creating symbolic links..."
  if ./create_symbolic_links.sh; then
    echo "Symbolic links created"
  else
    echo "Failed to create symbolic links"
    exit 1
  fi
fi

exit 0

