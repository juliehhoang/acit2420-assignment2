#!/bin/bash
# This script creates a new user on the system with specified attributes.

# It ensures that the script is run with root privileges, as creating users requires elevated permissions.
if [[ $EUID -ne 0 ]]; then
  echo "Error: This script must be run as root. Use 'sudo' to run the script"
  exit 1
fi

# Checks if no arguments were provided ($# is the number of arguments).
if [[ $# -eq 0 ]]; then
    echo "Use: $0 [-u] username [-s] shell [-g] groups [-h] home directory"
    echo "  -u    Username for the new user"
    echo "  -s    Specify shell (default: /bin/bash)"
    echo "  -g    Additional comma-separated groups"
    echo "  -h    Specify home directory (optional)"
  exit 1
fi

# Default values
USER_SHELL="/bin/bash"   # Default shell for the new user
USER_GROUPS=""           # Default, no additional groups
HOME_DIR=""              # Default, no home directory specified

# Check which options were provided by the user using getopts
while getopts ":u:s:g:h:" opt; do
  case ${opt} in
    u)
      USERNAME="${OPTARG}"   # Set the username for the new user
      ;;
    s)
      USER_SHELL="${OPTARG}" # Set the shell for the new user
      ;;
    g)
      USER_GROUPS="${OPTARG}" # Set additional groups (comma-separated list)
      ;;
    h)
      HOME_DIR="${OPTARG}"    # Set a custom home directory for the new user
      ;;
    \?)
      # Handle invalid options
      echo "Invalid option: -$OPTARG"
      echo "Use: $0 [-u] username [-s] shell [-g] groups [-h] home directory"
      echo "  -u    Username for the new user"
      echo "  -s    Specify shell (default: /bin/bash)"
      echo "  -g    Additional comma-separated groups"
      echo "  -h    Specify home directory (optional)"
      exit 1
      ;;
    :)
      # Handle missing argument for an option
      echo "Error: Option -$OPTARG requires an argument"
      echo "  -u    Username for the new user"
      echo "  -s    Specify shell (default: /bin/bash)"
      echo "  -g    Additional comma-separated groups"
      echo "  -h    Specify home directory"
  esac
done

# Ensure that a username has been provided, as it's required to create or update a user
if [[ -z "$USERNAME" ]]; then
  echo "Error: Username (-u) is required"
  exit 1
fi

# Verify the specified shell is valid and executable (checks if the file exists and is executable)
if [[ ! -x "$USER_SHELL" ]]; then
  echo "Error: Specified shell $USER_SHELL is invalid or does not exist. Ensure the path is correct and the shell is installed"
  exit 1
fi

# Check if the user already exists by trying to retrieve their user ID
USER_EXISTS=false
if id "$USERNAME"; then
  USER_EXISTS=true
  # If no additional options are specified, notify the user and exit
  if [[ -z "$USER_SHELL" && -z "$USER_GROUPS" && -z "$HOME_DIR" ]]; then
    echo "User already exists, please choose a different username."
    exit 1
  else
    # Notify that the user exists and apply specified options
    echo "User '$USERNAME' already exists. Applying specified options to the existing user"
  fi
else
  # If the user does not exist, create a new user with the specified or default options
  if [[ -n "$HOME_DIR" ]]; then
    # Create user with a custom home directory if provided
    useradd -m -d "$HOME_DIR" -s "$USER_SHELL" "$USERNAME"
  else
    # Create user with a default home directory under /home
    useradd -m -s "$USER_SHELL" "$USERNAME"
  fi
  # Check if user creation was successful
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create user $USERNAME. Check if the home directory or username is valid"
    exit 1
  fi
  echo "User $USERNAME created with shell $USER_SHELL."
  
  # Prompt to set a password for the new user only
  echo "Please set the password for $USERNAME (or press Enter to skip):"
  passwd "$USERNAME"
  # Check if setting the password was successful
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to set password for $USERNAME. Try again by using 'passwd $USERNAME'."
    exit 1
  fi
fi

# Update the user's shell if a shell option was specified
if [[ -n "$USER_SHELL" ]]; then
  usermod -s "$USER_SHELL" "$USERNAME"
  if [[ $? -ne 0 ]]; then
    # Error message if setting the shell fails
    echo "Error: Failed to set shell for $USERNAME. Check if the shell path is valid"
    exit 1
  fi
  echo "Shell for $USERNAME set to $USER_SHELL."
fi

# Add user to additional groups if specified by the -g option
if [[ -n "$USER_GROUPS" ]]; then
  # Loop over each group specified in the comma-separated list
  # Reference:https://stackoverflow.com/questions/68420504/how-can-i-print-the-list-of-groups-in-just-one-line-with-commas-between-them
  for GROUP in $(echo "$USER_GROUPS" | sed 's/,/ /g'); do
    # Check if the group exists in the system before adding the user to it
    if grep -q "^$GROUP:" /etc/group; then
      usermod -aG "$GROUP" "$USERNAME"
      if [[ $? -ne 0 ]]; then
        echo "Error: Could not add $USERNAME to group $GROUP. Check group permissions"
        exit 1
      fi
      echo "User $USERNAME added to group $GROUP"
    else
      # Warning if the specified group does not exist
      echo "Warning: Group $GROUP does not exist. Skipping"
    fi
  done
fi

# Set up home directory if provided, and copy default skeleton files if creating a new user
if [[ -n "$HOME_DIR" ]] && [[ ! -d "$HOME_DIR" ]]; then
  # Create the custom home directory and copy skeleton files for the user
  mkdir -p "$HOME_DIR"
  cp -r /etc/skel/. "$HOME_DIR"
  chown -R "$USERNAME":"$USERNAME" "$HOME_DIR"
  echo "Home directory $HOME_DIR created and skeleton files copied"
fi

echo "User $USERNAME setup or updated successfully"
