color="\e[35m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

nodejs() {
  echo -e "${color} Configuring NodeJs Repos${nocolor}"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file

  echo -e "${color} Installing NodeJs${nocolor}"
  yum install nodejs -y &>>$log_file

  echo -e "${color} Add Application User ${nocolor}"
  useradd roboshop &>>$log_file

  echo -e "${color} Create Application Directory ${nocolor}"
  rm -rf app_path &>>$log_file
  mkdir ${app_path} &>>$log_file

  echo -e "${color} Download Application Content${nocolor}"
  curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>$log_file
  cd ${app_path} &>>$log_file

  echo -e "${color} Extract Application content${nocolor}"
  unzip /tmp/$component.zip &>>$log_file
  cd ${app_path} &>>$log_file

  echo -e "${color} Installing nodeJs Dependinces${nocolor}"
  npm install &>>$log_file

  echo -e "${color} Setup systemD service ${nocolor}"
  cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>$log_file

  echo -e "${color} Start $component Service${nocolor}"
  systemctl daemon-reload &>>$log_file
  systemctl enable $component &>>$log_file
  systemctl restart $component &>>$log_file



}
mongo_schema_setup() {
  echo -e "${color} Copy mongodb repo file${nocolor}"
  cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>$log_file

  echo -e "${color} Install Mongodb client${nocolor}"
  yum install mongodb-org-shell -y &>>$log_file
  mongo --host mongodb-dev.chennadevops.online </app/schema/$component.js &>>$log_file
}

python() {
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

  echo -e "\e[33m Start SystemD services\e[0m"
  cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service
  echo -e "\e[33m Start payment service\e[0m"
  systemctl daemon-reload &>>/tmp/roboshop.log
  systemctl enable payment &>>/tmp/roboshop.log
  systemctl restart payment &>>/tmp/roboshop.log

}