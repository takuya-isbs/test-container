#!/bin/bash
set -eux

source config-default.env.sh
source config.env.sh

lxc exec ${NODE_PREFIX}1 -- bash
