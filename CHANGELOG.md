# AWS Tamr Config Repo

## v2.4.1 - April 21st 2022
* Updates minimal required terraform version.

## v2.4.0 - March 3rd 2022
* Updates complete example to integrate Cloudwatch for Tamr VM and EMR Cluster
* Updates examples to use new versions of modules
* Adds terratest examples.

## v2.3.0 - October 21st 2021
* Update to how ES config is managed
* If `es_domain_endpoint` is set to an empty string, configuration is automatically set to use local ES
* New variable `es_enabled` created

## v2.2.0 - August 10th 2021
* Adds variable `emr_tags` that is passed to the config `TAMR_DATASET_EMR_CLUSTER_TAGS` into the file
* Updates examples to use new versions of modules

## v2.1.0 - July 2nd 2021
* Add HBase properties including `SHARED` mode to default Tamr config

## v2.0.0 - June 21st 2021
* Adds support for alternate backup/restore method that uses EMR's s3distcp
* Adds configuration `tamr_backup_emr_cluster_id`
* Removes configuration `tamr_backup_aws_cli_enabled`

## v1.1.1 - June 8th 2021
* Adds native support for backup config and DMS
* Updates examples to mark `rds-pw` and `private-key` as sensitive

## v1.0.1 - April 27th 2021
* Upgrades and pins `terraform-aws-modules/key-pair/aws` to version 1.0.0

## v1.0.0 - April 13th 2021
* Updates minimum Terraform version to 13
* Updates minimum AWS provider version to 3.36.0
* Examples updated with the latest versions of the modules

## v0.1.1 - Feb 18th 2021
* Set working default parameter for TAMR_JOB_SPARK_PROPS and adding support for TAMR_JOB_SPARK_CONFIG_OVERRIDES

## v0.1.0 - Oct 29th 2020
* Initing project
