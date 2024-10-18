#!/bin/bash

# Install Istio with ambient profile using istioctl
istioctl install --set profile=ambient --skip-confirmation

echo "Istio has been installed using istioctl."
