NUM_WORKER_NODES=4
IP_NW="10.0.0."
IP_START=10

Vagrant.configure("2") do |config|
  config.vm.provision "shell", inline: <<-SHELL
    pacman -Sy --needed minio minio-client s3fs-fuse docker gnu-netcat --noconfirm
    mkdir -p /shared/minio
    mkdir -p /shared/nfs
  SHELL

  config.vm.box = "archlinux/archlinux"
  config.vm.disk :disk, size: "5GB", primary: true
  config.vm.synced_folder ".", "/vagrant", disabled: true

  (1..NUM_WORKER_NODES).each do |i|

  config.vm.define "node1#{i}" do |node|
    node.vm.hostname = "node#{i}"
    node.vm.network "private_network", ip: IP_NW + "#{IP_START + i}"
    node.vm.provider "libvirt" do |lv|
      lv.memory = 1024
      lv.cpus = 2
    end
    node.vm.provision "shell", path: "provisionscript.sh", env: {"MYVAR" => "value"}
  end

  end
end 