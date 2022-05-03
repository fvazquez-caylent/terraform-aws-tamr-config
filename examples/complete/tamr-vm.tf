locals {
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ami.tamr-vm.id
}

data "aws_ami" "tamr-vm" {
  most_recent = true
  owners      = ["679593333241"]
  name_regex  = "ami-0747bdcabd34c712a-with-tamr-v20210100-20gb-1640221699-no-license-8892620f-9ecf-4370-b0a8-0c23b1d477d1"
  filter {
    name   = "product-code"
    values = ["832nkbrayw00cnivlh6nbbi6p"]
  }
}

module "tamr-vm" {
  source = "git::git@github.com:Datatamer/terraform-emr-tamr-vm?ref=4.4.0"

  ami                         = local.ami_id
  instance_type               = "r5.2xlarge"
  key_name                    = module.emr_key_pair.key_pair_key_name
  subnet_id                   = module.vpc.application_subnet_id
  vpc_id                      = module.vpc.vpc_id
  security_group_ids          = module.aws-sg-vm.security_group_ids
  availability_zone           = data.aws_subnet.application_subnet.availability_zone
  aws_role_name               = "${var.name_prefix}-tamr-ec2-role"
  aws_instance_profile_name   = "${var.name_prefix}-tamrvm-instance-profile"
  aws_emr_creator_policy_name = "${var.name_prefix}-emr-creator-policy"
  additional_policy_arns = [
    module.s3-logs.rw_policy_arn,
    module.s3-data.rw_policy_arn,
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
  bootstrap_scripts = [

    # NOTE: If you would like to use local scripts, you can use terraform's file() function
    templatefile("${path.module}/files/tamrvm-cloudwatch-install.sh", { region = data.aws_region.current.name, endpoint = module.vpc.vpce_logs_endpoint_dnsname, log_group = aws_cloudwatch_log_group.tamr_log_group.name }),
  ]
  tamr_emr_cluster_ids = [module.emr.tamr_emr_cluster_id]
  tamr_emr_role_arns = [
    module.emr.emr_service_role_arn,
    module.emr.emr_ec2_role_arn
  ]
  emr_abac_valid_tags = var.emr_abac_valid_tags
}

module "aws-vm-sg-ports" {
  source = "git::git@github.com:Datatamer/terraform-aws-tamr-vm.git//modules/aws-security-groups?ref=4.4.0"
}

module "aws-sg-vm" {
  source              = "git::git@github.com:Datatamer/terraform-aws-security-groups.git?ref=1.0.0"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = var.ingress_cidr_blocks
  egress_cidr_blocks = [
    "0.0.0.0/0" # TODO: scope down
  ]
  ingress_protocol = "tcp"
  egress_protocol  = "all"
  ingress_ports    = concat(module.aws-vm-sg-ports.ingress_ports, module.sg-ports-es.ingress_ports)
  sg_name_prefix   = format("%s-%s", var.name_prefix, "tamr-vm")
  tags             = var.tags
}
