
pipeline{

    agent any

       stage('Git Checkout'){
                    
            steps{
            gitCheckout(
                branch: "main",
                url: "https://github.com/deleonab/cicd-java-app.git"
            )
            }
        }
}
