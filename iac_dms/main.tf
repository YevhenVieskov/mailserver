# https://github.com/docker-mailserver/docker-mailserver
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = "mailserver"
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.private_key_name
  vpc_security_group_ids      = [module.mailserversg.security_group_id]
  availability_zone           = "${var.region}a"
  subnet_id                   = element(module.vpc.public_subnets, 0)
  associate_public_ip_address = true
  user_data                   = file("${path.module}/${var.udata_file}")
  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    ec2_sm      = module.iam_policy_sm.arn
    ec2_route53 = module.iam_policy_route53.arn
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
    secret-ansible-1 = {
      description             = "ansible vault password"
      recovery_window_in_days = 0
      secret_string           = var.ans_vault_pass
    },
  }

  tags = var.tags
}


module "iam_policy_sm" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "ec2_sm"
  path        = "/"
  description = "Secret manager access from EC2 policy"

  policy = templatefile("${path.module}/secret_manager_policy.tpl", { region = var.region, id = var.aws_user_id })

  tags = var.tags

}

module "iam_policy_route53" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "ec2_route53"
  path        = "/"
  description = "route53 change record policy"

  policy = templatefile("${path.module}/route53_change_record_txt.tpl", {})

  tags = var.tags

}