#!/bin/bash
sudo apt-get update
sudo apt install openjdk-8-jdk #install java jdk.
cd /opt
sudo wget https://download.sonatype.com/nexus/3/nexus-3.62.0-01-unix.tar.gz
sudo tar -zxvf nexus-3.62.0-01-unix.tar.gz
sudo mv /opt/nexus-3.62.0-01    /opt/nexus
sudo adduser nexus
sudo echo "nexus ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nexus
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work
sudo chmod -R 775 /opt/nexus
#nexus configurations. 
#sudo vi /opt/nexus/bin/nexus.rc
#run_as_user="nexus"
#starting nexus
#sudo su  -nexus

#7 CONFIGURE NEXUS TO RUN AS A SERVICE
# sudo ln -s /opt/nexus/bin/nexus /etc/init.d/nexus
# #9 Enable and start the nexus services
# sudo systemctl enable nexus
# sudo systemctl start nexus
# sudo systemctl status nexus
# echo "end of nexus installation"
#/opt/nexus/bin/nexus status
  # <server>
  #     <id>nexus</id>
     #  <username>admin</username>
 ## </server>
