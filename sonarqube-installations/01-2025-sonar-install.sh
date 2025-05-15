#!/bin/bash
# Author: Lion Technology 
# wsl ubuntu
#As a good security practice, SonarQuber Server is not advised to run sonar service as a root user, 
#so create a new user called sonar and grant sudo access to manage sonar services as follows
# 1. create a sonar 
sudo adduser sonar
# 2. Grand sudo access to sonar user
cd /opt 
sudo apt update
sudo apt install default-jdk 
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.8.zip
##install zip : 
sudo apt install zip
sudo apt install unzip 
sudo unzip sonarqube-7.8.zip
sudo rm -rf sonarqube-7.8.zip
sudo mv sonarqube-7.8 sonarqube
#changing permissions:
sudo chown -R sonar:sonar /opt/sonarqube/
sudo chmod -R 775 /opt/sonarqube/
sudo su - sonar
# start sonarqube as sonar user using relative path
sudo su - sonar  
cd /opt/sonarqube/bin/linux-x86-64/ 
sh sonar.sh start
# or start sonarqube as sonar user using absolute path
sh /opt/sonarqube/bin/linux-x86-64/sonar.sh start 
sh /opt/sonarqube/bin/linux-x86-64/sonar.sh status
#sh /opt/sonarqube/bin/linux-x86-64/sonar.sh start | stop | status | restart
# open sonarqube ports: 
# sudo ufw allow 9000/tcp
# To ACCESS SONARQUBE ON THE BROWSER:
# localhost:9000

# Default login information:
# username: admin
# pasword : admin