# Pin our tomcat version to something that has not been updated to remove the vulnerability
# https://hub.docker.com/layers/tomcat/library/tomcat/9.0.59-jdk11/images/sha256-383a062a98c70924fb1b1da391a054021b6448f0aa48860ae02f786aa5d4e2ad?context=explore
FROM lunasec/tomcat-9.0.59-jdk11

ENV test=test
ADD src/ /helloworld/src
ADD pom.xml /helloworld
ADD secrets.txt /helloworld 

#  Build spring app
RUN apt update && apt install maven -y
WORKDIR /helloworld/
RUN mvn clean package

# write malware into container 
RUN wget -P /helloworld https://github.com/stanezil/eicar/blob/main/eicar.txt

# MySecrets
ENV AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKE"
ENV AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"

#  Deploy to tomcat
RUN mv target/helloworld.war /usr/local/tomcat/webapps/

EXPOSE 8080
CMD ["catalina.sh", "run"]
