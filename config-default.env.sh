NUM_NODES=3
MAX_NUM_NODES=5
NODE_PREFIX=testcont

LXD_PROFILE=testcont  # auto creation
LXD_POOL=default   # use an existing storage pool

LXD_NET1_NAME=testcont1  # auto creation
LXD_NET1_PREFIX="10.99.88."
LXD_NET1_DHCP_RANGE="100-250"
NGINX_VIP_ADDR="${LXD_NET1_PREFIX}50"

LXD_REMOTE_TMP_PASSWORD=68157562-fa93-11ed-8c10-00155dc8aa19

IMAGE=ubuntu:22.04
IMAGE_FINGERPRINT=6d6a3c257ca7
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
