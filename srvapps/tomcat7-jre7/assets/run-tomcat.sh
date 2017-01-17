#!/bin/bash
#
# Antes de lanzar el TOMCAT ...

# Comprobar que se tiene definida la vble CONEXION_BBDD
if [ "" = "$CONEXION_BBDD" ]
then
   echo "ERROR: No se encontró definida la vble $CONEXION_BBDD" >&2
   exit 5
fi
export BD_TYPE=$( echo $CONEXION_BBDD | cut -d ':' -f 1 )
export BD_HOST=$( echo $CONEXION_BBDD | cut -d ':' -f 2 )
export BD_PORT=$( echo $CONEXION_BBDD | cut -d ':' -f 3 )
export BD_SID=$( echo $CONEXION_BBDD | cut -d ':' -f 4 )

# Iniciar vsftpd
/etc/init.d/vsftpd start

# Iniciar LibreOffice
/bin/start_open_office_nox.sh

# Crear los Recursos JDBC en server.xml
now=$(date '+%y%m%d_%H%M%S')
if /var/lib/sigm/deploy-config-wars-sigm.sh > /var/lib/sigm/deploy-config.$now.log
then
   cd $CATALINA_HOME
   export JAVA_OPTS=" -Djava.awt.headless=true -XX:MaxPermSize=512M -Dcom.sun.management.jmxremote=true "
   catalina.sh run
fi
