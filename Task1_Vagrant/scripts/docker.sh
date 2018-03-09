#!/bin/bash -eux

# Install Docker.
yum -y install  wget
wget https://download.docker.com/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
yum -y install docker-ce
service docker restart
mkdir -p /opt/dockerimages/nginx/html
echo "<html>
<header><title>This is title</title></header>
<body>
Hello world
</body>
</html>" > /opt/dockerimages/nginx/html/hello.html
