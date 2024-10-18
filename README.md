# AKS Cluster Configuration and Networking Setup
This guide provides steps to configure an Azure Kubernetes Service (AKS) cluster and install necessary network policies and tools like Calico and Istio.
## Prerequisites
1. Ensure you are logged in to your Azure account using Azure CLI:
    ```bash
    az login
    ```
2. You must have sufficient permissions to manage AKS clusters and install networking plugins.
## Steps
1. Remove Azure Policy Add-on
If your AKS cluster has the Azure Policy Add-on enabled, it may cause issues with networking policies like Calico. You can disable it using the following command:
    ```bash
    az aks disable-addons --addons azure-policy --name MyAKSCluster --resource-group MyResourceGroup
    ```
For more details, refer to [Azure Policy for Kubernetes](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/policy-for-kubernetes#remove-the-add-on-from-aks).
2. Clear kube cache (one-time step)
Clear the cache from the `.kube` directory:
    ```bash
    rm -rf ~/.kube/cache
    ```
3. Get AKS Cluster Credentials
To interact with the AKS cluster using `kubectl`, you need to retrieve the credentials:
    ```bash
    az aks get-credentials --resource-group MyResourceGroup --name MyAKSCluster
    ```
4. Modify kubeconfig
Edit the `kubeconfig` file to bypass the certificate authority data for the cluster:
    1. Open your `~/.kube/config` file.
    2. Locate the section for the current cluster and modify it as follows:
        ```yaml
        - cluster:
            insecure-skip-tls-verify: true
            server: https://your-server
        ```
5. Install Calico with Operator
To install Calico for network policy enforcement, use the following commands:
    1. Create the necessary resources for Calico using the official manifest:
        ```bash
        kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml
        ```
    2. Configure Calico for AKS by applying the following configuration:
        ```bash
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
        ```
6. Install Istio
There are two ways to install Istio: using `istioctl` or via `helm`.
Before installing Istio, ensure you have the necessary CRDs for Istio Gateway API:
    ```bash
    kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
    { kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml; }
    ```
### Option 1: Install Istio with `istioctl`
1. Install Istio using the following command:
    ```bash
    istioctl install --set profile=ambient --skip-confirmation
    ```
### Option 2: Install Istio with `helm`
1. Add the Istio Helm repo and update it:
    ```bash
    helm repo add istio https://istio-release.storage.googleapis.com/charts
    helm repo update
    ```
2. Install the base Istio components:
    ```bash
    helm install istio-base istio/base -n istio-system --create-namespace --wait
    ```
3. Install `istiod` component, which manages and configures proxies to route traffic within the service mesh, use the following command:
    ```bash
    helm install istiod istio/istiod --namespace istio-system --set profile=ambient --wait
    ```
4. Install CNI Node Agent. The CNI Helm chart installs the Istio CNI node agent. This component detects the pods that belong to the ambient mesh and configures traffic redirection between them. Use the following command to install it:
    ```bash
    helm install istio-cni istio/cni -n istio-system --set profile=ambient --wait
    ```
5. Install the Data Plane (ztunnel DaemonSet). The `ztunnel` DaemonSet is responsible for handling network traffic at the node level, providing proxy services for the ambient mesh. To install the `ztunnel` component, use the command below:
    ```bash
    helm install ztunnel istio/ztunnel -n istio-system --wait
    ```
6. Optional: Install the Ingress Gateway. If you need to set up an ingress gateway for external traffic, you can install it using the following command:
    ```bash
    helm install istio-ingress istio/gateway -n istio-ingress --create-namespace --wait
    ```
7. Verify the installation by checking the Istio components:
    ```bash
    helm ls -n istio-system
    ```
    You can also check the status of the individual Istio pods:
    ```bash
    kubectl get pods -n istio-system
    ```
   This should return the status of the istio-cni, istiod, and ztunnel pods to ensure they are running as expected.