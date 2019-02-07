#!/bin/sh

OS_ROCKY=`cat /etc/issue | grep 'Rocky'`

if [ "$OS_ROCKY" != "" ]
then
    /etc/init.d/iNodeAuthService stop
    rm -f /etc/rc.d/rc3.d/S080iNodeAuthService > /dev/null 2>&1
    rm -f /etc/rc.d/rc5.d/S080iNodeAuthService > /dev/null 2>&1
    rm -f /etc/rc.d/rc0.d/K01iNodeAuthService > /dev/null 2>&1
    rm -f /etc/rc.d/rc1.d/K01iNodeAuthService > /dev/null 2>&1
    rm -f /etc/rc.d/rc2.d/K01iNodeAuthService > /dev/null 2>&1
    rm -f /etc/rc.d/rc4.d/K01iNodeAuthService > /dev/null 2>&1
    rm -f /etc/rc.d/rc6.d/K01iNodeAuthService > /dev/null 2>&1
else
    service iNodeAuthService stop
fi

Sec=0
while [ 1 ]
do
    IfExistMon=`ps awx -o command|awk -F/ '{print $NF}'|grep -x iNodeMon`
    if [ "$IfExistMon" != "" ]
    then
        sleep 1
        Sec=`expr $Sec + 1`

        if [ "$Sec" -lt 9 ]
	    then
            killall -9 iNodeMon > /dev/null 2>&1
        else
            killall -9 iNodeMon
            break
        fi
    else
        break
    fi
done

Sec=0
while [ 1 ]
do
    IfExistAuth=`ps awx -o command|awk -F/ '{print $NF}'|grep -x AuthenMngService`
    if [ "$IfExistAuth" != "" ]
    then
        sleep 1
        Sec=`expr $Sec + 1`

        if [ "$Sec" -lt 9 ]
		then
            killall -9 AuthenMngService > /dev/null 2>&1
        else
            killall -9 AuthenMngService
            break
        fi
    else
        break
    fi
done

IfExistUI=`ps awx -o command|awk -F/ '{print $NF}'|grep -x iNodeClient`
if [ "$IfExistUI" != "" ]
then
    sleep 5
    killall -9 iNodeClient
fi

OS_UBUNTU=`cat /etc/issue | grep 'Ubuntu'`

if [ "$OS_UBUNTU" != "" ]
then
iNODE_SERVICE=`cat /etc/rc.local | grep 'iNodeAuthService'`
if [ "$iNODE_SERVICE" != "" ]
then
cp -fr /etc/rc.local /etc/rc.local.bak
sed -e '/iNodeAuthService/d' /etc/rc.local > /etc/rc.temp
mv -f /etc/rc.temp /etc/rc.local
chmod 755 /etc/rc.local
update-rc.d -f iNodeAuthService remove > /dev/null 2>&1
fi
else
  if [ "$OS_ROCKY" = "" ]
  then
  chkconfig --del iNodeAuthService
  fi
fi

OS_DEEPIN=`cat /etc/issue | grep 'Deepin'`

if [ "$OS_DEEPIN" != "" ]
then
iNODE_SERVICE=`cat /etc/rc.local | grep 'iNodeAuthService'`
if [ "$iNODE_SERVICE" != "" ]
then
cp -fr /etc/rc.local /etc/rc.local.bak
sed -e '/iNodeAuthService/d' /etc/rc.local > /etc/rc.temp
mv -f /etc/rc.temp /etc/rc.local
chmod 755 /etc/rc.local
update-rc.d -f iNodeAuthService remove > /dev/null 2>&1
fi
else
  if [ "$OS_ROCKY" = "" ]
  then
  chkconfig --del iNodeAuthService
  fi
fi

if [ -r "/etc/iNode" ]
then
rm -fr /etc/iNode
fi

rm -f /etc/init.d/iNodeAuthService

./delRun.sh

cd ../
rm -fr iNodeClient
