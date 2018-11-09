#注意  
如果要更改 MYSQL_ROOT_PASSWORD="xx"  要修改docker-compose.yml 里所有共三个参数否则启动不了，切记，比如：  

zabbix-web-nginx-mysql:  
    image: zabbix/zabbix-web-nginx-mysql:latest  
    container_name: zabbix-web-nginx-mysql  
    environment:  
        - MYSQL_PASSWORD="zabbix-admin-123456"   
 
 
 zabbix-web-nginx-mysql:  
    image: zabbix/zabbix-web-nginx-mysql:latest  
    container_name: zabbix-web-nginx-mysql  
    environment:    
        - MYSQL_PASSWORD="zabbix-admin-123456"  


 zabbix-server-mysql:  
        image: zabbix/zabbix-server-mysql  
        container_name: zabbix-server-mysql  
        environment:  
            - MYSQL_PASSWORD="zabbix-admin-123456"   

      
