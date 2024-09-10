Region    = "eu-west-1"
vpc_cidr  = "10.0.0.0/16"
vpc_name  = "main" 


subnets = {
  public_az1 = {
    cidr   = "10.0.1.0/24"
    public = true
    az     = "eu-west-1a"
    name   = "public-subnet-az1"
  }
  private_az1 = {
    cidr   = "10.0.2.0/24"
    public = false
    az     = "eu-west-1a"
    name   = "private-subnet-az1"
  }
  public_az2 = {
    cidr   = "10.0.3.0/24"
    public = true
    az     = "eu-west-1b"
    name   = "public-subnet-az2"
  }
  private_az2 = {
    cidr   = "10.0.4.0/24"
    public = false
    az     = "eu-west-1b"
    name   = "private-subnet-az2"
  }
}