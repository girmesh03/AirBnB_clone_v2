#!/usr/bin/python3
"""Fabric script that distributes an archive to your web servers,
using the function do_deploy."""

from fabric.api import env, put, run
from os.path import exists
import re


env.hosts = ['100.25.167.139', '54.172.232.30']


def do_deploy(archive_path):
    """Function to distribute archive to web servers"""
    if not exists(archive_path):
        return False
    try:
        # Upload archive to /tmp/ directory on web server
        put(archive_path, "/tmp/")

        # Get the file name without extension
        file_name = re.search(r'\/([^.\/]+)\.tgz$', archive_path).group(1)

        # Create directory to uncompress archive if it doesn't exist
        run("sudo mkdir -p /data/web_static/releases/{}/".format(file_name))

        # Uncompress archive to /data/web_static/releases/ directory
        run("sudo tar -xzf /tmp/{}.tgz -C \
            /data/web_static/releases/{}/".format(file_name, file_name))

        # Delete archive from web server
        run("sudo rm /tmp/{}.tgz".format(file_name))

        # Move contents of web_static directory up one level
        run("sudo mv /data/web_static/releases/{}/web_static/* \
            /data/web_static/releases/{}/".format(file_name, file_name))

        # Remove the web_static directory
        run("sudo rm -rf \
            /data/web_static/releases/{}/web_static".format(file_name))

        # Delete symbolic link if it exists
        run("sudo rm -rf /data/web_static/current")

        # Create new symbolic link
        run("sudo ln -s /data/web_static/releases/{}/ \
             /data/web_static/current".format(file_name))

        print("New version deployed!")
        return True
    except Exception:
        return False
