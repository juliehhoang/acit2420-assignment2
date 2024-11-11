# acit2420-assignment2
This project consists of two main Bash scripting projects designed to automate system setup and user management tasks. These scripts simplify the process of installing essential packages, setting up symbolic links for configuration files, and creating new users with predefined settings.
## Overview
1. **Project 1: Configuration scripts**: Automate the installation of packages and create symbolic links to configuration files stored in a remote Git repository.
2. **Project 2: New user script**: Automate the process of creating a new user with specific group memberships, home directory setup, and shell configuration.
## Prerequisites
- **OS**: Arch Linux
- **Editor**: Neovim
- **Shell**: Bash
Ensure you have the required permissions to execute these scripts.
### Cloning the Repository
To start, clone the repository:
```bash
git clone https://github.com/juliehhoang/acit2420-assignment2.git
```
---
## Project 1: Configuration Scripts
The system setup scripts will automate the process of installing software and configuring directories for ease of use.
#### Script Components
1. **Package Installation**: Installs required packages.
2. **Symbolic Links Creation: Creates symbolic links from configuration files to the appropriate locations.
3. **Master Script**: Used to call package installation and symbolic links creation as required.
---
### `install_packages.sh` - Package Installation Script
This script automates the installation of essential software packages on an Arch Linux system. It reads a list of packages from a specified file, checks if each package is already installed, and installs it if it’s missing.
#### Script Details
- **Root Privileges**: This script must be run with root privileges because it installs system packages. If the script is not run as root, it will exit and prompt the user to use `sudo`.
    
- **Package List**: The script reads the package names from a file named `packages.txt`, which is located in the same directory as the script. Each line in `packages.txt` should contain the name of a package to be installed.
    
- **Installation Check**: Before attempting to install each package, the script checks if it is already installed using `pacman -Qi`. If the package is found, it will skip the installation for that package.
    
- **Installation**: For packages not already installed, the script uses `pacman -S` to install them. After each installation attempt, it checks if the installation was successful. If an installation fails, it will display an error message and exit.
#### Usage
**Run the Script**: Open a terminal, navigate to the directory containing `install_packages.sh`, and run the script with `sudo`:

```bash
`sudo ./install_packages.sh`
```
#### Notes
- **Package Manager**: This script is designed specifically for **Arch Linux** and uses `pacman` as the package manager.
---
### `create_symbolic_links.sh` - Symbolic Link Creation Script
This script sets up symbolic links for executable files and configuration files, allowing you to maintain a central repository for configuration and executable files. It creates links from these files to commonly used locations on your system, making it easier to keep your environment consistent and manage configurations from a single source.
#### Script Details
- **Directory Creation**: The script ensures that the necessary directories (`~/bin`, `~/.config/kak`, and `~/.config/tmux`) exist. If they don’t, the script creates them.

- **Symbolic Links**: 
  - **Executables**: Creates symbolic links for executable files (`sayhi` and `install-fonts`) from the local `bin` directory to `~/bin`.
  
  - **Configuration Files**:
    - Creates symbolic links for configuration files for `kakoune` (`kakrc`) and `tmux` (`tmux.conf`) from the local `config` directory to the `~/.config` directory.
    - Creates a symbolic link for `bashrc` in the `home` directory, linking it to `~/.bashrc`.

- **Overwrite Behavior**: Uses the `-f` option with `ln` to force overwrite any existing files or links at the target location, ensuring that links are updated if they already exist.

- **Check for Directories**: 
  - If `~/bin` or `~/.config` directories already exist, it skips linking these directories directly. Otherwise, it creates links for the `~/bin` and `~/.config` directories.
#### Usage
**Run the Script**: Open a terminal, navigate to the directory containing `create_symbolic_links.sh`, and run the script:
```bash
 ./create_symbolic_links.sh
```

**Script Completion**: Once the script completes, all required symbolic links will be set up. You can verify the links by checking the target locations (`~/bin`, `~/.config`, `~/.bashrc`) to ensure they point to the original files in the local directory.
#### Files and Directories Structure
- bin/
	- sayhi
	- install-fonts
- config/
	- kak/
		- kakrc
	- tmux/
		- tmux.conf
- home/
	- bashrc
