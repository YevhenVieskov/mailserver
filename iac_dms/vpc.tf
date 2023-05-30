
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = ["${var.region}a"]
  public_subnets  = [var.pub_a]
  private_subnets = [var.pvt_a]

  enable_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  create_igw           = true

  tags = merge(var.tags, { Name = "docker-swarm VPC" })
}






























