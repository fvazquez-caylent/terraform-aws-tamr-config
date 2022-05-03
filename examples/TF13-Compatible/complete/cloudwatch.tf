#################################################################################################################
# This version has been patched to allow the use of terraform version 0.13.7, if you are using a newer
# version we suggest going to the next major release.
# This version is creating security groups using resource blocks instead of modules.
# Internal ticket for reference is CA-214.
#################################################################################################################

resource "aws_cloudwatch_log_group" "tamr_log_group" {
  name = format("%s-%s", var.name_prefix, "tamr_log_group")
  tags = var.tags
}

resource "local_file" "cloudwatch-install" {
  filename = "${path.module}/files/emr-cloudwatch-install.sh"
  content  = templatefile("${path.module}/files/emr-cloudwatch-install.tpl", { region = data.aws_region.current.name, endpoint = module.vpc.vpce_logs_endpoint_dnsname, log_group = aws_cloudwatch_log_group.tamr_log_group.name })
}
