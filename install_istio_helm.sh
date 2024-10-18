#!/bin/bash

# Add Istio Helm repository and update
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

# Install Istio base components
helm install istio-base istio/base -n istio-system --create-namespace

# Install istiod control plane
helm install istiod istio/istiod --namespace istio-system --set profile=ambient

# Install Istio CNI
helm install istio-cni istio/cni -n istio-system --set profile=ambient

# Install ztunnel DaemonSet
helm install ztunnel istio/ztunnel -n istio-system

echo "Istio and related components have been installed using Helm."
