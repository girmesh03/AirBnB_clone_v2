#!/usr/bin/env bash
# Prepare Web Server for deployment of web_static

sudo apt-get update
sudo apt-get install -y nginx

sudo rm -rf /etc/nginx/sites-available/default
sudo rm -rf /etc/nginx/sites-enabled/default

sudo cp -r default_server_block_copy /etc/nginx/sites-available/default
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

echo "Hello World!" > /var/www/html/index.html
echo "Ceci n'est pas une page" > /var/www/html/404.html
ufw allow 'Nginx HTTP'

# Create a redirection
redirect="\n\tlocation /redirect_me {\n\t\treturn 301 https://youtu.be/dQw4w9WgXcQ;\n\t}"
sudo sed -i "/server_name _;/a\\$redirect" /etc/nginx/sites-available/default

# custom 404 page
custom_error_page="\n\terror_page 404 /404.html;\n\tlocation = /404.html {\n\t\troot /var/www/html;\n\t\tinternal;\n\t}"
sudo sed -i "/server_name _;/a\\$custom_error_page" /etc/nginx/sites-available/default

mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/

echo "Holberton School" > /data/web_static/releases/test/index.html

sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

chown -R ubuntu:ubuntu /data/

web_static="\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current;\n\t\tindex index.html index.htm index.nginx-debian.html;\n\t}"
sudo sed -i "/server_name _;/a\\$web_static" /etc/nginx/sites-available/default

# Restart nginx
sudo service nginx restart
