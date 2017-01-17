#!/bin/bash
#
# Este script permite crear un TAG Resource
# para JNDI, que incorporar a server.xml
#
# Argumentos:
#   1º= Nombre del contexto en Contextos.cfg (ej: sigem_registroPresencialWeb)

 WorkDir="/var/lib/sigm"
 Cfg="Contextos.cfg"

 # Comprobar argumentos...
 if [ "$1" = "" ]
 then
    echo "ERROR: Debes indicar <nombre_del_contexto> " >&2
    echo "       Ejemplo: sigem_registroPresencialWeb " >&2
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

 if ! grep -qi "^$1:" $FileConf
 then
    echo "ERROR: No se encontró el nombre '$1' en '$FileConf'">&2
    exit 9
 fi

 WAR=$( grep -i "^$1:" $FileConf | head -1 | cut -d ':' -f1 )
 CTX=$( grep -i "^$1:" $FileConf | head -1 | cut -d ':' -f2 )
 Res=$( grep -i "^$1:" $FileConf | head -1 | cut -d ':' -f3 )

 # Descargar ... 
 if [ ! -e  $CATALINA_HOME/webapps/$CTX.war ]
 then
    echo "WARNING: No se encontró $CATALINA_HOME/webapps/$CTX.war: Se ignora $1..." >&2
    exit 0
 fi

 # Para los temporales...
 tmpFile="/tmp/ctx_$$_$RANDOM"

 cat <<EOF >$tmpFile.prefijo
<?xml version='1.0' encoding='utf-8'?>
<Context reloadable="true">
EOF

 cat <<EOF >$tmpFile.sufijo
</Context>
EOF


 # Transformar los recursos JNDI
 for r in $( echo "$Res" | sed -e 's+,+ +g' )
 do
   N=""
   if [ "SIGEMADMIN" = "$r" ]
   then
     N="sigemAdmin"
   elif [ "DIR3" = "$r" ]
   then
     N="fwktd-dir3DS"
   elif [ "REGISTRO" = "$r" ]
   then
     N="registroDS_000"
   elif [ "AUDIT" = "$r" ]
   then
     N="fwktd-auditDS_000"
   elif [ "SIR" = "$r" ]
   then
     N="fwktd-sirDS_000"
   elif [ "TRAMITADOR" = "$r" ]
   then
     N="tramitadorDS_000"
   elif [ "ETRAM" = "$r" ]
   then
     N="eTramitacionDS_000"
   elif [ "ARCHIVO" = "$r" ]
   then
     N="archivoDS_000"
   elif [ "TERCEROS" = "$r" ]
   then
     N="tercerosDS_000"
   fi

   if [ "" != "$N" ]
   then
      echo "<ResourceLink global=\"jdbc/$r\" name=\"jdbc/$N\" type=\"javax.sql.DataSource\"/>"
   fi
 done >$tmpFile.resources

 # Comprobar que al final escribió algo
 if grep -q 'ResourceLink' $tmpFile.resources
 then
    mkdir $CATALINA_HOME/conf/Catalina/localhost -p 
    cat $tmpFile.prefijo $tmpFile.resources $tmpFile.sufijo > $CATALINA_HOME/conf/Catalina/localhost/$CTX.xml
 fi
   

 rm -f $tmpFile.*
