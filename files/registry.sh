#!/bin/bash

depende() {
	apt-get update
	apt-get install apt-transport-https ca-certificates curl gnupg-agent
}

docker_install() {
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	
	apt-get update
	
	apt-get install docker-ce docker-ce-cli containerd.io -y
	
	usermod -aG docker suporte && sudo su - suporte
	software-properties-common -y	

	echo -e "teste: \n sudo su - suporte \n docker version"
}

main() {
	docker_install
}

main