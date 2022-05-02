#################################################################################################################
# This version has been patched to allow the use of terraform version 0.13.7, if you are using a newer
# version we suggest going to the next major release.
# This version is creating security groups using resource blocks instead of modules.
# Internal ticket for reference is CA-214.
#################################################################################################################

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
| core\_ingress\_rules | Required ports for the EMR core security group. | `map(map(any))` | <pre>{<br>  "0": {<br>    "from": 8042,<br>    "proto": "tcp",<br>    "to": 8042<br>  },<br>  "1": {<br>    "from": 16020,<br>    "proto": "tcp",<br>    "to": 16020<br>  },<br>  "2": {<br>    "from": 50075,<br>    "proto": "tcp",<br>    "to": 50075<br>  },<br>  "3": {<br>    "from": 16030,<br>    "proto": "tcp",<br>    "to": 16030<br>  },<br>  "4": {<br>    "from": 50010,<br>    "proto": "tcp",<br>    "to": 50010<br>  }<br>}</pre> | no |
| create\_new\_service\_role | Whether to create a new IAM service linked role for ES. This only needs to happen once per account. If false, linked\_service\_role is required | `bool` | `"false"` | no |
| data\_subnet\_cidr\_blocks | List of CIDR blocks for the data subnets | `list(string)` | <pre>[<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| egress\_cidr\_blocks | List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR) | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| emr\_abac\_valid\_tags | Valid tags for maintaining resources when using ABAC IAM Policies with Tag Conditions. Make sure `emr_tags` contain the values specified here and that your Subnet is tagged as well | `map(list(string))` | `{}` | no |
| emr\_tags | Map of tags to add to EMR resources. They must contain abac\_valid\_tags at minimum | `map(string)` | `{}` | no |
| es\_ingress\_rules | Required ports for the ElasticSearch security group. | `map(map(any))` | <pre>{<br>  "0": {<br>    "from": 80,<br>    "proto": "tcp",<br>    "to": 80<br>  },<br>  "1": {<br>    "from": 443,<br>    "proto": "tcp",<br>    "to": 443<br>  }<br>}</pre> | no |
| ingress\_cidr\_blocks | List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR) | `list(string)` | `[]` | no |
| load\_balancing\_subnets\_cidr\_blocks | CIDR Block for the load balancing subnets | `list(string)` | <pre>[<br>  "10.0.4.0/24",<br>  "10.0.5.0/24"<br>]</pre> | no |
| master\_ingress\_rules | Required ports for the EMR master security group. | `map(map(any))` | <pre>{<br>  "0": {<br>    "from": 8443,<br>    "proto": "tcp",<br>    "to": 8443<br>  },<br>  "1": {<br>    "from": 20888,<br>    "proto": "tcp",<br>    "to": 20888<br>  },<br>  "10": {<br>    "from": 16000,<br>    "proto": "tcp",<br>    "to": 16000<br>  },<br>  "11": {<br>    "from": 2181,<br>    "proto": "tcp",<br>    "to": 2181<br>  },<br>  "12": {<br>    "from": 19888,<br>    "proto": "tcp",<br>    "to": 19888<br>  },<br>  "13": {<br>    "from": 9095,<br>    "proto": "tcp",<br>    "to": 9095<br>  },<br>  "14": {<br>    "from": 8085,<br>    "proto": "tcp",<br>    "to": 8085<br>  },<br>  "2": {<br>    "from": 8088,<br>    "proto": "tcp",<br>    "to": 8088<br>  },<br>  "3": {<br>    "from": 50070,<br>    "proto": "tcp",<br>    "to": 50070<br>  },<br>  "4": {<br>    "from": 16010,<br>    "proto": "tcp",<br>    "to": 16010<br>  },<br>  "5": {<br>    "from": 9090,<br>    "proto": "tcp",<br>    "to": 9090<br>  },<br>  "6": {<br>    "from": 8070,<br>    "proto": "tcp",<br>    "to": 8070<br>  },<br>  "7": {<br>    "from": 18080,<br>    "proto": "tcp",<br>    "to": 18080<br>  },<br>  "8": {<br>    "from": 80,<br>    "proto": "tcp",<br>    "to": 80<br>  },<br>  "9": {<br>    "from": 8020,<br>    "proto": "tcp",<br>    "to": 8020<br>  }<br>}</pre> | no |
| name\_prefix | A prefix to add to the names of all created resources. | `string` | `"tamr-config-complete-test"` | no |
| public\_subnets\_cidr\_blocks | CIDR Block for the public subnets | `list(string)` | <pre>[<br>  "10.0.6.0/24",<br>  "10.0.7.0/24"<br>]</pre> | no |
| rds\_ingress\_rules | Required ports for the EMR RDS security group. | `map(map(any))` | <pre>{<br>  "0": {<br>    "from": 5432,<br>    "proto": "tcp",<br>    "to": 5432<br>  }<br>}</pre> | no |
| standard\_egress\_rules | Required standard egress traffic. | `map(map(any))` | <pre>{<br>  "0": {<br>    "from": 0,<br>    "proto": "all",<br>    "to": 65535<br>  }<br>}</pre> | no |
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
