# DEVOPSFETCH

## Objective
`devopsfetch` is a DevOps tool designed to collect and display critical system information, including details on active ports, user logins, Nginx configurations, Docker images, and container statuses. The tool also includes a systemd service for continuous monitoring and logging.

## Features
The features includes:
- **Log Management**: Ensuring log rotation and management to prevent excessive log file growth.
- **Log Rotation**: Rotating logs
- **Displaying System Information**: It displays system information in a well presented manner


## Usage
To use `devopsfetch`, run the installation script to install all dependencies and set up logging and systemd.
Then simply invoke the tool `./devopsfetch.sh` with the desired flags as shown in the examples above. 
The tool will output the requested information in a clear format

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Kemzzy-Dev/devopsfetch.git
   cd /devopsfetch

2. Make it an executable 
   ```bash
   chmod +x install.sh
   chmod +x devopsfetch.sh

3. Run the installation script
   ```bash
    ./install.sh

4. Start using the program
    `Refer to the guide above`


### Commands

#### Ports
- **Display all active ports and services**
  - Flag: `-p` or `--port`
  - Usage: `./devopsfetch.sh -p` or `./devopsfetch.sh --port`
  
- **Provide detailed information about a specific port**
  - Flag: `-p <port_number>`
  - Usage: `./devopsfetch.sh -p 80` or `./devopsfetch.sh --port 80`

#### Docker
- **List all Docker images and containers**
  - Flag: `-d` or `--docker`
  - Usage: `./devopsfetch.sh -d` or `./devopsfetch.sh --docker`
  
- **Provide detailed information about a specific container**
  - Flag: `-d <container_name>`
  - Usage: `./devopsfetch.sh -d my_container` or `./devopsfetch.sh --docker my_container`

#### Nginx
- **Display all Nginx domains and their ports**
  - Flag: `-n` or `--nginx`
  - Usage: `./devopsfetch.sh -n` or `./devopsfetch.sh --nginx`
  
- **Provide detailed configuration information for a specific domain**
  - Flag: `-n <domain>`
  - Usage: `./devopsfetch.sh -n example.com` or `./devopsfetch.sh --nginx example.com`

#### Users
- **List all users and their last login times**
  - Flag: `-u` or `--users`
  - Usage: `./devopsfetch.sh -u` or `./devopsfetch.sh --users`
  
- **Provide detailed information about a specific user**
  - Flag: `-u <username>`
  - Usage: `./devopsfetch.sh -u john_doe` or `./devopsfetch.sh --users john_doe`

#### Time Range
- **Display activities within a specified time range**
  - Flag: `-t` or `--time`
  - Usage: `./devopsfetch.sh -t "2024-07-01 00:00:00" "2024-07-24 23:59:59"` or `./devopsfetch.sh --time "2024-07-01 00:00:00" "2024-07-24 23:59:59"`

### Help and Documentation
Use the help flag to display usage instructions for the program:
- Flag: `-h` or `--help`
- Usage: `./devopsfetch.sh -h` or `./devopsfetch.sh --help`