source=common.sh
echo -e "${color} Configuer Earlong service${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>/tmp/roboshop.log
stat_check $?
echo -e "${color} Configuer rabbitmq service${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>/tmp/roboshop.log
stat_check $?
echo -e "${color} Install rabbitmq service${nocolor}"
yum install rabbitmq-server -y &>>/tmp/roboshop.log
stat_check $?
echo -e "${color} Start rabbitmq service ${nocolor}"
systemctl enable rabbitmq-server &>>/tmp/roboshop.log
stat_check $?
systemctl restart rabbitmq-server
stat_check $?
echo -e "${color} rabbitmq appliction user${nocolor}"
rabbitmqctl add_user roboshop roboshop123 &>>/tmp/roboshop.log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/roboshop.log
stat_check $?
