#!/bin/sh
echo "Running pre-start script..."
# 在这里添加你想要运行的命令
apt update
apt install -y sudo
apt install -y locales
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8
apt update
apt install -y dialog apt-utils
