# Playing with Kafka

<https://kafka.apache.org/intro>

<https://kafka.apache.org/quickstart>

## Let's start the cluster with a single node (server)

```
[~]
$ wget http://apache.mediamirrors.org/kafka/2.5.0/kafka_2.12-2.5.0.tgz
...
```

```
[~]
$ tar -xzf kafka_2.12-2.5.0.tgz
...
```

```
[~]
$ cd kafka_2.12-2.5.0/

[~/kafka_2.12-2.5.0/]
$ 
```

```
[~/kafka_2.12-2.5.0/]
$ bin/zookeeper-server-start.sh config/zookeeper.properties
...
```

```
[~/kafka_2.12-2.5.0/]
$ bin/kafka-server-start.sh config/server.properties
...
```

```
[~/kafka_2.12-2.5.0/]
$ bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic test
...
```

```
[~/kafka_2.12-2.5.0/]
$ bin/kafka-topics.sh --list --bootstrap-server localhost:9092
...
```

```
[~/kafka_2.12-2.5.0/]
$ bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
```

Open a new terminal.

```
[~]
$ cd kafka_2.12-2.5.0/

[~/kafka_2.12-2.5.0/]
$ 
```

```
[~/kafka_2.12-2.5.0/]
$ bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
```

We can type text within the producer terminal and see it appearing on the consumer one.

## Let's extend the cluster with 2 new nodes

Open a third terminal.

```
[~]
$ cd kafka_2.12-2.5.0/

[~/kafka_2.12-2.5.0/]
$ 
```

```
[~/kafka_2.12-2.5.0/]
$ cp config/server.properties config/server-1.properties
```

Modify the `config/server-1.properties` file as following:

```
broker.id=1
listeners=PLAINTEXT://:9093
log.dirs=/tmp/kafka-logs-1
```

```
[~/kafka_2.12-2.5.0/]
$ cp config/server.properties config/server-2.properties
```

Modify the `config/server-2.properties` file as following:

```
broker.id=1
listeners=PLAINTEXT://:9093
log.dirs=/tmp/kafka-logs-2
```

_to be continued..._