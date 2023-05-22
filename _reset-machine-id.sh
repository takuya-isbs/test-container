#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

rm -v /var/lib/dbus/machine-id /etc/machine-id
dbus-uuidgen --ensure
systemd-machine-id-setup
