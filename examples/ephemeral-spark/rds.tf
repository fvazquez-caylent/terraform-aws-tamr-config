# Generate random password for db
resource "random_password" "rds-password" {
  length  = 16
  special = false
}

module "rds-postgres" {
  source = "git::git@github.com:Datatamer/terraform-aws-rds-postgres.git?ref=3.1.0"

  identifier_prefix = "${var.name_prefix}-"
  username          = "tamr"
  password          = random_password.rds-password.result

  subnet_group_name    = "${var.name_prefix}-subnet-group"
  postgres_name        = "tamr0"
  parameter_group_name = "${var.name_prefix}-rds-postgres-pg"

  vpc_id = var.vpc_id
  # Network requirement: DB subnet group needs a subnet in at least two AZs
  rds_subnet_ids = var.data_subnet_ids

  security_group_ids = module.rds-postgres-sg.security_group_ids
  tags               = var.tags
}

module "sg-ports-rds" {
  source = "git::git@github.com:Datatamer/terraform-aws-rds-postgres.git//modules/rds-postgres-ports?ref=3.1.0"
}

module "rds-postgres-sg" {
  source                  = "git::git@github.com:Datatamer/terraform-aws-security-groups.git?ref=1.0.0"
  vpc_id                  = var.vpc_id
  ingress_cidr_blocks     = var.ingress_cidr_blocks
  ingress_security_groups = module.aws-sg-vm.security_group_ids
  egress_cidr_blocks      = var.egress_cidr_blocks
  ingress_ports           = module.sg-ports-rds.ingress_ports
  sg_name_prefix          = var.name_prefix
  egress_protocol         = "all"
  ingress_protocol        = "tcp"
  tags                    = var.tags
}
