### 一、安装mysql8版本

```javascript
wget http://repo.mysql.com/yum/mysql-8.0-community/el/7/x86_64/mysql80-community-release-el7-3.noarch.rpm
rpm -ivh mysql80-community-release-el7-3.noarch.rpm
yum remove mariadb-libs -y
yum install mysql-community-client mysql-community-server -y
systemctl enable mysqld && systemctl start mysqld
cat /var/log/mysqld.log | grep password #拿到root密码.

[root@node1 zabbix]# mysql -uroot -p'7m&=V)p>-.of'
mysql> alter user 'root'@'localhost' identified by 'Tcdn@2021';
Query OK, 0 rows affected (0.01 sec)
mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)
```

### 二、安装zabbix5.0服务、客户端

```javascript
rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
yum clean all
yum install zabbix-server-mysql zabbix-agent -y
yum install centos-release-scl -y


vi /etc/yum.repos.d/zabbix.repo
[zabbix-frontend]
enabled=1   #参数改为1

yum install zabbix-web-mysql-scl zabbix-nginx-conf-scl zabbix-get -y
```

### 三、配置数据库,修改zabbix-server配置文件

```javascript
# mysql -uroot -p
password
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> create user zabbix@localhost identified by 'Tcdn@2021';
mysql> grant all privileges on zabbix.* to zabbix@localhost;
mysql> ALTER USER 'zabbix'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Tcdn@2021';
mysql> FLUSH PRIVILEGES;
mysql> quit;
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix


vi /etc/zabbix/zabbix_server.conf
DBPassword=password    #上面创建的zabbix用户的数据库密码.

vi /etc/opt/rh/rh-nginx116/nginx/conf.d/zabbix.conf
listen 80;
server_name example.com;    #访问域名IP.


vi /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf
listen.acl_users = apache,nginx
php_value[date.timezone] = Asia/Shanghai
```

### 四、启动zabbix.

```javascript
systemctl restart zabbix-server zabbix-agent rh-nginx116-nginx rh-php72-php-fpm
systemctl enable zabbix-server zabbix-agent rh-nginx116-nginx rh-php72-php-fpm
```

### 五、其它服务器上面配置客户端.

```javascript

vi /etc/zabbix/zabbix_agentd.conf
Server=172.27.0.6   #zabbix-server机器的IP
ListenPort=10050
ServerActive=172.27.0.6
Hostname=node2

 
systemctl restart zabbix-agent
systemctl enable zabbix-agent


 #在zabbix-server服务器上面测试是否可以连接客户端.
 zabbix_get -s 172.27.0.8 -p 10050 -k system.uname
 
 
 #修改字体
 cd /usr/share/zabbix/assets/fonts
 cp /root/simkai.ttf .
 chown zabbix:zabbix simkai.ttf
 
 vi /usr/share/zabbix/include/defines.inc.php  #修改81行和122行
 define('ZBX_GRAPH_FONT_NAME',           'simkai');
 define('ZBX_FONT_NAME', 'simkai');
 systemctl restart rh-nginx116-nginx rh-php72-php-fpm
```

