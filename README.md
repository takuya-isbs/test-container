# test-docker-swarm

```bash
./01_create-nodes.sh
./02_init-swarm.sh
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



root@testdocker1:/SRC# docker stack rm test
Removing service test_web
Removing network test_default

```

UNDER CONSTRUCTION
