FROM tomcat:8-jre8                          
# MAINTAINER                                
MAINTAINER "Haykel"                         
# COPY WAR FILE ON TO Contaire              
COPY /target/Gestion.war /usr/local/tomcat/webapps
CMD ["catalina.sh", "run"]
EXPOSE 8080
