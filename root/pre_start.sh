su
apt update && apt upgrade -y && apt update --fix-missing && apt install neofetch nano git vim curl wget sudo tmate  -y
curl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /usr/bin/systemctl && chmod +x /usr/bin/systemctl
echo "-: Package and Sudo setup complete. :-"
