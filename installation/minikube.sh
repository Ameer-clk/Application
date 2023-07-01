#!/bin/bash

# Check the Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
elif [ -f /etc/redhat-release ]; then
    OS="rhel"
else
    echo "Unsupported Linux distribution."
    exit 1
fi

# Install Minikube on Ubuntu
install_minikube_ubuntu() {
    # Install dependencies
    sudo apt update
    sudo apt install -y curl conntrack

    # Download and install Minikube binary
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube

    # Download and install CRI-O binary
    curl -LO https://github.com/cri-o/cri-o/releases/latest/download/crio-${CRI_O_VERSION}.tar.gz
    sudo tar -C / -xzf crio-${CRI_O_VERSION}.tar.gz
    rm crio-${CRI_O_VERSION}.tar.gz

    # Cleanup
    rm minikube-linux-amd64
}

# Install Minikube on Red Hat-based systems
install_minikube_rhel() {
    # Install dependencies
    sudo yum install -y curl conntrack

    # Download and install Minikube binary
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube

    # Download and install CRI-O binary
    curl -LO https://github.com/cri-o/cri-o/releases/latest/download/crio-${CRI_O_VERSION}.tar.gz
    sudo tar -C / -xzf crio-${CRI_O_VERSION}.tar.gz
    rm crio-${CRI_O_VERSION}.tar.gz

    # Cleanup
    rm minikube-linux-amd64
}

# Set the CRI-O version
CRI_O_VERSION="1.21.0"

# Install Minikube and CRI-O based on the Linux distribution
if [ "$OS" == "ubuntu" ]; then
    install_minikube_ubuntu
elif [ "$OS" == "rhel" ]; then
    install_minikube_rhel
else
    echo "Unsupported Linux distribution."
    exit 1
fi

# Verify Minikube installation
minikube version

# Verify CRI-O installation
sudo crioctl version
