# Playing with Kafka

<https://kafka.apache.org/intro>

<https://kafka.apache.org/quickstart>

## Let's start the cluster with a single node (server)

```
[~/environment]
$ wget http://apache.mediamirrors.org/kafka/2.5.0/kafka_2.12-2.5.0.tgz
--2020-05-12 15:17:32--  http://apache.mediamirrors.org/kafka/2.5.0/kafka_2.12-2.5.0.tgz
Resolving apache.mediamirrors.org (apache.mediamirrors.org)... 5.196.66.229
Connecting to apache.mediamirrors.org (apache.mediamirrors.org)|5.196.66.229|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 61604633 (59M) [application/x-gzip]
Saving to: ‘kafka_2.12-2.5.0.tgz’

kafka_2.12-2.5.0.tgz                 100%[======================================================================>]  58.75M  11.0MB/s    in 12s     

2020-05-12 15:17:44 (4.90 MB/s) - ‘kafka_2.12-2.5.0.tgz’ saved [61604633/61604633]
```

```
[~/environment]
$ tar -xzf kafka_2.12-2.5.0.tgz
```

```
[~/environment]
$ cd kafka_2.12-2.5.0/

[~/environment/kafka_2.12-2.5.0/]
$ 
```

```
[~/environment/kafka_2.12-2.5.0/]
$ bin/zookeeper-server-start.sh config/zookeeper.properties
[2020-05-12 15:18:51,479] INFO Reading configuration from: config/zookeeper.properties (org.apache.zookeeper.server.quorum.QuorumPeerConfig)
...
```

Open a new terminal.

```
[~/environment]
$ cd kafka_2.12-2.5.0/

[~/environment/kafka_2.12-2.5.0/]
$ 
```

```
[~/environment/kafka_2.12-2.5.0/]
$ bin/kafka-server-start.sh config/server.properties
...
```

Open a new terminal.

```
[~/environment]
$ cd kafka_2.12-2.5.0/

[~/environment/kafka_2.12-2.5.0/]
$ 
```

```
[~/environment/kafka_2.12-2.5.0/]
$ bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic test
Created topic test.
```

```
[~/environment/kafka_2.12-2.5.0/]
$ bin/kafka-topics.sh --list --bootstrap-server localhost:9092
test
```

```
[~/environment/kafka_2.12-2.5.0/]
$ bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
>
```

```
>Hello World!
>
```

Open a new terminal.

```
[~/environment]
$ cd kafka_2.12-2.5.0/

[~/environment/kafka_2.12-2.5.0/]
$ 
```

```
[~/environment/kafka_2.12-2.5.0/]
$ bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
Hello World!
```

We can type text within the producer terminal and see it appearing on the consumer one.

## Let's extend the cluster with 2 new nodes

Open a new terminal.

```
[~/environment]
$ cd kafka_2.12-2.5.0/

[~/environment/kafka_2.12-2.5.0/]
$ 
```

```
[~/environment/kafka_2.12-2.5.0/]
$ cp config/server.properties config/server-1.properties
```

Modify the `config/server-1.properties` file as following:

```
broker.id=1
listeners=PLAINTEXT://:9093
log.dirs=/tmp/kafka-logs-1
```

```
[~/environment/kafka_2.12-2.5.0/]
$ cp config/server.properties config/server-2.properties
```

Modify the `config/server-2.properties` file as following:

```
broker.id=1
listeners=PLAINTEXT://:9093
log.dirs=/tmp/kafka-logs-2
```

_to be continued..._