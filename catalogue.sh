echo -e "\e[33m Configuring NodeJs Repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[33m Installing NodeJs\e[0m"
yum install nodejs -y

echo -e "\e[33m Add Application User \e[0m"
useradd roboshop

echo -e "\e[33m Create Application Directory \e[0m"
rm -rf /app
mkdir /app

echo -e "\e[33m Download Application Content\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[33m Extract Application content\e[0m"
unzip /tmp/catalogue.zip
cd /app

echo -e "\e[33m Installing nodeJs Dependinces\e[0m"
npm install

echo -e "\e[33m Setup systemD service \e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[33m Start catalogue Service\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[33m Copy mongodb repo file\e[0m"
cp mongodb.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[33m Install Mongodb client\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[33m Load schema\e[0m"
mongo --host mongodb-dev.chennadevops.online </app/schema/catalogue.js