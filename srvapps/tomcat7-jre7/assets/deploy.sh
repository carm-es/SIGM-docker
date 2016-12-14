#!/bin/bash
#
#

 WorkDir="/var/lib/sigm"

 # Comprobar que exista CATALINA_HOME
 if [ "" = "$CATALINA_HOME" ]
 then
    echo "ERROR: No existe la variable CATALINA_HOME" >&2
    exit 4
 fi

 # Descomprimir scripts para la base de datos
 cd $WorkDir 

 # Crear el usuario sigem (en unix)
 useradd sigem  -m

 # Crear estructura de directorios (faltan todos los LOGs, los ficheros de archivo, etc...)
 for dir in $(cat $WorkDir/ListaDirectorios )
 do
    mkdir -p /home/sigem/$dir
 done
 chmod 777 -R /home/sigem

 # Descargar la configuracion de SIGEM
 if [ "" != "$SIGM_REPO" ]
 then
    echo "Descargarndo 'sigem_config-${SIGM_VERSION}.zip' de '$SIGM_REPO'" >&2
    if ! wget -O $WorkDir/config.zip -q "$SIGM_REPO/es/ieci/tecdoc/sigem/sigem_config/${SIGM_VERSION}/sigem_config-${SIGM_VERSION}.zip"
    then
       echo "ERROR: En la descarga... no se puede continuar" >&2
       exit 3
    fi

    echo "Descargarndo 'sigem_bd_dist-${SIGM_VERSION}-bd.zip' de '$SIGM_REPO'" >&2
    if ! wget -O $WorkDir/bd.zip -q "$SIGM_REPO/es/ieci/tecdoc/sigem/sigem_bd_dist/$SIGM_VERSION/sigem_bd_dist-${SIGM_VERSION}-bd.zip"
    then
       echo "ERROR: En la descarga... no se puede continuar" >&2
       exit 3
    fi
 else
    echo "ERROR: SIGM_REPO debe estar definida" >&2
    exit 5
 fi

 
 # Descargar cada uno de los WARS de SIGM y crear el Contexto
 for ctx in $(grep ':' Contextos.cfg | grep -v '#' | cut -d ':' -f 1)
 do
    bash CreateContext.sh $ctx
 done 

 # Extraer los drivers JDBC...
 cd $WorkDir 
 unzip $WorkDir/bd.zip 'driversJdbc/*'


 # Ahora descomprimir la configuración
 cd /home/sigem/SIGEM/conf
 unzip $WorkDir/config.zip

 # Se supone que ahora debería parsearse para cambiar
 # la configuración de acceso a base de datos...
 #  en la configuración por el tema de JBOSS, env/comp/jdbc etc...

 # El vsftp, el openoffice
 
 
 
