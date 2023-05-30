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


  tags = var.tags
}

resource "aws_eip" "mailserver-eip" {
  instance = module.ec2_instance.id
  domain   = "vpc"
}

resource "aws_eip_association" "mailserver-association" {
  instance_id   = module.ec2_instance.id
  allocation_id = aws_eip.mailserver-eip.id
}