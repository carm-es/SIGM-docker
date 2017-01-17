#!/bin/bash
#
#
# Aplica los cambios para Tomcat en los ficheros de configuración
# de /home/sigem/SIGEM/conf siguiendo la guía:
#
# https://carm-es.github.io/SIGM/3.0.1/Documentaci%C3%B3n-t%C3%A9cnica/instalaci%C3%B3n/Configuraci%C3%B3n-para-Oracle-11g.html
# 
# 

 cd /home/sigem/SIGEM/conf

 sed -e 's+fwktd-audit.database=postgresql+fwktd-audit.database=oracle+' fwktd-audit/fwktd-audit-api.properties >/tmp/x
 cp -f /tmp/x fwktd-audit/fwktd-audit-api.properties 

 sed -e 's+fwktd-csv.database=postgresql+fwktd-csv.database=oracle+' fwktd-csv/fwktd-csv-api.properties >/tmp/x
 cp -f /tmp/x fwktd-csv/fwktd-csv-api.properties 

 sed -e 's+fwktd-sir.database=postgresql+fwktd-sir.database=oracle+' fwktd-sir/fwktd-sir-api.properties >/tmp/x
 cp -f /tmp/x fwktd-sir/fwktd-sir-api.properties 


 sed -e 's+<DB_Factory_Class>common.db.DBEntityFactoryPostgreSQL</DB_Factory_Class>+<DB_Factory_Class>common.db.DBEntityFactoryOracle9i</DB_Factory_Class>+'  SIGEM_ArchivoWeb/archivo-cfg.xml >/tmp/x
 cp -f /tmp/x  SIGEM_ArchivoWeb/archivo-cfg.xml
 


 sgmadm_user=$( grep '^SIGEMADMIN' /var/lib/sigm/ConexionBD.cfg | cut -d ':' -f 2 )
 sgmadm_pass=$( grep '^SIGEMADMIN' /var/lib/sigm/ConexionBD.cfg | cut -d ':' -f 3 )
 sgmadm_db=$( grep '^SIGEMADMIN' /var/lib/sigm/ConexionBD.cfg | cut -d ':' -f 4 )

 sed -e "s+sigem.springDatasource.database=jdbc:postgresql://localhost/sigemAdmin+sigem.springDatasource.database=jdbc:oracle:thin:@$BD_HOST:$BD_PORT:$BD_SID+" SIGEM_Core/database.properties \
 | sed -e "s+sigem.springDatasource.user=postgres+sigem.springDatasource.user=$sgmadm_user+" \
 | sed -e "s+sigem.springDatasource.password=postgres+sigem.springDatasource.password=$sgmadm_pass+" \
 | sed -e "s+sigem.springDatasource.driver=org.postgresql.Driver+sigem.springDatasource.driver=oracle.jdbc.OracleDriver+" \
 > /tmp/x
 cp -f /tmp/x  SIGEM_Core/database.properties 
 
 

 sed -e 's+isicres.database=postgres+isicres.database=oracle+' SIGEM_RegistroPresencial/database.properties >/tmp/x
 cp -f /tmp/x SIGEM_RegistroPresencial/database.properties 
 

 sed -e 's+<property name="dialect">net.sf.hibernate.dialect.PostgreSQLDialect</property>+<property name="dialect">net.sf.hibernate.dialect.OracleDialect</property>+' SIGEM_RegistroPresencial/hibernate.cfg.xml >/tmp/x
 cp -f /tmp/x SIGEM_RegistroPresencial/hibernate.cfg.xml



 sed -e 's+<DAOImplementation>com.ieci.tecdoc.common.entity.dao.PostgreSQLDBEntityDAO</DAOImplementation>+<DAOImplementation>com.ieci.tecdoc.common.entity.dao.OracleDBEntityDAO</DAOImplementation>+' SIGEM_RegistroPresencial/ISicres-Configuration.xml >/tmp/x
 cp -f /tmp/x SIGEM_RegistroPresencial/ISicres-Configuration.xml

