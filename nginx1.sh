#!/bin/bash

# Install of Nginx
fileD="/etc/nginx/sites-available/default
http_upgrade="one"
host=two

sudo yum install nginx apache2-utils

# wait for command to complete
sleep 10

# set user/password in HTTP password file.  Create the password file if it does not exist
htpasswd -b -c /etc/nginx/htpasswd.users kibanaadmin Top_labmix

# empty contents of file, then write new lines to file
truncate -s 0 /etc/nginx/sites-available/default
fileD="/etc/nginx/htpasswd.users"

echo "server {" > $fileD
echo -e '\t listen 80;' >> $fileD
echo -e '\t server_name example.com;' >> $fileD
echo -e '\t auth_basic "Restricted Access";' >> $fileD
echo -e '\t auth_basic_user_file /etc/nginx/htpasswd.users;' >> $fileD
echo -e '\t location / {' >> $fileD
echo -e '\t \t proxy_pass http://localhost:5601;' >> $fileD
echo -e '\t \t proxy_http_version 1.1;' >> $fileD
echo -e '\t \t proxy_set_header Upgrade $http_upgrade;' >> $fileD
echo -e '\t \t proxy_set_header Connection 'upgrade';' >> $fileD
echo -e '\t \t proxy_set_header Host $host;' >> $fileD
echo -e '\t \t proxy_cache_bypass $http_upgrade;' >> $fileD
echo -e '\t }' >> $fileD
echo -e '}' >> $fileD

Sed -i 's/example.com/myserver/g' /etc/nginx/sites-available/default

sudo servie nginx restart
