# Overview

<p align="left">
   <img src="https://i.imgur.com/4l9bHvG.png" alt="ansible logo" width="150" align="left" />
   <img src="https://i.imgur.com/EXNTJnA.png" alt="kubernetes home logo" width="150" align="left" />
</p>

### Operations for my home

_...with Ansible and Kubernetes!_ :sailboat:
<br/><br/><br/><br/>

This repository is the running configuration of my personal home kubernetes cluster. The cluster is powered by vSphere and maintainend by in real-time by Flux.

# Infrastructure

### Hypervisor: vSphere

### K8S Distribution: K3s

### K8S Storage Provider: Longhorn

### K8S Ingress: Traefik2

# Directory Structure

```
|── ansible - Contains bootstrap playbooks
│   ├── deploy-flux.yaml - Flux Bootstrap playbook
│   ├── deploy-k3s.yml - Create K3S Cluster
│   ├── group_vars - VM Configuration
│   ├── hosts.nshores - Inventory
│   └── roles - Roles for node creation
├── k8s-apps - Helm Charts
│   ├── bootstrap - Flux Bootstrap Root
│   ├── home - Home Services
│   ├── media - Media Services
│   └── system - Core Cluster Services
├── packer - Packer template for Ubuntu vSphere image
```  

# Bootstrapping

* Populate with environment specific setings
  * vCenter or vSphere is required to create the VM's.
  * Terraform is required to create the VM resources.

 ```
ansible\group_vars\YOUR_NAME\main.yml
ansible\hosts.YOURNAME
```

* Create the inital cluster and install K3s  
  * `ansible-playbook -i your_inventory deploy_k3s.yml`

* Connect the K3s cluster to flux  

 ```
 flux bootstrap github \
  --owner=nshores \
  --repository=home-k8s-ops \
  --private=true \
  --personal=true \
  --path=k8s-apps 
  ```

## Secrets

I'm not a fan of using complex secrets management in my personal K8S setups, So i've decided to simply create `.env` files and leave the secrets as a manual step. If you want to follow along, Your directory structure should look like

```
 .secrets
  ├── kustomization.yaml
  |── secrets.env
  └── secrets.yaml

```

Sample Files:  
**kustomization.yaml**

```
secretGenerator:
  - name: home-secrets
    envs:
      - secrets.env
    files:
      - comm_config.yaml

configMapGenerator:
  - name: ha-configmap-secret
    files:
      - secrets.yaml

generatorOptions:
  disableNameSuffixHash: true
```

**secrets.env**

```

CLOUDFLARE_API_KEY=xxx
PLEX_CLAIM=xxxx
address=xxx
```

**secrets.yaml**

```
spotify_client_id: xxx
spotify_client_secret: xxx
```

## Prerequisites

* Create files
  * `secrets.yaml secrets.env kustomization.yaml`

## Create the secret

`kubectl apply -k .secrets -n home`
&nbsp;

# :handshake:&nbsp; Thanks

I learned a lot from the people that have shared their clusters over at
[awesome-home-kubernetes](https://github.com/k8s-at-home/awesome-home-kubernetes)

Another big thanks to the great work done by community over at [Funky Penguin's Geek Cookbook](https://geek-cookbook.funkypenguin.co.nz/community/discord/)
