variable "region_name" {
  type    = string
  default = "ap-northeast-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.20.0.0/24"
}

variable "subnet2_cidr" {
  type    = string
  default = "10.20.1.0/24"
}

variable "az1" {
  type    = string
  default = "ap-northeast-2a"
}

variable "az2" {
  type    = string
  default = "ap-northeast-2b"
}
