#!/bin/bash
#
# Este script permite crear descargar el WAR que se le pasa 
# como argumento
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

 # Descargar ... 
 echo "Descargarndo '$WAR.war' de '$SIGM_REPO'" >&2
 if ! wget -O $CATALINA_HOME/webapps/$CTX.war -q "$SIGM_REPO/es/ieci/tecdoc/sigem/$WAR/${SIGM_VERSION}/$WAR-${SIGM_VERSION}.war"
 then
    echo "ERROR: En la descarga de '$SIGM_REPO/es/ieci/tecdoc/sigem/$WAR/${SIGM_VERSION}/$WAR-${SIGM_VERSION}.war' ... no se puede continuar" >&2
    exit 3
 fi

