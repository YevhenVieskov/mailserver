#!bin/bash
#set -e # Exit on first error
#set -x # Print expanded commands to stdout
#https://github.com/docker-mailserver/docker-mailserver

sudo apt install -y git

sudo apt-get -y update
sudo apt-get -y install python3-pip
sudo apt-get -y install python3-cryptography

#install ansible
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt -y update
sudo apt install -y ansible

sudo apt-get -y update
sudo apt-get -y install ca-certificates curl gnupg lsb-release
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg


echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo sh -c 'curl -L https://github.com/docker/machine/releases/download/v0.5.5/docker-machine_linux-amd64 >/usr/local/bin/docker-machine && \
     chmod +x /usr/local/bin/docker-machine'

#sudo groupadd docker || true 
sudo usermod -aG docker $USER  || true 
#newgrp docker || true 

#install Mozilla SOPS
SOPS_LATEST_VERSION=$(curl -s "https://api.github.com/repos/mozilla/sops/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
curl -Lo sops.deb "https://github.com/mozilla/sops/releases/latest/download/sops_${SOPS_LATEST_VERSION}_amd64.deb"
sudo apt --fix-broken install ./sops.deb
#rm -rf sops.deb

ansible-galaxy install hmlkao.docker_mailserver

git clone https://github.com/YevhenVieskov/mailserver.git

ansible playbook -u ubuntu ./mailserver/ansible/docker_mailserver.yml






