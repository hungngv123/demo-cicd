pipeline {
    agent {
        docker {
            image 'docker:20.10.7' // Docker image có Docker CLI và hỗ trợ DIND
            args '--privileged -v /var/run/docker.sock:/var/run/docker.sock' // Mount Docker socket và cấp quyền privileged
        }
    }
    tools {
        maven 'my-maven'
    }
    stages {
        stage('Build with Maven') {
            steps {
                sh 'mvn --version'
                sh 'java -version'
                sh 'mvn clean package -Dmaven.test.failure.ignore=true'
            }
        }

        stage('Packaging/Pushing image') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub', url: 'https://index.docker.io/v1/') {
                    sh 'docker build -t hunghd123/springboot .'
                    sh 'docker push hunghd123/springboot'
                }
            }
        }

        stage('Deploy Spring Boot to DEV') {
            steps {
                echo 'Deploying and cleaning'
                sh 'docker image pull hunghd123/springboot'
                sh 'docker container stop hunghd123-springboot || echo "this container does not exist" '
                sh 'docker network create dev || echo "this network exists"'
                sh 'echo y | docker container prune '
                sh 'docker container run -d --rm --name khalid-springboot -p 8085:8085 --network dev hunghd123/springboot'
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
