# Terraform-generated Tamr Config Module
This terraform module automates populating some Tamr config variables that are generated as outputs from other AWS scale-out modules.

# Examples
## Minimal
Smallest complete fully working example. This example might require extra resources to run the example.
- [Minimal](https://github.com/Datatamer/terraform-aws-tamr-config/tree/master/examples/minimal)

# Resources Created
This module creates:
* A template_file data source which renders the contents of a populated Tamr config.
* If `rendered_config_path` is provided, the populated Tamr config will be output to a yaml file in this path.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.15 |
| aws | >= 3.36.0 |

## Providers

| Name | Version |
|------|---------|
| local | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ephemeral\_spark\_configured | True if EMR was configured for ephemeral spark clusters. | `bool` | n/a | yes |
| es\_domain\_endpoint | Endpoint of Elasticsearch domain. | `string` | n/a | yes |
| rds\_pg\_hostname | Hostname of RDS postgres instance. | `string` | n/a | yes |
| rds\_pg\_password | Master password for RDS postgres database instance. | `string` | n/a | yes |
| spark\_cluster\_log\_uri | The path to the S3 location where logs for the Spark cluster are stored. | `string` | n/a | yes |
| tamr\_data\_bucket | Name of Tamr root directory bucket. | `string` | n/a | yes |
| additional\_templated\_variables | Mapping of additional Tamr variables (not included in template) to its value. If a variable name in this map defines the same key as an input variable, the value specified in this map takes precedence. | `map(string)` | `{}` | no |
| apps\_dms\_default\_cloud\_provider | Defines the default cloud service provider for DMS when `APPS_DMS_ENABLED` is set to `true` | `string` | `"s3"` | no |
| apps\_dms\_enabled | Set to `true` to enable the  Data Movement Service (DMS) | `bool` | `true` | no |
| config\_template\_path | Path to Tamr config template. | `string` | `"./tamr-config.yml"` | no |
| core\_ebs\_size | The core EBS volume size, in gibibytes (GiB). | `string` | `""` | no |
| core\_ebs\_type | Type of volumes to attach to the core nodes. Valid options are gp2, io1, standard and st1. | `string` | `""` | no |
| core\_ebs\_volumes\_count | Number of volumes to attach to the core nodes. | `string` | `""` | no |
| core\_group\_instance\_count | Number of Amazon EC2 instances used to execute the job flow. | `string` | `""` | no |
| core\_instance\_type | The EC2 instance type of the core nodes. | `string` | `""` | no |
| emr\_additional\_core\_sg\_id | Security group ID of the EMR Additional Core Security Group. | `string` | `""` | no |
| emr\_additional\_master\_sg\_id | Security group ID of the EMR Additional Master Security Group. | `string` | `""` | no |
| emr\_instance\_profile\_name | Name of instance profile for EMR EC2 instances. | `string` | `""` | no |
| emr\_key\_pair\_name | Name of the Key Pair that will be attached to the EMR EC2 instances. | `string` | `""` | no |
| emr\_managed\_core\_sg\_id | Security group ID of the EMR Managed Core Security Group. | `string` | `""` | no |
| emr\_managed\_master\_sg\_id | Security group ID of the EMR Managed Master Security Group. | `string` | `""` | no |
| emr\_release\_label | The release label for the Amazon EMR release. | `string` | `"emr-5.29.0"` | no |
| emr\_root\_volume\_size | The size, in GiB, of the EBS root device volume of the Linux AMI that is used for each EMR EC2 instance. | `string` | `"10"` | no |
| emr\_service\_access\_sg\_id | Security group ID of EMR Service Access Security Group. | `string` | `""` | no |
| emr\_service\_role\_name | Name of IAM service role for EMR cluster. | `string` | `""` | no |
| emr\_subnet\_id | ID of the subnet where the EMR cluster will be created. | `string` | `""` | no |
| emr\_tags | Map of tags to add to new resources in EMR | `map(string)` | `{}` | no |
| emrfs\_dynamodb\_table\_name | Name for the EMRFS DynamoDB table. | `string` | `""` | no |
| es\_enabled | Whether or not to enable Elasticsearch by setting TAMR\_ES\_ENABLED flag | `bool` | `true` | no |
| hbase\_config\_path | Path to HBase configuration in EMR root directory bucket. | `string` | `"config/hbase/conf.dist/"` | no |
| hbase\_namespace | n/a | `string` | `"tamr"` | no |
| hbase\_number\_of\_regions | Number of regions to create by default in HBase | `string` | `"1000"` | no |
| hbase\_number\_of\_salt\_values | Number of distinct salt values to be used for prefixing row keys in HBase tables.  Must be >= hbase\_number\_of\_regions | `string` | `"1000"` | no |
| hbase\_storage\_mode | Storage mode for HBase.  Valid values: `SHARED`, `DEDICATED` | `string` | `"SHARED"` | no |
| master\_ebs\_size | The master EBS volume size, in gibibytes (GiB). | `string` | `""` | no |
| master\_ebs\_type | Type of volumes to attach to the master nodes. Valid options are gp2, io1, standard and st1. | `string` | `""` | no |
| master\_ebs\_volumes\_count | Number of volumes to attach to the master nodes. | `string` | `""` | no |
| master\_instance\_type | The EC2 instance type of the master nodes. | `string` | `""` | no |
| rds\_pg\_db\_port | The RDS postgres database port. | `number` | `5432` | no |
| rds\_pg\_dbname | RDS postgres database name. | `string` | `"doit"` | no |
| rds\_pg\_username | Master username for RDS postgres database instance. | `string` | `"tamr"` | no |
| rendered\_config\_path | If provided, the populated Tamr config will be output to this path. Include a file name (E.g. /path/to/config.yml). NOTE: Any required parent directories will be created automatically, and any existing file with the given name will be overwritten. | `string` | `""` | no |
| spark\_driver\_memory | n/a | `string` | `"5G"` | no |
| spark\_emr\_cluster\_id | Spark cluster ID. Value will not be used if deployment is spinning up ephemeral Spark clusters. | `string` | `""` | no |
| spark\_executor\_cores | n/a | `number` | `2` | no |
| spark\_executor\_instances | n/a | `number` | `2` | no |
| spark\_executor\_memory | n/a | `string` | `"8G"` | no |
| tamr\_backup\_emr\_cluster\_id | ID of the static EMR cluster to run s3distcp on when backing up to or restoring from S3. | `string` | `""` | no |
| tamr\_data\_path | Path in root directory bucket (bucket provided for tamr\_bucket\_name input) to write data to. | `string` | `"tamr/unify-data"` | no |
| tamr\_external\_storage\_providers | Filesystem connection information for external storage providers. | `string` | `""` | no |
| tamr\_file\_based\_hbase\_backup\_enabled | Whether to backup contents of HBase root directory to backup path | `bool` | `true` | no |
| tamr\_spark\_config\_override | A list of spark config overrides. If not set all jobs will run with the default spark settings. Used for setting job-by-job spark resource settings. | `string` | `""` | no |
| tamr\_spark\_properties\_override | JSON blob of spark properties to override. If not set, will use a default set of properties that should work for most use cases. | `string` | `""` | no |
| tamr\_unify\_backup\_aws\_role\_based\_access | Set to `true` if Tamr should use EC2 instance profile (role-based) credentials instead of static credentials | `bool` | `true` | no |
| tamr\_unify\_backup\_es | Defines whether or not to back up Elasticsearch | `bool` | `false` | no |
| tamr\_unify\_backup\_path | Identifies the path for storing backup files | `string` | `"tamr/backups"` | no |

## Outputs

| Name | Description |
|------|-------------|
| rendered | Rendered Tamr config |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# References
This repo is based on:
* [terraform standard module structure](https://www.terraform.io/docs/modules/index.html#standard-module-structure)
* [templated terraform module](https://github.com/tmknom/template-terraform-module)

# Development
## Generating Docs
Run `make terraform/docs` to generate the section of docs around terraform inputs, outputs and requirements.

## Checkstyles
Run `make lint`, this will run terraform fmt, in addition to a few other checks to detect whitespace issues.
NOTE: this requires having docker working on the machine running the test

## Releasing new versions
* Update version contained in `VERSION`
* Document changes in `CHANGELOG.md`
* Create a tag in github for the commit associated with the version

# License
Apache 2 Licensed. See LICENSE for full details.
