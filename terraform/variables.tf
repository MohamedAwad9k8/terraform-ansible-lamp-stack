variable "webserver_sg_ingress_ports" {
  type = list(number)
  default = [ 80, 443, 22 ]
}

variable "dbserver_sg_ingress_ports" {
  type = list(number)
  default = [ 3306, 22 ]
}
