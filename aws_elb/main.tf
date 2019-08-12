provider "aws" {
  region = "us-east-2"
}
resource "aws_security_group" "elb" {
  name = var.elb_name
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
### Creating ELB
resource "aws_elb" "elb_platzi" {
  name = var.elb_name
  security_groups = ["${aws_security_group.elb.id}"]
  availability_zones = var.availability_zones
  dynamic "listener" {
    for_each = var.elb_listener

    content {
        lb_port = listener.value.lb_port
        lb_protocol = listener.value.lb_protocol
        instance_port = listener.value.instance_port
        instance_protocol = listener.value.instance_protocol
    }
  }
}