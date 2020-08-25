# Playing with Go

## Download and Install Go

1\. Download the Go distribution:

```text
$ wget https://golang.org/dl/go1.15.linux-amd64.tar.gz
```

<details><summary>Output the command</summary>

```text
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

```text
$ sudo tar -C /usr/local -xzf go1.15.linux-amd64.tar.gz
```

3\. Add `/usr/local/go/bin` to the `PATH` environment variable:

```text
$ export PATH=$PATH:/usr/local/go/bin
```

```text
$ sudo ln -s /usr/local/go/bin/go /usr/bin/go
```

## Test the Installation

```text
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

```text
$ go build hello.go
$ ./hello
```

<details><summary>Output the command</summary>

```console
Hello World!
```

</details>

If you see the "Hello World!" message then your Go installation is working.

## Organization of the Code

```text
$ export GOROOT="/usr/local/go"
$ export PATH=$PATH:$GOROOT/bin
$ export GOPATH="/home/ubuntu/environment/go"
$ export PATH=$PATH:$GOPATH/bin
```

Go programs are organized into _packages_.

A _package_ is a collection of source files in the same directory that are **compiled** together.

Functions, types, variables, and constants defined in one source file are visible to all other source files within the same _package_.

A _repository_ contains one or more _modules_.

A _module_ is a collection of related Go _packages_ that are **released** together.

A Go _repository_ typically contains only one _module_, located at the root of the _repository_.

A file named `go.mod` there declares the _module path_: the _import path_ prefix for all _packages_ within the _module_.

The _module_ contains the _packages_ in the directory containing its `go.mod` file as well as subdirectories of that directory, up to the next subdirectory containing another `go.mod` file (if any).

Each _module_'s path not only serves as an _import path_ prefix for its _packages_, but also indicates where the `go` command should look to download it.

For example, in order to download the _module_ `golang.org/x/tools`, the go command would consult the _repository_ indicated by `https://golang.org/x/tools`.

An _import path_ is a string used to import a _package_.

A _package_'s _import path_ is its _module_ path joined with its subdirectory within the _module_.

## References

<https://golang.org/doc/install>

<https://golang.org/doc/gopath_code.html>