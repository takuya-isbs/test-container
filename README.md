# test-docker-swarm

test various containers environment on LXD instance

## setup

### LXD init for test nodes

TODO

### create configuration file

```bash
$ touch config.env.sh
```

### specify LXD storage pool

```bash
### example to override (default is LXD_POOL=default)
$ vi config.env.sh
LXD_POOL=btrfs1
```

### create nodes

```bash
./01_create-nodes.sh
```

## use swarm

```bash
./02_swarm-init.sh
./SHELL.sh 1
cd /SRC
```

```text
root@testdocker1:/SRC# docker stack deploy -c docker-compose.yml test
Creating network test_default
Creating service test_web

root@testdocker1:/SRC# docker service ls
ID             NAME       MODE         REPLICAS   IMAGE          PORTS
3wo9kk2mksgo   test_web   replicated   0/2        nginx:latest   *:50080->80/tcp

#### routing mesh not working ???

root@testdocker1:/SRC# docker stack rm test
Removing service test_web
Removing network test_default

```

## use k3s

```bash
./03_k3s-setup.sh
### waiting for pods to be ready
./03.1_k3s-check-nginx.sh
./03.2_k3s-uninstall.sh
```

## use microk8s

TODO

## use minikube

TODO

## use LXD container

TODO
UNDER CONSTRUCTION
