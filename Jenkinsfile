pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "mohamedgamal10/my-react-app:$BUILD_NUMBER"
        BASTION_HOST = "${bastion_host_ip}"
        PUBLIC_KEY   = "${bastion-key}"
        PRIVATE_KEY  = "${asg-key}"
        AWS_REGION   = "eu-west-1"
        ASG_NAME     = "main-asg"
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
                    withAWS(credentials: 'aws_cred', region: $AWS_REGION) {
                        // Retrieve private IPs of EC2 instances in the ASG
                        def privateIps = sh(returnStdout: true, script: """
                            aws autoscaling describe-auto-scaling-instances --query 'AutoScalingInstances[?AutoScalingGroupName==`$ASG_NAME`].InstanceId' --output text | \
                            xargs -I {} aws ec2 describe-instances --instance-ids {} \
                            --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text
                        """).trim().split()

                        // Loop over each private IP and SSH to deploy the Docker image
                        for (ip in privateIps) {
                            sh """
                            ssh -i $PUBLIC_KEY -o ProxyCommand="ssh -i $PUBLIC_KEY -W %h:%p ubuntu@$BASTION_HOST" -i $PRIVATE_KEY ubuntu@$ip << EOF
                                docker stop my-react-app
                                docker rm my-react-app
                                docker pull $DOCKER_IMAGE
                                docker run -d --name my-react-app -p 80:80 $DOCKER_IMAGE
                            EOF
                            """
                        }
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

