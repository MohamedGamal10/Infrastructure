resource "tls_private_key" "bastion_tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_key" {
  key_name   = var.basion_key_pair_name
  public_key = tls_private_key.bastion_tls_key.public_key_openssh
}

resource "local_file" "bastion_private_key" {
  content  = tls_private_key.bastion_tls_key.private_key_pem
  filename = "${path.module}/keys/${var.basion_key_pair_name}.pem"
}

resource "aws_security_group" "bastion_sg" {
  name   = "${var.bastion_name}-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "bastion" {
  ami             = var.basion_ami_id
  instance_type   = var.basion_instance_type
  subnet_id       = var.public_subnet_id
  key_name        = aws_key_pair.bastion_key.key_name
  security_groups = [aws_security_group.bastion_sg.id]

  root_block_device {
    volume_size           = var.basion_volume_size
    volume_type           = var.basion_volume_type
    delete_on_termination = true
  }


  tags = {
    Name = "${var.vpc_name}-${var.bastion_name}-ec2"
  }
}
