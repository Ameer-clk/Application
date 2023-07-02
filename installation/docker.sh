#!/bin/bash

# Check the Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Unsupported Linux distribution."
    exit 1
fi

# Install Docker on Ubuntu
install_docker_ubuntu() {
    # Update the apt package index
    sudo apt update

    # Install necessary packages to allow apt to use a repository over HTTPS
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

    # Add the Docker GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Add the Docker repository
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update the apt package index (again)
    sudo apt update

    # Install Docker
    sudo apt install -y docker.io
}

# Install Docker on Red Hat-based systems
install_docker_rhel() {
    # Install necessary packages
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2

    # Set up the Docker repository
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

    # Install Docker
    sudo yum install -y docker

    # Start and enable Docker service
    sudo systemctl start docker
    sudo systemctl enable docker
    
}

# Install Docker based on the Linux distribution
if [ "$OS" == "ubuntu" ]; then
    install_docker_ubuntu
elif [ "$OS" == "rhel" ]; then
    install_docker_rhel
else
    echo "Unsupported Linux distribution."
    exit 1
fi

# Verify Docker installation
docker version

