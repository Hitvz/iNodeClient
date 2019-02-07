#!/bin/sh

cd /

for i in /install_lib_32/pkg_lib_i686/*.gz
do
tar xzvf $i
done

for i in /install_lib_32/pkg_lib_i686/*.tar
do
tar xzvf $i
done

for i in /install_lib_32/pkg_lib_i686/*.g
do
tar xzvf $i
done

tar zxvf /install_lib_32/gtk2_i686_lib#2.12.2-x86-linx-Rocky4.2.pkg.tar.gz
tar zxvf /install_lib_32/pango_i686_lib#1.20.5-i86-linx-Rocky4.2.pkg.tar.gz
