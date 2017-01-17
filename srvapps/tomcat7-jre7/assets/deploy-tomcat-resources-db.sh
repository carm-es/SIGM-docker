#!/bin/bash
#
# Este script añadir los recursos JNDI a $CATALINA_HOME/conf/server.xml
# 
# Requiere que existan las variables de entorno:
#    CATALINA_HOME: Ruta donde encontrar el tomcat
#    BD_TYPE: Tipo de la base de datos (oracle,postgres)
#    BD_HOST: IP o nombre del servidor de BD
#    BD_PORT: Puerto de conexion a la BD
#

 WorkDir="/var/lib/sigm"
 Cfg="ConexionBD.cfg"
 Scp="create-jndi-resource.sh"

 # Comprobar variables...
 [ "" = "$CATALINA_HOME" ] && echo "ERROR: La variable CATALINA_HOME debe estar definida" >&2  && exit 5
 [ "" = "$BD_TYPE" ] && echo "ERROR: La variable BD_TYPE debe estar definida" >&2  && exit 5
 [ "" = "$BD_HOST" ] && echo "ERROR: La variable BD_HOST debe estar definida" >&2  && exit 5
 [ "" = "$BD_PORT" ] && echo "ERROR: La variable BD_PORT debe estar definida" >&2  && exit 5

 # Comprobar que se tiene acceso a la configuración de Tomcat...
 if [ ! -e $CATALINA_HOME/conf/server.xml ]
 then
    echo "ERROR: No se tiene acceso a $CATALINA_HOME/conf/server.xml" >&2
    exit 19
 fi

 # Buscar fichero de configuración...
 FileConf=""
 [ -e $Cfg ] && FileConf=$Cfg
 [ -e $WorkDir/$Cfg ] && FileConf=$WorkDir/$Cfg

 if [ "" = "$FileConf" ]
 then
    echo "ERROR: No se encontró el fichero $Cfg" >&2
    exit 6
 fi

 ScriptConf=""
 [ -e $Scp ] && ScriptConf=$Scp
 [ -e $WorkDir/$Scp ] && ScriptConf=$WorkDir/$Scp

 if [ "" = "$ScriptConf" ]
 then
    echo "ERROR: No se encontró el script $Scp" >&2
    exit 6
 fi

 # Para los temporales...
 tmpFile="/tmp/tomcatConf_$$_$RANDOM"

 # Generar todos los resources...
 for ctx in $(grep ':' $FileConf | grep -v '#' | cut -d ':' -f 1)
 do
    bash $ScriptConf $ctx $BD_TYPE $BD_HOST $BD_PORT 
 done >> $tmpFile.resources


 # Trocear el fichero de configuración...
 cat $CATALINA_HOME/conf/server.xml | sed -n -e '1,/<GlobalNamingResources>/p'   >$tmpFile.prefijo
 cat $CATALINA_HOME/conf/server.xml | sed -n -e '/<\/GlobalNamingResources>/,$p' >$tmpFile.sufijo

 cat <<EOF >$tmpFile.users

    <Resource name="UserDatabase" auth="Container"
              type="org.apache.catalina.UserDatabase"
              description="User database that can be updated and saved"
              factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
              pathname="conf/tomcat-users.xml" />

EOF

 
 # Dejar la configuración definitiva...
 cat $tmpFile.prefijo $tmpFile.users $tmpFile.resources $tmpFile.sufijo > $CATALINA_HOME/conf/server.xml

 # Borrar temporales...
 rm -f $tmpFile.*

 exit 0
