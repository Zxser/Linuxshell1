在CentOS服务器，我们可以执行以下命令安装
yum install rsync
对于debian、ubuntu服务器，则是以下命令
sudo apt-get  install  rsync

rsync服务器的配置文件rsyncd.conf

下面我们将涉及到三个文件 rsyncd.conf，rsyncd.secrets 和rsyncd.motd。
rsyncd.conf 是rsync服务器主要配置文件。
rsyncd.secrets是登录rsync服务器的密码文件。
rsyncd.motd是定义rysnc 服务器信息的，也就是用户登录信息。
下面我们分别建立这三个文件。

mkdir /etc/rsyncd
注：在/etc目录下创建一个rsyncd的目录，我们用来存放rsyncd.conf 和rsyncd.secrets文件；

touch /etc/rsyncd/rsyncd.conf
注：创建rsyncd.conf ，这是rsync服务器的配置文件；

touch /etc/rsyncd/rsyncd.secrets
注：创建rsyncd.secrets ，这是用户密码文件；

chmod 600 /etc/rsyncd/rsyncd.secrets
注：为了密码的安全性，我们把权限设为600；

touch /etc/rsyncd/rsyncd.motd
注：创建rsyncd.motd文件，这是定义服务器信息的文件。
下一就是我们修改 rsyncd.conf 和rsyncd.secrets 和rsyncd.motd 文件的时候了。
rsyncd.conf文件内容：

# Minimal configuration file for rsync daemon
# See rsync(1) and rsyncd.conf(5) man pages for help
 
# This line is required by the /etc/init.d/rsyncd script
pid file = /var/run/rsyncd.pid   
port = 873
address = 192.168.1.171 
#uid = nobody
#gid = nobody   
uid = root   
gid = root   
 
use chroot = yes 
read only = no 
 
 
#limit access to private LANs
hosts allow=192.168.1.0/255.255.255.0 10.0.1.0/255.255.255.0 
hosts deny=*
 
max connections = 5
motd file = /etc/rsyncd/rsyncd.motd
 
#This will give you a separate log file
#log file = /var/log/rsync.log
 
#This will log every file transferred - up to 85,000+ per user, per sync
#transfer logging = yes
 
log format = %t %a %m %f %b
syslog facility = local3
timeout = 300
 
[linuxsirhome]   
path = /home   
list=yes
ignore errors
auth users = linuxsir
secrets file = /etc/rsyncd/rsyncd.secrets 
comment = linuxsir home 
exclude =   beinan/  samba/     
 
[beinan]
path = /opt
list=no
ignore errors
comment = optdir   
auth users = beinan
secrets file = /etc/rsyncd/rsyncd.secrets
密码文件：/etc/rsyncd/rsyncd.secrets的内容格式；

用户名:密码
linuxsir:222222
beinan:333333
注： linuxsir是系统用户，这里的密码值得注意，为了安全，你不能把系统用户的密码写在这里。比如你的系统用户 linuxsir 密码是 abcdefg ，为了安全，你可以让rsync 中的linuxsir 为 222222 。这和samba的用户认证的密码原理是差不多的；
rsyncd.motd 文件;
它是定义rysnc 服务器信息的，也就是用户登录信息。比如让用户知道这个服务器是谁提供的等；类似ftp服务器登录时，我们所看到的 linuxsir.org ftp ……。 当然这在全局定义变量时，并不是必须的，你可以用#号注掉，或删除；我在这里写了一个 rsyncd.motd的内容为：

+++++++++++++++++++++++++++
+ linuxsir.org  rsync  2002-2007 +
+++++++++++++++++++++++++++
rsyncd.conf文件代码说明

pid file = /var/run/rsyncd.pid
注：告诉进程写到 /var/run/rsyncd.pid 文件中；

port = 873
注：指定运行端口，默认是873，您可以自己指定；

address = 192.168.1.171
注：指定服务器IP地址；

uid = nobody
gid = nobdoy
注：服务器端传输文件时，要发哪个用户和用户组来执行，默认是nobody。 如果用nobody 用户和用户组，可能遇到权限问题，有些文件从服务器上拉不下来。所以我就偷懒，为了方便，用了root 。不过您可以在定义要同步的目录时定义的模块中指定用户来解决权限的问题。

use chroot = yes
用chroot，在传输文件之前，服务器守护程序在将chroot 到文件系统中的目录中，这样做的好处是可能保护系统被安装漏洞侵袭的可能。缺点是需要超级用户权限。另外对符号链接文件，将会排除在外。也就是说，你在rsync服务器上，如果有符号链接，你在备份服务器上运行客户端的同步数据时，只会把符号链接名同步下来，并不会同步符号链接的内容；这个需要自己来尝试；

read only = yes
注：read only 是只读选择，也就是说，不让客户端上传文件到服务器上。还有一个 write only选项，自己尝试是做什么用的吧；

