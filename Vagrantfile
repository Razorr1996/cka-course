# -*- mode: ruby -*-
# vi: set ft=ruby :

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

  config.dns.tld = "cka"

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

  config.vm.define "control" do |control|
    control.vm.hostname = "control"

    control.vm.provider "parallels" do |prl|
      prl.name = "CKA control"
    end
  end

  (1..3).each { |worker_num|
    worker_name = "worker#{worker_num}"

    config.vm.define worker_name do |worker|
      worker.vm.hostname = worker_name

      worker.vm.provider "parallels" do |prl|
        prl.name = "CKA #{worker_name}"
      end
    end
  }

end
