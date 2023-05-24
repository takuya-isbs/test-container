#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

lxc exec ${NODE_1} -- bash /SRC/_minikube-uninstall.sh
