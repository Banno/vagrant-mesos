# Vagrant Mesos

This project downloads a vagrant box with [Mesos](http://mesos.apache.org/) and [Docker](https://www.docker.com/) preinstalled from [Atlas](https://atlas.hashicorp.com). By default this will launch one master and five slaves. The master also runs [Zookeeper](http://zookeeper.apache.org/), [Marathon](https://mesosphere.github.io/marathon/), and [Chronos](https://github.com/mesos/chronos).

# Running the Vagrant cluster

## Requirements

- [Vagrant](https://www.vagrantup.com/downloads.html) version 1.7.0+
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads)

## Start the cluster

`vagrant up`

## Pause cluster

`vagrant suspend`

## Delete cluster

`vagrant destroy`

## Change versions of marathon or chronos

Change version variable in the [Vagranfile](Vagrantfile)

## Change the number of Mesos slaves

Change the upper end of the range (1..5) to the number of slaves you want to run.

# Packer Build

## Requirements

- [Packer](https://packer.io/downloads.html)
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads)

## Add custom vagrant box

1. `vagrant box add BOX_NAME PATH_TO_BOX_FILE`
2. Change box name in the [Vagranfile](Vagrantfile)
