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
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[33m Extract Application content\e[0m"
unzip /tmp/cart.zip
cd /app

echo -e "\e[33m Installing nodeJs Dependinces\e[0m"
npm install

echo -e "\e[33m Setup systemD service \e[0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service

echo -e "\e[33m Start cart Service\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart

