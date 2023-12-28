#!/bin/bash
$DOCKER_DIST='raspbian'

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/raspbian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 64-bit
if [ $(uname -m) == 'aarch64' ]; then
    $DOCKER_DIST='debian'
fi

# Set up Docker's APT repository:
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$DOCKER_DIST \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# Install docker and mariadb
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin mariadb-server
sudo mysql_secure_installation

# Add current user to docker group
sudo usermod -aG docker $USER && echo "User $USER added to docker group, log out and log back in to apply changes."

# Start LAMP web server containers
cd lamp/ && echo "Starting containers..." && docker compose up -d