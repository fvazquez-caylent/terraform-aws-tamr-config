variable "name_prefix" {
  type        = string
  description = "A prefix to add to the names of all created resources."
  default     = "tamr-config-complete-test"
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR)"
  default     = []
}

variable "availability_zones" {
  type        = list(string)
  description = "The list of availability zones where we should deploy resources. Must be exactly 2"
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
  default     = ""
}

variable "license_key" {
  type        = string
  description = "Tamr license key"
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

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR Block for the VPC"
  default     = "10.0.0.0/16"
}

variable "data_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for the data subnets"
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "application_subnet_cidr_block" {
  type        = string
  description = "CIDR Block for the application subnet"
  default     = "10.0.0.0/24"
}

variable "compute_subnet_cidr_block" {
  type        = string
  description = "CIDR Block for the compute subnet"
  default     = "10.0.1.0/24"
}

variable "load_balancing_subnets_cidr_blocks" {
  type        = list(string)
  description = "CIDR Block for the load balancing subnets"
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "public_subnets_cidr_blocks" {
  type        = list(string)
  description = "CIDR Block for the public subnets"
  default     = ["10.0.6.0/24", "10.0.7.0/24"]
}

variable "create_new_service_role" {
  default     = "false"
  type        = bool
  description = "Whether to create a new IAM service linked role for ES. This only needs to happen once per account. If false, linked_service_role is required"
}
