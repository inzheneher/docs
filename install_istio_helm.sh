#!/bin/bash

# Function to check the exit status of the last command
check_success() {
    if [ $? -ne 0 ]; then
        echo "Installation failed. Exiting."
        exit 1
    fi
}

# Add Istio Helm repository and update
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

# Check if the repository update was successful
check_success

# Install Istio base components
helm install istio-base istio/base -n istio-system --create-namespace
check_success

# Install istiod control plane
helm install istiod istio/istiod --namespace istio-system --set profile=ambient
check_success

# Install Istio CNI
helm install istio-cni istio/cni -n istio-system --set profile=ambient
check_success

# Install ztunnel DaemonSet
helm install ztunnel istio/ztunnel -n istio-system
check_success

echo "Istio and related components have been installed using Helm."
