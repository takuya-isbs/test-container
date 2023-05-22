#!/bin/bash
set -eux

source config-default.env.sh
source config.env.sh

ID=${1:-1}

lxc exec ${NODE_PREFIX}${ID} -- bash
