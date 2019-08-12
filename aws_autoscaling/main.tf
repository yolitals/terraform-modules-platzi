provider "aws" {
  region = "us-east-2"
}
resource "aws_security_group" "instance" {
  name = var.sg_name
  #ingress {
  #  from_port = 8080
  #  to_port = 8080
  #  protocol = "tcp"
  #  cidr_blocks = ["0.0.0.0/0"]
  #}
  dynamic "ingress" {
    for_each = var.ingress_rules

    content {
        from_port = ingress.value.from_port
        to_port = ingress.value.to_port
        protocol = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

resource "aws_launch_configuration" "as_conf" {
  name_prefix   = var.name_prefix
  image_id      = var.ami_id
  instance_type = var.instance_type
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = var.autoscaling_name
  launch_configuration = aws_launch_configuration.as_conf.name
  min_size             = var.min_size
  max_size             = var.max_size
  availability_zones   = var.availability_zones
  load_balancers       = var.load_balancer
  health_check_type = "ELB"
  lifecycle {
    create_before_destroy = true
  }
}