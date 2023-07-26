color="\e[35m"
nocolor="${nocolor}"
log_file="/tmp/roboshop.log"
app_path="/app"

app_presetup() {
  echo -e "${color} Add Application User ${nocolor}"
  useradd roboshop &>>$log_file

  echo -e "${color} Create application directory${nocolor}"
  rm -rf /app &>>/tmp/roboshop.log &>>$log_file
  mkdir /app &>>/tmp/roboshop.log &>>$log_file

  echo -e "${color} Download Application Content${nocolor}"
  curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>$log_file
  cd ${app_path} &>>$log_file

  echo -e "${color} Extract Application content${nocolor}"
  unzip /tmp/$component.zip &>>$log_file
  cd ${app_path} &>>$log_file

}

systemd_setup() {
  echo -e "${color} Setup systemD service ${nocolor}"
  cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>$log_file

  echo -e "${color} Start $component Service${nocolor}"
  systemctl daemon-reload &>>$log_file
  systemctl enable $component &>>$log_file
  systemctl restart $component &>>$log_file
}

nodejs() {
  echo -e "${color} Configuring NodeJs Repos${nocolor}"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file

  echo -e "${color} Installing NodeJs${nocolor}"
  yum install nodejs -y &>>$log_file

  app_presetup

  echo -e "${color} Installing nodeJs Dependinces${nocolor}"
  npm install &>>$log_file

  systemd_setup

}


mongo_schema_setup() {
  echo -e "${color} Copy mongodb repo file${nocolor}"
  cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>$log_file

  echo -e "${color} Install Mongodb client${nocolor}"
  yum install mongodb-org-shell -y &>>$log_file
  mongo --host mongodb-dev.chennadevops.online </app/schema/$component.js &>>$log_file
}

mysql_schema_setup(){
  echo -e "${color} Install mysql client${nocolor}"
  yum install mysql -y &>>/tmp/roboshop.log &>>$log_file

  echo -e "${color} Load schema${nocolor}"
  mysql -h mysql-dev.chennadevops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>/tmp/roboshop.log &>>$log_file

}

maven() {
  echo -e "${color} Install MAVEN ${nocolor}"
  yum install maven -y &>>/tmp/roboshop.log &>>$log_file

  app_presetup



  echo -e "${color} Download application content ${nocolor}"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>/tmp/roboshop.log &>>$log_file
  cd ${app_path}



  echo -e "${color} Download maven dependencies${nocolor}"
  mvn clean package &>>$log_file


  mv target/${component}-1.0.jar ${component}.jar &>>/tmp/roboshop.log &>>$log_file

  mysql_schema_setup



  systemd_setup
}

python() {
  echo -e "${color} Install Python${nocolor}"
  yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log
  echo -e "${color} Add user application${nocolor}"
  useradd roboshop &>>/tmp/roboshop.log
  echo -e "${color} make directory ${nocolor}"
  mkdir /app &>>/tmp/roboshop.log
  echo -e "${color} download application content${nocolor}"
  curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>/tmp/roboshop.log
  cd /app
  echo -e "${color} Extract zip file of payment${nocolor}"
  unzip /tmp/payment.zip &>>/tmp/roboshop.log

  echo -e "${color} Install application dependencies${nocolor}"
  cd /app
  pip3.6 install -r requirements.txt &>>/tmp/roboshop.log

  echo -e "${color} Start SystemD services${nocolor}"
  cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service
  echo -e "${color} Start payment service${nocolor}"
  systemctl daemon-reload &>>/tmp/roboshop.log
  systemctl enable payment &>>/tmp/roboshop.log
  systemctl restart payment &>>/tmp/roboshop.log

}