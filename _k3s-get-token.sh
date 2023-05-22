#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

cat /var/lib/rancher/k3s/server/node-token
