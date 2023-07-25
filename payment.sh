echo -e "\e[33m Install Python\e[0m"
yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log
echo -e "\e[33m Add user application\e[0m"
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[33m make directory \e[0m"
mkdir /app &>>/tmp/roboshop.log
echo -e "\e[33m download application content\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>/tmp/roboshop.log
cd /app
echo -e "\e[33m Extract zip file of payment\e[0m"
unzip /tmp/payment.zip &>>/tmp/roboshop.log

echo -e "\e[33m Install application dependencies\e[0m"
cd /app
pip3.6 install -r requirements.txt &>>/tmp/roboshop.log
echo -e "\e[33m Start payment service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable payment &>>/tmp/roboshop.log
systemctl restart payment &>>/tmp/roboshop.log