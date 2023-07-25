echo -e "\e[33m Install MAVEN \e[0m"
yum install maven -y &>>/tmp/roboshop.log

echo -e "\e[33m Adding user\e[0m"
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[33m Create application directory\e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[33m Download application content \e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[33m extract application content\e[0m"
unzip /tmp/shipping.zip &>>/tmp/roboshop.log

echo -e "\e[33m Download maven dependencies\e[0m"
mvn clean package


mv target/shipping-1.0.jar shipping.jar &>>/tmp/roboshop.log

echo -e "\e[33m Install mysql client\e[0m"
yum install mysql -y &>>/tmp/roboshop.log

echo -e "\e[33m Load schema\e[0m"
mysql -h mysql-dev.chennadevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>/tmp/roboshop.log

echo -e "\e[33m Start Shipping services\e[0m"
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[33m Start Shipping services\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log

systemctl enable shipping
systemctl restart shipping



systemctl restart shipping