#注意  
如果要更改 MYSQL_ROOT_PASSWORD="xx"  要修改docker-compose.yml 里所有共三个参数- MYSQL_PASSWORD 否则启动不了，切记,至关重要。  

#第一步  
docker network create zabbix  
#第二步  
docker-compose up --build -d  

#第三步  

#登录  
http://localhost:666  

登录用户：Admin    密码: zabbix  

#登录后选择 配置 >>> 主机 >>> Zabbix server >>> DNS名称
在dns名称里面填写  zabbix-agent
#保存退出。
