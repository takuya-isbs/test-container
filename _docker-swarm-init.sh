#!/bin/bash
set -eux

MY_ADDR="$1"
docker swarm init --advertise-addr "$MY_ADDR" > /dev/null 2>&1

TOKEN=`docker swarm join-token worker -q`
echo "$TOKEN"
