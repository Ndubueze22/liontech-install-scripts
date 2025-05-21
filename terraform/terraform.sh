#!/bin/bash

# Terraform Installation Script for Ubuntu

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root or using sudo"
  exit 1
fi

# Update package index
apt-get update

# Install required dependencies
apt-get install -y wget unzip

# Determine latest Terraform version
TERRAFORM_VERSION=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/v//')

# Check if Terraform is already installed
if command -v terraform &> /dev/null; then
  INSTALLED_VERSION=$(terraform version | head -n 1 | cut -d 'v' -f 2)
  if [ "$INSTALLED_VERSION" == "$TERRAFORM_VERSION" ]; then
    echo "Terraform version $TERRAFORM_VERSION is already installed."
    exit 0
  else
    echo "Updating Terraform from version $INSTALLED_VERSION to $TERRAFORM_VERSION"
  fi
fi

# Download Terraform
echo "Downloading Terraform version $TERRAFORM_VERSION..."
wget -q "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -O /tmp/terraform.zip

# Install Terraform
unzip -o /tmp/terraform.zip -d /usr/local/bin/
chmod +x /usr/local/bin/terraform

# Clean up
rm /tmp/terraform.zip

# Verify installation
if command -v terraform &> /dev/null; then
  echo "Terraform installed successfully:"
  terraform version
else
  echo "Terraform installation failed."
  exit 1
fi