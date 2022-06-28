# Building
* **WSL Notes** -  
  * WSL needs a proxy configured to forward network traffic to Linux Guest running inside WSL
  
  `iex "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$addr";`  
`iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$addr connectport=$port connectaddress=$remoteport";`

<br />

# Packer notes

```
packer build -var 'vcenter_password=YourPassword' -var-file=vars.json ubuntu-20.04_template.json   
```
<br />

```
==> ubuntu2004-amd64-shoreslab: Creating VM...
==> ubuntu2004-amd64-shoreslab: Customizing hardware...
==> ubuntu2004-amd64-shoreslab: Mounting ISO images...
==> ubuntu2004-amd64-shoreslab: Adding configuration parameters...
==> ubuntu2004-amd64-shoreslab: Starting HTTP server on port 8924
==> ubuntu2004-amd64-shoreslab: Set boot order temporary...
==> ubuntu2004-amd64-shoreslab: Power on VM...
==> ubuntu2004-amd64-shoreslab: Waiting 5s for boot...
==> ubuntu2004-amd64-shoreslab: HTTP server is working at http://172.21.222.203:8924/
==> ubuntu2004-amd64-shoreslab: Typing boot command...
==> ubuntu2004-amd64-shoreslab: Waiting for IP...
==> ubuntu2004-amd64-shoreslab: IP address: 192.168.99.188
==> ubuntu2004-amd64-shoreslab: Using ssh communicator to connect: 192.168.99.188
==> ubuntu2004-amd64-shoreslab: Waiting for SSH to become available...
==> ubuntu2004-amd64-shoreslab: Connected to SSH!
==> ubuntu2004-amd64-shoreslab: Provisioning with shell script: scripts/ubuntu_post_tasks.sh
==> ubuntu2004-amd64-shoreslab: Executing shutdown command...
==> ubuntu2004-amd64-shoreslab: Deleting Floppy drives...
==> ubuntu2004-amd64-shoreslab: Eject CD-ROM drives...
==> ubuntu2004-amd64-shoreslab: Convert VM into template...
==> ubuntu2004-amd64-shoreslab: Clear boot order...
Build 'ubuntu2004-amd64-shoreslab' finished after 19 minutes 43 seconds.

==> Wait completed after 19 minutes 43 seconds

==> Builds finished. The artifacts of successful builds are:
--> ubuntu2004-amd64-shoreslab: ubuntu2004-amd64-shoreslab
```

# Packer Issues
https://github.com/hashicorp/packer/issues/9115

Various isues with Ubuntu 20.04

# Credit
https://imagineer.in/blog/packer-build-for-ubuntu-20-04/
https://github.com/hashicorp/packer/issues/9115
https://vmware.github.io/photon/assets/files/html/3.0/photon_admin/Customizing_Gos_Cloudinit.html
https://kb.vmware.com/s/article/59557
https://geek-cookbook.funkypenguin.co.nz/


#CEPH
https://tracker.ceph.com/projects/ceph/wiki/Benchmark_Ceph_Cluster_Performance
Must use thick disks eager zero.

https://access.redhat.com/solutions/3341491
nshores@docker-swarm-mgr-1:~$ sudo ceph osd crush rm-device-class osd.0
done removing class of osd(s): 0
nshores@docker-swarm-mgr-1:~$ sudo ceph osd crush rm-device-class osd.2
done removing class of osd(s): 2
nshores@docker-swarm-mgr-1:~$ sudo ceph osd crush set-device-class ssd osd.0 osd.2
set osd(s) 0,2 to class 'ssd'
nshores@docker-swarm-mgr-1:~$