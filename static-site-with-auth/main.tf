provider "aws" {
  region = "ap-northeast-1"
  profile = "test-role"
}

variable "s3_bucket_name" {
  default = "test-role-bucket-1192"
}

variable "root_domain_name" {
  default = "test-role-1192.com"
}
