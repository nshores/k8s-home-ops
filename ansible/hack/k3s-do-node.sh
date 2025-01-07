#/usr/local/bin/k3s-agent-uninstall.sh


curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list |sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update
sudo apt-get install tailscale -y
sudo tailscale up --accept-routes --advertise-routes 10.124.0.0/24

#creates variables for master server ip, node ip, provider-id
# curl http://169.254.169.254/metadata/v1/id
curl -sfL https://get.k3s.io |  K3S_TOKEN=home-k8s-ops INSTALL_K3S_VERSION=v1.25.13+k3s1 INSTALL_K3S_EXEC="agent --server https://192.168.99.201:6443 \
--node-ip=10.124.0.2 \
--flannel-iface=eth1 \
--node-label location=cloud \
" sh -


