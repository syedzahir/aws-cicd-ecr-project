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
# sudo service nginx stop

# Log in to ECR
echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 135167406830.dkr.ecr.us-east-1.amazonaws.com

# Pull the latest image
REPOSITORY_URI=135167406830.dkr.ecr.us-east-1.amazonaws.com/szh-cicd-ecr
IMAGE_TAG=$(date +%Y%m%d%H)
docker pull $REPOSITORY_URI:$IMAGE_TAG

# Run the container
docker run -d -p 80:80 $REPOSITORY_URI:$IMAGE_TAG
