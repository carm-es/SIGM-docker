#!/bin/bash
#
# Este script permite crear un TAG Resource
# para JNDI, que incorporar a server.xml
#
# Argumentos:
#   1º= Nombre del recurso en ConexionBD.cfg (ej: SIGEMADMIN)
#   2º= Tipo de base de datos (ej: oracle, postgres)
#   3º= Servidor de base de datos (ej: localhost)
#   4º= Puerto de conexion (ej:1521)

 WorkDir="/var/lib/sigm"
 Cfg="ConexionBD.cfg"

 # Comprobar argumentos...
 if [ "$4" = "" ]
 then
    echo "ERROR: Debes indicar <recurso> <tipo_base_de_datos> <servidor_bd> <puerto_bd>" >&2
    echo "       Ejemplo: SIGEMADMIN oracle localhost 1521" >&2
    exit 5
 fi

 # Leer el fichero...
 FileConf=""
 [ -e $Cfg ] && FileConf=$Cfg
 [ -e $WorkDir/$Cfg ] && FileConf=$WorkDir/$Cfg

 if [ "" = "$FileConf" ]
 then
    echo "ERROR: No se encontró el fichero $Cfg" >&2
    exit 6
 fi

 if ! grep -qi "$1:" $FileConf
 then
    echo "ERROR: No se encontró el recurso '$1' en '$FileConf'">&2
    exit 9
 fi

 JNDI=$( grep -i "^$1:" $FileConf | head -1 | cut -d ':' -f1 )
 User=$( grep -i "^$1:" $FileConf | head -1 | cut -d ':' -f2 )
 Pass=$( grep -i "^$1:" $FileConf | head -1 | cut -d ':' -f3 )
 DBname=$( grep -i "^$1:" $FileConf | head -1 | cut -d ':' -f4 )

 SID="XE"
 if [ "" != "$BD_SID" ]
 then
    SID=$BD_SID
 fi

 # Ver el tipo 
 if echo "$2" | grep -qi "oracle"
 then
    Driver="oracle.jdbc.OracleDriver"
    URL="jdbc:oracle:thin:@$3:$4:$SID"

 elif  echo "$2" | grep -qi "postgres"
 then
    Driver="org.postgresql.Driver"
    URL="jdbc:postgresql://$3:$4/$DBname"

 else
    echo "ERROR: No se reconoce el tipo '$2'" >&2
    exit 3
 fi
 

 cat <<EOF

<Resource name="jdbc/$JNDI"
          type="javax.sql.DataSource"
          driverClassName="$Driver"
          maxTotal="20" maxIdle="10" maxWaitMillis="-1"
          removeAbandonedOnBorrow="true" removeAbandonedOnMaintenance="true" removeAbandonedTimeout="5"
          poolPreparedStatements="false" 
          url="$URL"
          username="$User" password="$Pass" />

EOF

