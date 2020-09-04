# serf in Kubernetes

The purpose of the repo is to serve as an example on how to use SERF to discover nodes inside a Kubernetes cluster and a practical example for:
* Building Dockerfiles
* Kubernetes Service
* Kubernetes Pod
* Kubernetes Deployment
* Passing information to Kubernetes resorces using ConfigMaps

An real world example for using SERF in this context would be:
- Containers in different Pods that must discover each other to configure the container application
- Specific discover of nodes that match a certain pattern

## Running the example:

Step 1. Create and verify serf service:

```console
$ kubectl create -f kubernetes/serf-service.yml
service/serf created
$ kubectl get svc serf
NAME   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
serf   ClusterIP   10.109.254.149   <none>        7946/TCP,7946/UDP   37s
```

Step 2. Create and verify serf configmap:
```console
$ kubectl create -f kubernetes/serf-configmap.yaml
configmap/serfconf created
$ kubectl get configmap serfconf
NAME       DATA   AGE
serfconf   1      38s
```

Step 2. Create and verify serf deployment:

```console
$ kubectl create -f kubernetes/serf-deployment.yaml
deployment.apps/serf created
$ kubectl get deployment serf
NAME   READY   UP-TO-DATE   AVAILABLE   AGE
serf   3/3     3            3           10m
```

Step 3. Scale replicas:

```console
$ kubectl scale --replicas=4 deployment/serf
deployment.apps/serf scaled
$ kubectl get deployment serf
NAME   READY   UP-TO-DATE   AVAILABLE   AGE
serf   4/4     4            4           12m
```

Step 4. Verify serf cluster:

```console
$ kubectl get pods
NAME                                READY   STATUS      RESTARTS   AGE
serf-d5f56c4c5-4g9nj                1/1     Running     0          14m
serf-d5f56c4c5-8kqdp                1/1     Running     0          14m
serf-d5f56c4c5-jvkbj                1/1     Running     0          2m11s
serf-d5f56c4c5-znd9n                1/1     Running     0          14m

$ kubectl logs serf-d5f56c4c5-4g9nj

$ kubectl logs serf-4pglm
======================================================================
SERF_PORT_7946_TCP=tcp://10.109.254.149:7946
KUBERNETES_SERVICE_PORT=443
KUBERNETES_PORT=tcp://10.96.0.1:443
SERF_PORT_7946_UDP=udp://10.109.254.149:7946
HOSTNAME=serf-d5f56c4c5-4g9nj
SHLVL=2
HOME=/home/serf
SERF_SERVICE_PORT_SERF_TCP=7946
SERF_SERVICE_PORT_SERF_UDP=7946
MY_SERVICE_SERVICE_HOST=10.102.120.247
MY_SERVICE_PORT_8080_TCP_ADDR=10.102.120.247
SERF_SERVICE_HOST=10.109.254.149
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
MY_SERVICE_PORT_8080_TCP_PORT=8080
MY_SERVICE_PORT_8080_TCP_PROTO=tcp
SERF_CONFDIR=/etc/serf
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_PROTO=tcp
SERF_SERVICE_PORT=7946
SERF_PORT=tcp://10.109.254.149:7946
MY_SERVICE_SERVICE_PORT=8080
MY_SERVICE_PORT=tcp://10.102.120.247:8080
SERF_PORT_7946_TCP_ADDR=10.109.254.149
MY_SERVICE_PORT_8080_TCP=tcp://10.102.120.247:8080
SERF_PORT_7946_UDP_ADDR=10.109.254.149
SERF_PORT_7946_TCP_PORT=7946
SERF_APPDIR=/app
SERF_PORT_7946_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_SERVICE_PORT_HTTPS=443
SERF_PORT_7946_UDP_PORT=7946
SERF_DISCOVERY_ADDRESS=serf.default.svc.cluster.local
SERF_PORT_7946_UDP_PROTO=udp
KUBERNETES_SERVICE_HOST=10.96.0.1
PWD=/
======================================================================
serf: starting args(agent -config-dir /etc/serf -retry-join serf.default.svc.cluster.local)
==> Starting Serf agent...
==> Starting Serf agent RPC...
==> Serf agent running!
         Node name: 'serf-d5f56c4c5-4g9nj'
         Bind addr: '0.0.0.0:7946'
                       RPC addr: '127.0.0.1:7373'
                      Encrypted: false
                       Snapshot: false
                        Profile: lan
    Message Compression Enabled: true

==> Log data will now stream in as it occurs:

    2020/08/22 02:35:01 [INFO] agent: Serf agent starting
    2020/08/22 02:35:01 [INFO] serf: EventMemberJoin: serf-d5f56c4c5-4g9nj 172.18.0.13
    2020/08/22 02:35:01 [INFO] agent: Joining cluster...(replay: false)
    2020/08/22 02:35:01 [INFO] agent: joining: [serf.default.svc.cluster.local] replay: false
    2020/08/22 02:35:01 [INFO] serf: EventMemberJoin: serf-d5f56c4c5-8kqdp 172.18.0.15
    2020/08/22 02:35:01 [INFO] agent: joined: 1 nodes
    2020/08/22 02:35:01 [INFO] agent: Join completed. Synced with 1 initial agents
    2020/08/22 02:35:01 [INFO] serf: EventMemberJoin: serf-d5f56c4c5-znd9n 172.18.0.14
    2020/08/22 02:35:02 [INFO] agent: Received event: member-join
    2020/08/22 02:47:33 [INFO] serf: EventMemberJoin: serf-d5f56c4c5-jvkbj 172.18.0.16
    2020/08/22 02:47:34 [INFO] agent: Received event: member-join
```
## Attributions

This repo was forked from: https://github.com/slack/kubernetes-serf