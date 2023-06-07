module "mailserversg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "mailserver-sg"
  description = "Security group that allows traffic between docker swarm nodes"
  vpc_id      = module.vpc.vpc_id


  ingress_with_cidr_blocks = [

    {
      rule        = "http-80-tcp"
      description = "http"
      cidr_blocks = "0.0.0.0/0" #module.vpc.vpc_cidr_block
    },

    {
      rule        = "https-443-tcp"
      description = "https"
      cidr_blocks = "0.0.0.0/0"
    },

    {
      rule        = "ssh-tcp"
      description = "ssh"
      cidr_blocks = "0.0.0.0/0"
    },

    {
      rule        = "all-icmp"
      description = "icmp"
      cidr_blocks = module.vpc.vpc_cidr_block
    },

    {
      from_port   = 25
      to_port     = 25
      description = "smtp"
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },

    {
      from_port   = 143
      to_port     = 143
      description = "imap4"
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },

    {
      from_port   = 465
      to_port     = 465
      description = "esmtp"
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },

    {
      from_port   = 587
      to_port     = 587
      description = "esmtp"
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },

    {
      from_port   = 993
      to_port     = 993
      description = "imap4"
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },


  ]

  egress_rules = ["all-all"]

  tags = merge(var.tags, { Name = "mailserver security group" })

}








