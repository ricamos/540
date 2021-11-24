# -*- mode: ruby -*-
# vi: set ft=ruby :

vbox_group = '4540'
#domain = 'srh.local'
#rede = '192.168.42'

# Variaveis
VAGRANTFILE_API_VERSION = 2

# Chamando modulo YAML
require 'yaml'

# Lendo o arquivo YAML com as configuracoes do ambiente
env = YAML.load_file('environment.yaml')

# Limitando apenas a ultima versao estavel do Vagrant instalada
Vagrant.require_version '>= 2.0.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/" #vagrant rsync-auto
  
  # Iteracao com os servidores do ambiente
  env.each do |env|
    config.vm.define env['name'] do |srv|
      srv.vm.box      = env['box']
      srv.vm.hostname = env['hostname']
      srv.vm.network 'private_network', ip: env['ipaddress']
      if env['additional_interface'] == true
        srv.vm.network 'private_network', ip: '1.0.0.100',
          auto_config: false
      end
      
      srv.vm.provider 'virtualbox' do |vb|
        vb.name   = env['name']
        vb.memory = env['memory']
        vb.cpus   = env['cpus']
        vb.customize ["modifyvm", :id, "--groups", "/#{vbox_group}"]
      end
      
      srv.vm.provision 'ansible_local' do |ansible|
        ansible.playbook           = env['provision']
        ansible.install_mode       = 'pip'
        ansible.become             = true
        ansible.become_user        = 'root'
        ansible.compatibility_mode = '2.0'
      end

      if env['name'] == "manager_off" || env['name'] == "worker01_off" then 
        #srv.vm.provision "shell", inline: "echo 'Executando script' && sudo sh /vagrant/files/manager.sh"
        srv.vm.provision "shell", path: "files/manager.sh" 
      end
      
      if env['name'] == "registry" then
        srv.vm.provision "shell", path: "files/registry.sh" 
      end

      if env['name'] == "worker02" then
        srv.vm.provision "shell", path: "files/worker02.sh" 
      end

    end
  end
end
