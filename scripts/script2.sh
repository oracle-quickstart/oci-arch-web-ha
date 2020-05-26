## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

#!/bin/bash
sudo echo "Starting the script"

sudo echo $1

sudo echo "disable the firewall"

sudo service firewalld stop
sudo systemctl disable firewalld


# Installing the docker engine
sudo echo "Installing the docker engine"

sudo yum update -y
sudo yum install -y docker-engine
sudo systemctl enable docker
sudo systemctl start docker


# Pulling the docker image from docker hub
sudo echo "Pulling the docker image from docker hub"

sudo docker pull testuser2000/python-flask:python-flask-app

# deploying the app
sudo echo "deploying the app"

DATABASE_IP=$1 
sudo docker run -d -e DB_IP="${DATABASE_IP}" -p 5000:5000 --restart=always testuser2000/python-flask:python-flask-app

sudo echo "Script run complete and exiting"
