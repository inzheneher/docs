#!/bin/bash

# Function to check the exit status of the last command
check_success() {
    if [ $? -ne 0 ]; then
        echo "Installation failed. Exiting."
        exit 1
    fi
}

# Install Istio Ingress Gateway
helm install istio-ingress istio/gateway -n istio-ingress --create-namespace --wait
check_success

echo "Ingress Gateway has been installed."
