# Playing with MongoDB

Issue the command `lsb_release -dc` to be sure you are running **Ubuntu 18.04 (Bionic)**:

```
[~/environment]
$ lsb_release -dc
Description:    Ubuntu 18.04.4 LTS
Codename:       bionic
```

Issue the following command to import the MongoDB public GPG Key from <https://www.mongodb.org/static/pgp/server-4.2.asc>:

```
[~/environment]
$ wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
OK
```

Create the list file `/etc/apt/sources.list.d/mongodb-org-4.2.list` for **Ubuntu 18.04 (Bionic)**:

```
[~/environment]
$ echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse
```

Issue the following command to reload the local package database:

```
[~/environment]
$ sudo apt-get update
Hit:1 http://eu-west-1.ec2.archive.ubuntu.com/ubuntu bionic InRelease
...
Fetched 267 kB in 1s (377 kB/s)
Reading package lists... Done
```

To install the latest stable version, issue the following

```
[~/environment]
$ sudo apt-get install -y mongodb-org
Reading package lists... Done
Building dependency tree
...
Setting up mongodb-org (4.2.6) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
```

Although you can specify any available version of MongoDB, `apt-get` will upgrade the packages when a newer version becomes available. To prevent unintended upgrades, you can pin the package at the currently installed version:

```
[~/environment]
$ echo "mongodb-org hold" | sudo dpkg --set-selections
```
```
[~/environment]
$ echo "mongodb-org-server hold" | sudo dpkg --set-selections
```
```
[~/environment]
$ echo "mongodb-org-shell hold" | sudo dpkg --set-selections
```
```
[~/environment]
$ echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
```
```
[~/environment]
$ echo "mongodb-org-tools hold" | sudo dpkg --set-selections
```

```
[~/environment]
$ ps --no-headers -o comm 1
systemd
```

You can start the mongod process by issuing the following command:

```
[~/environment]
$ sudo systemctl start mongod
```

```
[~/environment]
$ sudo systemctl status mongod
● mongod.service - MongoDB Database Server
   Loaded: loaded (/lib/systemd/system/mongod.service; disabled; vendor preset: enabled)
   Active: active (running) since Tue 2020-05-12 14:44:01 UTC; 50s ago
     Docs: https://docs.mongodb.org/manual
 Main PID: 10481 (mongod)
   CGroup: /system.slice/mongod.service
           └─10481 /usr/bin/mongod --config /etc/mongod.conf

May 12 14:44:01 ip-172-31-46-78 systemd[1]: Started MongoDB Database Server.
```

```
[~/environment]
$ sudo systemctl enable mongod
Created symlink /etc/systemd/system/multi-user.target.wants/mongod.service → /lib/systemd/system/mongod.service.
```

As needed, you can stop the `mongod` process by issuing the following command:

```
[~/environment]
$ sudo systemctl stop mongod
```

You can restart the `mongod` process by issuing the following command:

```
[~/environment]
$ sudo systemctl restart mongod
```

```
[~/environment]
$ mongo
```
