#!/bin/bash

depende() {
	yum install yum-utils device-mapper-persistent-data lvm2 -y
	yum install mariadb -y
}

docker_install() {
	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	yum install docker-ce docker-ce-cli containerd.io -y
	systemctl enable docker && sudo systemctl start docker
	usermod -aG docker suporte # add user suporte ao grupo docker
	yum -y install bash-completion bash-completion-extras # auto complete command

	echo -e "teste: \n sudo su - suporte \n docker version"
}

docker_plugins(){
	docker plugin install trajano/nfs-volume-plugin --grant-all-permissions
	docker plugin install --grant-all-permissions store/weaveworks/net-plugin:2.5.2
	docker plugin ls
}

registry_client(){
	mkdir -p /etc/docker/certs.d/registry:5000
	yum install sshpass -y
	sshpass -p '4linux' scp -o "StrictHostKeyChecking=no" suporte@registry:certs/registry.crt /home/suporte
	mv /home/suporte/registry.crt /etc/docker/certs.d/registry:5000/ca.crt

	echo -e "teste: \n docker login -u suporte registry:5000 \n senha: 4linux"
}

docker_swarm(){
	docker swarm init --advertise-addr 172.16.0.100
	# docker swarm join --token SWMTKN-1-1ld3p4gkzyb00pxx2wu2sn07856z8kv07jh1p7zlply1uxm7av-c9py3uluga5cwt8rgbaw41e8z 172.16.0.100:2377
	docker swarm join-token worker
	docker swarm join-token manager
}

main() {
	depende
	docker_install
	docker_plugins
	registry_client
}

main