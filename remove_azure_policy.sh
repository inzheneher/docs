#!/bin/bash

# Function to display usage information
usage() {
  echo "Usage: $0 <resource-group> <cluster-name>"
  exit 1
}

# Function to check the exit status of the last command
check_success() {
    if [ $? -ne 0 ]; then
        echo "Operation failed. Exiting."
        exit 1
    fi
}

# Check if two arguments were passed
if [ "$#" -ne 2 ]; then
  usage
fi

# Assign command-line arguments to variables
RESOURCE_GROUP=$1
CLUSTER_NAME=$2

# Disable Azure Policy Add-on
az aks disable-addons --addons azure-policy --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP
check_success

echo "Azure Policy Add-on has been disabled for the cluster $CLUSTER_NAME."