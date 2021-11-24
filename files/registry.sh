#!/bin/bash

depende() {
	echo 'dependencias...'
	apt-get update -y
	apt-get install apt-transport-https ca-certificates curl gnupg-agent -y
}

docker_install() {
	echo 'Install docker...'
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	
	apt-get update
	
	apt-get install docker-ce docker-ce-cli containerd.io -y
	
	usermod -aG docker suporte && sudo su - suporte
	software-properties-common -y	

	echo -e "teste: \n sudo su - suporte \n docker version"
}

nfs_volume(){
	echo "Edit exports"
	echo '/home/suporte/storage/web_data 172.16.0.0/24(rw,no_root_squash)' >> /etc/exports
	#echo '/home/suporte/storage/web_data worker01(rw,no_root_squash) worker02(rw,no_root_squash)' >> /etc/exports
	systemctl restart nfs-kernel-server
}

docker_plugins(){
	docker plugin install trajano/nfs-volume-plugin --grant-all-permissions
	docker plugin install --grant-all-permissions store/weaveworks/net-plugin:2.5.2
	docker plugin ls
}

registry_up(){
	apt-get install apache2-utils -y
	mkdir /home/suporte/certs
	mkdir /home/suporte/auth
	mkdir /home/suporte/data

	htpasswd -Bbn suporte 4linux > /home/suporte/auth/htpasswd
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout registry.key -addext "subjectAltName = DNS:registry" -out registry.crt -subj "/CN=registry/O=4Labs/OU=DevOps"
	# openssl req -newkey rsa:4096 -nodes -sha256 -keyout registry.key -addext "subjectAltName = DNS:registry" -x509 -days 365 -out registry.crt
	mv registry* certs

	docker container run -d --restart=always --name registry -v "$(pwd)"/data:/var/lib/registry -v "$(pwd)"/auth:/auth -e "REGISTRY_AUTH=htpasswd" -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd -v "$(pwd)"/certs:/certs -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key -p 5000:5000 registry:2
}

docker_compose(){
	curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
}

main() {
	depende
	docker_install
	nfs_volume
	docker_plugins
	#registry_up
	docker_compose
}

main