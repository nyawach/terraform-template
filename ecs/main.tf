variable "profile" {}

variable "region" { default = "ap-northeast-1"}

provider "aws" {
  profile = "${var.profile}"
  region  = "${var.region}"
}
