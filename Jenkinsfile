pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "mohamedgamal10/my-react-app:$BUILD_NUMBER"
        AWS_REGION   = "eu-west-1"
        ASG_NAME     = "terraform-20241001215659470200000004"
        BASTION_HOST = "${bastion_host_ip}"
    }

    stages {
        stage('Pull Repo') {
            steps {
                 sh '''
                    git clone https://github.com/MohamedGamal10/Infrastructure.git
                    '''
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker_cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh '''
                        cd Infrastructure/app
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
                    withAWS(credentials: 'aws_cred', region: AWS_REGION) {
                        // Retrieve private IPs of EC2 instances in the ASG
                        def privateIps = sh(returnStdout: true, script: """
                            aws autoscaling describe-auto-scaling-instances --query 'AutoScalingInstances[?AutoScalingGroupName==\`${ASG_NAME}\`].InstanceId' \
                            --output text | tr '\t' '\n' | xargs -I {} aws ec2 describe-instances --instance-ids {} --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text
                        """).trim().split()

                        withCredentials([sshUserPrivateKey(credentialsId: 'bastion-key', keyFileVariable: 'PUBLIC_KEY'),
                                         sshUserPrivateKey(credentialsId: 'asg-key', keyFileVariable: 'PRIVATE_KEY')]) {
                            for (ip in privateIps) {
                                echo "Connecting to instance: $ip via Bastion Host: $BASTION_HOST"
                                sh """
                                ssh -i ${PUBLIC_KEY} -o StrictHostKeyChecking=no -o ProxyCommand="ssh -i ${PUBLIC_KEY} -W %h:%p ubuntu@${BASTION_HOST}" ubuntu@$ip << EOF
                                    if [[ \$(docker ps -q -f name=my-react-app) ]]; then
                                        docker stop my-react-app
                                        docker rm my-react-app
                                    fi
                                    docker pull $DOCKER_IMAGE
                                    docker run -d --restart unless-stopped --name my-react-app -p 80:80 $DOCKER_IMAGE
                                EOF
                                """
                            }
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
