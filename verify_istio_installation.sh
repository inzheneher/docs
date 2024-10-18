#!/bin/bash

# Verify Istio installation status
echo "Verifying Istio installation..."

helm ls -n istio-system
kubectl get pods -n istio-system

echo "Istio installation verification complete."
