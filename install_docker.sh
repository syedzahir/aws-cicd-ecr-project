# Update package information
sudo apt-get update

# Install Docker
sudo apt-get install -y docker.io

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

#stop nginx service
sudo service nginx stop

# Add your user to the Docker group to run Docker commands without sudo
$USER = 'ubuntu'
sudo usermod -aG docker $USER