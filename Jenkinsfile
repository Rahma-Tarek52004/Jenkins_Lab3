pipeline {

    agent any

    options {
        skipDefaultCheckout(true)
    }

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

        stage('Check Docker') {
            steps {
                sh '''
                    echo "Docker version:"
                    docker version

                    echo ""
                    echo "Docker info:"
                    docker info
                '''
            }
        }

        stage('Test Docker Network') {
            steps {
                sh '''
                    echo "Testing Python image and PyPI connection..."

                    docker run --rm python:3.12-slim \
                        python -m pip install flask
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "Building Docker image..."

                    DOCKER_BUILDKIT=0 docker build \
                        --no-cache \
                        -t ${IMAGE_NAME}:${IMAGE_TAG} .
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
                    echo "Removing old container if it exists..."

                    docker rm -f ${CONTAINER_NAME} || true

                    echo "Starting new container..."

                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p 5000:5000 \
                        ${DOCKER_IMAGE}

                    echo "Container started."

                    docker ps
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
            echo "========================================"
            echo "Pipeline failed!"
            echo "Check the stage that failed above."
            echo "========================================"
        }

        always {
            sh '''
                docker logout || true
            '''
        }
    }
}
