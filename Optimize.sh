#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
cat << "EOF"
                                     
________            _____        
___  __/___  _________  /____  __
__  /  _  / / /  __ \  __/  / / /
_  /   / /_/ // /_/ / /_ / /_/ / 
/_/    \__,_/ \____/\__/ \__,_/  
                                      

EOF
echo "Ssmgr node server installation script for Ubuntu18.04 and Debian 9"
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }
echo "Press Y for continue the installation process, or press any key else to exit."
read is_install
if [[ is_install =~ ^[Y,y,Yes,YES]$ ]]
then
	echo "Bye"
	exit 0
fi
echo "Update exsit package..."
apt-get update
echo "Install package..."
export DEBIAN_FRONTEND=noninteractive
apt-get install tzdata iproute2 curl git sudo software-properties-common -y
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs shadowsocks-libev
npm i -g shadowsocks-manager --unsafe-perm
npm install pm2 -g
echo "Asia/Shanghai" > /etc/timezone
rm /etc/localtime && \
dpkg-reconfigure -f noninteractive tzdata
echo "Optimize the shadowsocks server..."
cat >> /etc/security/limits.conf << EOF
* soft nofile 51200
* hard nofile 51200
EOF
ulimit -n 51200
cat >> /etc/sysctl.conf << EOF
fs.file-max = 51200
net.core.default_qdisc = fq
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mem = 25600 51200 102400
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_congestion_control = bbr
EOF
sysctl -p