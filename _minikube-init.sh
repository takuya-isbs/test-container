#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

MINIKUBE_PROFILE=demo

usermod -aG docker $USERNAME || true

cd
if [ ! -f minikube-linux-amd64 ]; then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
fi
install minikube-linux-amd64 /usr/local/bin/minikube

MINIKUBE="exec_user minikube -p $MINIKUBE_PROFILE"
KUBECTL="$MINIKUBE kubectl --"

$MINIKUBE start --nodes 1

$MINIKUBE status

$KUBECTL get all --all-namespaces -o wide
$KUBECTL get nodes -o wide
$KUBECTL apply -f /SRC/microbot-manifest.yml

# wait for pods running
PODS_NUM=0
while [ $PODS_NUM -lt 2 ]; do
    sleep 1
    PODS_NUM=`$KUBECTL get pods | grep "Running" | wc -l`
done
$KUBECTL get all --all-namespaces -o wide

URL=`$MINIKUBE service microbot --url `
curl $URL
