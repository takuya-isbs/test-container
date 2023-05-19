#!/bin/bash
set -eux

source config-default.env.sh
source config.env.sh

# usage:
# delete and create: ./01_create-nodes.sh
# delete only:       ./01_create-nodes.sh DELETE

DELETE=${1:-}

IGNORE() {
    true
}

wait_for_wake() {
    local NODE_NAME=$1
    until lxc exec ${NODE_NAME} -- cloud-init status --wait; do
        sleep 1
    done
    # until lxc exec ${NODE_NAME} -- ping -q -4 -c 1 ${DNS_CHECK}; do
    #     sleep 1
    # done
}

exec_retry() {
    local NODE_NAME=$1
    shift
    until lxc exec ${NODE_NAME} -- "$@"; do
        sleep 1
    done
}

validate() {
    [ $NUM_NODES -le $MAX_NUM_NODES ]
}

validate

for i in `seq $MAX_NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    lxc stop ${NODE_NAME} || IGNORE
    lxc delete ${NODE_NAME} || IGNORE
done

if [ "$DELETE" = "DELETE" ]; then
    exit 0
fi

for i in `seq $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    lxc launch ${IMAGE} ${NODE_NAME} ${VM} -c limits.cpu=2 -c limits.memory=2GiB -c security.nesting=true

    SRC_DIR=$(realpath .)
    lxc config device add ${NODE_NAME} SRC disk source=${SRC_DIR} path=/SRC
done

for i in `seq $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    wait_for_wake ${NODE_NAME}
    lxc exec ${NODE_NAME} -- bash /SRC/_install-docker.sh &
done
wait

for i in `seq $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    lxc exec ${NODE_NAME} -- docker version
done
