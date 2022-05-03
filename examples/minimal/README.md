This example demonstrates a terraform-generated Tamr config for a full aws-scale out environment set up for static Spark clusters. The environment consists of:
- static EMR deployment running both HBase and Spark
- data bucket and logs bucket shared by both HBase and Spark
- newly-generated EC2 key pair (used by both Tamr VM and EMR EC2 instances)
- Elasticsearch domain
- RDS Postgres instance
- Tamr VM deployment

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami\_id | AMI to use for Tamr EC2 instance | `string` | n/a | yes |
| application\_subnet\_id | Subnet ID for Tamr VM | `string` | n/a | yes |
| compute\_subnet\_id | Subnet ID for EMR cluster | `string` | n/a | yes |
| data\_subnet\_ids | List of at least 2 subnet IDs in different AZs | `list(string)` | n/a | yes |
| license\_key | Tamr license key | `string` | n/a | yes |
| vpc\_id | VPC ID of deployment | `string` | n/a | yes |
| create\_new\_service\_role | Whether to create a new IAM service linked role for ES. This only needs to happen once per account. If false, linked\_service\_role is required | `bool` | `"false"` | no |
| egress\_cidr\_blocks | List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR) | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| emr\_abac\_valid\_tags | Valid tags for maintaining resources when using ABAC IAM Policies with Tag Conditions. Make sure `emr_tags` contain the values specified here and that your Subnet is tagged as well | `map(list(string))` | `{}` | no |
| emr\_tags | Map of tags to add to EMR resources. They must contain abac\_valid\_tags at minimum | `map(string)` | `{}` | no |
| ingress\_cidr\_blocks | List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR) | `list(string)` | `[]` | no |
| name\_prefix | A prefix to add to the names of all created resources. | `string` | `"tamr-config-test"` | no |
| tags | Map of tags to add to resources. | `map(string)` | `{}` | no |

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
