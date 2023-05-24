#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

MINIKUBE_PROFILE=demo

exec_user minikube stop -p $MINIKUBE_PROFILE
exec_user minikube delete -p $MINIKUBE_PROFILE
