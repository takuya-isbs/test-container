#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

set_proxy

MY_ADDR="$1"
docker swarm init --advertise-addr "$MY_ADDR" > /dev/null 2>&1

TOKEN=`docker swarm join-token worker -q`
echo "$TOKEN"
