NUM_NODES=3
MAX_NUM_NODES=5
NODE_PREFIX=testdocker
LXD_PROFILE=default

IMAGE=ubuntu:22.04
USERNAME=ubuntu

MICROK8S_VERSION=1.26/stable

HTTP_PROXY=
HTTPS_PROXY=

USE_VM=true

COMMON_OPT="-c limits.cpu=6 -c limits.memory=2500MiB"
if $USE_VM; then
    LAUNCH_OPT="--vm $COMMON_OPT"
else
    LAUNCH_OPT="-c security.nesting=true $COMMON_OPT"
fi
