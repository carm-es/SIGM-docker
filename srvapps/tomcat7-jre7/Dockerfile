# Selección de versión de Tomcat a usar
#   https://hub.docker.com/_/tomcat/
FROM tomcat:7-jre7

MAINTAINER ignacio.barrancos@carm.es

# Instalar paquetes que faltan
RUN apt-get -qq update && \
    apt-get -q -y upgrade && \
    apt-get install -y unzip vsftpd vim libreoffice libreoffice-l10n-es uno-libs3 ure unoconv xvfb x11-utils x11-xserver-utils ftp && \
    rm -rf /var/lib/apt/lists/*

# Fijar version de SIGM a desplegar
ENV SIGM_VERSION 3.0.1-M2

# Fijar Repositorio de artefactos
# Si no se establece habrá que añadir todos los WARs
ENV SIGM_REPO http://casa.tecnoquia.com/SIGM/mvn-repo

# Donde está instalado Tomcat
ENV CATALINA_HOME /usr/local/tomcat

# Desplegar scripts y configuración para Tomcat
RUN mkdir -p /var/lib/sigm 
ADD config/ConexionBD.cfg       /var/lib/sigm/ConexionBD.cfg
ADD config/Contextos.cfg        /var/lib/sigm/Contextos.cfg
ADD config/ListaDirectorios	/var/lib/sigm/ListaDirectorios 
ADD config/tomcat-users.xml     $CATALINA_HOME/conf/tomcat-users.xml
ADD config/vsftpd.conf          /etc/vsftpd.conf

ADD assets/sigem_configLocation.jar  $CATALINA_HOME/lib/sigem_configLocation.jar
ADD assets/start_open_office_nox.sh  /bin/start_open_office_nox.sh

ADD assets/configure-sigm-apps-for-oracle.sh     /var/lib/sigm/configure-sigm-apps-for-oracle.sh    
ADD assets/configure-sigm-apps-for-postgres.sh   /var/lib/sigm/configure-sigm-apps-for-postgres.sh

ADD assets/create-jndi-resource.sh           /var/lib/sigm/create-jndi-resource.sh
ADD assets/deploy-etc-hosts.sh               /var/lib/sigm/deploy-etc-hosts.sh
ADD assets/deploy-config-wars-sigm.sh        /var/lib/sigm/deploy-config-wars-sigm.sh
ADD assets/deploy-context-app.sh             /var/lib/sigm/deploy-context-app.sh
ADD assets/deploy-docker.sh                  /var/lib/sigm/deploy-docker.sh
ADD assets/deploy-tomcat-resources-db.sh     /var/lib/sigm/deploy-tomcat-resources-db.sh
ADD assets/download-sigm-war.sh              /var/lib/sigm/download-sigm-war.sh
ADD assets/run-tomcat.sh                     /var/lib/sigm/run-tomcat.sh

# Descarga de elementos y preparación del contenedor
RUN chmod a+x /var/lib/sigm/*.sh && \
    chmod a+x /bin/start_open_office_nox.sh && \
    /var/lib/sigm/deploy-docker.sh

ENV CONEXION_BBDD  oracle:192.168.2.63:1521:XE

EXPOSE 8080
EXPOSE 8443
CMD ["/var/lib/sigm/run-tomcat.sh", "run"]

#
# Construir con:
#   docker build -t sigm/tomcat7-jre7:3.0.1-M2 .
#
# Ejecutar interactivo (y comprobar si falla algo con):
#   docker run -p 8080:8080 -i sigm/tomcat7-jre7:3.0.1-M2
#
