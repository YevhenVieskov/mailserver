#!bin/bash
#set -e # Exit on first error
#set -x # Print expanded commands to stdout

sudo apt install -y git
sudo apt-get -y update
sudo apt-get -y install python3-pip

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

# https://stackoverflow.com/questions/45699189/editing-docker-compose-yml-with-pyyaml
# ruamel.yaml is a YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order
# https://gist.github.com/shatil/0d08d889bde981a899e9ddab189909e6
pip3 install ruamel.yaml
pip3 install ruamel.dcw==0.5.0



#pip3 install --user boto3

#pip3 --version
#docker --version
#docker compose version
#docker-machine version



