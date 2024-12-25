# Overview

<p align="left">
   <img src="https://i.imgur.com/4l9bHvG.png" alt="ansible logo" width="150" align="left" />
   <img src="https://i.imgur.com/EXNTJnA.png" alt="kubernetes home logo" width="150" align="left" />
   <img src="https://user-images.githubusercontent.com/31406378/108641411-f9374f00-7496-11eb-82a7-0fa2a9cc5f93.png" alt="terraform home logo" width="150" align="left" />
</p>

### Operations for my home

_...with Ansible + Terraform and Kubernetes!_ :sailboat:
<br/><br/><br/><br/>
<br/>
<img src="https://raw.githubusercontent.com/nshores/k8s-home-ops/main/images/dashboard.png" alt="dashboard" align="center" />

This repository is the running configuration of my personal home kubernetes cluster. The cluster is powered by [K3s](https://k3s.io/) Nodes and maintainend in real-time by [Flux](https://fluxcd.io/docs/).

# Infrastructure

### Hypervisor: VMware ESXI 8.0

### Base OS: Ubuntu 22.04

### K8S Distribution: [K3s](https://k3s.io/)

### K8S Storage Provider: [Longhorn](https://longhorn.io/)

### K8S Ingress: [Traefik2](https://doc.traefik.io/traefik/)

### K8S Version: 1.25

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
  * vCenter (For Templates) is required to create the VM's.
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

## GPU Transcoding Notes

There is a bug in ESXI 8.0 that will create a memory leak when passing through your iGPU unless you set `SVGA.present=FALSE` [on the VM](https://github.com/nshores/k8s-home-ops/blob/d6202e760876ca792b5551dd7abef33265fc8691/ansible/roles/vsphere/templates/swarm_node.tf.j2#L43) being created.

## GPU Testing tools

```
apt install --no-install-recommends ffmpeg vainfo
sudo apt install intel-gpu-tools
clinfo
vainfo --display drm --device /dev/dri/renderD129
ffmpeg -v verbose -init_hw_device vaapi=va:/dev/dri/renderD129 -init_hw_device opencl@va
ffmpeg -loglevel debug -hwaccel vaapi -vaapi_device /dev/dri/renderD129 -i *.mp4 -f null -
```

# K3S ApiServer VIP Notes

By default the k3s apiserver does not have any kind of load balancing active. To enable HA ApiServer access the `kubernetes` network service object is to set to type `loadbalancer` and has an IP assigned from the range defined in `metallb`. To avoid SSL errors, this is added to the inital K3S setup as well via the `--tls-san value` argument.
<https://docs.k3s.io/installation/configuration#registration-options-for-the-k3s-server>

# ESXI Options

To prevent having to toggle the passthrough of the iGPU upon ESXI reboot, perform the following command in ESXI via SSH  

`esxcli system settings kernel set -s vga -v FALSE`

# TODO

Perhaps this is a better way to handle the HA VIP SAN issue.  
<https://github.com/k3s-io/k3s/issues/3369>

# :handshake:&nbsp; Thanks

I learned a lot from the people that have shared their clusters over at
[awesome-home-kubernetes](https://github.com/k8s-at-home/awesome-home-kubernetes)

Another big thanks to the great work done by community over at [Funky Penguin's Geek Cookbook](https://geek-cookbook.funkypenguin.co.nz/community/discord/)
