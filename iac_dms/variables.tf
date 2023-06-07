
#variables
variable "profile" {
  description = "AWS Profile"
  type        = string
  default     = "vieskovtf"
}

variable "region" {
  description = "Region for AWS resources"
  type        = string
  default     = "us-west-2"
}

variable "tags" {
  description = "Tags to apply to all the resources"
  type        = map(any)

  default = {
    Terraform   = "true"
    Environment = "mailserver"
  }
}



#################
# VPC
#################


variable "vpc_name" {
  description = "Name to be used for the Jenkins master instance"
  type        = string
  default     = "vpc-mailserver"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}



variable "pub_a" {
  description = "subnet"
  type        = string
  default     = "10.0.1.0/24"
}


variable "pub_b" {
  description = "subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "pvt_a" {
  description = "subnet"
  type        = string
  default     = "10.0.101.0/24"
}

variable "pvt_b" {
  description = "subnet"
  type        = string
  default     = "10.0.102.0/24"
}


#################
# EC2
#################

variable "instance_type" {
  description = "Instance Type to use for docker mailserver"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Instance name to use for docker mailserver"
  type        = string
  default     = "docker-mail-server"
}

variable "ami" {
  description = "Instance AMI"
  type        = string
  default     = "ami-03f65b8614a860c29"
}

variable "private_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
  type        = string
  default     = "key"
}

variable "udata_file" {
  description = "Name to be used for the Jenkins master instance"
  type        = string
  default     = "bootstrapdms.sh"
}

variable "private_key_path" {
  description = "The path to an EC2 Key Pair"
  type        = string
  default     = "~/key.pem"
}

###############################################################


#################
# Route 53
#################

variable "domain_name" {
  description = "domain_name"
  type        = string
  default     = "example.com"
}

variable "main_zone_name" {
  description = "Route 53 zone name"
  type        = string
  default     = "example.com"
}

variable "mail_zone_name" {
  description = "Route 53 zone name"
  type        = string
  default     = "mail.example.com"
}

variable "record_mx" {
  description = "Route 53 zone name"
  type        = string
  default     = "1 mail.example.com"
}

variable "record_dkim" {
  description = "Route 53 zone name"
  type        = string
  default     = "v=DKIM1; k=rsa; p=ABC123longkeypart1\"\"ABC123longkeypart2"
}


variable "record_spf" {
  description = "Route 53 zone name"
  type        = string
  default     = "v=spf1 a mx ~all"
}

variable "record_dmark" {
  description = "Route 53 zone name"
  type        = string
  default     = "v=DMARC1; p=quarantine; pct=100; rua=mailto:abuse+rua@example.com; ruf=mailto:abuse+ruf@example.com; fo=1"
}

variable "create_certificate" {
  description = "Create ACM certificate"
  type        = bool
  default     = false
}

variable "wait_for_validation" {
  description = "Validation ACM certificate"
  type        = bool
  default     = false
}


/*variable "public_zone_id" {
  description = "public zone id"
  type        = string
  default     = "Z1WA3EVJBXSQ2V"
}

variable "private_zone_id" {
  description = "Instance Type to use for Jenkins master"
  type        = string
  default     = "Z3CVA9QD5NHSW3"
}*/


variable "ssl_certificate_id" {
  description = "Certificate for load balancer"
  type        = string
  default     = "arn:aws:acm:us-east-2:052776272001:certificate/5f64bc59-ee3e-4202-86e0-0edbb6f0afe7"
}


#################
# Ansible secret
#################
variable "ans_vault_pass" {
  description = "Ansyble vault password "
  type        = string
}

#################
# IAM Roles
#################

variable "trusted_role_arns_root" {
  description = "Trusted role arns for root"
  type        = string
  default     = "arn:aws:iam::012345678911:root"
}

variable "trusted_role_arns_user" {
  description = "Trusted role arns for user"
  type        = string
  default     = "arn:aws:iam::012345678911:user"
}

variable "aws_user_id" {
  description = "Trusted role arns for user"
  type        = string
  default     = "012345678911"
}


variable "mailserver2" {
  description = "Conditional variable for mailserver2"
  type        = bool
  default     = false
}









