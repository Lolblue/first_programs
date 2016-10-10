#!/bin/bash

# Install of Nginx
kibana_conf="/etc/nginx/conf.d/kibana.conf"
systemctl stop httpd
systemctl disable httpd
yum remove nginx httpd-tools

yum -y install epel-release
yum -y install nginx httpd-tools

# set user/password in HTTP password file.  Create the password file if it does not exist
htpasswd -b -c /etc/nginx/htpasswd.users kibanaadmin Top_labmix

cp /etc/nginx/nginx.conf /etc/nginx/nginx.confbk
sed '/server {/,$ d' /etc/nginx/nginx.conf | tee /etc/nginx/nginx_conf7
echo "}" >> /etc/nginx/nginx_conf7
cp /etc/nginx/nginx_conf7 /etc/nginx/nginx.conf
touch /etc/nginx/conf.d/kibana.conf
# echo contents into file
 
echo "server {" > $kibana_conf
echo -e '\t listen 80;' >> $kibana_conf
echo -e '\t server_name localhost;' >> $kibana_conf
echo -e '\t auth_basic "Restricted Access";' >> $kibana_conf
echo -e '\t auth_basic_user_file /etc/nginx/htpasswd.users;' >> $kibana_conf
echo -e '\t location / {' >> $kibana_conf
echo -e '\t \t proxy_pass http://localhost:5601;' >> $kibana_conf
echo -e '\t \t proxy_http_version 1.1;' >> $kibana_conf
echo -e '\t \t proxy_set_header Upgrade $http_upgrade;' >> $kibana_conf
echo -e '\t \t proxy_set_header Connection 'upgrade';' >> $kibana_conf
echo -e '\t \t proxy_set_header Host $host;' >> $kibana_conf
echo -e '\t \t proxy_cache_bypass $http_upgrade;' >> $kibana_conf
echo -e '\t }' >> $kibana_conf
echo -e '}' >> $kibana_conf
 
systemctl start nginx
systemctl enable nginx

exit


