#!/bin/bash
sudo apt update
#Install java: 
sudo apt install default-jdk   #this installs Java , a dependencyh for maven
#varify installation of java :  
java -version
cd /opt
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
sudo tar xf apache-maven-*.tar.gz
sudo ln -s /opt/apache-maven-3.9.9 /opt/maven

#maven-configuration : 
#sudo vi /etc/profile.d/maven.sh

#copy and paste in the maven.sh: 

#export JAVA_HOME=/usr/lib/jvm/default-java
#export M2_HOME=/opt/maven
#export MAVEN_HOME=/opt/maven
#export PATH=${M2_HOME}/bin:${PATH}

#Make the script executable with chmod:
#sudo chmod +x /etc/profile.d/
#source /etc/profile.d/maven.sh

#4. Verify the installation:
#mvn -version