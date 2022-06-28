apt-get install -f -y python net-tools curl python3-pip zsh

# Install VMWare Guestinfo Cloud-init source
curl -sSL https://raw.githubusercontent.com/vmware/cloud-init-vmware-guestinfo/master/install.sh | sh -


# Reset Cloud-init state (https://stackoverflow.com/questions/57564641/openstack-Packer-cloud-init)
cloud-init clean -s -l

#allow cloud-init to customize network settings
sudo rm /etc/cloud/cloud.cfg.d/99-installer.cfg
sudo rm /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg

#enable cloud-init customizations
sudo echo "disable_vmware_customization: false" >> /etc/cloud/cloud.cfg

#replace multipath config
sudo rm /etc/multipath.conf