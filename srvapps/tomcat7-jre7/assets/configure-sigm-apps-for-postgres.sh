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

 sgmadm_user=$( grep '^SIGEMADMIN' /var/lib/sigm/ConexionBD.cfg | cut -d ':' -f 2 )
 sgmadm_pass=$( grep '^SIGEMADMIN' /var/lib/sigm/ConexionBD.cfg | cut -d ':' -f 3 )
 sgmadm_db=$( grep '^SIGEMADMIN' /var/lib/sigm/ConexionBD.cfg | cut -d ':' -f 4 )

 sed -e "s+sigem.springDatasource.database=jdbc:postgresql://localhost/sigemAdmin+sigem.springDatasource.database=jdbc:postgresql://$BD_HOST/$sgmadm_db+" SIGEM_Core/database.properties \
 | sed -e "s+sigem.springDatasource.user=postgres+sigem.springDatasource.user=$sgmadm_user+" \
 | sed -e "s+sigem.springDatasource.password=postgres+sigem.springDatasource.password=$sgmadm_pass+" \
 > /tmp/x
 cp -f /tmp/x  SIGEM_Core/database.properties 
 
