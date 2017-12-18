# Quick-Installation-ZABBIX

## zabbix安装脚本
### 脚本作者:Linux-MIY
### email:meng352247816@outlook.com

 * 要求纯净centos6/7系统（强烈建议用7，用6的话安装非常缓慢）
 * 关闭防火墙
 * 关闭selinux
 * php>=5.6
 
#### 运行**server-install.sh**安装zabbix服务器端
由于zabbix3需要php5.6以上，因此脚本会删除原有php环境从新安装  
  
**mysql默认root密码123321**  
**zabbix数据库名称zabbix**  
**zabbix数据库用户名zabbix**  
**zabbix数据库密码zabbix**  

#### 在被监控终端运行**agent-install.sh**安装

## 更新日志


### 2017-09-10更新 
1. 升级zabbix到3.0.3  
2. 添加吴兆松的**graphtrees**插件  
[graphtrees github](https://github.com/OneOaaS/graphtrees)  
[graphtrees 实现效果](http://t.cn/RqAeAxT)  

### 2017-11-20更新  
1. agent-install.sh增加wget安装  
2. 升级zabbix到2.4.7  
3. server-install.sh复制zabbix-2.4.7.tar.gz到/var/www/html/zabbix，agent-install.sh从服务端调取zabbix-2.4.7.tar.gz安装包
