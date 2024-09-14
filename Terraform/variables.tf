variable "Region" {
    type        = string
}

variable "vpc_cidr" {
    type        = string
}

variable "vpc_name" {
    type        = string
}

variable "igw_name" {
  type        = string
}

variable "nat_name" {
  type        = string
}

variable "public_subnets" {
  description = "A map of public subnets"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  description = "A map of private subnets"
  type = map(object({
    cidr = string
    az   = string
  }))
}