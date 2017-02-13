#!/bin/bash
#
#

 WorkDir="/var/lib/sigm"
 DB="SQLServer"

 # Descomprimir scripts para la base de datos
 cd $WorkDir 

 # Descargar si se puede el ZIP con los scripts
 dev=1
 if [ ! -e sigem_bd_dist-${SIGM_VERSION}-bd.zip ]
 then
    if [ "" != "$SIGM_REPO" ]
    then
       dev=0
       echo "Descargarndo 'sigem_bd_dist-${SIGM_VERSION}-bd.zip' de '$SIGM_REPO'" >&2
       wget "$SIGM_REPO/es/ieci/tecdoc/sigem/sigem_bd_dist/$SIGM_VERSION/sigem_bd_dist-${SIGM_VERSION}-bd.zip"
    fi
 fi

 if [ -e sigem_bd_dist-${SIGM_VERSION}-bd.zip ]
 then
    unzip sigem_bd_dist-${SIGM_VERSION}-bd.zip "$DB/*" || exit 123
    if [ 1 -eq $dev ]
    then
       echo "USANDO scripts locales (desarrollo)" >&2
    fi
 else
    echo "ERROR: No se puede acceder a sigem_bd_dist-${SIGM_VERSION}-bd.zip ... saliendo" >&2
    exit 126
 fi
 

 # Arrancar el servicio...
 cd /tmp
 nohup /opt/mssql/bin/sqlservr.sh &

 # Esperar a que arranque el servicio
 sleep 2m

 #
 # CREACION DE BASES DE DATOS...
 #

 

 cd $WorkDir 
 echo "CREANDO BASES DE DATOS" >&2
 sqlcmd -S localhost -U SA -P $SA_PASSWORD <  $WorkDir/create-databases.sql

 
 # Inicializacion de las Bases de datos
 cd $WorkDir/$DB 
 bash $WorkDir/initdb.sh


