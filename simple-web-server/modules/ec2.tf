# TODO: ECS で立てる

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
 
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
 
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
 
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }
 
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
 
  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}
resource "aws_instance" "test" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"
    # key_name = "cm-yawata.yutaka"
    vpc_security_group_ids = [ aws_security_group.web.id ]
    subnet_id = aws_subnet.public-a.id
    associate_public_ip_address = true

    root_block_device {
      volume_type = "gp2"
      volume_size = 20
    }

    ebs_block_device {
      device_name = "/dev/sdf"
      volume_type = "gp2"
      volume_size = 100
    }

    tags = {
        Name = "test"
    }
}
