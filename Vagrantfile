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

  config.vm.define "web-01", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "web-01"
    v.vm.network "private_network", ip: "192.168.50.11"
    v.vm.network "forwarded_port", guest: 80, host: 8011
  end

  config.vm.define "web-02", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "web-02"
    v.vm.network "private_network", ip: "192.168.50.12"
  end

  config.vm.define "web-03", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "web-03"
    v.vm.network "private_network", ip: "192.168.50.12"
  end

  config.vm.define "dash-01", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "dash-01"
    v.vm.network "private_network", ip: "192.168.50.21"
  end

  config.vm.define "db-01", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "db-01"
    v.vm.network "private_network", ip: "192.168.50.31"
  end

  config.vm.define "db-02", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "db-02"
    v.vm.network "private_network", ip: "192.168.100.32"
  end

  config.vm.define "monitor-01", autostart: false do |v|
    v.vm.box = BOX_NAME
    v.vm.hostname = "monitor-01"
    v.vm.network "private_network", ip: "192.168.100.51"
  end


  #
  # Add the required puppet modules before provisioning is run by puppet
  #
  config.vm.provision :shell do |shell|
     shell.inline = "puppet module install puppetlabs-stdlib;
                     puppet module install puppetlabs-apache;
		     puppet module install puppetlabs-firewall
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
      "boundary_api_token" => ENV["BOUNDARY_API_TOKEN"]
    }
  end

end
