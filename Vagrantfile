# -*- mode: ruby -*-
# vi: set ft=ruby :

CKA_WORKER_NUM = 3

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/ubuntu-22.04-arm64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  config.vm.provider "parallels" do |prl|
    prl.memory = 4096
    prl.cpus = 4

    # Uncomment for updating Parallels Tools
    # prl.update_guest_tools = true

    prl.customize "post-import", ["set", :id, "--nested-virt", "on"]
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  cka_nodes = ["control"] + (1..CKA_WORKER_NUM).map { |i| "worker#{i}" }

  cka_nodes.each do |node_name|
    config.vm.define node_name do |cfg|
      cfg.vm.hostname = node_name

      cfg.vm.provider "parallels" do |prl|
        prl.name = "CKA #{node_name}"
      end
    end
  end

  if Vagrant.has_plugin?("vagrant-group")
    config.group.groups = {
      "cka" => cka_nodes,
    }
  end

end
