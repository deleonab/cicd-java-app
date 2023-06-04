We shall be building a CI/CD Pipeline to deploy our java application in a Kubernetes cluster. We shall be using Jenkins shared library instead of a simple Jenkinsfile. 

 - We shall host our Jenkins shared Library as well as our application code in Github
 - Jenkins will checkout the code from Github
 - Jenkins will do Unit Testing, Integration Testing and Static Code Analysis using Sonarqube
 - Next it will do a Quality Gate status checks
 - If it passes, It will proceed with the build otherwise it will be marked as failed.
 -  The Maven build will produce a*.jar artifact.
 -  We shall use a Dockerfile to build our docker image
 -  Next, we shall scan our image for vulnerabilities using Trivy. If pushing to ECS, we can enable image scanning i.e push on scan feature. 
 -  We shall push our image to dockerhub or ECS.
 -  The image pushed to the repo will be used in our deployment manifests to deploy into our Kubernetes cluster.


CREATE JENKINS SERVER
- create VPC with 2 private and 2 public subnets (cicd-project-vpc)  vpc-094dc7f7668457ea8
-	Use Ubuntu image 22.04
-	Choose T2 Medium
-	Create Key Pair   (cicd-keypair)
-	Security group 
	Open Port 22 (SSH), 8080(Jenkins) and 9000(SonarQube)
-	Storage 30GB
 
Userdata
Install Jenkins, Docker and Sonarqube
The docker is needed to run sonarqube as a container
i.e docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
```

#!/bin/bash

sudo apt update -y

sudo apt upgrade -y 

sudo apt install openjdk-17-jre -y

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y 
sudo apt-get install jenkins -y

```
INSTALL DOCKER

```
#!/bin/bash
sudo apt update -y

sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y

sudo apt update -y

apt-cache policy docker-ce -y

sudo apt install docker-ce -y

#sudo systemctl status docker
### This added to ensure our container runs
sudo chmod 777 /var/run/docker.sock
### docker container start [container id]  as it will need to be started if userdata script fails
```

Launch Sonarqube container
```
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
```

### Wait for our instance to be up and running.

Go to Jenkins using the Instance public IP on port 8080

Get the InitialAdminPassword and log into the Jenkins web interface

![Jenkins Installed](./images/jenkins-installed.png)

### Check if docker was successfully installed by running
```
 docker container ls
```

![check docker installation](./images/sonar-installed.png)

- Sonarqube container is running
![check docker installation](./images/sonar-installed2.png)


### Create our first jenkins job as a pipeline, pipeline script from SCM, script path as Jenkinsfile

![project options](./images/jenkins-project-options.png)


### We shall be using 2 git repositories
1. Host our java app, jenkinsfile,dockerfile and deployment manifest files

2. Host our jenkins shared library
https://github.com/deleonab/jenkins-shared-library-for-pipeline.git

We shall import the jenkins shared library into our jenkinsfile and pass parameters into our script. This way, different teams could use the same library.

jenkins-shared-library-for-pipeline/vars/
The vars directory will contain all the groovy scripts which will be called into our Jenkinsfile

### Repo: jenkins-shared-library-for-pipeline
### folder: vars
### file: gitCheckout.groovy
```
def call(Map stageParams) {
 
    checkout([
        $class: 'GitSCM',
        branches: [[name:  stageParams.branch ]],
        userRemoteConfigs: [[ url: stageParams.url ]]
    ])
  }
```

### Repo: cicd-java-app
### file: Jenkinsfile

```
### import the library
@Library('my-shared-library') _

pipeline{

    agent any

       stage('Git Checkout'){
                    when { expression {  params.action == 'create' } }
            steps{
            gitCheckout(
                branch: "main",
                url: "https://github.com/deleonab/cicd-java-app.git"
            )
            }
        }
}
```
Get the url for our git jenkins shared library
```
https://github.com/deleonab/jenkins-shared-library-for-pipeline.git
```
Go to Jenkins
Dashboard > Manage Jenjins > System Configuration > System

Search for the 'Global Pipeline Libraries' section

Name: my-shared-library
Default Version: main
Project Repository: https://github.com/deleonab/jenkins-shared-library-for-pipeline.git

![global configuration](./images/global-pipeline.png)

