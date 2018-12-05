#!/bin/bash
docker run --name zabbix-mysql -t \
	--restart always \
	-e MYSQL_DATABASE="zabbix" \
	-e MYSQL_USER="zabbix" \
	-e MYSQL_PASSWORD="12345" \
	-e MYSQL_ROOT_PASSWORD="12345" \
	-d mysql:5.7 \
	--character-set-server=utf8 --collation-server=utf8_bin
docker run --name zabbix-java-gateway -t \
	--restart always \
	-d zabbix/zabbix-java-gateway:latest
docker run --name zabbix-server-mysql -t \
	--restart always \
	-e DB_SERVER_HOST="zabbix-mysql" -t \
	-e MYSQL_DATABASE="zabbix" \
	-e MYSQL_USER="zabbix" \
	-e MYSQL_PASSWORD="12345" \
	-e MYSQL_ROOT_PASSWORD="12345" \
	-e ZAX_JAVAGATEWAY="zabbix-java-gateway" \
	--link zabbix-mysql:mysql \
	--link zabbix-java-gateway:zabbix-java-gateway \
	-p 10051:10051 \
	-d zabbix/zabbix-server-mysql:latest
docker run --name zabbix-agent -t \
	--restart always \
	-e ZBX_HOSTNAME="zabbix-agent" \
	-e ZBX_SETVER_HOST="zabbix-server-mysql" \
	--link zabbix-server-mysql:zabbix-server \
	--link zabbix-java-gateway:zabbix-java-gateway \
	-p 10050:10050 \
	-d zabbix/zabbix-agent:latest
docker run --name zabbix-web-nginx-mysql -t \
	--restart always \
	-e DB_SERVER_HOST="zabbix-mysql" -t \
	-e MYSQL_DATABASE="zabbix" \
	-e MYSQL_USER="zabbix" \
	-e MYSQL_PASSWORD="12345" \
	-e MYSQL_ROOT_PASSWORD="12345" \
    --link zabbix-mysql:mysql \
	--link zabbix-server-mysql:zabbix-server \
	-p 80:80 \
	-d zabbix/zabbix-web-nginx-mysql:latest


#拿到ip
#docker exec   -it  $(docker ps -a | grep "zabbix-agent" | awk '{print $1}')  "ifconfig"|grep "inet addr"|awk "NR==1"|awk '{print $2}'|cut -d ':' -f2
#登录用户：Admin 密码: zabbix
#登录后选择 配置 >>> 主机 >>> ip地址 >>> 把上面的容器ip写到这里

#出现内存警告设置
{Template OS Linux:system.swap.size[,pfree].last(0)}<50 and {Template OS Linux:system.swap.size[,free].last(0)}<>0
