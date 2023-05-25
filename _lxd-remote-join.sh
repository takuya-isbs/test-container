#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

unset LXD_PROFILE
unset LXD_POOL
unset LXD_INSTANCE

REMOTE_NODE=$1

lxc remote remove $REMOTE_NODE || true
lxc remote add $REMOTE_NODE $REMOTE_NODE --password $LXD_REMOTE_TMP_PASSWORD --accept-certificate
