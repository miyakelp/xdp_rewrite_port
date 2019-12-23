# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-8"

  config.vm.define "mysql_server" do |c|
    c.vm.hostname = "mysql-server"
    c.vm.network "private_network", ip: "192.168.33.10"
    c.vm.network "forwarded_port", guest: 22, host: 10022, id: "ssh"
    c.vm.provision "shell", inline: "dnf install -y llvm clang kernel-headers mysql-server git"
  end

  config.vm.define "mysql_client" do |c|
    c.vm.hostname = "mysql-client"
    c.vm.network "private_network", ip: "192.168.33.20"
    c.vm.network "forwarded_port", guest: 22, host: 20022, id: "ssh"
    c.vm.provision "shell", inline: "dnf install -y llvm clang kernel-headers mysql git"
  end

  config.vm.provider "virtualbox" do |v|
    v.gui = false
    v.memory = 2048
    v.cpus = 1
  end
end

