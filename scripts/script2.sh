#!/bin/bash
sudo echo "Starting the script"

# Installing the docker engine
sudo echo "Installing the docker engine"

sudo cd /etc/yum.repos.d/
sudo wget http://yum.oracle.com/public-yum-ol7.repo

sudo yum install docker-engine
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker

USERNAME=$2
PASSWORD=$3

# Pulling the docker image from docker hub
sudo echo "Pulling the docker image from docker hub"

sudo docker login --username="${USERNAME}" --password="${PASSWORD}"
sudo docker pull testuser2000/python-flask:python-flask-app

# Opening the firewall
sudo echo "Opening the firewall"

sudo firewall-cmd --permanent --add-port=5000/tcp

# deploying the app
sudo echo "deploying the app"

DATABASE_IP=$1 
sudo docker run -d -e DB_IP="${DATABASE_IP}" -p 5000:5000 testuser2000/python-flask:python-flask-app

sudo echo "Script run complete and exiting"

command || exit 1
