#!/bin/sh

ROOTFS_DIR=$(pwd)
export PATH=$PATH:~/.local/usr/bin
max_retries=50
timeout=1
ARCH=$(uname -m)

# 确定 CPU 架构
if [ "$ARCH" = "x86_64" ]; then
  ARCH_ALT=amd64
elif [ "$ARCH" = "aarch64" ]; then
  ARCH_ALT=arm64
else
  printf "Unsupported CPU architecture: ${ARCH}\n"
  exit 1
fi

# 检查是否已经安装
if [ ! -e "$ROOTFS_DIR/.installed" ]; then
  echo "#######################################################################################"
  echo "#"
  echo "#                                      Foxytoux INSTALLER"
  echo "#"
  echo "#                           Copyright (C) 2024, RecodeStudios.Cloud"
  echo "#"
  echo "#"
  echo "#######################################################################################"
  
  install_ubuntu=YES
fi

case $install_ubuntu in
  [yY][eE][sS])
    wget --tries=$max_retries --timeout=$timeout --no-hsts -O /tmp/rootfs.tar.gz \
      "http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.4-base-${ARCH_ALT}.tar.gz"
    tar -xf /tmp/rootfs.tar.gz -C $ROOTFS_DIR
    ;;
  *)
    echo "Skipping Ubuntu installation."
    ;;
esac

# 安装 proot
if [ ! -e "$ROOTFS_DIR/.installed" ]; then
  mkdir -p "$ROOTFS_DIR/usr/local/bin"
  wget --tries=$max_retries --timeout=$timeout --no-hsts -O "$ROOTFS_DIR/usr/local/bin/proot" "https://raw.githubusercontent.com/foxytouxxx/freeroot/main/proot-${ARCH}"

  while [ ! -s "$ROOTFS_DIR/usr/local/bin/proot" ]; do
    rm -f "$ROOTFS_DIR/usr/local/bin/proot"
    wget --tries=$max_retries --timeout=$timeout --no-hsts -O "$ROOTFS_DIR/usr/local/bin/proot" "https://raw.githubusercontent.com/foxytouxxx/freeroot/main/proot-${ARCH}"

    if [ -s "$ROOTFS_DIR/usr/local/bin/proot" ]; then
      chmod 755 "$ROOTFS_DIR/usr/local/bin/proot"
      break
    fi

    chmod 755 "$ROOTFS_DIR/usr/local/bin/proot"
    sleep 1
  done

  chmod 755 "$ROOTFS_DIR/usr/local/bin/proot"
fi

# 设置 DNS 并标记已安装
if [ ! -e "$ROOTFS_DIR/.installed" ]; then
  printf "nameserver 1.1.1.1\nnameserver 1.0.0.1" > "${ROOTFS_DIR}/etc/resolv.conf"
  rm -rf /tmp/rootfs.tar.gz
  touch "$ROOTFS_DIR/.installed"
fi

# 创建预启动脚本
cat << 'EOF' > ${ROOTFS_DIR}/root/pre_start.sh
#!/bin/sh
echo "Running pre-start script..."
# 在这里添加你想要运行的命令
EOF

chmod +x ${ROOTFS_DIR}/root/pre_start.sh

# 颜色设置
CYAN='\e[0;36m'
WHITE='\e[0;37m'
RESET_COLOR='\e[0m'

# 显示完成信息
display_gg() {
  echo -e "${WHITE}___________________________________________________${RESET_COLOR}"
  echo -e ""
  echo -e "           ${CYAN}-----> Mission Completed ! <----${RESET_COLOR}"
}

clear
display_gg

# 启动 proot 环境并执行预启动脚本
$ROOTFS_DIR/usr/local/bin/proot \
  --rootfs="${ROOTFS_DIR}" \
  -0 -w "/root" -b /dev -b /sys -b /proc -b /etc/resolv.conf --kill-on-exit \
  /bin/sh -c "/root/pre_start.sh; exec /bin/bash"
