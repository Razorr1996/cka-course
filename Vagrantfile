# -*- mode: ruby -*-
# vi: set ft=ruby :

VM_MEMORY = 4096
VM_CPUS = 2

GROUPS = {
  :cka1 => { :control_num => 1, :worker_num => 2 },
  # :cka2 => { :control_num => 3, :worker_num => 2, :env => { "K8S_VERSION" => "v1.27" } },
}

Vagrant.configure("2") do |config|
  config.vm.box = "basa62/ubuntu-22.04-arm64"

  config.vm.box_check_update = false

  config.vm.provider "parallels" do |prl|
    prl.memory = VM_MEMORY
    prl.cpus = VM_CPUS

    prl.customize "post-import", ["set", :id, "--nested-virt", "on"]
  end

  if Vagrant.has_plugin?("vagrant-group")
    config.group.groups = {}
  end

  GROUPS.each do |group, settings|
    control_nodes = (1..settings[:control_num]).map { |i| "#{group}-control#{i}" }
    worker_nodes = (1..settings[:worker_num]).map { |i| "#{group}-worker#{i}" }
    nodes = control_nodes + worker_nodes
    env = settings[:env] || {}

    nodes.each do |node_name|
      config.vm.define node_name do |cfg|
        cfg.vm.hostname = node_name

        cfg.vm.provider "parallels" do |prl|
          prl.name = node_name
        end

        cfg.vm.provision "shell",
          path: "cka/setup-container.sh",
          env: env

        cfg.vm.provision "shell",
          path: "cka/setup-kubetools.sh",
          env: env

      end

    end

    if Vagrant.has_plugin?("vagrant-group")
      config.group.groups.merge!(group.to_s => nodes)
    end

  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "config.yml"
    ansible.compatibility_mode = "2.0"
  end

end
