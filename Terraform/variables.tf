variable "Region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "igw_name" {
  type = string
}

variable "nat_name" {
  type = string
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



variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ebs_volume_size" {
  type = number
}


variable "desired_capacity" {
  type = number
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "key_pair_name" {
  type = string
}

variable "ebs_volume_type" {
  type = string
}

variable "instance_role_name" {
  type = string
}

variable "instance_profile_name" {
  type = string
}
