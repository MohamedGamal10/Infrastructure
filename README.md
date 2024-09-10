# Project Task: Building Infrastructure with Terraform and Configuring Docker with Ansible
## Objective:
Build and manage infrastructure across two availability zones (AZs) using Terraform, and configure Docker on private machines using Ansible. The project should leverage GitOps practices with your preferred CI/CD tool.

## Tools Required:
Terraform: For building the infrastructure.
Ansible: For configuration management and automation.
Docker: To be installed on private machines and used for running a container.
GitOps: For managing configurations and CI/CD processes.
CI/CD Tools: Choose one (Jenkins, GitHub Actions, or GitLab Pipelines).
Task Breakdown:
Terraform Infrastructure Setup:

## Steps
Create VPC and configure network needs.
For each AZ, create two subnets: one public and one private.
Set up an Auto Scaling Group (ASG) with two instances.
Place the Load Balancer (LB) in the public subnets.
Deploy the instances in the private subnets.
Ensure the private IPs of the instances are passed to an inventory file for later use.
Bastion Host Configuration:

Set up a Bastion Host in the public subnet to manage access to the private instances.
After creating the infrastructure, copy the necessary Ansible role and configuration files to the Bastion Host.
Ansible Configuration:

Use Ansible to install Docker on the private instances.
Create a custom Ansible role for Docker installation.
Run a nginx container on each private instance using Docker.
GitOps Implementation:

Manage the entire configuration (Terraform and Ansible) using a Git repository.
Implement CI/CD pipelines using your chosen tool (Jenkins, GitHub Actions, or GitLab Pipelines) to automate the deployment and configuration process.
Hints:
You will execute the Ansible playbook on the Bastion Host.
Ensure that all configurations and scripts are stored and managed in a Git repository.
Use the inventory file created by Terraform to manage the target hosts for Ansible.
