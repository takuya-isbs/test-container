#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

microk8s.add-node --format token-check
