#!/usr/bin/env bash
# ABash script that sets up your web servers for the deployment of web_static.

sudo apt-get update -y
sudo apt-get install nginx -y

# create directories
sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/

# Create a fake HTML file
echo "Alx School" > /data/web_static/releases/test/index.html

# if file called current exists, delete it
sudo rm -rf /data/web_static/current

# Create a symbolic link
sudo ln -s /data/web_static/releases/test/ /data/web_static/current

# Give ownership of the /data/ folder to the ubuntu user AND group
sudo chown -R ubuntu:ubuntu /data/

# Update the Nginx configuration to serve the content of /data/web_static/current/ to hbnb_static
sudo sed -i "16i\ \n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}" /etc/nginx/sites-available/default

# restart nginx
sudo service nginx restart
