source=common.sh

echo -e "${color} Copy Mongodb Repo File${nocolor}"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo
stat_check $?
echo -e "${color} installing Mongodb server${nocolor}"
yum install mongodb-org -y
stat_check $?
echo -e "${color}Update mongoDB listen Adress${nocolor}"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat_check $?
#modefiy the config file
echo -e "${color} Start Mongodb service${nocolor}"
systemctl enable mongod
systemctl restart mongod
stat_check $?