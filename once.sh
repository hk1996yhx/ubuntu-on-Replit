apt update
apt upgrade -y
apt update --fix-missing
apt install -y sudo
apt update
apt install -y apt-utils 
apt update
apt install -y nano  vim curl wget git
apt update
apt install -y   neofetch tmate
curl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /usr/bin/systemctl && chmod +x /usr/bin/systemctl
echo "-: Package and Sudo setup complete. :-"
