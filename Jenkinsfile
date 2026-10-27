pipeline {
    agent { label 'linux-docker-java21' }
    options {
        skipDefaultCheckout(true)
        timestamps()
        disableConcurrentBuilds()
        timeout(time: 30, unit: 'MINUTES')
    }
    triggers { pollSCM('H/2 * * * *') }
    environment {
        STUDENT_NAME = 'Ziyayev Olzhas'
        STUDENT_GROUP = 'IT2-2302'
        IMAGE_NAME = 'ziyayev-olzhas-student-api'
        IMAGE_TAG = 'v1.0-ziyayev-olzhas'
        GRADLE_USER_HOME = "${WORKSPACE}/.gradle"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo "Student: ${STUDENT_NAME} | Group: ${STUDENT_GROUP}"
                sh 'java -version && docker version && chmod +x gradlew'
            }
        }
        stage('Build') {
            steps { sh './gradlew --no-daemon clean assemble' }
        }
        stage('Test') {
            steps { sh './gradlew --no-daemon test' }
            post { always { junit testResults: 'build/test-results/test/*.xml', allowEmptyResults: false } }
        }
        stage('Docker Build') {
            steps { sh 'docker build --tag "$IMAGE_NAME:$IMAGE_TAG" .' }
        }
        stage('Verify') {
            steps {
                sh '''
                    docker image inspect "$IMAGE_NAME:$IMAGE_TAG" --format 'Image={{.Id}} Size={{.Size}} Created={{.Created}}'
                    echo "Verified image for $STUDENT_NAME ($STUDENT_GROUP)"
                '''
            }
        }
    }
    post {
        success { echo 'Ziyayev Olzhas: build, tests and Docker image verification passed.' }
        failure { echo 'Pipeline failed. Review the first failed stage; subsequent stages were skipped.' }
        always { archiveArtifacts artifacts: 'build/libs/*.jar', allowEmptyArchive: true, fingerprint: true }
    }
}
