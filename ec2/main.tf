variable "aws_region" {
  default = "ap-northeast-1"
}
variable "aws_zone" {
  default = "ap-northeast-1c"
}
variable "aws_profile" {
  default = "jt-homeshindan"
}

provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
}

resource "aws_key_pair" "mock" {
  key_name   = "ec2-mock"
}


resource "aws_instance" "mock" {
  ami = "ami-0064e711cbc7a825e" # Amazon Linux
  instance_type = "t2.micro"
  monitoring    = true
  key_name = "${aws_key_pair.mock.key_name}"
}
