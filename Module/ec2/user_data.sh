#!/bin/bash

dnf update -y
dnf install -y docker
systemctl enable docker
systemctl start docker
docker pull ${docker_image}
docker run -d --name hello-world --restart always p 80:80 ${docker_image}