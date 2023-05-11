#!/usr/bin/python3
"""Fabric script that deletes out-of-date archives, using the function"""

from fabric.api import env, local
from os.path import exists
from datetime import datetime
from fabric.operations import run, put
from os.path import basename


env.hosts = ['54.209.182.89', '18.207.234.15']
env.user = 'ubuntu'
env.key_filename = '~/.ssh/school'


def do_pack():
    """Function to generate archive from web_static folder"""
    try:
        if not exists("versions"):
            local("mkdir -p versions")
        time_now = datetime.now().strftime("%Y%m%d%H%M%S")
        archive_path = "versions/web_static_{}.tgz".format(time_now)
        local("tar -cvzf {} web_static".format(archive_path))
        return archive_path
    except Exception:
        return None


def do_deploy(archive_path):
    """Function to distribute archive to web servers"""
    if not exists(archive_path):
        return False
    try:
        # Upload archive to /tmp/ directory on web server
        put(archive_path, "/tmp/")

        # Get the file name without extension
        file_name = basename(archive_path).replace(".tgz", "")

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


def deploy():
    """Function to deploy archive to web servers"""
    # Create archive from web_static folder
    archive_path = do_pack()

    # If archive was not created, return False
    if not archive_path:
        return False

    # Distribute archive to web servers
    result = do_deploy(archive_path)

    return result
