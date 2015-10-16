# Boundary Vagrant Environment for Plugin Development

Provides virtual machines to develop and test Boundary meter plugins.

## Prerequisites

- Vagrant 1.7.2 or later. Vagrant can be downloaded [here](https://www.vagrantup.com/downloads.html)
- VirtualBox 4.3.2.6 or later. VirtualBox can be downloaded [here](https://www.virtualbox.org/wiki/Downloads)

## Installation

### Getting Started

The Boundary meter is installed on each of the virtual machines via the [Boundary Puppet Module](https://forge.puppetlabs.com/puppetlabs/boundary). Boundary Meter installation requires that the _api token_ be known at install time. The Boundary API Token can be found in the _Settings_ -> _Account_ dialog in the Boundary user interface.

### List of Platforms to Virtual Machine Mapping

The table below provides the mapping of platform to virtual machine name that is used later to start a virtual machine for testing plugins.

| Platform             | Virtual Machine Name  | Notes |
|:---------------------|:---------------------:|:-----:|
|Centos 5.11           |`centos-5.11`          |       |
|Centos 6.6            |`centos-6.6`           |       |
|Centos 7.0            |`centos-7.0`           |       |
|Centos 7.1            |`centos-7.1`           |       |
|Ubuntu 12.04          |`ubuntu-12.04`         |       |
|Ubuntu 14.04          |`ubuntu-14.04`         |       |
|Windows Server 2008 R2|`win-serv-2008-r2`     |       |
|Windows Server 2012 R2|`win-serv-2012-r2`     |       |


### Starting a Virtual Machine

With the Boundary api token perform the following:

1. Either checkout or clone the git repository ()[]
2. Issue the following command, the target platforms are listed in the table below:
```
$ BOUNDARY_API_TOKEN=<api token> vagrant up <virtual machine name>
```


### Stopping a Virtual Machine

```
$ vagrant halt <virtual machine name>
```

### Destroying a Virtual Machine

```
$ vagrant destroy <virtual machine name>
```
## Plugin Installation and Configuration

### Web Servers
1. Start virtual machines
```
$ BOUNDARY_API_TOKEN=<api token> vagrant up web-01 --provider virtualbox
```
2. Deploy Apache plugin on each of the web servers

### Database Servers
```
$ BOUNDARY_API_TOKEN=<api token> vagrant up db-01 db-02 --provider virtualbox
```
2. Deploy MySQL plugin on each of the database servers

### Monitoring Server

1. Start virtual machine
```
$ BOUNDARY_API_TOKEN=<api token> vagrant up monitor-01 --provider virtualbox
```
2. Deploy httpcheck plugin
3. Configure check of web-01

