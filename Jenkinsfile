
@Library('my-shared-library') _
pipeline{

    agent any
stages{
       stage('Git Checkout'){
                    
            steps{
            gitCheckout(
                branch: "main",
                url: "https://github.com/deleonab/cicd-java-app.git"
            )
            }
        }

        stage('Unit Test maven'){
         
         
            steps{
               script{
                   
                   mvnTest()
               }
            }
        }

        ```
        stage('Integration Test maven'){
         
            steps{
               script{
                   
                   mvnIntegrationTest()
               }
            }
        }

}
}
