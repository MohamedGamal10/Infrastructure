output "asg_id" {
  value = aws_autoscaling_group.asg.id
}

output "launch_template_id" {
  value = aws_launch_template.lt.id
}
