output "tamr-vm" {
  value = module.tamr-vm
}

output "rds-postgres" {
  value = module.rds-postgres
}

output "rds-pw" {
  value     = random_password.rds-password
  sensitive = true
}

output "elasticsearch" {
  value = module.tamr-es-cluster
}

output "ec2-key" {
  value = module.emr_key_pair
}

output "private-key" {
  value     = tls_private_key.emr_private_key.private_key_pem
  sensitive = true
}

output "emr-hbase" {
  value = module.emr-hbase
}

output "ephemeral-spark-iam" {
  value = module.ephemeral-spark-iam
}

output "ephemeral-spark-sgs" {
  value = module.ephemeral-spark-sgs
}

output "ephemeral-spark-config" {
  value = module.ephemeral-spark-config
}

output "tamr-config" {
  value     = module.tamr-config.rendered
  sensitive = true
}
