variable "name_prefix" {
  type        = string
  description = "A prefix to add to the names of all created resources."
  default     = "tamr-config-test"
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR)"
  default     = []
}

variable "egress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR)"
  default     = ["0.0.0.0/0"]
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

variable "compute_subnet_id" {
  type        = string
  description = "Subnet ID for EMR cluster"
}

variable "application_subnet_id" {
  type        = string
  description = "Subnet ID for Tamr VM"
}

variable "data_subnet_ids" {
  type        = list(string)
  description = "List of at least 2 subnet IDs in different AZs"
}

variable "create_new_service_role" {
  default     = "false"
  type        = bool
  description = "Whether to create a new IAM service linked role for ES. This only needs to happen once per account. If false, linked_service_role is required"
}

variable "master_ingress_rules" {
  type        = map(map(any))
  description = "Required ports for the EMR master security group."
  default = {
    0  = { from = 8443, to = 8443, proto = "tcp" }
    1  = { from = 20888, to = 20888, proto = "tcp" }
    2  = { from = 8088, to = 8088, proto = "tcp" }
    3  = { from = 50070, to = 50070, proto = "tcp" }
    4  = { from = 16010, to = 16010, proto = "tcp" }
    5  = { from = 9090, to = 9090, proto = "tcp" }
    6  = { from = 8070, to = 8070, proto = "tcp" }
    7  = { from = 18080, to = 18080, proto = "tcp" }
    8  = { from = 80, to = 80, proto = "tcp" }
    9  = { from = 8020, to = 8020, proto = "tcp" }
    10 = { from = 16000, to = 16000, proto = "tcp" }
    11 = { from = 2181, to = 2181, proto = "tcp" }
    12 = { from = 19888, to = 19888, proto = "tcp" }
    13 = { from = 9095, to = 9095, proto = "tcp" }
    14 = { from = 8085, to = 8085, proto = "tcp" }
  }
}

variable "standard_egress_rules" {
  type        = map(map(any))
  description = "Required standard egress traffic."
  default = {
    0 = { from = 0, to = 65535, proto = "all" }

  }
}

variable "core_ingress_rules" {
  type        = map(map(any))
  description = "Required ports for the EMR core security group."
  default = {
    0 = { from = 8042, to = 8042, proto = "tcp" }
    1 = { from = 16020, to = 16020, proto = "tcp" }
    2 = { from = 50075, to = 50075, proto = "tcp" }
    3 = { from = 16030, to = 16030, proto = "tcp" }
    4 = { from = 50010, to = 50010, proto = "tcp" }
  }
}

variable "rds_ingress_rules" {
  type        = map(map(any))
  description = "Required ports for the EMR RDS security group."
  default = {
    0 = { from = 5432, to = 5432, proto = "tcp" }
  }
}

variable "es_ingress_rules" {
  type        = map(map(any))
  description = "Required ports for the ElasticSearch security group."
  default = {
    0 = { from = 80, to = 80, proto = "tcp" }
    1 = { from = 443, to = 443, proto = "tcp" }
  }
}
