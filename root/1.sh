apt update
apt install -y sudo
apt install -y locales
locale-gen zh_CN.UTF-8
update-locale LANG=zh_CN.UTF-8
apt install -y dialog apt-utils
apt update && apt upgrade -y
apt install -y neofetch nano git vim curl wget sudo tmate && neofetch
echo "-: Package and Sudo setup complete. :-"
