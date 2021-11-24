source /vagrant/files/registry.sh

nfs_client(){
	apt-get install nfs-common -y	
	showmount -e registry
	#docker plugin install --grant-all-permissions trajano/nfs-volume-plugin
	docker volume create -d trajano/nfs-volume-plugin --opt device=registry:/home/suporte/storage/web_data volume_nfs
}

registry_client(){
	mkdir -p /etc/docker/certs.d/registry:5000
	apt-get install sshpass -y
	sshpass -p '4linux' scp -o "StrictHostKeyChecking=no" suporte@registry:certs/registry.crt /home/suporte
	mv /home/suporte/registry.crt /etc/docker/certs.d/registry:5000/ca.crt

	echo -e "teste: \n docker login -u suporte registry:5000 \n senha: 4linux"
}

man(){
	depende
	docker_install
	docker_plugins
	nfs_client
	registry_client	
}

man