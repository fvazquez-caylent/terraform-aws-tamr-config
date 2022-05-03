This example demonstrates a terraform-generated Tamr config for a full aws-scale out environment set up for static Spark clusters. The environment consists of:
- static EMR deployment running both HBase and Spark
- data bucket and logs bucket shared by both HBase and Spark
- newly-generated EC2 key pair (used by both Tamr VM and EMR EC2 instances)
- Elasticsearch domain
- RDS Postgres instance
- Tamr VM deployment
- VPC with 4 subnets according to reference network architecture

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| local | n/a |
| random | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| license\_key | Tamr license key | `string` | n/a | yes |
| ami\_id | AMI to use for Tamr EC2 instance | `string` | `""` | no |
| application\_subnet\_cidr\_block | CIDR Block for the application subnet | `string` | `"10.0.0.0/24"` | no |
| availability\_zones | The list of availability zones where we should deploy resources. Must be exactly 2 | `list(string)` | `[]` | no |
| compute\_subnet\_cidr\_block | CIDR Block for the compute subnet | `string` | `"10.0.1.0/24"` | no |
| create\_new\_service\_role | Whether to create a new IAM service linked role for ES. This only needs to happen once per account. If false, linked\_service\_role is required | `bool` | `"false"` | no |
| data\_subnet\_cidr\_blocks | List of CIDR blocks for the data subnets | `list(string)` | <pre>[<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| egress\_cidr\_blocks | List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR) | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| emr\_abac\_valid\_tags | Valid tags for maintaining resources when using ABAC IAM Policies with Tag Conditions. Make sure `emr_tags` contain the values specified here and that your Subnet is tagged as well | `map(list(string))` | `{}` | no |
| emr\_tags | Map of tags to add to EMR resources. They must contain abac\_valid\_tags at minimum | `map(string)` | `{}` | no |
| ingress\_cidr\_blocks | List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR) | `list(string)` | `[]` | no |
| load\_balancing\_subnets\_cidr\_blocks | CIDR Block for the load balancing subnets | `list(string)` | <pre>[<br>  "10.0.4.0/24",<br>  "10.0.5.0/24"<br>]</pre> | no |
| name\_prefix | A prefix to add to the names of all created resources. | `string` | `"tamr-config-complete-test"` | no |
| public\_subnets\_cidr\_blocks | CIDR Block for the public subnets | `list(string)` | <pre>[<br>  "10.0.6.0/24",<br>  "10.0.7.0/24"<br>]</pre> | no |
| tags | Map of tags to add to resources. | `map(string)` | `{}` | no |
| vpc\_cidr\_block | CIDR Block for the VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| ec2-key | n/a |
| elasticsearch | n/a |
| emr | n/a |
| private-key | n/a |
| rds-postgres | n/a |
| rds-pw | n/a |
| tamr-config | n/a |
| tamr-vm | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
