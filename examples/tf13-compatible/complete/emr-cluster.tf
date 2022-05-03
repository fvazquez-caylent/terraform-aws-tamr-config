locals {
  applications = ["Spark", "Hbase", "Ganglia"]
}

# EMR Static HBase,Spark cluster
module "emr" {
  source = "git@github.com:Datatamer/terraform-aws-emr.git?ref=7.3.1"

  # Configurations
  create_static_cluster = true
  release_label         = "emr-5.29.0" # spark 2.4.4, hbase 1.4.10
  applications          = local.applications
  emr_config_file_path  = "${path.module}/emr.json"
  bucket_path_to_logs   = "logs/${var.name_prefix}-cluster/"
  tags                  = merge(var.tags, var.emr_tags)
  abac_valid_tags       = var.emr_abac_valid_tags

  # Networking
  subnet_id                 = module.vpc.compute_subnet_id
  vpc_id                    = module.vpc.vpc_id
  emr_managed_master_sg_ids = [aws_security_group.aws-emr-sg-master.id]
  emr_managed_core_sg_ids   = [aws_security_group.aws-emr-sg-core.id]
  emr_service_access_sg_ids = [aws_security_group.aws-emr-sg-service-access.id]

  # External resource references
  bucket_name_for_root_directory = module.s3-data.bucket_name
  bucket_name_for_logs           = module.s3-logs.bucket_name
  additional_policy_arns = [
    module.s3-logs.rw_policy_arn,
    module.s3-data.rw_policy_arn,
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
  bootstrap_actions = [
    {
      name = "cw_agent_install",
      path = "s3://${module.s3-data.bucket_name}/${aws_s3_bucket_object.sample_bootstrap_script.id}"
      args = []
    }
  ]
  key_pair_name = module.emr_key_pair.key_pair_key_name

  # Names
  cluster_name                  = "${var.name_prefix}-EMR-Cluster"
  emr_service_role_name         = "${var.name_prefix}-service-role"
  emr_ec2_role_name             = "${var.name_prefix}-ec2-role"
  emr_ec2_instance_profile_name = "${var.name_prefix}-emr-instance-profile"
  emr_service_iam_policy_name   = "${var.name_prefix}-service-policy"
  emr_ec2_iam_policy_name       = "${var.name_prefix}-ec2-policy"
  master_instance_fleet_name    = "${var.name_prefix}-MasterInstanceFleet"
  core_instance_fleet_name      = "${var.name_prefix}-CoreInstanceFleet"
  emr_managed_sg_name           = "${var.name_prefix}-EMR-Managed"
  emr_service_access_sg_name    = "${var.name_prefix}-EMR-Service-Access"

  # Scale
  master_instance_on_demand_count = 1
  core_instance_on_demand_count   = 4
  master_instance_type            = "m4.2xlarge"
  core_instance_type              = "r5.2xlarge"
  master_ebs_size                 = 50
  core_ebs_size                   = 200
}

module "sg-ports-emr" {
  source = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-ports?ref=7.3.1"

  applications = local.applications
}

### Security group for Master EMR Master node ###

resource "aws_security_group" "aws-emr-sg-master" {
  name        = format("%s-%s", var.name_prefix, "emr-master")
  description = "EMR Master security group for Tamr (CIDR)"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "master_ingress_rules" {
  for_each                 = var.master_ingress_rules
  type                     = "ingress"
  from_port                = each.value.from
  to_port                  = each.value.to
  protocol                 = each.value.proto
  description              = format("Tamr ingress SG rule %s for port %s", each.key, each.value.from)
  source_security_group_id = module.aws-sg-vm.security_group_ids[0]
  security_group_id        = aws_security_group.aws-emr-sg-master.id
}

resource "aws_security_group_rule" "master_egress_rules" {
  for_each          = var.standard_egress_rules
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = each.value.proto
  description       = format("Tamr egress CIDR rule %s", each.key)
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws-emr-sg-master.id
}

### Security group and rules for EMR Core nodes ###

resource "aws_security_group" "aws-emr-sg-core" {
  name        = format("%s-%s", var.name_prefix, "emr-core")
  description = "EMR Core security group for Tamr (CIDR)"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "core_ingress_rules" {
  for_each                 = var.core_ingress_rules
  type                     = "ingress"
  from_port                = each.value.from
  to_port                  = each.value.to
  protocol                 = each.value.proto
  description              = format("Tamr ingress SG rule %s for port %s", each.key, each.value.from)
  source_security_group_id = module.aws-sg-vm.security_group_ids[0]
  security_group_id        = aws_security_group.aws-emr-sg-core.id
}

resource "aws_security_group_rule" "core_egress_rules" {
  for_each          = var.standard_egress_rules
  type              = "egress"
  from_port         = each.value.from
  to_port           = each.value.to
  protocol          = each.value.proto
  description       = format("Tamr egress CIDR rule %s", each.key)
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws-emr-sg-core.id
}

### Security group and rules for EMR service access ###

resource "aws_security_group" "aws-emr-sg-service-access" {
  name        = format("%s-%s", var.name_prefix, "emr-service-access")
  description = "EMR Service Access security group for Tamr (CIDR)"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "service_access_egress_rules" {
  for_each          = var.standard_egress_rules
  type              = "egress"
  from_port         = each.value.from
  to_port           = each.value.to
  protocol          = each.value.proto
  description       = format("Tamr egress CIDR rule %s", each.key)
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws-emr-sg-service-access.id
}
