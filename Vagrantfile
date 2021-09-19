# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variaveis
VAGRANTFILE_API_VERSION = 2

# Chamando modulo YAML
require 'yaml'

# Lendo o arquivo YAML com as configuracoes do ambiente
env = YAML.load_file('environment.yaml')

# Limitando apenas a ultima versao estavel do Vagrant instalada
Vagrant.require_version '>= 2.0.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
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
<<<<<<< Updated upstream
=======

      config.vm.provider :aws do |aws, override|
        aws.access_key_id = "AKIASIX4VFN7YDB2KQP7"
        aws.secret_access_key = "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"
        #aws.session_token = "SESSION TOKEN"
        aws.keypair_name = "ricardo"

        aws.region = 'sa-east-1'
        aws.ami = "ami-02e2a5679226e293c"
        aws.security_groups = ['default']

        override.ssh.username = "ricardo"
        override.ssh.private_key_path = "~/.ssh/id_rsa"
      end
      
>>>>>>> Stashed changes
      srv.vm.provider 'virtualbox' do |vb|
        vb.name   = env['name']
        vb.memory = env['memory']
        vb.cpus   = env['cpus']
      end
      srv.vm.provision 'ansible_local' do |ansible|
        ansible.playbook           = env['provision']
        ansible.install_mode       = 'pip'
        ansible.become             = true
        ansible.become_user        = 'root'
        ansible.compatibility_mode = '2.0'
      end
    end
  end
end
