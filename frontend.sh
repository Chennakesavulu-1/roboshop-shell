yum install nginx -y




rm -rf /usr/share/nginx/html/*

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

vim /etc/nginx/default.d/roboshop.conf


#we need to copy config file here
systemctl enable nginx
systemctl restart nginx

