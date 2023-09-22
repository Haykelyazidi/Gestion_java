
pipeline {
    agent any
    
    environment{
        IMAGE="haydevops/app_java:v_${env.BUILD_NUMBER}"
       // DOCKERHUB_CREDENTIALS = credentials('LeonelDockerHub')
    }
    
    tools {
      maven 'mvn'
  }
  
    stages {
        stage('CLONE avec Git') {
            steps {
                git branch:'master', url:'https://github.com/Haykelyazidi/Gestion_java.git'
            }
        }

        stage('BUILD avec Maven') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        // stage('TEST avec Sonarqube') {
        //   steps {
        //     withSonarQubeEnv(installationName: 'sq1') { 
        //       sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.0.2155:sonar'
        //     }
        //   }
        // }

        // stage('TEST avec SonarQube') {
        //     steps {
        //      withSonarQubeEnv('sq1') { 
        //      sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.0.2155:sonar'
        //    }
        //  }
        // }
    
         stage('RELEASE avec Dockerfile') {
            steps {
               sh 'docker build -t ${IMAGE} .'
            }
         }

        
        

         
        
         stage('Push Image') {
            steps {
                withCredentials([string(credentialsId: 'docker_hub', variable: 'DOCKER_CREDENTIALS')]) {
                sh "echo $DOCKER_CREDENTIALS | docker login -u haydevops --password-stdin"
                //sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push ${IMAGE}'
                //sh 'docker logout'
            }
        }
        }
          stage('Remove Container') {
            steps {
                script {
                    def containerName = 'haykel_java' // Remplacez par le nom de votre conteneur
                    
                    def containerId = sh(script: "docker ps -aq -f name=${containerName}", returnStdout: true).trim()
                    if (containerId) {
                        sh "docker rm -f ${containerName}"
                        echo "Container '${containerName}' has been removed."
                    } else {
                        echo "No container found with the name '${containerName}'."
                       // sh 'docker run -d --name haykel_java -p 8050:8080 ${IMAGE}'
                    }
                }
            }
        }
        
         stage('DEPLOYMENT: Lancement du conteneur') {
            steps {
                 script {
                     def containerId = sh(returnStdout: true, script: "docker ps -q -f name=haykel_java").trim()
                     if (containerId) {
                         echo "Ancien conteneur détecté : $containerId"
                         sh "docker kill $containerId"
                         sh "docker rm $containerId"
                         sh 'docker run -d --name haykel_java -p 8050:8080 ${IMAGE}'
                     } else {
                         echo "Aucun ancien conteneur trouvé"
                         sh 'docker run -d --name haykel_java -p 8050:8080 ${IMAGE}'
                     }
                 }
                
             }
         }
        
         stage('Suppression de l\'image') {
            steps {
                sh 'docker rmi -f ${IMAGE}'
            }
        }
        }
   
   
    }
  
