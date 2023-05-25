#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

unset LXD_PROFILE
unset LXD_POOL
unset LXD_INSTANCE

ID_NUM=${1}

apt-get -y install jq
snap install lxd

LXD_PROFILE=testbridge1
LXD_POOL=testdisk1
LXD_INSTANCE=nginx-lb-${ID_NUM}

lxc profile delete $LXD_PROFILE || IGNORE
### do not delete automatically
#lxc storage delete $LXD_POOL || IGNORE

lxc profile create $LXD_PROFILE
lxc network attach-profile br0 $LXD_PROFILE eth0
lxc storage create $LXD_POOL dir source=/var/snap/lxd/common/lxd/storage-pools/${LXD_POOL} || IGNORE
lxc profile device add $LXD_PROFILE root disk path=/ pool=${LXD_POOL} size=30GB
lxc profile show $LXD_PROFILE

# download
lxc image copy $IMAGE local:
