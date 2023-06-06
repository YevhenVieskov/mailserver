#!bin/bash
#set -e # Exit on first error
set -x # Print expanded commands to stdout
#https://github.com/docker-mailserver/docker-mailserver


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

#clone repo
mkdir -p $folder/mailserver
git clone https://github.com/YevhenVieskov/mailserver.git  $folder/mailserver     #not clone
#cd /home/ubuntu/mailserver/ansible

# get secret
#cd ~/mailserver/ansible
aws secretsmanager get-secret-value --secret-id secret-ansible-1  --query SecretString --output text > "${folder}/mailserver/ansible/password_file"

#decrypt playbook
ansible-vault decrypt --vault-password-file ${folder}/mailserver/ansible/password_file ${folder}/mailserver/ansible/docker_mailserver.yml

#install pip3, dependencies and docker-mailserver
ansible-galaxy install hmlkao.docker_mailserver  #not install
#pip3 install ansible-vault pip3  not installed yet

#run playbook to times !!!!
#fatal: [localhost]: FAILED! => {"msg": "The conditional check 'cert_generated.changed 
#and not cert_was_generated.stats.exists' failed. The error was: error while evaluating
#conditional (cert_generated.changed and not cert_was_generated.stats.exists): 'dict object' 
#has no attribute 'stats'. 
#second run skip failed task and run docker-mailserver

chgrp -R ubuntu:ubuntu ${folder}/mailserver

ansible-playbook -u ubuntu ${folder}/mailserver/ansible/docker_mailserver.yml
ansible-playbook -u ubuntu  ${folder}/mailserver/ansible/docker_mailserver.yml

mail_persist_folder="/opt/mail"
dkim_file="${mail_persist_folder}/config/opendkim/keys/mail.vieskov.com/mail.txt"


#https://unix.stackexchange.com/questions/734805/regex-to-extract-dkim-record-from-file
DKIM=$(grep -oP '".*?"' /opt/mail/config/opendkim/keys/mail.vieskov.com/mail.txt | tr -d '\n' | sed 's/" *"//g')
keyd=${DKIM##*p=}
len="${#keyd}"
let lenm1=len-1
key=${keyd:0:$lenm1}
key1=${key:0:${#key}/2}
key2=${key:${#key}/2}
DKIM_SPLIT="\"v=DKIM1; h=sha256; k=rsa; p=${key1}\" \"${key2}\""

#create DKIM record in route53
hosted_zone=$(aws route53 list-hosted-zones-by-name --dns-name example.com --query "HostedZones[].Id" --output text)
hz_id=${hosted_zone##*/}
hz_id="${hz_id%\"}"
hz_id="${hz_id#\"}"
aws route53 list-resource-record-sets --hosted-zone-id $hz_id        


# https://stackoverflow.com/questions/49228500/creating-route53-record-sets-via-shell-script
#aws route53 change-resource-record-sets \
#  --hosted-zone-id $hz_id \
#  --change-batch '
#  {
#    "Comment": "Testing creating a record set",
#   "Changes": [{
#      "Action"              : "CREATE",
#      "ResourceRecordSet"  : {
#        "Name"              : "_domainkey",
#        "Type"             : "TXT",
#        "TTL"              : 300,
#        "ResourceRecords"  : [{
#            "Value"         : "'"$DKIM_SPLIT"'"
#        }]
#      }
#    }]
#  }
#  '

  cat << EOF > dkim.json
{
    "Comment": "Testing creating a record set",
   "Changes": [{
      "Action"              : "CREATE",
      "ResourceRecordSet"  : {
        "Name"              : "_domainkey",
        "Type"             : "TXT",
        "TTL"              : 300,
        "ResourceRecords"  : [{
            "Value"         : ${DKIM_SPLIT}
        }]
      }
    }]
  }
EOF

aws route53 change-resource-record-sets \
  --hosted-zone-id $hz_id \
  --change-batch file://dkim.json

--change-batch file://dkim.json

groupadd docker || true 
usermod -aG docker $USER  || true 
newgrp docker




#{
#            "Name": "_domainkey.mail.vieskov.com.",
#            "Type": "TXT",
#            "TTL": 300,
#            "ResourceRecords": [
#                {
#                    "Value": "\"v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAt8O2tYOlDBFvxLTpzjynQ/kV6rzIEvTqPLO8Sgz9K5NIjeHEWsyGVbh6pZH0v9J7SGzxNQdowACp0JdFEfc7vWCNkJZ9KQMR66NJsZNsoL4msBAiwv+dgz3Dn0uM2RGhgKR6L5kiWdK3VDv7uHJIeJiZ\" \"4JEj8MRmEvmj10FShnuKo33TAWLKUrF2Qb/IgOtzRYgRvpRsDa2C3S6A8lDAOgsqqaldWGH38AFectDl8P6CyTJENMjLMBC0R5Y8qAUs0dNJ2bEq3n7VypkV0NCu0sNhmMrWVW3kcn1tymXiGTyjXzMd8AnrA69X7t/BqNXOLor0Jkdic8OB4BnDAHhOBQIDAQAB\""
#                }
#            ]
#        }



#DKIM_SPLIT="\"v=DKIM1; h=sha256; k=rsa; p=${key1}\" \"${key2}\""
