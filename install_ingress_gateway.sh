#!/bin/bash

# Install Istio Ingress Gateway
helm install istio-ingress istio/gateway -n istio-ingress --create-namespace --wait

echo "Ingress Gateway has been installed."
