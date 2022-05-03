#################################################################################################################
# This version has been patched to allow the use of terraform version 0.13.7, if you are using a newer
# version we suggest going to the next major release.
# This version is creating security groups using resource blocks instead of modules.
# Internal ticket for reference is CA-214.
#################################################################################################################

module "tamr-es-cluster" {
  source = "git::git@github.com:Datatamer/terraform-aws-es?ref=3.1.0"

  # Names
  domain_name = "${var.name_prefix}-es"
  sg_name     = "${var.name_prefix}-es-security-group"

  # In-transit encryption options
  node_to_node_encryption_enabled = true
  enforce_https                   = true

  # Networking
  vpc_id             = var.vpc_id
  subnet_ids         = [var.data_subnet_ids[0]]
  security_group_ids = [aws_security_group.aws-es.id]
  # CIDR blocks to allow ingress from (i.e. VPN)
  ingress_cidr_blocks = var.ingress_cidr_blocks
  aws_region          = data.aws_region.current.name
}

data "aws_region" "current" {}

# Security Groups
module "sg-ports-es" {
  source = "git::git@github.com:Datatamer/terraform-aws-es.git//modules/es-ports?ref=3.1.0"
}

data "aws_subnet" "application_subnet" {
  id = var.application_subnet_id
}

## Security group and rules for ES ###

resource "aws_security_group" "aws-es" {
  name        = format("%s-%s", var.name_prefix, "es")
  description = "ES security group for Tamr (CIDR)"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "es_ingress_rules_app_source" {
  for_each                 = var.es_ingress_rules
  type                     = "ingress"
  from_port                = each.value.from
  to_port                  = each.value.to
  protocol                 = each.value.proto
  description              = format("Tamr egress SG rule %s for port %s", each.key, each.value.from)
  source_security_group_id = module.aws-sg-vm.security_group_ids[0]
  security_group_id        = aws_security_group.aws-es.id
}

resource "aws_security_group_rule" "es_ingress_rules_spark_source" {
  for_each                 = var.es_ingress_rules
  type                     = "ingress"
  from_port                = each.value.from
  to_port                  = each.value.to
  protocol                 = each.value.proto
  description              = format("Tamr egress SG rule %s for port %s", each.key, each.value.from)
  source_security_group_id = module.ephemeral-spark-sgs.emr_managed_sg_id
  security_group_id        = aws_security_group.aws-es.id
}

resource "aws_security_group_rule" "es_egress_rules" {
  for_each          = var.standard_egress_rules
  type              = "egress"
  from_port         = each.value.from
  to_port           = each.value.to
  protocol          = each.value.proto
  description       = format("Tamr egress CIDR rule %s", each.key)
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws-es.id
}

# Only needed once per account, set `create_new_service_role` variable to true if first time running in account
resource "aws_iam_service_linked_role" "es" {
  count            = var.create_new_service_role == true ? 1 : 0
  aws_service_name = "es.amazonaws.com"
}
