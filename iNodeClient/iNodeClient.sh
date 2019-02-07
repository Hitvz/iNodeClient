#!/bin/sh
CHK_LCALL=`echo $LC_ALL|grep ^zh_CN`
if [ "$CHK_LCALL" != "" ];then
    export LC_ALL=zh_CN.gb2312            
fi 

CHK_LANG=`echo $LANG|grep ^zh_CN`
if [ "$CHK_LANG" != "" ];then
    export LANG=zh_CN.gb2312                
fi 

"@INSTALL_PATH/.iNode/iNodeClient" &


