source config-default.env.sh
source config.env.sh

COMMON_OPT="-c limits.cpu=${LIMIT_CPU} -c limits.memory=${LIMIT_MEMORY}"
if $USE_VM; then
    LAUNCH_OPT="--vm $COMMON_OPT"
else
    LAUNCH_OPT="-c security.nesting=true $COMMON_OPT"
fi

NODE_1=${NODE_PREFIX}1
NODE_2=${NODE_PREFIX}2
NODE_3=${NODE_PREFIX}3

# for host

# for guest
exec_user() {
    sudo -i -u $USERNAME "$@"
}

# common
IGNORE() {
    true
}

set_proxy() {
    if [ -n "$HTTP_PROXY" ]; then
        http_proxy=$HTTP_PROXY
        export HTTP_PROXY http_proxy
    fi
    if [ -n "$HTTPS_PROXY" ]; then
        https_proxy=$HTTPS_PROXY
        export HTTPS_PROXY https_proxy
    fi
}

get_ipv4() {
    local NAME="$1"
    local IF="${2:-}"

    if [ -z "$IF" ]; then
        IF=eth0
        if $USE_VM; then
            #IF=enp5s0
            IF=br0
        fi
    fi
    lxc list -f json | jq -r '.[] | select(.name == "'"$NAME"'") | .state.network.'"$IF"'.addresses[] | select(.family == "inet") | .address'
}
