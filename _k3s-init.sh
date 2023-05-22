#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

curl -sfL https://get.k3s.io | sh -

