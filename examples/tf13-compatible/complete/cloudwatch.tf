resource "aws_cloudwatch_log_group" "tamr_log_group" {
  name = format("%s-%s", var.name_prefix, "tamr_log_group")
  tags = var.tags
}

resource "local_file" "cloudwatch-install" {
  filename = "${path.module}/files/emr-cloudwatch-install.sh"
  content  = templatefile("${path.module}/files/emr-cloudwatch-install.tpl", { region = data.aws_region.current.name, endpoint = module.vpc.vpce_logs_endpoint_dnsname, log_group = aws_cloudwatch_log_group.tamr_log_group.name })
}
