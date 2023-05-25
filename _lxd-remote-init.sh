#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

unset LXD_PROFILE
unset LXD_POOL
unset LXD_INSTANCE

lxc config set core.https_address "[::]"
lxc config set core.trust_password $LXD_REMOTE_TMP_PASSWORD
