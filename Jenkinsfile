pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "my-react-app:${BUILD_NUMBER}"
        BASTION_HOST = "bastion_host_ip"
        SSH_KEY = "/path/to/private_key.pem"
        AWS_REGION = "your_aws_region"
        ASG_NAME = "your_asg_name"
    }

    stages {
        stage('Pull Repo') {
            steps {
              git url: 'https://github.com/MohamedGamal10/Infrastructure.git'
    
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                     withCredentials([usernamePassword(credentialsId: 'docker_hub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) 
                    {
                        sh '''
                        cd app
                        docker build -t ${USERNAME}/my-react-app:${BUILD_NUMBER} .
                        echo "${PASSWORD}" | docker login -u "${USERNAME}" --password-stdin
                        docker push ${USERNAME}/my-react-app:${BUILD_NUMBER}
                        '''   
                    }
                }
            }
        }
        
        stage('Deploy to ASG Instances') {
            steps {
                script {
                    // Retrieve private IPs of EC2 instances in the ASG
                    def privateIps = sh(returnStdout: true, script: """
                        aws autoscaling describe-auto-scaling-instances --query 'AutoScalingInstances[?AutoScalingGroupName==`$ASG_NAME`].InstanceId' --output text | \
                        xargs -I {} aws ec2 describe-instances --instance-ids {} \
                        --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text
                    """).trim().split()

                    // Loop over each private IP and SSH to deploy the Docker image
                    for (ip in privateIps) {
                        sh """
                        ssh -i $SSH_KEY -o ProxyCommand="ssh -i $SSH_KEY -W %h:%p ec2-user@$BASTION_HOST" ec2-user@$ip << EOF
                            docker stop my-react-app || true
                            docker rm my-react-app || true
                            docker pull $DOCKER_IMAGE
                            docker run -d --name my-react-app -p80:80 $DOCKER_IMAGE
                        EOF
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }

  }

