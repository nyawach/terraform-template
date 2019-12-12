# VPC

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink               = false
  enable_classiclink_dns_support   = false

  lifecycle {
    prevent_destroy       = false
  }
}

# Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}


# Subnet

resource "aws_subnet" "public-a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "public-b" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "us-west-2b"
}


# Route Table

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}


# Route Table Assosiation

resource "aws_route_table_association" "public-rta-a" {
  subnet_id = aws_subnet.public-a.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-rta-b" {
  subnet_id = aws_subnet.public-b.id
  route_table_id = aws_route_table.public-rt.id
}


# Security Group

resource "aws_security_group" "elb" {
  name = "elb"
  vpc_id = aws_vpc.vpc.id
  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web" {
  name = "web"
  vpc_id = aws_vpc.vpc.id
  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    security_groups = [aws_security_group.elb.id]
  }
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "db" {
  name = "db"
  vpc_id = aws_vpc.vpc.id
  ingress {
    protocol = "tcp"
    from_port = 3306
    to_port = 3306
    security_groups = [aws_security_group.web.id]
  }
}
