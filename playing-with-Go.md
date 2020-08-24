# Playing with Go

## Download and Install Go

1\. Download the Go distribution:

```
$ wget wget https://golang.org/dl/go1.15.linux-amd64.tar.gz
```
<details><summary>Output the command</summary>

```
--2020-08-24 08:02:02--  https://golang.org/dl/go1.15.linux-amd64.tar.gz
Resolving golang.org (golang.org)... 74.125.193.141, 2a00:1450:400b:c01::8d
Connecting to golang.org (golang.org)|74.125.193.141|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://dl.google.com/go/go1.15.linux-amd64.tar.gz [following]
--2020-08-24 08:02:02--  https://dl.google.com/go/go1.15.linux-amd64.tar.gz
Resolving dl.google.com (dl.google.com)... 74.125.193.136, 74.125.193.93, 74.125.193.91, ...
Connecting to dl.google.com (dl.google.com)|74.125.193.136|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 121136135 (116M) [application/octet-stream]
Saving to: ‘go1.15.linux-amd64.tar.gz’

go1.15.linux-amd64.tar.gz           100%[==================================================================>] 115.52M   158MB/s    in 0.7s    

2020-08-24 08:02:03 (158 MB/s) - ‘go1.15.linux-amd64.tar.gz’ saved [121136135/121136135]
```
</details>

2\. Extract the archive into `/usr/local`, creating a Go tree in `/usr/local/go`:

```
$ sudo tar -C /usr/local -xzf go1.15.linux-amd64.tar.gz
```

3\. Add `/usr/local/go/bin` to the `PATH` environment variable:

```
$ export PATH=$PATH:/usr/local/go/bin
```

## Test the Installation

```
$ mkdir -p go/src/hello
$ cd go/src/hello
$ touch hello.go
```

```go
package main

import "fmt"

func main() {
	fmt.Printf("Hello World!\n")
}
```

```
$ go build hello.go
$ ./hello
```
<details><summary>Output the command</summary>

```
Hello World!
```
</details>

If you see the "Hello World!" message then your Go installation is working.

## References

<https://golang.org/doc/install>