variable "asg_name" {
  type = string
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

variable "subnet_ids" {
  type = list(string)
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

variable "vpc_name" {
  type = string
}


variable "ebs_volume_type" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "instance_role_name" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "asg_sg_name" {
  type = string
}
