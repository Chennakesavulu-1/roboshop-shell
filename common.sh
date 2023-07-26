color="\e[35m"
nocolor="${nocolor}"
log_file="$log_file"
app_path="/app"

app_presetup() {
  echo -e "${color} Add Application User ${nocolor}"
  useradd roboshop &>>$log_file
  if [ $? -eq 0 ]; then
    echo Sucess
  else
    echo Failure
  fi


  echo -e "${color} Create application directory${nocolor}"
  rm -rf /app &>>$log_file &>>$log_file
  mkdir /app &>>$log_file &>>$log_file
  if [ $? -eq 0 ]; then
      echo Sucess
    else
      echo Failure
    fi

  echo -e "${color} Download Application Content${nocolor}"
  curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>$log_file
  cd ${app_path} &>>$log_file
  if [ $? -eq 0 ]; then
      echo Sucess
    else
      echo Failure
    fi

  echo -e "${color} Extract Application content${nocolor}"
  unzip /tmp/$component.zip &>>$log_file
  cd ${app_path} &>>$log_file
  echo $?

}

systemd_setup() {
  echo -e "${color} Setup systemD service ${nocolor}"
  cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>$log_file
  if [ $? -eq 0 ]; then
      echo Sucess
    else
      echo Failure
    fi

  echo -e "${color} Start $component Service${nocolor}"
  systemctl daemon-reload &>>$log_file
  systemctl enable $component &>>$log_file
  systemctl restart $component &>>$log_file
  if [ $? -eq 0 ]; then
      echo Sucess
    else
      echo Failure
    fi
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
  yum install mysql -y &>>$log_file &>>$log_file

  echo -e "${color} Load schema${nocolor}"
  mysql -h mysql-dev.chennadevops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>$log_file &>>$log_file

}

maven() {
  echo -e "${color} Install MAVEN ${nocolor}"
  yum install maven -y &>>$log_file &>>$log_file

  app_presetup

  echo -e "${color} Download application content ${nocolor}"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file &>>$log_file
  cd ${app_path}

  echo -e "${color} Download maven dependencies${nocolor}"
  mvn clean package &>>$log_file


  mv target/${component}-1.0.jar ${component}.jar &>>$log_file &>>$log_file

  mysql_schema_setup

  systemd_setup
}

python() {
  echo -e "${color} Install Python${nocolor}"
  yum install python36 gcc python3-devel -y &>>$log_file
  if [ $? -eq 0 ]; then
      echo Sucess
    else
      echo Failure
    fi

  app_presetup

  echo -e "${color} Install application dependencies${nocolor}"
  cd /app
  pip3.6 install -r requirements.txt &>>$log_file
  if [ $? -eq 0 ]; then
      echo Sucess
    else
      echo Failure
    fi

  systemd_setup

}