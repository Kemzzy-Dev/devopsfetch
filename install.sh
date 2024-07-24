#!/bin/bash

# Function to install necessary dependencies
install_dependencies() {
    echo "Installing necessary dependencies..."
    sudo apt-get update
    sudo apt-get install -y nginx docker.io jq net-tools


    # Ensure Docker is started
    sudo systemctl start docker
    sudo systemctl enable docker

    # Create log directory
    sudo mkdir -p /var/log/devopsfetch
}

# Function to create the systemd service
create_systemd_service() {

    cat <<EOF | sudo tee /etc/systemd/system/devopsfetch.service
[Unit]
Description=DevOps Fetch Service
After=network.target

[Service]
ExecStart=/home/ubuntu/devopsfetch/devopsfetch.sh
Restart=always
StandardOutput=file:/var/log/devopsfetch/devopsfetch.log
StandardError=file:/var/log/devopsfetch/devopsfetch.log

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
Unit=devopsfetch.service

[Install]
WantedBy=multi-user.target
EOF >

    sudo systemctl daemon-reload
    sudo systemctl enable devopsfetch.service
    sudo systemctl start devopsfetch.service
}

# Function to set up log rotation
setup_log_rotation() {

    cat <<EOF | sudo tee /etc/logrotate.d/devopsfetch
/var/log/devopsfetch/devopsfetch.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
    create 0640 root root
    sharedscripts
    postrotate
        systemctl restart devopsfetch.service > /dev/null
    endscript
}
EOF
}

install_dependencies
echo "Creating systemd service..."
create_systemd_service > /dev/null 2>&1
echo "Setting up log rotation..."
setup_log_rotationn > /dev/null 2>&1


echo "Setup complete. The devopsfetch service is now monitoring your system."
