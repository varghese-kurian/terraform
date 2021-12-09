variable "provide" {
  type = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type = string
  default = "110.0.0.0/16"
}

variable "public_subnet" {
  default = ["110.0.1.0/24"]
}

variable "private_subnet" {
  default = ["110.0.3.0/24", "110.0.4.0/24", "110.0.2.0/24"]
}


variable "subnet_name_public" {
  default = ["subnet_public_0"]
}

variable "subnet_name_private" {
  default = ["subnet_private_0", "subnet_private_1", "subnet_private_2"]
}

variable "open" {
  type = string
  default = "0.0.0.0/0"
}

variable "Vpc_name" {
  type = string
  default = "MyVPC"
}

variable "Igw_name" {
  type = string
  default = "IGW_gateWay"
}

variable "Elastic_name" {
  type = string
  default = "Elastic_ip"
}

variable "Nat_name" {
  type = string
  default = "NAT_gateway"
}

variable "private_subnet_name" {
  type = string
  default = "Route_private"
}

variable "public_subnet_name" {
  type = string
  default = "Route_public"
}



