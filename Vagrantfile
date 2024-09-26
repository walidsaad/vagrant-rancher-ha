# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:
# Define the number of master and worker nodes
# If this number is changed, remember to update setup-hosts.sh script with the new hosts IP details in /etc/hosts of each VM.
NUM_MASTER_NODE = 1
NUM_WORKER_NODE = 2
IP_NW = "192.168.5."
MASTER_IP_START = 10
NODE_IP_START = 20
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/focal64"
  config.vm.box_check_update = false
  # Provision Master Nodes
  (1..NUM_MASTER_NODE).each do |i|

      config.vm.define "master-#{i}" do |node|
        # Name shown in the GUI
        node.vm.provider "virtualbox" do |vb|
            vb.name = "kubernetes-ha-master-#{i}"
            vb.memory = 8000
            vb.cpus = 2
            vb.customize ['modifyvm',"kubernetes-ha-master-#{i}",'--natdnshostresolver1', 'on']
            vb.customize ['modifyvm',"kubernetes-ha-master-#{i}", '--natdnsproxy1', 'on']
        end
        node.vm.hostname = "master-#{i}"
        node.vm.network :private_network, ip: IP_NW + "#{MASTER_IP_START + i}"
        node.vm.network "forwarded_port", guest: 22, host: "#{2710 + i}"
        node.vm.provision "setup-hosts", :type => "shell", :path => "ubuntu/vagrant/setup-hosts.sh" do |s|
          s.args = ["enp0s8"]
        end
        node.vm.provision "setup-dns", type: "shell", :path => "ubuntu/update-dns.sh"
        node.vm.provision "install-docker", type: "shell", :path => "ubuntu/install-docker.sh"
      end
  # Provision Worker Nodes
  (1..NUM_WORKER_NODE).each do |i|
    config.vm.define "worker-#{i}" do |node|
        node.vm.provider "virtualbox" do |vb|
            vb.name = "kubernetes-ha-worker-#{i}"
            vb.memory = 8000
            vb.cpus = 2
            vb.customize ['modifyvm',"kubernetes-ha-worker-#{i}",'--natdnshostresolver1', 'on']
            vb.customize ['modifyvm',"kubernetes-ha-worker-#{i}", '--natdnsproxy1', 'on']
        end
        node.vm.hostname = "worker-#{i}"
        node.vm.network :private_network, ip: IP_NW + "#{NODE_IP_START + i}"
		    node.vm.network "forwarded_port", guest: 22, host: "#{2720 + i}"
        node.vm.provision "setup-hosts", :type => "shell", :path => "ubuntu/vagrant/setup-hosts.sh" do |s|
          s.args = ["enp0s8"]

        end
        node.vm.provision "setup-dns", type: "shell", :path => "ubuntu/update-dns.sh"
        node.vm.provision "install-docker", type: "shell", :path => "ubuntu/install-docker.sh"
        node.vm.provision "allow-bridge-nf-traffic", :type => "shell", :path => "ubuntu/allow-bridge-nf-traffic.sh"
   end
    end
  end
  end
