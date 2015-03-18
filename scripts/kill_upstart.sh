service zookeeper stop
echo manual > /etc/init/zookeeper.override
echo manual > /etc/init/mesos-slave.override
echo manual > /etc/init/mesos-master.override
echo manual > /etc/init/docker.override
service docker stop
