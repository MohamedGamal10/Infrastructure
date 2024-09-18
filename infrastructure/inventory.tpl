[bastion]
${bastion_public_ip} ansible_ssh_private_key_file=~/bastion-key.pem

[private_instances]
%{ for ip in private_ips ~}
${ip} ansible_ssh_private_key_file=~/private-asg-key-pair.pem ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q -i ~/bastion-key.pem ubuntu@${bastion_public_ip}"'
%{ endfor ~}

[all:vars]
ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'