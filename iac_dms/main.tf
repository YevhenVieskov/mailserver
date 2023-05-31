# https://github.com/docker-mailserver/docker-mailserver
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "mailserver"

  instance_type               = var.instance_type
  key_name                    = var.private_key_name
  vpc_security_group_ids      = [module.mailserversg.security_group_id]
  availability_zone           = "${var.region}a"
  subnet_id                   = element(module.vpc.public_subnets, 0)
  associate_public_ip_address = true
  user_data                   = file(var.udata_path)
  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }


  tags = var.tags

    depends_on = [module.secrets_manager_ansible.secret_arns]
}

resource "aws_eip" "mailserver-eip" {
  instance = module.ec2_instance.id
  domain   = "vpc"
}

resource "aws_eip_association" "mailserver-association" {
  instance_id   = module.ec2_instance.id
  allocation_id = aws_eip.mailserver-eip.id
}

module "secrets_manager_ansible" {

  source = "lgallard/secrets-manager/aws"

  secrets = {
    secret-ansible = {
      description             = "ansible vault password"
      recovery_window_in_days = 7
      secret_string           = var.secret_string
    },
    
  }

  tags = var.tags
}


module "iam_policy_sm" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "example"
  path        = "/"
  description = "Secret manager policy"
  
  policy = templatefile("./secret_manager_policy.tpl", { region = var.region, id = var.aws_user_id})
 
tags = var.tags

}

module "iam_policy_route53" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "example"
  path        = "/"
  description = "route53 policy"
  
  policy = templatefile("./route53_change_record_txt.tpl")
 
tags = var.tags

}