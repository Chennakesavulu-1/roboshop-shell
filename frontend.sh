echo -e "\e[33m Installing nginx Server\e[0m"
yum install nginx -y



echo -e "\e[33m Removing old App content\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[33m Download Frontend Contend\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo -e "\e[33m Extrated Frontend Content\e[0m"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip
echo -e "\e[33m Update Frontend Configuration\e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf

#we need to copy config file here
systemctl enable nginx
systemctl restart nginx


