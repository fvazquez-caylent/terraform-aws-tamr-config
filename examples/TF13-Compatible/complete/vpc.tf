locals {
  azs = length(var.availability_zones) > 0 ? var.availability_zones : slice(data.aws_availability_zones.available.names, 0, 2)
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Get current Region
data "aws_region" "current" {}

module "vpc" {
  source             = "git::https://github.com/Datatamer/terraform-aws-networking.git?ref=1.1.1"
  availability_zones = local.azs
  name_prefix        = var.name_prefix
  tags               = merge(var.tags, var.emr_tags)
  # Cidr Blocks
  vpc_cidr_block                     = var.vpc_cidr_block
  ingress_cidr_blocks                = var.ingress_cidr_blocks
  application_subnet_cidr_block      = var.application_subnet_cidr_block
  data_subnet_cidr_blocks            = var.data_subnet_cidr_blocks
  compute_subnet_cidr_block          = var.compute_subnet_cidr_block
  load_balancing_subnets_cidr_blocks = var.load_balancing_subnets_cidr_blocks
  public_subnets_cidr_blocks         = var.public_subnets_cidr_blocks
  # Create subnets flag
  create_public_subnets         = true
  enable_nat_gateway            = false
  create_load_balancing_subnets = true
  # Allowed security group for accepting ingress traffic to the EMR Interface Endpoint
  interface_endpoint_ingress_sg = module.aws-sg-vm.security_group_ids[0]
}
