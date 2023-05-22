get_ipv4() {
    local NAME="$1"

    local IF=eth0
    if $USE_VM; then
        IF=enp5s0
    fi
    lxc list -f json | jq -r '.[] | select(.name == "'"$NAME"'") | .state.network.'"$IF"'.addresses[] | select(.family == "inet") | .address'
}
