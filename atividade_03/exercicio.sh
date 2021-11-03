#!/bin/bash

#Exercício03

docker network create net-exercicio3
docker run -d --network net-exercicio3 --name nginx-exercicio3 -p 80:80 nginx
docker run -d --network net-exercicio3 --name bd-exercicio3 -e MYSQL_ROOT_PASSWORD=root mysql/mysql-server:8.0

