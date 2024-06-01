#!/bin/sh
echo "Running pre-start script..."
# 在这里添加你想要运行的命令
apt update
apt install sudo
sudo apt-get install locales
sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8
