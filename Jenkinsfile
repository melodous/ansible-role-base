node {


    currentBuild.result = "SUCCESS"

    try {

       stage('Checkout'){

          checkout scm
       }

       stage('Lint ansible role'){

         sh 'make ansiblelint'

       }

       stage('Lint ansible role'){

         sh 'make yamllint'

       }


       stage('Generate infrastructure and test'){

         sh 'make test'

       }


    }
    catch (err) {

        currentBuild.result = "FAILURE"

            mail body: "project build error is here: ${env.BUILD_URL}" ,
            from: 'xxxx@yyyy.com',
            replyTo: 'yyyy@yyyy.com',
            subject: 'project build failed',
            to: 'zzzz@yyyyy.com'

        throw err
    }

}

