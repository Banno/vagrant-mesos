# Vagrant Mesos

This project downloads a vagrant box with [Mesos](http://mesos.apache.org/) and [Docker](https://www.docker.com/) preinstalled from [Atlas](https://atlas.hashicorp.com). By default this will launch one master and five slaves. The master also runs [Zookeeper](http://zookeeper.apache.org/), [Marathon](https://mesosphere.github.io/marathon/), and [Chronos](https://github.com/mesos/chronos).

## Running the Vagrant cluster

### Requirements

- [Vagrant](https://www.vagrantup.com/downloads.html) version 1.7.0+
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads)

### Start the cluster

`vagrant up`

### Pause cluster

`vagrant suspend`

### Delete cluster

`vagrant destroy`

## Configuration

### Versions of marathon or chronos

Change version variable in [Vagranfile](Vagrantfile)

### Number of Mesos slaves

Change `NUMBER_OF_SLAVES` variable in [Vagranfile](Vagrantfile)

### Mesos daemon memory allocation

Change `MASTER_MEMORY` and/or `SLAVE_MEMORY` variable in [Vagranfile](Vagrantfile)

## Install and Root level CA

Put your ca file(s) in the CAs directory

## Packer Build

### Requirements

- [Packer](https://packer.io/downloads.html)
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads)

### Add custom vagrant box

1. `vagrant box add BOX_NAME PATH_TO_BOX_FILE`
2. Change box name in [Vagranfile](Vagrantfile)

## Contributing

Fork away, commit, and send a pull request.
