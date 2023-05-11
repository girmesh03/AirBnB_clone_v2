#!/usr/bin/env bash
# Prepare Web Server for deployment of web_static

apt-get update
apt-get install -y nginx

mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/

echo "
<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>
" > /data/web_static/releases/test/index.html

sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

chown -R ubuntu:ubuntu /data/

web_static="\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current;\n\t\tindex index.html index.htm index.nginx-debian.html;\n\t}"
sed -i "/server_name _;/a\\$web_static" /etc/nginx/sites-available/default

# Restart nginx
service nginx restart
