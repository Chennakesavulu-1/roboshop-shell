echo -e "\e[33m Copy Mongodb Repo File\e[0m"
cp mongodb.repo /etc/yum.repos.d/mongodb.repo
echo -e "\e[33m installing Mongodb server\e[0m"
yum install mongodb-org -y

#modefiy the config file
echo -e "\e[33m Start Mongodb service\e[0m"
systemctl enable mongod
systemctl restart mongod