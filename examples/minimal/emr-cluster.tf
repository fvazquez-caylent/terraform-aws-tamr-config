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
  subnet_id                 = var.compute_subnet_id
  vpc_id                    = var.vpc_id
  emr_managed_master_sg_ids = module.aws-emr-sg-master.security_group_ids
  emr_managed_core_sg_ids   = module.aws-emr-sg-core.security_group_ids
  emr_service_access_sg_ids = module.aws-emr-sg-service-access.security_group_ids

  # External resource references
  bucket_name_for_root_directory = module.s3-data.bucket_name
  bucket_name_for_logs           = module.s3-logs.bucket_name
  additional_policy_arns = [
    module.s3-logs.rw_policy_arn,
    module.s3-data.rw_policy_arn
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

module "aws-emr-sg-master" {
  source                  = "git::git@github.com:Datatamer/terraform-aws-security-groups.git?ref=1.0.0"
  vpc_id                  = var.vpc_id
  ingress_cidr_blocks     = var.ingress_cidr_blocks
  ingress_security_groups = module.aws-sg-vm.security_group_ids
  egress_cidr_blocks      = var.egress_cidr_blocks
  ingress_ports           = module.sg-ports-emr.ingress_master_ports
  sg_name_prefix          = format("%s-%s", var.name_prefix, "emr-master")
  egress_protocol         = "all"
  ingress_protocol        = "tcp"
  tags                    = merge(var.tags, var.emr_tags)
}

module "aws-emr-sg-core" {
  source                  = "git::git@github.com:Datatamer/terraform-aws-security-groups.git?ref=1.0.0"
  vpc_id                  = var.vpc_id
  ingress_cidr_blocks     = var.ingress_cidr_blocks
  ingress_security_groups = module.aws-sg-vm.security_group_ids
  egress_cidr_blocks      = var.egress_cidr_blocks
  ingress_ports           = module.sg-ports-emr.ingress_core_ports
  sg_name_prefix          = format("%s-%s", var.name_prefix, "emr-core")
  egress_protocol         = "all"
  ingress_protocol        = "tcp"
  tags                    = merge(var.tags, var.emr_tags)
}

module "aws-emr-sg-service-access" {
  source              = "git::git@github.com:Datatamer/terraform-aws-security-groups.git?ref=1.0.0"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = var.ingress_cidr_blocks
  ingress_ports       = module.sg-ports-emr.ingress_service_access_ports
  egress_cidr_blocks  = var.egress_cidr_blocks
  sg_name_prefix      = format("%s-%s", var.name_prefix, "emr-service-access")
  egress_protocol     = "all"
  ingress_protocol    = "tcp"
  tags                = merge(var.tags, var.emr_tags)
}
