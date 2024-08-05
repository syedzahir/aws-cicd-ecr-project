#!/bin/bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 135167406830.dkr.ecr.us-east-1.amazonaws.com/szh-cicd-ecr
docker pull 135167406830.dkr.ecr.us-east-1.amazonaws.com/szh-cicd-ecr:latest
docker run -d -p 80:80 135167406830.dkr.ecr.us-east-1.amazonaws.com/szh-cicd-ecrlatest