source=common.sh
echo -e "${color} Disabel mysql version ${nocolor}"
yum module disable mysql -y &>>/tmp/roboshop.log
stat_check $?
echo -e "${color} Copy mysql repo file${nocolor}"
cp /home/centos/roboshop-shell/mysql.repos /etc/yum.repos.d/mysql.repo
stat_check $?

echo -e "${color} Install mysql community server${nocolor}"
yum install mysql-community-server -y &>>/tmp/roboshop.log
stat_check $?
echo -e "${color}  start mysql service${nocolor}"
systemctl enable mysql
systemctl restart mysql
stat_check $?
echo -e "${color} Setup mysql Password${nocolor}"
mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log
stat_check $?
