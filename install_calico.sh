#!/bin/bash

# Function to check the exit status of the last command
check_success() {
    if [ $? -ne 0 ]; then
        echo "Installation failed. Exiting."
        exit 1
    fi
}

# Apply the Calico operator
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml
check_success

# Apply the Calico configuration for AKS
kubectl create -f - <<EOF
kind: Installation
apiVersion: operator.tigera.io/v1
metadata:
  name: default
spec:
  kubernetesProvider: AKS
  cni:
    type: Calico
  calicoNetwork:
    bgp: Disabled
    ipPools:
    - cidr: 192.168.0.0/16
      encapsulation: VXLAN
---
apiVersion: operator.tigera.io/v1
kind: APIServer
metadata:
  name: default
spec: {}
EOF
check_success

echo "Calico has been installed and configured for AKS."
