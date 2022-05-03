variable "name_prefix" {
  type        = string
  description = "A prefix to add to the names of all created resources."
  default     = "tamr-config-ephemeral"
}

variable "path_to_spark_logs" {
  type        = string
  description = "Path in logs bucket to store spark logs. E.g. tamr/spark-logs"
  default     = ""
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR)"
  default     = []
}

variable "ami_id" {
  type        = string
  description = "AMI to use for Tamr EC2 instance"
}

variable "license_key" {
  type        = string
  description = "Tamr license key"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID of deployment"
}

variable "application_subnet_id" {
  type        = string
  description = "Subnet ID for Tamr VM"
}

variable "compute_subnet_id" {
  type        = string
  description = "Subnet ID for EMR cluster"
}

variable "data_subnet_ids" {
  type        = list(string)
  description = "List of at least 2 subnet IDs in different AZs"
}

variable "egress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR)"
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to add to resources."
  default     = {}
}

variable "emr_tags" {
  type        = map(string)
  description = "Map of tags to add to EMR resources. They must contain abac_valid_tags at minimum"
  default     = {}
}

variable "emr_abac_valid_tags" {
  type        = map(list(string))
  description = "Valid tags for maintaining resources when using ABAC IAM Policies with Tag Conditions. Make sure `emr_tags` contain the values specified here and that your Subnet is tagged as well"
  default     = {}
}

variable "create_new_service_role" {
  default     = "false"
  type        = bool
  description = "Whether to create a new IAM service linked role for ES. This only needs to happen once per account. If false, linked_service_role is required"
}
