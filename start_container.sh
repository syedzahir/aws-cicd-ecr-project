#!/bin/bash

# Install AWS CLI if not installed
if ! command -v aws &> /dev/null
then
    echo "AWS CLI not found. Installing AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install
fi

# Check if NGINX service is running and stop it if it is
if pgrep nginx > /dev/null
then
    echo "NGINX service is running. Stopping NGINX service..."
    sudo service nginx stop
    sleep 10  # Wait for a few seconds to ensure NGINX has stopped
else
    echo "NGINX service is not running. No need to stop it."
fi

# Check if port 80 is still in use and kill the process if it is
if lsof -i:80 | grep LISTEN > /dev/null
then
    echo "Port 80 is still in use. Killing the process using port 80..."
    sudo fuser -k 80/tcp
    sleep 10  # Wait for a few seconds to ensure the process has been killed
else
    echo "Port 80 is not in use."
fi


# Find container ID using port 80
container_id=$(sudo docker ps --filter "publish=80" -q)

# Stop the container
if [ -n "$container_id" ]; then
    sudo docker stop "$container_id"
	sleep 10
	sudo docker rm "$container_id"
	sleep 10
fi

#  Remove all stopped containers
sudo docker container prune -f
sleep 30

# Remove unused images and networks
sudo docker system prune -a -f --volumes
sleep 30


# Log in to ECR
echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 135167406830.dkr.ecr.us-east-1.amazonaws.com

# Pull the latest image
REPOSITORY_URI=135167406830.dkr.ecr.us-east-1.amazonaws.com/szh-cicd-ecr
IMAGE_TAG=latest #$(date +%Y%m%d%H)
docker pull $REPOSITORY_URI:$IMAGE_TAG

# Run the container
docker run -d -p 80:80 $REPOSITORY_URI:$IMAGE_TAG
