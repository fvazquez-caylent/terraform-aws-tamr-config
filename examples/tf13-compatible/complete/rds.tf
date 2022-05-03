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

  vpc_id = module.vpc.vpc_id
  # Network requirement: DB subnet group needs a subnet in at least two AZs
  rds_subnet_ids = module.vpc.data_subnet_ids

  security_group_ids = [aws_security_group.rds-postgres-sg.id]
  tags               = var.tags
}

module "sg-ports-rds" {
  source = "git::git@github.com:Datatamer/terraform-aws-rds-postgres.git//modules/rds-postgres-ports?ref=3.1.0"
}

### Security group for RDS PostgreSQL database ###

resource "aws_security_group" "rds-postgres-sg" {
  name   = format("%s-%s", var.name_prefix, "-rds")
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "rds_ingress_rules" {
  for_each                 = var.rds_ingress_rules
  type                     = "ingress"
  from_port                = each.value.from
  to_port                  = each.value.to
  protocol                 = each.value.proto
  description              = format("Tamr ingress SG rule %s for port %s", each.key, each.value.from)
  source_security_group_id = module.aws-sg-vm.security_group_ids[0]
  security_group_id        = aws_security_group.rds-postgres-sg.id
}

resource "aws_security_group_rule" "rds_egress_rules" {
  for_each          = var.standard_egress_rules
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = each.value.proto
  description       = format("Tamr egress-cidr-%s", each.key)
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds-postgres-sg.id
}
