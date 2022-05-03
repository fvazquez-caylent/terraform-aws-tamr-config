# Set up logs bucket with read/write permissions
module "s3-logs" {
  source      = "git::git@github.com:Datatamer/terraform-aws-s3.git?ref=1.1.1"
  bucket_name = "${var.name_prefix}-emr-logs"
  read_write_actions = [
    "s3:PutObject",
    "s3:GetObject",
    "s3:DeleteObject",
    "s3:AbortMultipartUpload",
    "s3:ListBucket",
    "s3:ListObjects",
    "s3:CreateJob",
    "s3:HeadBucket"
  ]
  read_write_paths = [""] # r/w policy permitting specified rw actions on entire bucket
}

# Set up root directory bucket
module "s3-data" {
  source      = "git::git@github.com:Datatamer/terraform-aws-s3.git?ref=1.1.1"
  bucket_name = "${var.name_prefix}-emr-data"
  read_write_actions = [
    "s3:GetBucketLocation",
    "s3:GetBucketCORS",
    "s3:GetObjectVersionForReplication",
    "s3:GetObject",
    "s3:GetBucketTagging",
    "s3:GetObjectVersion",
    "s3:GetObjectTagging",
    "s3:ListMultipartUploadParts",
    "s3:ListBucketByTags",
    "s3:ListBucket",
    "s3:ListObjects",
    "s3:ListObjectsV2",
    "s3:ListBucketMultipartUploads",
    "s3:PutObject",
    "s3:PutObjectTagging",
    "s3:HeadBucket",
    "s3:DeleteObject",
    "s3:AbortMultipartUpload",
    "s3:CreateJob"
  ]
  read_write_paths = [""] # r/w policy permitting default rw actions on entire bucket
}
