#!/bin/bash
#
# Antes de lanzar el TOMCAT ...

# Copiar el driver jdbc
JarJDBC=$(find /var/lib/sigm/driversJdbc -type f -name "*jar" | grep -i "$BD_TYPE" | sort -u | tail -1 )
if [ "" = "$JarJDBC" ]
then
  echo "ERROR: No se pudo encontrar driver jdbc para '$DB_TYPE'"
  exit 4
fi
cp $JarJDBC $CATALINA_HOME/lib/


# Crear los Recursos JDBC en server.xml
if /var/lib/sigm/ConfigTomcat.sh
then
   cd $CATALINA_HOME
   catalina.sh run
fi
