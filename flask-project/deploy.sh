#!/bin/bash

# 从Docker Hub拉取最新镜像
docker pull $DOCKERHUB_USERNAME/flask-app:latest

# 停止并删除现有容器
docker stop flask-app || true
docker rm flask-app || true

# 运行新容器
docker run -d -p 5000:5000 --name flask-app $DOCKERHUB_USERNAME/flask-app:latest

# 清理未使用的镜像
docker image prune -f