#!/bin/sh

#add auto start

INODE_CFG="/etc/iNode/inodesys.conf"
if [ -r "$INODE_CFG" ]; then
    LINE=`cat $INODE_CFG`
    INSTALL_DIR=${LINE##*INSTALL_DIR=}
    if [ ! -r "$INSTALL_DIR" ]; then
        echo "INSTALL_DIR is not exist"
        exit 0
    fi
else
   echo "iNode is not installed"
   exit 0
fi

GNOME_DIR="/usr/share/gnome/autostart"
KDE_DIR="/usr/share/autostart"
DESKTOP=0

if [ -d "$GNOME_DIR" ]; then
    cp -fr $INSTALL_DIR/iNodeClient.desktop $GNOME_DIR
    DESKTOP=1
fi
if [ -d "$KDE_DIR" ]; then
    cp -fr $INSTALL_DIR/iNodeClient.desktop $KDE_DIR
    DESKTOP=1
fi

if [ $DESKTOP -eq 1 ]; then
    exit 0
fi


OS_UBUNTU=`cat /etc/issue | grep 'Ubuntu'`
OS_ROCKY=`cat /etc/issue | grep 'Rocky'`

if [ "$OS_UBUNTU" != "" ]; then

	USERDIRLIST=`cat /etc/passwd|awk -F : '$3>=1000 && $3<65534 || $3==0 {print $6}'`
	for temp in $USERDIRLIST
	do
    	USER="$temp/.profile"
    	if [ -f "$USER" ]
    	then
        	STR=`cat $USER |grep 'iNodeClient.sh'`
        	if [ "$STR" = "" ]; then
          	echo "$INSTALL_DIR/iNodeClient.sh" >> $USER
        	fi
        
    	fi
	done
	
elif [ "$OS_ROCKY" != "" ]; then

	USERDIRLIST=`cat /etc/passwd|awk -F : '$3>=500 && $3<65534 || $3==0 {print $6}'`
	for temp in $USERDIRLIST
	do
    	USER="$temp/.profile"
    	if [ -f "$USER" ]
    	then
        	STR=`cat $USER |grep 'iNodeClient.sh'`
        	if [ "$STR" = "" ]; then
          	echo "$INSTALL_DIR/iNodeClient.sh" >> $USER
        	fi
        
    	fi
	done

else

	USERDIRLIST=`cat /etc/passwd|awk -F : '$3>=500 && $3<65534 || $3==0 {print $6}'`
	for temp in $USERDIRLIST
	do
    	USER="$temp/.bash_profile"
    	if [ -f "$USER" ]
    	then
        	STR=`cat $USER |grep 'iNodeClient.sh'`
        	if [ "$STR" = "" ]; then
          	echo "$INSTALL_DIR/iNodeClient.sh" >> $USER
        	fi
        
    	fi
	done

fi
