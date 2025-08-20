#!/bin/bash

CONTAINER_ID=`docker ps -a | grep jdk11-dev | awk -F " " '{print $1}'`
if [ -z "$CONTAINER_ID" ]; then
  echo "Container jdk11-dev not found."
else
  echo "Container jdk11-dev already exists with ID: $CONTAINER_ID"
  echo "Removing the existing container..."
  docker stop $CONTAINER_ID
  docker rm -f $CONTAINER_ID
fi

IMAGE_ID=`docker images | grep jdk11-dev | awk -F " " '{print $3}'`
if [ -z "$IMAGE_ID" ]; then
  echo "Image jdk11-dev not found. Building the image..."
else
  echo "Image jdk11-dev already exists with ID: $IMAGE_ID"
  echo "Removing the existing image..."
  docker rmi -f $IMAGE_ID
fi

docker builder prune -a -f

# Ensure the Dockerfile uses Unix line endings
dos2unix.exe Dockerfile

echo "Building the Docker image..."
docker build -t jdk11-dev .

echo "Running the Docker container..."
# For git bash on Windows, use /$(pwd) 
# Otherwise, use $(pwd) for Linux or Mac or power shell on Windows
docker run -d -e SSH_PASSWORD=123 -v "/$(pwd):/app" -p 2222:22 jdk11-dev

docker ps -a
docker logs `docker ps -a | grep jdk11-dev | awk -F " " '{print $1}'` --tail 50
