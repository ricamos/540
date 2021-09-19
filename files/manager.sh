#!/bin/bash

depende() {
	yum install yum-utils device-mapper-persistent-data lvm2 -y
}

docker_install() {
	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	yum install docker-ce docker-ce-cli containerd.io -y
	systemctl enable docker && sudo systemctl start docker
	usermod -aG docker suporte # add user suporte ao grupo docker

	echo -e "teste: \n sudo su - suporte \n docker version"
}

main() {
	depende
	docker_install
}

main