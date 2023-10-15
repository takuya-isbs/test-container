#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

set_proxy

apt-get -y remove docker docker-engine docker.io containerd runc || true
apt-get -y update
#apt-get -y install jq
apt-get -y install ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
#docker run hello-world

# for microk8s
#snap install microk8s --classic --channel=${MICROK8S_VERSION}

if $USE_VM; then
    apt update
    #apt install -y bridge-utils

    cat <<EOF > /etc/netplan/99-bridge.yaml
network:
  version: 2
  ethernets:
    enp5s0:
      dhcp4: false
      dhcp6: false
      accept-ra: false
  bridges:
    br0:
      interfaces: [enp5s0]
      dhcp4: true
      dhcp6: true
EOF

    cat <<EOF > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
network: {config: disabled}
EOF

    sed -i -e 's;#net.ipv4.ip_forward=1;net.ipv4.ip_forward=1;' /etc/sysctl.conf
    ### reboot required
fi
