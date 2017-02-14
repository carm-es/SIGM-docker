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
 useradd sigem -m
 echo -e "sigem\nsigem\n" | passwd sigem

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

 if wget -O /tmp/probe.war -q "https://github.com/psi-probe/psi-probe/releases/download/2.4.0.SP1/probe.war"
 then
    mv /tmp/probe.war $CATALINA_HOME/webapps/
 fi

 
 # Descargar cada uno de los WARS de SIGM y crear el Contexto
 for ctx in $(grep ':' Contextos.cfg | grep -v '#' | cut -d ':' -f 1)
 do
    bash download-sigm-war.sh $ctx
 done 

 # Extraer los drivers JDBC...
 cd $WorkDir 
 unzip $WorkDir/bd.zip 'driversJdbc/*'


 # Añadir las CAs al CACERTS de JAVA...
 Hoy=$( date  '+%Y%m' )
 mkdir /tmp/cas_$Hoy
 cd /tmp/cas_$Hoy
 unzip $CATALINA_HOME/CAs-Trusted.zip

 for i in *
 do
    a=$(echo $i | sed -e 's+\.+_+g' )
    yes | $JAVA_HOME/bin/keytool -importcert -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit -file $i -alias "${a}_$Hoy"
 done 

 cd -
 rm -fr /tmp/cas_$Hoy



 
 
