pipeline {
    agent any

    stages {

        stage('Deploy') {
            steps {
                script {
                    sh '''
                        sshpass -p "Bl@kW" ssh -o StrictHostKeyChecking=no natasha@ststor01 \
                        "cd /var/www/html && git pull origin master"
                    '''
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    def response_code = sh(
                        script: "curl -s -o /dev/null -w '%{http_code}' http://stlb01:8091",
                        returnStdout: true
                    ).trim()

                    if (response_code != '200') {
                        error("App not working after deployment. HttpCode: ${response_code}")
                    } else {
                        echo "App is working fine ✔️"
                    }
                }
            }
        }
    }
}
