#!/bin/bash

# Set variables for your cluster
RESOURCE_GROUP="MyResourceGroup"
CLUSTER_NAME="MyAKSCluster"

# Get AKS credentials
az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME

# Edit kubeconfig to bypass certificate authority (Optional)
KUBECONFIG_PATH="$HOME/.kube/config"
if grep -q "certificate-authority-data" $KUBECONFIG_PATH; then
    echo "Modifying kubeconfig to skip TLS verification..."
    kubectl config set-cluster $CLUSTER_NAME --insecure-skip-tls-verify=true
else
    echo "TLS verification already disabled."
fi

echo "Credentials for AKS cluster $CLUSTER_NAME have been retrieved."
