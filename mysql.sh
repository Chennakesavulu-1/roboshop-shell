echo -e "\e[33m Disabel mysql version \e[0m"
yum module disable mysql -y &>>/tmp/roboshop.log
echo -e "\e[33m Copy mysql repo file\e[0m"
cp /home/centos/roboshop-shell/mysql.repos /etc/yum.repos.d/mysql.repo

echo -e "\e[33m Install mysql community server\e[0m"
yum install mysql-community-server -y &>>/tmp/roboshop.log
echo -e "\e[33m  start mysql service\e[0m"
systemctl enable mysqld
systemctl restart mysqld
echo -e "\e[33m Setup mysql Password\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log
echo -e "\e[33m New passwd\e[0m"
mysql -uroot -pRoboShop@1