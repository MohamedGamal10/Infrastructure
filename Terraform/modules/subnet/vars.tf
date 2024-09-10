variable "vpc_id" {
  type        = string
}

variable "subnets" {
  type = map(object({
    cidr   = string
    public = bool
    az     = string
    name   = string
  }))
}