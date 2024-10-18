#!/bin/bash

# Set variables for your cluster
RESOURCE_GROUP="MyResourceGroup"
CLUSTER_NAME="MyAKSCluster"

# Disable Azure Policy Add-on
az aks disable-addons --addons azure-policy --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP

echo "Azure Policy Add-on has been disabled for the cluster $CLUSTER_NAME."
