#!/usr/bin/env bash

# install keys and repos for fluentd and docker
curl https://packages.treasuredata.com/GPG-KEY-td-agent | apt-key add -
curl https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] http://packages.treasuredata.com/3/ubuntu/$(lsb_release -cs)/ $(lsb_release -cs) contrib"
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# install needed packages
apt-get update
apt-cache policy docker-ce
timedatectl set-ntp no
apt-get install -y docker-ce docker-compose td-agent mongodb ntp build-essential

# drop our config files
cp host/daemon.json /etc/docker/
cp host/in_docker.conf /etc/td-agent/

# install fluentd gems for mongo and s3
td-agent-gem install fluent-plugin-mongo
td-agent-gem install fluent-plugin-s3

# restart services
service docker restart
td-agent -c /etc/td-agent/in_docker.conf &

# build and run out app server
cd appserver
docker build -t flaskapp .
docker run -d -p 5000:5000 flaskapp
