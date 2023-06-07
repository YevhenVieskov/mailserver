#!bin/bash
#set -e # Exit on first error
set -x # Print expanded commands to stdout
#https://github.com/mailserver2/mailserver


#install git
apt install -y git

apt-get -y update
apt-get -y install python3-pip
apt-get -y install python3-cryptography

#install zip
apt install -y zip
apt install -y unzip


#install jq
apt install -y jq

#install ansible
apt-add-repository -y ppa:ansible/ansible
apt -y update
apt install -y ansible

apt-get -y update
apt-get -y install ca-certificates curl gnupg lsb-release
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg


echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
   tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get -y update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

#sudo sh -c 'curl -L https://github.com/docker/machine/releases/download/v0.5.5/docker-machine_linux-amd64 >/usr/local/bin/docker-machine && \
#     chmod +x /usr/local/bin/docker-machine'

#sudo groupadd docker || true 
#sudo usermod -aG docker $USER  || true 

#install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

folder="/home/ubuntu"
ans_dms_path=$folder/docker-mail-server

#clone repo
mkdir -p $folder/mailserver2
git clone https://github.com/mailserver2/mailserver.git $folder/mailserver2   

#clone repo
mkdir -p $folder/mailserver
git clone https://github.com/YevhenVieskov/mailserver.git  $folder/mailserver  

# get secret
#cd ~/mailserver/ansible
aws secretsmanager get-secret-value --secret-id secret-ansible-1  --query SecretString --output text > "${folder}/mailserver/ansible/password_file"

#decrypt playbook
ansible-vault decrypt --vault-password-file ${folder}/mailserver/ansible/password_file ${folder}/mailserver/ansible/.env

chown -R ubuntu:ubuntu ${folder}/mailserver
chown -R ubuntu:ubuntu ${folder}/mailserver2

mv $folder/mailserver2/docker-compose.sample.yml  $folder/mailserver2/docker-compose.yml
cp $folder/mailserver/ansible/.env $folder/mailserver2

docker network create http_network
docker network create mail_network
docker-compose up -d

groupadd docker || true 
usermod -aG docker $USER  || true 
newgrp docker




