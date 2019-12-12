resource "aws_elb" "elb" {
  name = "simple-web-server-elb"
  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 20
  idle_timeout = 60
  internal = false
  listener {
    lb_protocol = "http"
    lb_port = 80
    instance_protocol = "http"
    instance_port = 80
  }
  subnets = [aws_subnet.public-a.id, aws_subnet.public-b.id]
  security_groups = [aws_security_group.elb.id]
  instances = [ aws_instance.test.id ]
}
