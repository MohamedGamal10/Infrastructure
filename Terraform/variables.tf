variable "Region" {
    type        = string
}

variable "vpc_cidr" {
    type        = string
}

variable "vpc_name" {
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