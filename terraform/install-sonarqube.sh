#!/bin/bash
apt update -y
apt install -y openjdk-17-jdk unzip wget postgresql postgresql-contrib

# Create SonarQube user
useradd -m -d /opt/sonarqube -s /bin/bash sonarqube

cd /opt
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.4.1.88267.zip
unzip sonarqube-*.zip
mv sonarqube-*/ sonarqube
chown -R sonarqube:sonarqube /opt/sonarqube

# Enable SonarQube
echo -e "[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonarqube
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/sonarqube.service

systemctl daemon-reexec
systemctl enable sonarqube
systemctl start sonarqube
