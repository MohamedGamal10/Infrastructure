variable "vpc_id" {
  type        = string
}

variable "vpc_name" {
  type        = string
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "internet_gateway_id" {
  type        = string
}

variable "nat_gateway_id" {
  type        = string
}
