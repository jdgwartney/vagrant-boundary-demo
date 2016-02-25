# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  #
  # Configure VirtualBox Provider
  #
  config.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 2
  end

  BOX_NAME = "puppetlabs/centos-6.6-64-puppet"

  config.vm.define "web-1", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "web-1"
    v.vm.box_version = "1.0.1"
    v.vm.network "private_network", ip: "192.168.50.11"
#    v.vm.network "forwarded_port", guest: 80, host: 8011
  end

  config.vm.define "web-2", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "web-2"
    v.vm.box_version = "1.0.1"
    v.vm.network "private_network", ip: "192.168.50.12"
  end

  config.vm.define "web-3", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "web-3"
    v.vm.box_version = "1.0.1"
    v.vm.network "private_network", ip: "192.168.50.13"
  end

  config.vm.define "dash-1", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "dash-1"
    v.vm.box_version = "1.0.1"
    v.vm.network "private_network", ip: "192.168.50.21"
  end

  config.vm.define "dbm-1", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "dbm-1"
    v.vm.box_version = "1.0.1"
    v.vm.network "private_network", ip: "192.168.50.31"
  end

  config.vm.define "dbm-2", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "db-2"
    v.vm.box_version = "1.0.1"
    v.vm.network "private_network", ip: "192.168.100.32"
  end

  config.vm.define "dbs-1", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "dbs-1"
    v.vm.box_version = "1.0.1"
    v.vm.network "private_network", ip: "192.168.50.33"
  end

  config.vm.define "dbs-2", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "db-slave-02"
    v.vm.box_version = "1.0.1"
    v.vm.network "private_network", ip: "192.168.100.34"
  end

  config.vm.define "ns-1", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "ns-01"
    v.vm.box_version = "1.0.1"
    v.vm.network "private_network", ip: "192.168.100.51"
  end

  config.vm.define "ns-2", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "ns-02"
    v.vm.box_version = "1.0.1"
    v.vm.network "private_network", ip: "192.168.100.14"
  end

  config.vm.define "mon-1", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "mon-1"
    v.vm.box_version = "1.0.1"
    v.vm.network "private_network", ip: "192.168.100.51"
  end

  config.vm.define "install-1", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "install-1"
    v.vm.box_version = "1.0.1"
    v.vm.network "private_network", ip: "192.168.100.101"
  end

  #
  # Add the required puppet modules before provisioning is run by puppet
  #
  config.vm.provision :shell do |shell|
     shell.inline = "puppet module install puppetlabs-apt;
                     puppet module install puppetlabs-stdlib;
                     puppet module install puppetlabs-apache;
		     puppet module install puppetlabs-firewall;
                     puppet module install puppetlabs-mysql;
                     puppet module install boundary-boundary;
                     exit 0"
  end

  #
  # Use Puppet to provision the server and setup an elastic search cluster
  # on a single box
  #
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "site.pp"
    puppet.module_path = "manifests/modules"
    puppet.facter = {
      "api_token" => ENV["API_TOKEN"]
    }
  end

end
