output "asg_id" {
  value = aws_autoscaling_group.asg.id
}

output "asg_name" {
  value = aws_autoscaling_group.asg.name
}


output "launch_template_id" {
  value = aws_launch_template.lt.id
}

data "aws_instances" "asg_instances" {
  instance_tags = {
    "aws:autoscaling:groupName" = aws_autoscaling_group.asg.name
  }
}


output "asg_instance_private_ips" {
  value = data.aws_instances.asg_instances.private_ips
}
