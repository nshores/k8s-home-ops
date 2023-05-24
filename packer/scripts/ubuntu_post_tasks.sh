apt-get install -f -y python net-tools curl python3-pip zsh

# Install VMWare Guestinfo Cloud-init source
#Should not be needed anymore as this is included with the latest version of cloud-init
# curl -sSL https://raw.githubusercontent.com/vmware/cloud-init-vmware-guestinfo/master/install.sh | sh -


# Reset Cloud-init state (https://stackoverflow.com/questions/57564641/openstack-Packer-cloud-init)
cloud-init clean -s -l

#allow cloud-init to customize network settings
https://askubuntu.com/questions/1366315/terraform-cloud-init-via-extra-config-datasourcevmware
sudo rm /etc/cloud/cloud.cfg.d/90_dpkg.cfg

 
cat > /etc/cloud/cloud.cfg.d/99-vmware-guest-customization.cfg <<EOF
disable_vmware_customization: false
datasource:
  VMware:
    allow_raw_data: false
    vmware_cust_file_max_wait: 10
EOF


#enable cloud-init customizations
sudo echo "disable_vmware_customization: false" >> /etc/cloud/cloud.cfg

#replace multipath config
sudo rm /etc/multipath.conf