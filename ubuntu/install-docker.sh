curl https://releases.rancher.com/install-docker/20.10.sh | sh
sudo usermod -aG docker vagrant && sudo chmod 777 /var/run/docker.sock
