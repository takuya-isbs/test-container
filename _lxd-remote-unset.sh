#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

unset LXD_PROFILE
unset LXD_POOL
unset LXD_INSTANCE

lxc config unset core.trust_password
