echo -e "\e[33m Configuring NodeJs Repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[33m Installing NodeJs\e[0m"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[33m Add Application User \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33m Create Application Directory \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[33m Download Application Content\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[33m Extract Application content\e[0m"
unzip /tmp/user.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[33m Installing nodeJs Dependinces\e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[33m Setup systemD service \e[0m"
cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>>/tmp/roboshop.log

echo -e "\e[33m Start user Service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable user &>>/tmp/roboshop.log
systemctl restart user &>>/tmp/roboshop.log

echo -e "\e[33m Copy mongodb repo file\e[0m"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[33m Install Mongodb client\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[33m Load schema\e[0m"
mongo --host mongodb-dev.chennadevops.online </app/schema/user.js