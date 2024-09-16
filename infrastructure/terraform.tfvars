Region   = "eu-west-1"
vpc_cidr = "10.0.0.0/16"
vpc_name = "main"
igw_name = "igw"
nat_name = "nat"

public_subnets = {
  "public_az1" = {
    cidr = "10.0.1.0/24"
    az   = "eu-west-1a"
  }
  "public_az2" = {
    cidr = "10.0.3.0/24"
    az   = "eu-west-1b"
  }
}

private_subnets = {
  "private_az1" = {
    cidr = "10.0.2.0/24"
    az   = "eu-west-1a"
  }
  "private_az2" = {
    cidr = "10.0.4.0/24"
    az   = "eu-west-1b"
  }
}


#AutoScaling Vars
ami_id                = "ami-03cc8375791cb8bcf"
instance_type         = "t2.micro"
ebs_volume_type       = "gp2"
ebs_volume_size       = 8
desired_capacity      = 2
max_size              = 4
min_size              = 1
asg_key_pair_name     = "private-asg-key-pair"
instance_profile_name = "my-instance-profile"
instance_role_name    = "my-instance-role"

#Basion Vars
basion_ami_id        = "ami-03cc8375791cb8bcf"
basion_instance_type = "t2.micro"
basion_volume_size   = 8
basion_volume_type   = "gp2"
basion_key_pair_name = "bastion-key"