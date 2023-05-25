#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

unset LXD_PROFILE
unset LXD_POOL
unset LXD_INSTANCE

ID_NUM=${1}
NODE_NAME=${NODE_PREFIX}${1}

LXD_PROFILE=bridge1
#LXD_POOL=disk1
LXD_INSTANCE=nginx-lb-${ID_NUM}

if [ $NODE_NAME = $NODE_1 ]; then
    REMOTE_NAME=local
else
    REMOTE_NAME=$NODE_1
fi
lxc launch -p $LXD_PROFILE ${REMOTE_NAME}:${IMAGE_FINGERPRINT} $LXD_INSTANCE
lxc list
