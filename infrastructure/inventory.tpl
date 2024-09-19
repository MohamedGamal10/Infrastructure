[bastion]
${bastion_public_ip}

[private_instances]
%{ for ip in private_ips ~}
${ip}
%{ endfor ~}

[all:vars]
ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'