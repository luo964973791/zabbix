#注意  
如果要更改 MYSQL_ROOT_PASSWORD="xx"  要修改docker-compose.yml 里所有共三个参数- MYSQL_PASSWORD 否则启动不了，切记,至关重要。  

docker-compose up --build -d  

#登录  
http://localhost:666  

登录用户：Admin    密码: zabbix  

#拿到dns-server的地址
docker exec   -it  $(docker ps -a | grep "zabbix-server-mysql" | awk '{print $1}')  "ifconfig"|grep "inet addr"|awk "NR==1"|awk '{print $2}'|cut -d ':' -f2

#编辑挂载文件下面这两项为dns-server的ip地址
vi zabbix-agent/conf/zabbix-agent.conf
Server=172.23.0.4
ServerActive=172.23.0.4

#登录后选择 配置 >>> 主机 >>> Zabbix server >>> DNS名称
在dns名称里面填写  zabbix-agent
#保存退出。

#最最最重要的要重启zabbix-agent
docker restart zabbix-agent


#出现内存警告设置
{Template OS Linux:system.swap.size[,pfree].last(0)}<50 and {Template OS Linux:system.swap.size[,free].last(0)}<>0
