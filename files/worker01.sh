source /vagrant/files/manager.sh

nfs_client(){
	yum install nfs-utils -y 
	showmount -e registry
	#docker plugin install --grant-all-permissions trajano/nfs-volume-plugin
	#docker volume create --driver local --opt type=nfs --opt o=addr=192.168.0.18,rw --opt device=:/home/ricardo/labs/Docker_local/data/database database
	docker volume create -d trajano/nfs-volume-plugin --opt device=registry:/home/suporte/storage/web_data volume_nfs

}

docker_compose(){
	sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
}

man(){
	depende
	docker_install
	docker_plugins
	nfs_client
	registry_client
	docker_compose
}

man