# -*- mode: ruby -*-
# vi: set ft=ruby :

ZOOKEEPER_VERSION = "3.4.6"
MARATHON_VERSION = "v0.8.1"
CHRONOS_VERSION = "latest"
MESOS_VERSION = "0.22.1"
NUMBER_OF_SLAVES = 3
MASTER_MEMORY = "512"
SLAVE_MEMORY = "1024"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  slave_host_entries = (1..NUMBER_OF_SLAVES).inject("") do |result, num|
    result + "192.168.33.1#{num} mesos-slave#{num}.vagrant mesos-slave#{num}\n"
  end

  $hosts = <<SCRIPT
echo "127.0.0.1 localhost
192.168.33.10 mesos-master.vagrant mesos-master
#{slave_host_entries}" > /etc/hosts
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
setup-runit-service mesos-slave "mesos-slave --work_dir=/tmp --master=$ZK_CONNECTION_STRING/mesos --containerizers=docker,mesos --hostname=$HOSTNAME --docker_stop_timeout=30secs --executor_registration_timeout=5mins --resources=mem:#{SLAVE_MEMORY.to_i - 256}"
SCRIPT

  config.vm.box = "banno/mesos"
  config.vm.box_version = MESOS_VERSION

  config.vm.provision "file", source: "scripts/setup-runit-service", destination: "/home/vagrant/bin/setup-runit-service"
  config.vm.provision "file", source: "scripts/setup-docker-runit-service", destination: "/home/vagrant/bin/setup-docker-runit-service"
  config.vm.provision "shell", privileged: true, inline: "mv /home/vagrant/bin/* /usr/local/bin"
  config.vm.provision "shell", inline: $hosts

  if File.directory?("CAs")
    Dir["CAs/*"].each do |crt|
      config.vm.provision "file", source: "#{crt}", destination: "/home/vagrant/#{crt}"
      config.vm.provision "shell", privileged: true, inline: "rsync -plarq /home/vagrant/CAs/ /usr/local/share/ca-certificates/ && sudo update-ca-certificates"
    end
  end

  config.vm.define "master" do |master_config|
    master_config.vm.network "private_network", ip: "192.168.33.10"
    master_config.vm.host_name = "mesos-master.vagrant"
    master_config.vm.provision "shell", inline: $master
    master_config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", MASTER_MEMORY]
    end
    # synced folder example: master_config.vm.synced_folder "~/repo", "/repo"
  end

  (1..NUMBER_OF_SLAVES).each do |id|
    config.vm.define "slave#{id}" do |slave_config|
      slave_config.vm.network "private_network", ip: "192.168.33.1#{id}"
      slave_config.vm.host_name = "mesos-slave#{id}.vagrant"
      slave_config.vm.provision "shell", inline: $slave
      slave_config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", SLAVE_MEMORY]
      end
      # synced folder example: master_config.vm.synced_folder "~/repo", "/repo"
    end
  end
end
