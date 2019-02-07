#!/bin/sh

CURRENT=`pwd`

#check install path
CHECKRESULT=`echo $CURRENT|grep '[^a-zA-Z0-9/(){}_. -]'`
if [ "$CHECKRESULT" != "" ];then
    echo "Invalid iNode client installation directory name. "
    echo "The directory name can contain only upper-case/lower-case English letters, digits, spaces, and the following characters:(){}/._-."
    exit 0
fi

INODE_CFG="/etc/iNode/inodesys.conf"

#[ -r "$INODE_CFG" ] && . "${INODE_CFG}"
if [ -r "$INODE_CFG" ];then
    LINE=`cat $INODE_CFG`
    INSTALL_DIR=${LINE##*INSTALL_DIR=}
fi

if [ "$INSTALL_DIR" != "" ];then
    echo "iNode has been installed on the path $INSTALL_DIR."
    if [ "$INSTALL_DIR" != "$CURRENT" ]  
    then
        echo -n "This operation will remove iNode. Are you sure to continue?[input Y/y to continue]:"
	    read ISCONTINUE    
	    if [ "$ISCONTINUE" != "Y" -a "$ISCONTINUE" != "y" ]; then                   
	        exit 0        
	    fi
	    cd "$INSTALL_DIR"        
	    ./uninstall.sh
	    cd "$CURRENT"
	    INSTALL_DIR=""
    else  
        exit 0
    fi        
fi

IfExistMon=`ps awx -o command|awk -F/ '{print $NF}'|grep -x iNodeMon`
if [ "$IfExistMon" != "" ]
then
    if [ -n "$INSTALL_DIR" ]
    then
        "$INSTALL_DIR/iNodeMon" -k
    fi
        
    Sec=0
    while [ 1 ]
    do
        IfExistMon=`ps awx -o command|awk -F/ '{print $NF}'|grep -x iNodeMon`
	if [ "$IfExistMon" != "" ]
        then
	    sleep 1
	    Sec=`expr $Sec + 1`

	    if [ "$Sec" -gt 10 ]
	    then
	        killall -9 iNodeMon
	    fi
	else
	    break
	fi
    done
fi

IfExistAuth=`ps awx -o command|awk -F/ '{print $NF}'|grep -x AuthenMngService`
if [ "$IfExistAuth" != "" ]
then
    if [ -n "$INSTALL_DIR" ]
    then
        "$INSTALL_DIR/AuthenMngService" -k
    fi
    
    Sec=0
    while [ 1 ]
    do
        IfExistAuth=`ps awx -o command|awk -F/ '{print $NF}'|grep -x AuthenMngService`
	if [ "$IfExistAuth" != "" ]
        then
	    sleep 1
	    Sec=`expr $Sec + 1`

	    if [ "$Sec" -gt 10 ]
	    then
	        killall -9 AuthenMngService
	    fi
	else
	    break
	fi
    done
fi

IfExistUI=`ps awx -o command|awk -F/ '{print $NF}'|grep -x iNodeClient`
if [ "$IfExistUI" != "" ]
then
    sleep 3
    killall -9 iNodeClient
fi

if [ ! -r "/etc/iNode" ]
then
mkdir /etc/iNode
fi

if [ ! -r "./clientfiles" ]
then
mkdir ./clientfiles
fi

if [ ! -r "./conf" ]
then
mkdir ./conf
fi

if [ ! -r "./log" ]
then
mkdir ./log
fi

INODE_CFG="/etc/iNode/inodesys.conf"

#-r "$INODE_CFG" ] && . "${INODE_CFG}"
if [ -r "$INODE_CFG" ];then
    LINE=`cat $INODE_CFG`
    INSTALL_DIR=${LINE##*INSTALL_DIR=}
fi

if [ -z "$INSTALL_DIR" ]; then
    echo INSTALL_DIR=$CURRENT >> /etc/iNode/inodesys.conf
fi


OS_LINX=`cat /etc/issue | grep 'Linx'`

if [ "$OS_LINX" != "" ]
then
    cp -fr ./libs/wxWidgets/* /usr/lib64/
    cp -fr ./libs/ace/* /usr/lib64/
    cp -fr ./libs/opswat/* /usr/lib64/
    cp -fr ./libs/libInode* /usr/lib64/
    if [ ! -r "/usr/lib64/libtiff.so.3" ]
    then
        cp -fr ./libs/std/libtiff.so.3 /usr/lib64/libtiff.so.3
    fi
    if [ ! -r "/usr/lib64/libtiff.so.3.9.4" ]
    then
        cp -fr ./libs/std/libtiff.so.3.9.4 /usr/lib64/libtiff.so.3.9.4
    fi
    if [ ! -r "/usr/lib64/libstdc++.so.6" ]
    then
        cp -fr ./libs/std/libstdc++.so.6 /usr/lib64/libstdc++.so.6
    fi
    if [ ! -r "/usr/lib64/libstdc++.so.6.0.13" ]
    then
        cp -fr ./libs/std/libstdc++.so.6.0.13 /usr/lib64/libstdc++.so.6.0.13
    fi
    if [ ! -d "/var/lock/subsys" ]
    then
        mkdir -p /var/lock/subsys
    fi
elif [  -r "/usr/lib64" ]
then 
    if [ ! -r "/usr/lib64/libstdc++.so.6" ]
    then
        cp -fr ./libs/std/libstdc++.so.6 /usr/lib64/libstdc++.so.6
    fi
    if [ ! -r "/usr/lib64/libstdc++.so.6.0.13" ]
    then
        cp -fr ./libs/std/libstdc++.so.6.0.13 /usr/lib64/libstdc++.so.6.0.13
    fi
	  
    if [ ! -r "/usr/lib64/libtiff.so.3" ]
    then
        cp -fr ./libs/std/libtiff.so.3 /usr/lib64/libtiff.so.3
    fi
    if [ ! -r "/usr/lib64/libtiff.so.3.9.4" ]
    then
        cp -fr ./libs/std/libtiff.so.3.9.4 /usr/lib64/libtiff.so.3.9.4
    fi
    if [ ! -r "/usr/lib64/libpangox-1.0.so.0" ]
    then
        cp -fr ./libs/std/libpangox-1.0.so.0 /usr/lib64/libpangox-1.0.so.0
    fi
    
    if [ ! -r "/usr/lib64/libpng12.so" ]
    then
        cp -fr ./libs/std/libpng12.so /usr/lib64/libpng12.so
    fi
    if [ ! -r "/usr/lib64/libpng12.so.0" ]
    then
        cp -fr ./libs/std/libpng12.so.0 /usr/lib64/libpng12.so.0
    fi
    if [ ! -r "/usr/lib64/libpng12.so.0.44.0" ]
    then
        cp -fr ./libs/std/libpng12.so.0.44.0 /usr/lib64/libpng12.so.0.44.0
    fi

    rm -f /usr/lib64/libwx_base-2.8.so.0
    rm -f /usr/lib64/libwx_base_net-2.8.so.0
    rm -f /usr/lib64/libwx_base_xml-2.8.so.0
    rm -f /usr/lib64/libwx_gtk2_adv-2.8.so.0
    rm -f /usr/lib64/libwx_gtk2_aui-2.8.so.0
    rm -f /usr/lib64/libwx_gtk2_core-2.8.so.0
    rm -f /usr/lib64/libwx_gtk2_html-2.8.so.0
    rm -f /usr/lib64/libwx_gtk2_qa-2.8.so.0
    rm -f /usr/lib64/libwx_gtk2_richtext-2.8.so.0
    rm -f /usr/lib64/libwx_gtk2_xrc-2.8.so.0
    cp -fr ./libs/wxWidgets/* /usr/lib64/

    rm -f /usr/lib64/libACE-6.2.0.so 
    rm -f /usr/lib64/libACEXML-6.2.0.so 
    rm -f /usr/lib64/libACEXML_Parser-6.2.0.so 
    cp -fr  ./libs/ace/* /usr/lib64/

    rm -f /usr/lib64/libCoreUtils.so
    rm -f /usr/lib64/libImplAv.so
    rm -f /usr/lib64/libImplFw.so
    rm -f /usr/lib64/libImplPatchManagement.so
    rm -f /usr/lib64/libOesisCore.so
    cp -fr ./libs/opswat/* /usr/lib64/

    rm -f /usr/lib64/libInodeUtility.so
    rm -f /usr/lib64/libInodePortalPt.so
    rm -f /usr/lib64/libInodeX1Pt.so
    rm -f /usr/lib64/libInodeSecurityAuth.so
    cp -fr ./libs/libInode* /usr/lib64/
    
        if [ ! -r "/usr/lib/libstdc++.so.6" ]
	then
	cp -fr ./libs/std/libstdc++.so.6 /usr/lib/
	fi
	if [ ! -r "/usr/lib/libstdc++.so.6.0.13" ]
	then
	cp -fr ./libs/std/libstdc++.so.6.0.13 /usr/lib/libstdc++.so.6.0.13
	fi
	  
	if [ ! -r "/usr/lib/libtiff.so.3" ]
	then
	cp -fr ./libs/std/libtiff.so.3 /usr/lib/libtiff.so.3
	fi
	if [ ! -r "/usr/lib/libtiff.so.3.9.4" ]
	then
	cp -fr ./libs/std/libtiff.so.3.9.4 /usr/lib/libtiff.so.3.9.4
	fi

	rm -f /usr/lib/libwx_base-2.8.so.0
	rm -f /usr/lib/libwx_base_net-2.8.so.0
	rm -f /usr/lib/libwx_base_xml-2.8.so.0
	rm -f /usr/lib/libwx_gtk2_adv-2.8.so.0
	rm -f /usr/lib/libwx_gtk2_aui-2.8.so.0
	rm -f /usr/lib/libwx_gtk2_core-2.8.so.0
	rm -f /usr/lib/libwx_gtk2_html-2.8.so.0
	rm -f /usr/lib/libwx_gtk2_qa-2.8.so.0
	rm -f /usr/lib/libwx_gtk2_richtext-2.8.so.0
	rm -f /usr/lib/libwx_gtk2_xrc-2.8.so.0
	cp -fr ./libs/wxWidgets/* /usr/lib/

	rm -f /usr/lib/libACE-6.2.0.so 
	rm -f /usr/lib/libACEXML-6.2.0.so 
	rm -f /usr/lib/libACEXML_Parser-6.2.0.so 
	cp -fr  ./libs/ace/* /usr/lib/

	rm -f /usr/lib/libCoreUtils.so
	rm -f /usr/lib/libImplAv.so
	rm -f /usr/lib/libImplFw.so
	rm -f /usr/lib/libImplPatchManagement.so
	rm -f /usr/lib/libOesisCore.so
	cp -fr ./libs/opswat/* /usr/lib/

	rm -f /usr/lib/libInodeUtility.so
	rm -f /usr/lib/libInodePortalPt.so
	rm -f /usr/lib/libInodeX1Pt.so
	rm -f /usr/lib/libInodeSecurityAuth.so
	mv -f ./libs/libInode* /usr/lib/
	
else

	if [ ! -r "/usr/lib/libstdc++.so.6" ]
	then
	cp -fr ./libs/std/libstdc++.so.6 /usr/lib/
	fi
	if [ ! -r "/usr/lib/libstdc++.so.6.0.13" ]
	then
	cp -fr ./libs/std/libstdc++.so.6.0.13 /usr/lib/libstdc++.so.6.0.13
	fi
	  
	if [ ! -r "/usr/lib/libtiff.so.3" ]
	then
	cp -fr ./libs/std/libtiff.so.3 /usr/lib/libtiff.so.3
	fi
	if [ ! -r "/usr/lib/libtiff.so.3.9.4" ]
	then
	cp -fr ./libs/std/libtiff.so.3.9.4 /usr/lib/libtiff.so.3.9.4
	fi

	rm -f /usr/lib/libwx_base-2.8.so.0
	rm -f /usr/lib/libwx_base_net-2.8.so.0
	rm -f /usr/lib/libwx_base_xml-2.8.so.0
	rm -f /usr/lib/libwx_gtk2_adv-2.8.so.0
	rm -f /usr/lib/libwx_gtk2_aui-2.8.so.0
	rm -f /usr/lib/libwx_gtk2_core-2.8.so.0
	rm -f /usr/lib/libwx_gtk2_html-2.8.so.0
	rm -f /usr/lib/libwx_gtk2_qa-2.8.so.0
	rm -f /usr/lib/libwx_gtk2_richtext-2.8.so.0
	rm -f /usr/lib/libwx_gtk2_xrc-2.8.so.0
	cp -fr ./libs/wxWidgets/* /usr/lib/

	rm -f /usr/lib/libACE-6.2.0.so 
	rm -f /usr/lib/libACEXML-6.2.0.so 
	rm -f /usr/lib/libACEXML_Parser-6.2.0.so 
	cp -fr  ./libs/ace/* /usr/lib/

	rm -f /usr/lib/libCoreUtils.so
	rm -f /usr/lib/libImplAv.so
	rm -f /usr/lib/libImplFw.so
	rm -f /usr/lib/libImplPatchManagement.so
	rm -f /usr/lib/libOesisCore.so
	cp -fr ./libs/opswat/* /usr/lib/

	rm -f /usr/lib/libInodeUtility.so
	rm -f /usr/lib/libInodePortalPt.so
	rm -f /usr/lib/libInodeX1Pt.so
	rm -f /usr/lib/libInodeSecurityAuth.so
	mv -f ./libs/libInode* /usr/lib/

fi



sed -i "s:@INSTALL_PATH:$CURRENT:g" ./iNodeClient.desktop
sed -i "s:@INSTALL_PATH:$CURRENT:g" ./iNodeClient.sh

chmod 755 ./AuthenMngService
chmod 755 ./iNodeMon
chmod 755 ./renew.ps
chmod 755 ./enablecards.ps
chmod 755 ./iNodeClient.desktop
chmod 755 ./iNodeClient.sh
chmod 755 ./iNodeClient.sh
chmod 755 ./addRun.sh
chmod 755 ./delRun.sh
chmod 777 ./clientfiles
chmod 777 ./clientfiles/8021
chmod 777 ./clientfiles/5020
chmod -R 777 ./conf

OS_DEEPIN=`cat /etc/issue | grep 'Deepin'`
OS_UBUNTU=`cat /etc/issue | grep 'Ubuntu'`
OS_FEDORA=`cat /etc/issue | grep 'Fedora'`
OS_ROCKY=`cat /etc/issue | grep 'Rocky'`

if [ "$OS_FEDORA" != "" ]
then
    export PATH=$PATH:/sbin
fi

#照搬ubuntu配置
if [ "$OS_DEEPIN" != "" ]
then
    iNODE_SERVICE=`cat /etc/rc.local | grep 'iNodeAuthService'`
    if [ "$iNODE_SERVICE" = "" ]
    then
        mv -f ./iNodeAuthService_ubuntu /etc/init.d/iNodeAuthService
        chmod 755 /etc/init.d/iNodeAuthService
        rm -f ./iNodeAuthService
        cp -fr /etc/rc.local /etc/rc.local.bak
        sed -e '/^exit 0$/d' /etc/rc.local > /etc/rc.temp
        echo "/etc/init.d/iNodeAuthService start" >> /etc/rc.temp
        echo "exit 0" >> /etc/rc.temp
        mv -f /etc/rc.temp /etc/rc.local
        chmod 755 /etc/rc.local
    fi
    if [ ! -r "/usr/lib/libtiff.so.3" ] && [ ! -r "/usr/lib/x86_64-linux-gnu/libtiff.so.3" ]
    then
	echo "libtiff.so.3 not exitst copy now"
        cp -fr ./libs/std/libtiff.so.3 /usr/lib/libtiff.so.3
        cp -fr ./libs/std/libtiff.so.3 /usr/lib/x86_64-linux-gnu/libtiff.so.3  
    fi
    #直接复制过去，不加判断
    cp -fr ./libs/std/libtiff.so.3 /usr/lib/libtiff.so.3
    cp -fr ./libs/std/libtiff.so.3 /usr/lib/x86_64-linux-gnu/libtiff.so.3

    if [ ! -r "/usr/lib/x86_64-linux-gnu/libjpeg.so.62" ] && [ ! -r "/usr/lib/libjpeg.so.62" ]
    then
        ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so.8.0.2 /usr/lib/x86_64-linux-gnu/libjpeg.so.62
    fi
    > ./enablecards.ps
    update-rc.d iNodeAuthService defaults 80 01  > /dev/null 2>&1
else
    mv -f ./iNodeAuthService /etc/init.d
    chmod 755 /etc/init.d/iNodeAuthService
    rm -f ./iNodeAuthService_ubuntu
    if [ "$OS_ROCKY" = "" ]
    then
        chkconfig --add iNodeAuthService
        chkconfig --level 2345 iNodeAuthService on
        chkconfig --level 016 iNodeAuthService off
        chkconfig iNodeAuthService on
    else
        ln -s /etc/init.d/iNodeAuthService /etc/rc.d/rc3.d/S080iNodeAuthService > /dev/null 2>&1
        ln -s /etc/init.d/iNodeAuthService /etc/rc.d/rc5.d/S080iNodeAuthService > /dev/null 2>&1
        ln -s /etc/init.d/iNodeAuthService /etc/rc.d/rc0.d/K01iNodeAuthService > /dev/null 2>&1
        ln -s /etc/init.d/iNodeAuthService /etc/rc.d/rc1.d/K01iNodeAuthService > /dev/null 2>&1
        ln -s /etc/init.d/iNodeAuthService /etc/rc.d/rc2.d/K01iNodeAuthService > /dev/null 2>&1
        ln -s /etc/init.d/iNodeAuthService /etc/rc.d/rc4.d/K01iNodeAuthService > /dev/null 2>&1
        ln -s /etc/init.d/iNodeAuthService /etc/rc.d/rc6.d/K01iNodeAuthService > /dev/null 2>&1                
    fi
fi

if [ "$OS_UBUNTU" != "" ]
then
    iNODE_SERVICE=`cat /etc/rc.local | grep 'iNodeAuthService'`
    if [ "$iNODE_SERVICE" = "" ]
    then
        mv -f ./iNodeAuthService_ubuntu /etc/init.d/iNodeAuthService
        chmod 755 /etc/init.d/iNodeAuthService
        rm -f ./iNodeAuthService
        cp -fr /etc/rc.local /etc/rc.local.bak
        sed -e '/^exit 0$/d' /etc/rc.local > /etc/rc.temp
        echo "/etc/init.d/iNodeAuthService start" >> /etc/rc.temp
        echo "exit 0" >> /etc/rc.temp
        mv -f /etc/rc.temp /etc/rc.local
        chmod 755 /etc/rc.local
    fi
    if [ ! -r "/usr/lib/libtiff.so.3" ] && [ ! -r "/usr/lib/x86_64-linux-gnu/libtiff.so.3" ]
    then
        cp -fr ./libs/std/libtiff.so.3 /usr/lib/libtiff.so.3
        cp -fr ./libs/std/libtiff.so.3 /usr/lib/x86_64-linux-gnu/libtiff.so.3  
    fi
#直接复制
    cp -fr ./libs/std/libtiff.so.3 /usr/lib/libtiff.so.3
    cp -fr ./libs/std/libtiff.so.3 /usr/lib/x86_64-linux-gnu/libtiff.so.3
#ubuntu还缺少了libpangox-1.0.so.0，所以还要复制

    cp -fr ./libs/std/libpangox-1.0.so.0 /usr/lib/x86_64-linux-gnu/libpangox-1.0.so.0

    if [ ! -r "/usr/lib/x86_64-linux-gnu/libjpeg.so.62" ] && [ ! -r "/usr/lib/libjpeg.so.62" ]
    then
        ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so.8.0.2 /usr/lib/x86_64-linux-gnu/libjpeg.so.62
    fi
    > ./enablecards.ps
    update-rc.d iNodeAuthService defaults 80 01  > /dev/null 2>&1
else
    mv -f ./iNodeAuthService /etc/init.d
    chmod 755 /etc/init.d/iNodeAuthService
    rm -f ./iNodeAuthService_ubuntu
    if [ "$OS_ROCKY" = "" ]
    then
        chkconfig --add iNodeAuthService
        chkconfig --level 2345 iNodeAuthService on
        chkconfig --level 016 iNodeAuthService off
        chkconfig iNodeAuthService on
    else
        ln -s /etc/init.d/iNodeAuthService /etc/rc.d/rc3.d/S080iNodeAuthService > /dev/null 2>&1
        ln -s /etc/init.d/iNodeAuthService /etc/rc.d/rc5.d/S080iNodeAuthService > /dev/null 2>&1
        ln -s /etc/init.d/iNodeAuthService /etc/rc.d/rc0.d/K01iNodeAuthService > /dev/null 2>&1
        ln -s /etc/init.d/iNodeAuthService /etc/rc.d/rc1.d/K01iNodeAuthService > /dev/null 2>&1
        ln -s /etc/init.d/iNodeAuthService /etc/rc.d/rc2.d/K01iNodeAuthService > /dev/null 2>&1
        ln -s /etc/init.d/iNodeAuthService /etc/rc.d/rc4.d/K01iNodeAuthService > /dev/null 2>&1
        ln -s /etc/init.d/iNodeAuthService /etc/rc.d/rc6.d/K01iNodeAuthService > /dev/null 2>&1                
    fi
fi

if [ "$OS_ROCKY" != "" ]
then    
    rm -f /usr/lib/libjpeg.so.62
    cp -fr ./libs/rocky/libjpeg.so.62 /usr/lib/ > /dev/null 2>&1
    cp -fr ./libs/rocky/gdk-pixbuf.loaders /etc/gtk-2.0/    
fi

SELINUX_FLAG=`getenforce 2>/dev/null | grep -x -i enforcing`
if [ "$SELINUX_FLAG" != "" ]
then
chcon -t textrel_shlib_t /usr/lib/libCoreUtils.so
chcon -t textrel_shlib_t /usr/lib/libImplAv.so
chcon -t textrel_shlib_t /usr/lib/libOesisCore.so
fi

if [ "$OS_UBUNTU" != "" ];then
    if [ -d "/var/lib/locales/supported.d/" ];then
	    if [  ! -f "/var/lib/locales/supported.d/zh-inode" ];then
	        echo "zh_CN.GB2312 GB2312" > /var/lib/locales/supported.d/zh-inode
	        locale-gen > /dev/null 2>&1
	    fi
	fi
fi


if [ "$OS_ROCKY" != "" ]
then
pango-querymodules > '/etc/pango/pango.modules'
/etc/init.d/iNodeAuthService start
fi

rm -f ./install.sh

if [ "$OS_ROCKY" = "" ]
then
/etc/init.d/iNodeAuthService start
fi
echo "isntall end"