The script will create links in:
- `~/bin/sayhi` -> `bin/sayhi`
- `~/bin/install-fonts` -> `bin/install-fonts`
- `~/.config/kak/kakrc` -> `config/kak/kakrc`
- `~/.config/tmux/tmux.conf` -> `config/tmux/tmux.conf`
- `~/.bashrc` -> `home/bashrc`
#### Notes
- **Link Management**: This approach lets you store all configurations in a central directory (your repository) and manage updates more easily.
- **Environment Consistency**: This script is especially useful if you frequently set up new environments, as it enables you to quickly set up consistent configurations and tools.
---
### `configure_system.sh` - System Configuration Script
This script provides a flexible way to set up your system by combining package installation and symbolic link creation into one command. You can choose to install packages, create symbolic links, or do both, based on the options you specify.
#### Script Details
- **Options**:
  - **`-i`**: Installs packages from the predefined `packages.txt` file by running the `install_packages.sh` script.
  - **`-l`**: Creates symbolic links for configuration files by running the `create_symbolic_links.sh` script.
  
- **Command-Line Parsing**:
  - The script uses `getopts` to handle the command-line options `-i` and `-l`.
  - If neither option is provided, it displays usage instructions and exits.

- **Script Execution**:
  - Based on the options selected, it either:
    - Runs `install_packages.sh` to install packages.
    - Runs `create_symbolic_links.sh` to create symbolic links.
  - After executing each selected option, it displays a success or failure message.
#### Usage

1. **Basic Usage**:
   - **To install packages only**:
     ```bash
     ./configure_system.sh -i
     ```
   - **To create symbolic links only**:
     ```bash
     ./configure_system.sh -l
     ```
   - **To perform both actions**:
     ```bash
     ./configure_system.sh -i -l
     ```

2. **Help and Errors**:
   - If you don’t provide any options or provide invalid options, the script will display usage instructions:
     ```plaintext
     Use: ./configure_system.sh [-i to install packages] [-l to create symbolic links]
     ```

3. **Script Output**:
   - If you select `-i`, the script will output messages about the package installation process.
   - If you select `-l`, the script will output messages about the symbolic link creation process.
   - Each step will show whether it succeeded or failed.
#### Notes
- **Permissions**: Since the package installation may require root privileges, you may need to run the script with `sudo` if using the `-i` option.
---
## Project 2: New User Script
This project contains a Bash script for creating and configuring new users on a Linux system. The script allows administrators to specify options such as the user’s shell, groups, and home directory, simplifying the process of user setup.
## Features
- **Create New Users**: Creates a user with a specified username.
- **Customizable Shell**: Option to set a default shell (e.g., `/bin/bash`, `/bin/zsh`).
- **Group Management**: Adds the user to additional groups.
- **Custom Home Directory**: Allows specification of a custom home directory path.
- **Password Prompt**: Prompts for setting a password for the new user.
## Script Logic
1. **Root Check**: Verifies the script is run with root privileges.
2. **User Existence Check**: Checks if the username already exists. If so, applies any provided options to update the existing user.
3. **User Creation**: If the user does not exist, creates a new user with the specified username, shell, and home directory.
4. **Group Assignment**: Adds the user to specified groups if provided.
5. **Home Directory Setup**: Creates and sets up the home directory if specified.
6. **Password Setup**: Prompts the administrator to set a password for the new user.
 
---
### `new_user_script.sh` - New User Creation Script
This script automates the process of creating a new user on a Linux system with specific options for shell, groups, and home directory. It verifies root privileges, checks user input, and allows for updates to an existing user if they already exist.
#### Script Details
- **Options**:
  - **`-u`**: Specify the username for the new user. This option is required.
  - **`-s`**: Set the shell for the new user (e.g., `/bin/bash` by default).
  - **`-g`**: Specify additional groups for the new user in a comma-separated format (e.g., `-g group1,group2`).
  - **`-h`**: Set a custom home directory path for the new user. If not specified, the default path under `/home` will be used.

- **Script Execution**:
  - Ensures it is run as root (exits with a message if not).
  - Checks if the specified username already exists on the system.
    - If it exists, it applies any specified updates to shell, groups, or home directory.
    - If it does not exist, it creates a new user with the specified options.
  - Sets the user’s password and prompts to confirm.
  - Adds the user to specified groups, checking if each group exists before adding.
  - Copies skeleton files to the new user’s home directory if it was created.
#### Usage
1. **Basic Usage**:
   - **To create a new user with a specified username**:
     ```bash
     sudo ./new_user_script.sh -u newusername
     ```
   - **To specify shell and groups**:
     ```bash
     sudo ./new_user_script.sh -u newusername -s /bin/zsh -g group1,group2
     ```
   - **To specify a custom home directory**:
     ```bash
     sudo ./new_user_script.sh -u newusername -h /custom/home/dir
     ```
#### Notes
- **Permissions**: This script must be run as root or with `sudo`.
- **Error Handling**: The script handles invalid options and missing arguments with clear messages and exits gracefully.