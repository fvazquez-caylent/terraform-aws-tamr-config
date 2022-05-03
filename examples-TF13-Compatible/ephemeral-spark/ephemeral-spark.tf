#################################################################################################################
# This version has been patched to allow the use of terraform version 0.13.7, if you are using a newer
# version we suggest going to the next major release.
# This version is creating security groups using resource blocks instead of modules.
# Internal ticket for reference is CA-214.
#################################################################################################################

# Ephemeral Spark cluster
module "ephemeral-spark-sgs" {
  source                    = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-sgs?ref=7.3.1"
  vpc_id                    = var.vpc_id
  emr_managed_sg_name       = format("%s-%s", var.name_prefix, "Ephem-Spark-Internal")
  emr_service_access_sg_ids = [aws_security_group.aws-emr-sg-service-access.id]
  tags                      = merge(var.tags, var.emr_tags)
}

module "ephemeral-spark-iam" {
  source                            = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-iam?ref=7.3.1"
  s3_bucket_name_for_logs           = module.s3-logs.bucket_name
  s3_bucket_name_for_root_directory = module.s3-data.bucket_name
  additional_policy_arns = [
    module.s3-logs.rw_policy_arn,
    module.s3-data.rw_policy_arn
  ]
  vpc_id                        = var.vpc_id
  emr_ec2_iam_policy_name       = "${var.name_prefix}-spark-ec2-policy"
  emr_service_iam_policy_name   = "${var.name_prefix}-spark-service-policy"
  emr_service_role_name         = "${var.name_prefix}-spark-service-role"
  emr_ec2_instance_profile_name = "${var.name_prefix}-spark-emr-instance-profile"
  emr_ec2_role_name             = "${var.name_prefix}-spark-ec2-role"
  tags                          = var.tags
}

module "ephemeral-spark-config" {
  source                         = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-config?ref=7.3.1"
  create_static_cluster          = false
  cluster_name                   = "" # unused
  emr_config_file_path           = "${path.module}/emr.json"
  bucket_name_for_root_directory = module.s3-data.bucket_name
}