#limit access to private LANs
hosts allow=192.168.1.0/255.255.255.0 10.0.1.0/255.255.255.0
注：在您可以指定单个IP，也可以指定整个网段，能提高安全性。格式是ip 与ip 之间、ip和网段之间、网段和网段之间要用空格隔开；

max connections = 5
注：客户端最多连接数；

motd file = /etc/rsyncd/rsyncd.motd
注：motd file 是定义服务器信息的，要自己写 rsyncd.motd 文件内容。当用户登录时会看到这个信息。

log file = /var/log/rsync.log
注：rsync 服务器的日志；

transfer logging = yes
注：这是传输文件的日志；

[linuxsirhome]
注：模块，它为我们提供了一个链接的名字，链接到哪呢，在本模块中，链接到了/home目录；要用[name] 形式；

path = /home
注：指定文件目录所在位置，这是必须指定的；

auth users = linuxsir
注：认证用户是linuxsir ，是必须在 服务器上存在的用户；

list=yes
注：list 意思是把rsync 服务器上提供同步数据的目录在服务器上模块是否显示列出来。默认是yes 。如果你不想列出来，就no ；如果是no是比较安全的，至少别人不知道你的服务器上提供了哪些目录。你自己知道就行了；

ignore errors
注：忽略IO错误，详细的请查文档；

secrets file = /etc/rsyncd/rsyncd.secrets
注：密码存在哪个文件；

comment = linuxsir home  data
注：注释可以自己定义，写什么都行，写点相关的内容就行；

exclude =   beinan/   samba/
注：exclude 是排除的意思，也就是说，要把/home目录下的beinan和samba 排除在外； beinan/和samba/目录之间有空格分开 ；

启动rsync 服务器及防火墙的设置

启动rsync服务器
启动rsync 服务器相当简单，–daemon 是让rsync 以服务器模式运行；

/usr/bin/rsync --daemon  --config=/etc/rsyncd/rsyncd.conf
rsync服务器和防火墙
Linux 防火墙是用iptables，所以我们至少在服务器端要让你所定义的rsync 服务器端口通过，客户端上也应该让通过。

iptables -A INPUT -p tcp -m state --state NEW  -m tcp --dport 873 -j ACCEPT
查看一下防火墙是不是打开了 873端口；

iptables -L
通过rsync客户端来同步数据

rsync -avzP linuxsir@linuxsir.org::linuxsirhome   linuxsirhome
Password: 这里要输入linuxsir的密码，是服务器端提供的，在前面的例子中，我们用的是 222222，输入的密码并不显示出来；输好后就回车；
注： 这个命令的意思就是说，用linuxsir 用户登录到服务器上，把linuxsirhome数据，同步到本地目录linuxsirhome上。当然本地的目录是可以你自己定义的，比如 linuxsir也是可以的；当你在客户端上，当前操作的目录下没有linuxsirhome这个目录时，系统会自动为你创建一个；当存在linuxsirhome这个目录中，你要注意它的写权限。
说明：
-a 参数，相当于-rlptgoD，-r 是递归 -l 是链接文件，意思是拷贝链接文件；-p 表示保持文件原有权限；-t 保持文件原有时间；-g 保持文件原有用户组；-o 保持文件原有属主；-D 相当于块设备文件；
-z 传输时压缩；
-P 传输进度；
-v 传输时的进度等信息，和-P有点关系，自己试试。可以看文档；

rsync -avzP  --delete linuxsir@linuxsir.org::linuxsirhome   linuxsirhome
这回我们引入一个 –delete 选项，表示客户端上的数据要与服务器端完全一致，如果 linuxsirhome目录中有服务器上不存在的文件，则删除。最终目的是让linuxsirhome目录上的数据完全与服务器上保持一致；用的时候要小心点，最好不要把已经有重要数所据的目录，当做本地更新目录，否则会把你的数据全部删除；

rsync -avzP  --delete  --password-file=rsync.password  linuxsir@linuxsir.org::linuxsirhome   linuxsirhome
这次我们加了一个选项 –password-file=rsync.password ，这是当我们以linuxsir用户登录rsync服务器同步数据时，密码将读取 rsync.password 这个文件。这个文件内容只是linuxsir用户的密码。我们要如下做；

touch rsync.password
chmod 600 rsync.password
echo "222222"> rsync.password
rsync -avzP  --delete  --password-file=rsync.password  linuxsir@linuxsir.org::linuxsirhome   linuxsirhome
注： 这样就不需要密码了；其实这是比较重要的，因为服务器通过crond 计划任务还是有必要的；

让rsync 客户端自动与服务器同步数据

编辑crontab
crontab -e
加入如下代码：

10 0 * * * rsync -avzP  --delete  --password-file=rsync.password  linuxsir@linuxsir.org::linuxsirhome   linuxsirhome
表示每天0点10分执行后面的命令。更多crontab用法请参考


