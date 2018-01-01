#!/bin/bash
# Author: Skiychan <dev@skiy.net>
# Link: https://www.skiy.net
#
#
# Project home page:
# https://github.com/skiy
 
# Set Golang Version
go_version="1.9.2"
 
# DIY version
if [ -n "$1" ] ;then
go_version=$1
fi
 
# Printf Version Info
clear
printf "
#########################################
# Author Skiychan<dev@skiy.net> #
# Link http://www.skiy.net #
#########################################
"
 
# Check if user is root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }
 
echo=echo
for cmd in echo /bin/echo; do
$cmd >/dev/null 2>&1 || continue
if ! $cmd -e "" | grep -qE '^-e'; then
echo=$cmd
break
fi
done
 
# Set Color
CSI=$($echo -e "\033[")
CEND="${CSI}0m"
CDGREEN="${CSI}32m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"
CMAGENTA="${CSI}1;35m"
CCYAN="${CSI}1;36m"
CSUCCESS="$CDGREEN"
CFAILURE="$CRED"
CQUESTION="$CMAGENTA"
CWARNING="$CYELLOW"
CMSG="$CCYAN"
 
#Check Linux Version
if [ -f /etc/redhat-release -o -n "`grep 'Aliyun Linux release' /etc/issue`" ];then
OS=CentOS
[ -n "`grep ' 7\.' /etc/redhat-release`" ] && CentOS_RHEL_version=7
[ -n "`grep ' 6\.' /etc/redhat-release`" -o -n "`grep 'Aliyun Linux release6 15' /etc/issue`" ] && CentOS_RHEL_version=6
[ -n "`grep ' 5\.' /etc/redhat-release`" -o -n "`grep 'Aliyun Linux release5' /etc/issue`" ] && CentOS_RHEL_version=5
elif [ -n "`grep bian /etc/issue`" ];then
OS=Debian
Debian_version=`lsb_release -sr | awk -F. '{print $1}'`
elif [ -n "`grep Ubuntu /etc/issue`" ];then
OS=Ubuntu
Ubuntu_version=`lsb_release -sr | awk -F. '{print $1}'`
else
echo "${CFAILURE}Does not support this OS, Please contact the author! ${CEND}"
kill -9 $$
fi
 
# Check Linux Bit
if [ $(getconf WORD_BIT) = '32' ] && [ $(getconf LONG_BIT) = '64' ] ; then
sys_bit="amd64"
else
sys_bit="386"
fi
 
printf "
#########################################
# System: %s #
# Bit: %s #
# Golang %s Install #
#########################################
\n" $OS $sys_bit $go_version
 
# Install Curl Lib for Linux
if [ $OS = 'CentOS' ];then
yum update -y
yum install -y curl
else
apt-get update -y
apt-get install -y curl
fi
 
# Download Golang Package, Then Unzip to /usr/local
#GO_DOWNLOAD=https://storage.googleapis.com/golang/go$go_version.linux-$sys_bit.tar.gz
# Download new
GO_DOWNLOAD=https://redirector.gvt1.com/edgedl/go/go$go_version.linux-$sys_bit.tar.gz
 
printf "
download url: %s
\n" $GO_DOWNLOAD
 
rm go.tar.gz -rf
curl --retry 10 --retry-delay 60 --retry-max-time 60 -C - -SL -o go.tar.gz $GO_DOWNLOAD && \
#curl -SL -o go.tar.gz http://golangtc.com/static/go/go$go_version/$go_version.linux-amd64.tar.gz && \
tar -C /usr/local/ -zxf go.tar.gz && \
rm go.tar.gz -rf
 
# Create GOPATH
mkdir -p /data/go
 
# Set ENV for Golang
if [ -z "`grep GOROOT /etc/profile`" ];then
cat <<EOF >> /etc/profile
export GOROOT=/usr/local/go
export GOPATH=/data/go
export PATH=\$GOROOT/bin:\$GOPATH/bin:\$PATH
EOF
fi
 
# Make Env Is Enable
. /etc/profile
go env
go version
 
# Printf Tip
printf "
##############################################
# 安装成功，请再次执行 source /etc/profile #
##############################################
"