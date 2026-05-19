#!/bin/bash

set -e

echo "========================================="
echo " Updating Ubuntu Packages"
echo "========================================="

sudo apt-get update -y

# ---------------------------------------------------
# Docker Installation
# ---------------------------------------------------

echo "========================================="
echo " Checking Docker"
echo "========================================="

if command -v docker &> /dev/null
then
    echo "Docker already installed."
else
    echo "Installing Docker..."
    sudo apt install docker.io -y
fi

# ---------------------------------------------------
# Docker Group Permission
# ---------------------------------------------------

echo "========================================="
echo " Configuring Docker Group"
echo "========================================="

if groups $USER | grep &>/dev/null '\bdocker\b'
then
    echo "User already added to docker group. Skipping..."
else
    sudo usermod -aG docker $USER
    newgrp docker 
    echo "User added to docker group."
    echo "Please logout and login again for changes to take effect."
fi

# ---------------------------------------------------
# Docker Compose Plugin
# ---------------------------------------------------

echo "========================================="
echo " Checking Docker Compose"
echo "========================================="

if docker-compose version &> /dev/null
then
    echo "Docker Compose already installed."
else
    echo "Installing Docker Compose..."
    sudo apt install docker-compose -y
fi

# ---------------------------------------------------
# unzip Installation
# ---------------------------------------------------

echo "========================================="
echo " Checking unzip"
echo "========================================="

if command -v unzip &> /dev/null
then
    echo "unzip already installed."
else
    echo "Installing unzip..."
    sudo apt install unzip -y
fi

# ---------------------------------------------------
# Terraform Installation
# ---------------------------------------------------

echo "========================================="
echo " Checking Terraform"
echo "========================================="

if command -v terraform &> /dev/null
then
    echo "Terraform already installed."
else
    echo "Installing Terraform..."

    wget -O- https://apt.releases.hashicorp.com/gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

    sudo apt update -y
    sudo apt install terraform -y
fi

# ---------------------------------------------------
# kubectl Installation
# ---------------------------------------------------

echo "========================================="
echo " Checking kubectl"
echo "========================================="

if command -v kubectl &> /dev/null
then
    echo "kubectl already installed."
else
    echo "Installing kubectl..."
    sudo snap install kubectl --classic
fi


# ---------------------------------------------------
# Helm Installation
# ---------------------------------------------------

echo "========================================="
echo " Checking Helm"
echo "========================================="

if command -v helm &> /dev/null
then
    echo "Helm already installed. Skipping"
else
    echo "Installing Helm..."

    sudo apt-get install curl gpg apt-transport-https -y

    curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/helm.gpg > /dev/null

    echo "deb [signed-by=/usr/share/keyrings/helm.gpg] \
    https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | \
    sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

    sudo apt-get update -y

    sudo apt-get install helm -y
fi


# ---------------------------------------------------
# AWS CLI v2 Installation
# ---------------------------------------------------

echo "========================================="
echo " Checking AWS CLI"
echo "========================================="

if command -v aws &> /dev/null
then
    echo "AWS CLI already installed."
else
    echo "Installing AWS CLI v2..."

    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

    unzip awscliv2.zip

    sudo ./aws/install

    rm -rf aws awscliv2.zip
fi

# ---------------------------------------------------
# AWS Configure
# ---------------------------------------------------

echo "========================================="
echo " Checking AWS Configuration"
echo "========================================="

if [ -f "$HOME/.aws/credentials" ]
then
    echo "AWS already configured."
else
    echo "Configuring AWS CLI..."

    aws configure
fi




# ---------------------------------------------------
# Versions
# ---------------------------------------------------

echo "========================================="
echo " Installed Versions"
echo "========================================="

docker --version || true
docker-compose --version || true
terraform version || true
kubectl version --client || true
aws --version || true
helm version || true

echo "========================================="
echo " Installation Completed Successfully"
echo "========================================="