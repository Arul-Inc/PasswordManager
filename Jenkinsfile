pipeline {
    agent any

    environment {
        IMAGE_NAME = "password-manager:latest"
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Pulls latest code pushed to your GitHub repository
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                // Builds the Docker image locally using your Dockerfile
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Applies the Kubernetes deployment & service configuration
                sh "kubectl apply -f k8s-deployment.yaml"

                // Forces Kubernetes to trigger a rolling update with the new Docker image
                sh "kubectl rollout restart deployment/password-manager-app"
            }
        }

        stage('Verify Deployment Status') {
            steps {
                // Waits for the deployment to successfully finish rolling out
                sh "kubectl rollout status deployment/password-manager-app --timeout=60s"
            }
        }
    }

    post {
        success {
            echo "========================================================"
            echo "SUCCESS: App deployed via Gunicorn to local Kubernetes!"
            echo "Access application at: http://localhost:30080"
            echo "========================================================"
        }
        failure {
            echo "Pipeline failed. Check build logs or pod status with 'kubectl get pods'."
        }
    }
}