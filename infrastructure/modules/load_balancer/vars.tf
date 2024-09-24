variable "lb_name" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "vpc_name" {
  type = string
}

variable "public_subnet_ids" {
  type        = list(string)
}

variable "asg_name" {
  type        = string
}

variable "enable_deletion_protection" {
  type        = bool
  default     = false
}

variable "idle_timeout" {
  type        = number
  default     = 60
}
