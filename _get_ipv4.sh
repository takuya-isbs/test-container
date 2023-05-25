#!/bin/bash
set -eu
cd $(dirname $0)
source ./lib.sh

get_ipv4 "$1" "$2"
