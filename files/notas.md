> Anotações da aula

https://sucess.docker.com/article/ucp-service-discovery-swarm

Teste montar NFS nos hosts:
https://debian-handbook.info/browse/pt-BR/stable/sect.nfs-file-server.html
docker volume create --driver local --opt type=nfs --opt o=addr=172.16.0.103,rw --opt device=:/home/suporte/storage/web_data nfs_volume


echo "registry:/home/suporte/storage/web_data /opt/data  nfs      defaults    0       0" >> /etc/fstab
mkdir /opt/data
mount -a
ls /opt/data


> Usar estas opções do docker:
--restart=always
--update-delay
-v 

> Traefik
https://docs.traefik.io

https://docs.docker.com/engine/reference/commandline/volume_create/
docker volume create --driver local --opt type=nfs --opt o=addr=172.16.0.103,rw --opt device=:/home/suporte/storage/web_data nfs_volume

version: '3.1'

services:
  webserver:
    image: "registry:5000/webserver-wordpress:latest"
    ports:
      - "8081:80"
    deploy:
      mode: replicated
      replicas: 2
      placement:
        constraints: [node.role == worker]
      labels:
        - "traefik.enable=true"
        - "traefik.port=80"
        - "traefik.backend=webserver"
        - "traefik.docker.network=traefik-net"
        - "traefik.backend.loadbalancer.swarm=true"
        - "traefik.frontend.rule=Host:webserver.4labs.example"
      restart_policy:
        condition: on-failure
        delay: 10s
      resources:
        limits:
          memory: 256M
          cpus: '0.2'
    volumes:
      - "nfs_volume:/var/www/html"
    networks:
      - traefik-net

volumes:
  nfs_volume:
    external: true
networks:
  traefik-net:
    external: true


https://forums.docker.com/t/autoscaling-in-docker-swarm/44353

https://www.haproxy.com/blog/haproxy-on-docker-swarm-load-balancing-and-dns-service-discovery/

https://blog.4linux.com.br/criando-um-container-do-docker-sem-o-docker/

https://github.com/Nordstrom/docker-machine/tree/master/docs/drivers


Subdominios
https://stackoverflow.com/questions/51329861/combining-traefik-frontend-redirect-replacement-with-pathprefixstrip

labels:
        - "traefik.enable=true"
        - "traefik.port=80"
        - "traefik.backend=webserver"
        - "traefik.docker.network=traefik-net"
        - "traefik.backend.loadbalancer.swarm=true"
        - "traefik.frontend.rule=Host:www.sgp.local; PathPrefixStrip:/suporte"

