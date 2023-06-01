#!bin/bash
#set -e # Exit on first error
#set -x # Print expanded commands to stdout
#https://github.com/docker-mailserver/docker-mailserver

#install git
sudo apt install -y git

sudo apt-get -y update
sudo apt-get -y install python3-pip
sudo apt-get -y install python3-cryptography

#install zip
sudo apt install -y zip
sudo apt install -y unzip


#install jq
sudo apt install -y jq

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

#install pip3, dependencies and docker-mailserver
ansible-galaxy install hmlkao.docker_mailserver
#pip3 install ansible-vault pip3  not installed yet

#install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
git clone https://github.com/YevhenVieskov/mailserver.git
cd /home/ubuntu/mailserver/ansible

# get secret

#You can find DKIM key in folder defined by mail_persist_folder variable in file config/opendkim/keys/<domain.tld>/mail.txt on your host (server)


aws secretsmanager get-secret-value --secret-id secret-ansible-1  --query SecretString --output text > password_file

ansible-vault decrypt --vault-password-file password_file secret.yml
ansible-playbook -u ubuntu docker_mailserver.yml

#create DKIM record in route53
# https://gist.github.com/justinclayton/0a4df1c85e4aaf6dde52

# aws route53 list-hosted-zones-by-name | jq '.HostedZones[] | select(.Name == "hoolicorp.com.") | .Id'
#aws route53  get-change --id
#aws route53 list-resource-record-sets --hosted-zone-id Z06370XXXXX
#aws route53 change-resource-record-sets --hosted-zone-id Z06370712F3OMF8G17950 --change-batch file://change-config.json
#aws route53 list-hosted-zones
cd ~






