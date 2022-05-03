module "tamr-es-cluster" {
  source = "git::git@github.com:Datatamer/terraform-aws-es?ref=3.1.0"

  # Names
  domain_name = "${var.name_prefix}-es"
  sg_name     = "${var.name_prefix}-es-security-group"

  # In-transit encryption options
  node_to_node_encryption_enabled = true
  enforce_https                   = true

  # Networking
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = [data.aws_subnet.data_subnet_es.id]
  security_group_ids = [aws_security_group.aws-es.id]
  # CIDR blocks to allow ingress from (i.e. VPN)
  ingress_cidr_blocks = var.ingress_cidr_blocks
  aws_region          = data.aws_region.current.name
}

# Security Groups
module "sg-ports-es" {
  source = "git::git@github.com:Datatamer/terraform-aws-es.git//modules/es-ports?ref=3.1.0"
}

## Security group and rules for ES ###

resource "aws_security_group" "aws-es" {
  name        = format("%s-%s", var.name_prefix, "es")
  description = "ES security group for Tamr (CIDR)"
  vpc_id      = module.vpc.vpc_id
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

resource "aws_security_group_rule" "es_ingress_rules_emr_source" {
  for_each                 = var.es_ingress_rules
  type                     = "ingress"
  from_port                = each.value.from
  to_port                  = each.value.to
  protocol                 = each.value.proto
  description              = format("Tamr egress SG rule %s for port %s", each.key, each.value.from)
  source_security_group_id = module.emr.emr_managed_sg_id
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

data "aws_subnet" "application_subnet" {
  id = module.vpc.application_subnet_id
}

data "aws_subnet" "data_subnet_es" {
  filter {
    name   = "availability-zone"
    values = [data.aws_subnet.application_subnet.availability_zone]
  }
  filter {
    name   = "subnet-id"
    values = toset(module.vpc.data_subnet_ids)
  }
}

# Only needed once per account, set `create_new_service_role` variable to true if first time running in account
resource "aws_iam_service_linked_role" "es" {
  count            = var.create_new_service_role == true ? 1 : 0
  aws_service_name = "es.amazonaws.com"
}
