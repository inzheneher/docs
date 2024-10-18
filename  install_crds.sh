#!/bin/bash

# Check if CRDs for Gateway API are already installed
echo "Checking for Gateway API CRDs..."

kubectl get crd gateways.gateway.networking.k8s.io &>/dev/null
if [ $? -ne 0 ]; then
    echo "CRDs for Gateway API not found. Installing..."
    kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml
    echo "CRDs for Gateway API have been installed."
else
    echo "CRDs for Gateway API are already installed."
fi
