variable "elb_name" {
  default = "platzi-elb-module"
}
variable "availability_zones" {
  type = list
  default = ["us-east-2a"]
}
variable "elb_listener" {
    default = [{lb_port = "80", lb_protocol = "http", instance_port="80", instance_protocol = "http"}]
}