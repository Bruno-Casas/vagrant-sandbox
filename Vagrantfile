NUM_WORKER_NODES=1
IP_NW="10.0.0."
IP_START=10

Vagrant.configure("2") do |config|
  config.vm.provision "shell", inline: <<-SHELL
    if test ! -f "/bin/minio"; then
      wget -q https://dl.min.io/server/minio/release/linux-amd64/minio -O /bin/minio
      chmod +x /bin/minio
      mkdir -p /shared/minio
      mkdir -p /shared/nfs
    fi

    rm /etc/init.d/minio
    if test ! -f "/etc/init.d/minio"; then
      cp /vagrant/minio.rc /etc/init.d/minio
      chmod +x /etc/init.d/minio
    fi
  SHELL

  config.vm.box = "generic/alpine315"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.disk :disk, size: "5GB", primary: true

  (1..NUM_WORKER_NODES).each do |i|

  config.vm.define "node1#{i}" do |node|
    node.vm.hostname = "node#{i}"
    node.vm.network "private_network", ip: IP_NW + "#{IP_START + i}"
    node.vm.provider "libvirt" do |lv|
      lv.memory = 1024
      lv.cpus = 1
    end
    node.vm.provision "shell", path: "provisionscript.sh", env: {"MYVAR" => "value"}
    # node.vm.provision "shell", inline: <<-SHELL
    #   killall minio
    #   ./minio server /shared/minio > /dev/null
    #   echo "oi" &
    # SHELL
  end

  end
end 