pipeline {

    agent any

    environment {
        IMAGE_NAME = "jenkins_docker-app"
        DOCKER_CREDENTIALS = credentials('jenkins_docker')
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_IMAGE = "${DOCKER_CREDENTIALS_USR}/${IMAGE_NAME}:${IMAGE_TAG}"
        CONTAINER_NAME = "flask-container"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Rahma-Tarek52004/Jenkins_Lab3.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Docker Login') {
            steps {
                sh '''
                    echo "${DOCKER_CREDENTIALS_PSW}" | docker login \
                        -u "${DOCKER_CREDENTIALS_USR}" \
                        --password-stdin
                '''
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh '''
                    docker tag \
                        ${IMAGE_NAME}:${IMAGE_TAG} \
                        ${DOCKER_IMAGE}
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                    docker push ${DOCKER_IMAGE}
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                    docker rm -f ${CONTAINER_NAME} || true

                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p 5000:5000 \
                        ${DOCKER_IMAGE}
                '''
            }
        }
    }

    post {

        success {
            echo "========================================"
            echo "Pipeline completed successfully!"
            echo "Docker Image: ${DOCKER_IMAGE}"
            echo "Application: http://localhost:5000"
            echo "========================================"
        }

        failure {
            echo "Pipeline failed!"
        }

        always {
            sh 'docker logout || true'
        }
    }
}

