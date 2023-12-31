source=common.sh

echo -e "${color} Installing nginx Server${nocolor}"
yum install nginx -y &>>$log_file
stat_check $?

echo -e "${color} Removing old App content${nocolor}"
rm -rf /usr/share/nginx/html/* &>>$log_file
stat_check $?

echo -e "${color} Download Frontend Contend${nocolor}"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
stat_check $?


echo -e "${color} Extrated Frontend Content${nocolor}"
stat_check $?

cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
stat_check $?


echo -e "${color} Update Frontend Configuration${nocolor}"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
stat_check $?

#we need to copy config file here
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
stat_check $?


