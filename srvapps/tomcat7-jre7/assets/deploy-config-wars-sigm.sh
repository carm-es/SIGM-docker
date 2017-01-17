#!/bin/bash
#
#
# Despliega los ficheros de configuración de SIGM
# 
# Por defecto, el script detecta si la máquina ya tenía una configuración
# desplegada. Si fuera así, saldrá del script sin hacer nada, pero en caso
# de que el valor de la vble $CONEXION_BBDD sea diferente al de la última
# vez que inició el docker, o se le indique al script -force como argumento
# se regenerará toda la configuración
#
# Argumentos:
#   1er arg [OPCIONAL] = -force => No comprueba si estaba desplegada:
#                        elimina anterior configuración y vuelve a 
#                        desplegarla

 WorkDir="/var/lib/sigm"

 # Comprobar que exista CATALINA_HOME
 if [ "" = "$CATALINA_HOME" ]
 then
    echo "ERROR: No existe la variable CATALINA_HOME" >&2
    exit 4
 fi

 # Comprobar que se configuró correctamente 
 if [ "" = "$CONEXION_BBDD" ]
 then
    echo "ERROR: No se encontró definida la vble $CONEXION_BBDD" >&2
    exit 5
 fi

 # Sustituir etc/hosts
 bash /var/lib/sigm/deploy-etc-hosts.sh
 chown sigem.sigem -R /home/sigem 2>/dev/null

 # Comprobar si se cambio algo de la configuracion, desde el último inicio del docker
 lastRun=$(cat $WorkDir/lastRunConfig 2>/dev/null )
 echo -e "\n\n* * * * * * *" >&2
 echo -e "  SIGM en Tomcat\n" >&2
 if [ "-force" != "$1" ] && [ "$lastRun" = "$CONEXION_BBDD" ]
 then
    echo "  [SKIP] Configuración desplegada en el último inicio" >&2
    exit 0
 else
    echo "  [CFG] Aplicando nueva configuración '$CONEXION_BBDD'" >&2
 fi
 echo -e "\n\n* * * * * * *\n\n" >&2

 # Descomprimir scripts para la base de datos
 cd $WorkDir 

 # Crear estructura de directorios (faltan todos los LOGs, los ficheros de archivo, etc...)
 rm /home/sigem -fr 2>/dev/null
 mkdir /home/sigem

 for dir in $(cat $WorkDir/ListaDirectorios )
 do
    mkdir -p /home/sigem/$dir
 done
 chmod 777 -R /home/sigem


 # Configurar los contentos de SIGM
 mkdir -p $CATALINA_HOME/conf/Catalina/localhost
 rm -f $CATALINA_HOME/conf/Catalina/localhost/*.xml 2>/dev/null
 for ctx in $(grep ':' Contextos.cfg | grep -v '#' | cut -d ':' -f 1)
 do
    bash deploy-context-app.sh $ctx
 done 


 # Configurar los Resources en server.xml del Tomcat
 if [ ! -e $CATALINA_HOME/conf/server.xml_original ]
 then
    cp -f  $CATALINA_HOME/conf/server.xml $CATALINA_HOME/conf/server.xml_original 
 fi
 cp -f  $CATALINA_HOME/conf/server.xml_original $CATALINA_HOME/conf/server.xml
 bash deploy-tomcat-resources-db.sh 


 # Copiar el driver jdbc
 JarJDBC=$(find /var/lib/sigm/driversJdbc -type f -name "*jar" | grep -i "$BD_TYPE" | sort -u | tail -1 )
 if [ "" = "$JarJDBC" ]
 then
    echo "ERROR: No se pudo encontrar driver jdbc para '$DB_TYPE'"
    exit 4
 fi
 cp -f $JarJDBC $CATALINA_HOME/lib/


 # Ahora descomprimir la configuración
 cd /home/sigem/SIGEM/conf
 unzip $WorkDir/config.zip >/dev/null 

 cd $WorkDir 
 bash configure-sigm-apps-for-$BD_TYPE.sh

 # El vsftp, el openoffice
 

 # Marcar la configuración para que si no cambia, no se vuelva a redesplegar
 echo "$CONEXION_BBDD" > $WorkDir/lastRunConfig

 chown sigem.sigem -R /home/sigem 2>/dev/null
