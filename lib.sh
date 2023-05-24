source config-default.env.sh
source config.env.sh

NODE_1=${NODE_PREFIX}1

# for host
get_ipv4() {
    local NAME="$1"

    local IF=eth0
    if $USE_VM; then
        #IF=enp5s0
        IF=br0
    fi
    lxc list -f json | jq -r '.[] | select(.name == "'"$NAME"'") | .state.network.'"$IF"'.addresses[] | select(.family == "inet") | .address'
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

# for guest
exec_user() {
    sudo -i -u $USERNAME "$@"
}
