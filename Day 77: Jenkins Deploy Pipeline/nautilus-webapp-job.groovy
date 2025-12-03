pipeline {
    agent { label 'ststor01' }

    stages {
        stage('Deploy') {
            steps {
                echo "Deploying web_app to /var/www/html ..."
                
                // Clean existing files except .git
                sh '''
                cd /var/www/html
                rm -rf *
                git clone http://gitea.sarah/web_app .
                '''
            }
        }
    }
}
