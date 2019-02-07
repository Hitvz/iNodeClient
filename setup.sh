#!/bin/sh

filepath=$(cd "$(dirname "$0")"; pwd)

echo "当前路径：$filepath"

sudo dpkg -i ./lib/libpng12-0_1.2.54-1ubuntu1_amd64.deb
sudo apt-get install libncurses5

if [ ! -d "/usr/iNodeClient" ] ; then
	echo "正在复制文件\n"
	sudo cp -fr $filepath/iNodeClient /usr/ -r
	echo "文件复制完成\n"
else
	echo "文件已存在，不需要复制\n"
fi

sudo chmod -R 777 /usr/iNodeClient
echo "\n文件提高权限完成\n"

if [ ! -f "/usr/iNodeClient/install.sh" ] ; then
	echo "install.sh文件不存在\n"
else
	echo "install.sh文件存在，执行安装"
	cd /usr/iNodeClient/
	sudo sh install.sh
fi

echo "按a查看程序依赖关系，其他键继续"
read stringA 

if [ "$stringA" = "a" ];then
#	echo "相等"
	if [ -f "/usr/iNodeClient/.iNode/iNodeClient" ];then
		sudo cp /usr/iNodeClient/.iNode/iNodeClient /usr/iNodeClient/
		ldd /usr/iNodeClient/iNodeClient
#		eval "ldd /usr/iNodeClient/iNodeClient"
		sudo rm /usr/iNodeClient/iNodeClient
		echo "若发现xxx.so => not found，说明iNodeClient用不了，这时，请百度吧"
	fi

else
	echo "继续"
fi

sudo chmod -R 777 /usr/iNodeClient

echo "\n正在重启服务让iNodeClient对网卡识别生效"

/etc/init.d/iNodeAuthService restart


sudo cp /usr/iNodeClient/iNodeClient.desktop /usr/share/applications/iNodeClient.desktop
echo "\n创建启动器快捷方式，成功"

echo "\n安装完毕,按任意键退出安装"

read waitkey
