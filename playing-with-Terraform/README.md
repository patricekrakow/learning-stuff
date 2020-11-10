# Playing with Terraform

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently.

Terraform works based on configuration files, e.g. `config.tf`.
These configuration files define your infrastructure.

Based on these configuration files, Terraform generates an execution plan describing what it will do to reach the desired state, and then executes it to build the described infrastructure.
As the configuration changes, Terraform is able to determine what changed and create incremental execution plans which can be applied.

## Install Terraform

1\. Go to <https://www.terraform.io/downloads.html>.

2\. Copy the link of the package of your OS, e.g. Linux > 64-bit:

```text
https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip
```

3\. Download and install the package you have chosen:

```text
$ mkdir terraform
$ cd terraform/
$ wget https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip
...
2020-11-10 11:43:25 (122 MB/s) - ‘terraform_0.13.5_linux_amd64.zip’ saved [34880173/34880173]
$ unzip terraform_0.13.5_linux_amd64.zip
Archive:  terraform_0.13.5_linux_amd64.zip
  inflating: terraform
$ export PATH=$PWD:$PATH
$ cd ..
$ terraform version
Terraform v0.13.5
```

## References

<https://www.terraform.io/>

<https://www.terraform.io/intro/index.html>

<https://youtu.be/h970ZBgKINg> | Introduction to HashiCorp Terraform with Armon Dadgar

<https://learn.hashicorp.com/collections/terraform/azure-get-started>
