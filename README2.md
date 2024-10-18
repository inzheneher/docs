# AKS Cluster Configuration and Networking Setup
This guide explains how to configure an Azure Kubernetes Service (AKS) cluster and install necessary networking tools such as Calico and Istio using pre-built scripts. Follow the steps in order to achieve the desired cluster setup.
## Prerequisites
1. Ensure you are logged into your Azure account using the Azure CLI:
    ```bash
    az login
    ```
2. Make sure you have sufficient permissions to manage AKS clusters and install networking plugins.
## Steps
1. Remove Azure Policy Add-on
If your AKS cluster has the Azure Policy Add-on enabled, it might interfere with networking policies like Calico. You can disable it by running the following script:
    ```bash
    ./remove_azure_policy.sh
    ```
2. Retrieve AKS Cluster Credentials
   To interact with your AKS cluster using `kubectl`, retrieve the cluster credentials by running the following command:
    ```bash
    ./get_aks_credentials.sh <resource-group> <cluster-name>
    ```
   Replace `<resource-group>` with the name of your Azure resource group and `<cluster-name>` with the name of your AKS cluster.  
   For example:
   > ./get_aks_credentials.sh MyResourceGroup MyAKSCluster 
   
   This script will also modify the kubeconfig file to bypass certificate authority checks if needed.
3. Install Calico Network Policies
To install Calico, which enforces network policies in your cluster, run the following script:
    ```bash
    ./install_calico.sh
    ```
4. Install Istio
Before installing Istio, make sure the necessary Custom Resource Definitions (CRDs) for the Gateway API are in place. Run this script to check for and install the required CRDs:
    ```bash
    ./install_crds.sh
    ```
   #### You can install Istio in two different ways: using istioctl or helm.
   Choose one of the following options based on your preference:  
   **Option 1: Install Istio using `istioctl`:**
   ```bash
   ./install_istio_istioctl.sh
   ```  
   **Option 2: Install Istio using `helm`:**
   ```bash
   ./install_istio_helm.sh
   ```
5. (Optional) Install the Ingress Gateway
If you need an Ingress Gateway for external traffic, you can install it by running the following script:
    ```bash
    ./install_ingress_gateway.sh
    ```
6. Verify the Installation
After the installation is complete, verify that all the Istio components are running correctly by running the verification script:
    ```bash
    ./verify_istio_installation.sh
    ```