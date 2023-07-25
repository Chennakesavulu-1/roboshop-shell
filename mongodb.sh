echo -e "\e[33m Copy Mongodb Repo File\e[0m"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo
echo -e "\e[33m installing Mongodb server\e[0m"
yum install mongodb-org -y
echo -e "\e[33mUpdate mongoDB listen Adress\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

#modefiy the config file
echo -e "\e[33m Start Mongodb service\e[0m"
systemctl enable mongod
systemctl restart mongod