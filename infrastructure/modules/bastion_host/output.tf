# Output the public IP and private key for the Bastion Host

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_private_key_path" {
  value = local_file.bastion_private_key.filename
}

output "bastion_security_group_id" {
  value = aws_security_group.bastion_sg.id
}
