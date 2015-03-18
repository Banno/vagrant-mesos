# -*- mode: ruby -*-
# vi: set ft=ruby :

ZOOKEEPER_VERSION = "3.4.6"
MARATHON_VERSION = "v0.8.0"
CHRONOS_VERSION = "2.1.0"
MESOS_VERSION = "0.21.1"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  $hosts = <<SCRIPT
echo "127.0.0.1 localhost
192.168.33.10 mesos-master.vagrant mesos-master
192.168.33.11 mesos-slave1.vagrant mesos-slave1
192.168.33.12 mesos-slave2.vagrant mesos-slave2
192.168.33.13 mesos-slave3.vagrant mesos-slave3
192.168.33.14 mesos-slave4.vagrant mesos-slave4
192.168.33.15 mesos-slave5.vagrant mesos-slave5" > /etc/hosts
SCRIPT

  $master = <<SCRIPT
export ZK_CONNECTION_STRING="zk://mesos-master.vagrant:2181"
export ENV_NAME="vagrant"
setup-runit-service docker "/usr/bin/docker -d --host=unix:///var/run/docker.sock --storage-driver=aufs"
sleep 5
setup-docker-runit-service zookeeper "--net=host jplock/zookeeper:#{ZOOKEEPER_VERSION}"
setup-runit-service mesos-master "mesos-master --work_dir=/tmp --port=5050 --zk=$ZK_CONNECTION_STRING/mesos --cluster=$ENV_NAME --quorum=1 --hostname=$HOSTNAME"
setup-docker-runit-service marathon "--net=host mesosphere/marathon:#{MARATHON_VERSION} --master $ZK_CONNECTION_STRING/mesos --zk $ZK_CONNECTION_STRING/marathon --hostname $HOSTNAME"
setup-docker-runit-service chronos "--net=host banno/chronos:#{CHRONOS_VERSION} --master $ZK_CONNECTION_STRING/mesos --zk_hosts $ZK_CONNECTION_STRING --http_port 8081"
SCRIPT

  $slave = <<SCRIPT
export ZK_CONNECTION_STRING="zk://mesos-master.vagrant:2181"
export ENV_NAME="vagrant"
setup-runit-service docker "/usr/bin/docker -d --host=unix:///var/run/docker.sock --storage-driver=aufs"
setup-runit-service mesos-slave "mesos-slave --work_dir=/tmp --master=$ZK_CONNECTION_STRING/mesos --containerizers=docker,mesos --hostname=$HOSTNAME --docker_stop_timeout=30secs --executor_registration_timeout=5mins"
SCRIPT

  config.vm.box = "banno/mesos"
  config.vm.box_version = MESOS_VERSION

  config.vm.provision "file", source: "scripts/setup-runit-service", destination: "/home/vagrant/bin/setup-runit-service"
  config.vm.provision "file", source: "scripts/setup-docker-runit-service", destination: "/home/vagrant/bin/setup-docker-runit-service"
  config.vm.provision "shell", privileged: true, inline: "mv /home/vagrant/bin/* /usr/local/bin"
  config.vm.provision "shell", inline: $hosts

  config.vm.define "master" do |master_config|
    master_config.vm.network "private_network", ip: "192.168.33.10"
    master_config.vm.host_name = "mesos-master.vagrant"
    master_config.vm.provision "shell", inline: $master
    master_config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "512"]
    end
    # synced folder example: master_config.vm.synced_folder "~/repo", "/repo"
  end

  (1..5).each do |id|
    config.vm.define "slave#{id}" do |slave_config|
      slave_config.vm.network "private_network", ip: "192.168.33.1#{id}"
      slave_config.vm.host_name = "mesos-slave#{id}.vagrant"
      slave_config.vm.provision "shell", inline: $slave
      slave_config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", "2048"]
      end
      # synced folder example: master_config.vm.synced_folder "~/repo", "/repo"
    end
  end
end
