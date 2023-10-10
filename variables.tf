variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}

variable "region-worker" {
  type    = string
  default = "us-west-2"
}

variable "vpc-1" {
  type    = string
  default = "172.28.0.0/22"
}

variable "vpc-1-pub" {
  type = list(string)
  default = [
    "172.28.0.0/24",
    "172.28.1.0/24",
  ]
}

variable "vpc-1-priv" {
  type = list(string)
  default = [
    "172.28.2.0/24",
    "172.28.3.0/24",
  ]
}

variable "vpc-2" {
  type    = string
  default = "172.28.4.0/22"
}

variable "vpc-2-pub" {
  type = list(string)
  default = [
    "172.28.4.0/24",
    "172.28.5.0/24",
  ]
}

variable "vpc-2-priv" {
  type = list(string)
  default = [
    "172.28.6.0/24",
    "172.28.7.0/24",
  ]
}

variable "tunnel1_cidr" {
  type    = string
  default = "169.254.10.0/30"
}

variable "tunnel2_cidr" {
  type    = string
  default = "169.254.10.4/30"
}

#instance type
variable "instance-type" {
  type    = string
  default = "t3.medium"
}

variable "fwl-ami" {
  type = string
  default = "ami-0abd8851da676ce44"
  
}

variable "aws-ami" {
  type = string
  default = "ami-0aa7d40eeae50c9a9"
  
}