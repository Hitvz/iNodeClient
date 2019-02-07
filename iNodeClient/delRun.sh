#!/bin/sh

#delete auto start

GNOME_DIR="/usr/share/gnome/autostart"
KDE_DIR="/usr/share/autostart"

if [ -d "$GNOME_DIR" ]; then
    rm -fr $GNOME_DIR/iNodeClient.desktop
fi
if [ -d "$KDE_DIR" ]; then
    rm -fr $KDE_DIR/iNodeClient.desktop
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
        	sed -i '/iNodeClient.sh/d' $USER
    	fi
	done
	
elif [ "$OS_ROCKY" != "" ]; then

	USERDIRLIST=`cat /etc/passwd|awk -F : '$3>=500 && $3<65534 || $3==0 {print $6}'`
	for temp in $USERDIRLIST
	do
    	USER="$temp/.profile"
    	if [ -f "$USER" ]
    	then
        	sed -i '/iNodeClient.sh/d' $USER
    	fi
	done
	
else

	USERDIRLIST=`cat /etc/passwd|awk -F : '$3>=500 && $3<65534 || $3==0 {print $6}'`
	for temp in $USERDIRLIST
	do
    	USER="$temp/.bash_profile"
    	if [ -f "$USER" ]
    	then
        	sed -i '/iNodeClient.sh/d' $USER
    	fi
	done
	
fi
