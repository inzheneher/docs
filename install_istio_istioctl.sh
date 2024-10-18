#!/bin/bash

# Function to check the exit status of the last command
check_success() {
    if [ $? -ne 0 ]; then
        echo "Installation failed. Exiting."
        exit 1
    fi
}

# Install Istio with ambient profile using istioctl
istioctl install --set profile=ambient --skip-confirmation
check_success

echo "Istio has been installed using istioctl."
