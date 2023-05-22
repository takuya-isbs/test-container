NUM_NODES=3
MAX_NUM_NODES=5
NODE_PREFIX=testdocker
STORAGE_POOL=default
IMAGE=ubuntu:22.04

HTTP_PROXY=
HTTPS_PROXY=

USE_VM=true

COMMON_OPT="-c limits.cpu=2 -c limits.memory=2GiB"
if $USE_VM; then
    LAUNCH_OPT="--vm $COMMON_OPT"
else
    LAUNCH_OPT="-c security.nesting=true $COMMON_OPT"
fi
