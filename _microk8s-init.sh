#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

# already installed
snap install microk8s --classic --channel=${MICROK8S_VERSION}
# microk8s enable dns
# microk8s enable dashboard
# microk8s enable storage
# microk8s enable ingress
# microk8s enable registory
