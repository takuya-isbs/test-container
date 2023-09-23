#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh
set_proxy

unset LXD_PROFILE
unset LXD_POOL
unset LXD_INSTANCE

: $NGINX_VIP_ADDR

# node1, node2, node3
NODE_ID="$1"

# for LXD container
. ./tmp/nginx-vrrp.conf
: $NODE_1_ADDR
: $NODE_2_ADDR
: $NODE_3_ADDR

HTML=/var/www/html/index.html
KEEPALIVED_CONF=/etc/keepalived/keepalived.conf
KEEPALIVED_ENV=/etc/default/keepalived
INTERFACE=eth0
KEEPALIVED_PASSWORD=1e1633ca-fad4-11ed-82e7-00155dc8aa19

apt-get update
apt-get -y install nginx keepalived

cat <<EOF > $HTML
Hostname:<br/>
EOF
hostname >> $HTML


cat <<EOF \
    | sed \
          -e "s;@NODE_1_ADDR@;${NODE_1_ADDR};" \
          -e "s;@NODE_2_ADDR@;${NODE_2_ADDR};" \
          -e "s;@NODE_3_ADDR@;${NODE_3_ADDR};" \
          -e "s;@INTERFACE@;${INTERFACE};" \
          -e "s;@NGINX_VIP_ADDR@;${NGINX_VIP_ADDR};" \
          -e "s;@KEEPALIVED_PASSWORD@;${KEEPALIVED_PASSWORD};" \
    | dd of=$KEEPALIVED_CONF
global_defs {
    vrrp_garp_master_refresh 60
    vrrp_check_unicast_src
}

vrrp_instance VI_LB {
    state BACKUP
    interface @INTERFACE@
    virtual_router_id 1
@node1    priority 150
@node2    priority 100
@node3    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass @KEEPALIVED_PASSWORD@
    }
    unicast_peer {
@^node1  @NODE_1_ADDR@
@^node2  @NODE_2_ADDR@
@^node3  @NODE_3_ADDR@
    }
    virtual_ipaddress {
        @NGINX_VIP_ADDR@/32 dev @INTERFACE@
    }
    nopreempt
}
EOF

cat <<EOF > $KEEPALIVED_ENV
DAEMON_ARGS="-D -i ${NODE_ID}"
EOF

systemctl enable keepalived
systemctl restart keepalived
systemctl status keepalived | cat


NGINX_OVERRIDE_DIR="/etc/systemd/system/nginx.service.d"
NGINX_OVERRIDE="${NGINX_OVERRIDE_DIR}/override.conf"

mkdir -p "$NGINX_OVERRIDE_DIR"

cat <<EOF > "$NGINX_OVERRIDE"
[Service]
TimeoutStartSec=0
ExecStopPost=/usr/bin/systemctl stop keepalived
ExecStartPost=/usr/bin/systemctl restart keepalived
EOF

systemctl daemon-reload

if systemctl is-active nginx; then
    systemctl reload nginx
else
    systemctl enable nginx
    systemctl restart nginx
    systemctl status nginx | cat
fi
