#! /bin/bash

echo "--------------Termux一键安装内网穿透开始！！！------------
--------------------------------------------------------------------------------------------------------------------------------"
sleep 1
echo "------------------开始将源文件更换为清华源----------------"
#换源
echo "deb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main" > /data/data/com.termux/files/usr/etc/apt/sources.list

echo "deb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable" > /data/data/com.termux/files/urs/etc/apt/sources.list.d/science.list

echo "deb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable" > /data/data/com.termux/files/urs/etc/apt/sources.list.d/science.list


echo "-------------------开始安装基本工具---------------------------------------------------------------------------------------"
#安装基本工具
pkg update -y
pkg install vim -y
pkg install curl -y
okg install wget -y
pkg install git -y 
pkg install tree -y
termux-auth -y


#改密码
flag=1
while [ $flag -eq 1 ];do
	read -s -p "请输入密码：" p1

	read -s -p "请再一次输入密码：" p2
	if [ $p1 == $p2 ];then
		break;
	else
		echo "两次密码不一致！"
	fi
	#密码一致写入密码
	echo $p1 | passwd allenle --stdin
done

#安装openssh并开启ssh
pkg install openssh

sshd

echo "


openssh安装成功！
ssh已开启!每次重启需手动开启！
可使用ssh连接termux

"
sleep 1
#安装frp
mkdir frp && cd /data/data/com.termux/files/home/frp && wget https://qianqu.me/frp/frpc_linux_arm64 --no-check-certificate && chmod +x /data/data/com.termux/files/home/frp/frpc_linux_arm64

echo "frp安装完成"

#把文件名改短一点
mv /data/data/com.termux/files/home/frp/frpc_linux_arm64 frpc
cd /data/data/com.termux/files/home/frp

touch frpc.ini

echo "根据网站的配置文件，请依次输入配置信息


"

read  -p "隧道名称：" compression
read  -p "server_addr:" addr
read  -p "userid:" user
read  -p "type:" type1
read  -p "local_ip:" ip
read  -p "port:" port
read  -p "绑定的域名：" domains


echo  "[common]
server_addr = $addr
server_port = 7000
tcp_mux = ture
pool_count = 1
protocol = tcp
user = $user
token = SakuraFrpClienToken
dns_server = 114.114.114.114

[$compression]
privilege_mode = true
type = http
local_ip = $ip
local_port = $port
custom_domains =$domains
use_encryption = false
use_compression = true" > /data/data/com.termux/files/home/frp/frpc.ini


echo "脚本结束！！！

-----------------------简易操作指令-----------------------------1.开启ssh             sshd
2.开启frp内网穿透     ./frpc(必须在frp目录下使用)
3.回到home目录        cd
4.查看目录下文件或路径 ls

ps:配置信息有误时可在/frp/frpc.ini中更改"


sleep 2

./frpc
