# Selección de versión de Tomcat a usar
#   https://hub.docker.com/_/tomcat/
FROM tomcat:7-jre7

MAINTAINER ignacio.barrancos@carm.es

# Fijar version de SIGM a desplegar
ENV SIGM_VERSION 3.0.1-M2

# Fijar Repositorio de artefactos
# Si no se establece habrá que añadir todos los WARs
ENV SIGM_REPO http://casa.tecnoquia.com/SIGM/mvn-repo

# Donde está instalado Tomcat
ENV CATALINA_HOME /usr/local/tomcat

# Desplegar scripts de configuración de Tomcat
RUN mkdir -p /var/lib/sigm 
ADD assets/ConexionBD.cfg	/var/lib/sigm/ConexionBD.cfg
ADD assets/ConfigTomcat.sh	/var/lib/sigm/ConfigTomcat.sh
ADD assets/Contextos.cfg	/var/lib/sigm/Contextos.cfg
ADD assets/CreateContext.sh	/var/lib/sigm/CreateContext.sh
ADD assets/CreateResource.sh	/var/lib/sigm/CreateResource.sh
ADD assets/deploy.sh		/var/lib/sigm/deploy.sh
ADD assets/run-tomcat.sh	/var/lib/sigm/run-tomcat.sh
ADD assets/ListaDirectorios	/var/lib/sigm/ListaDirectorios
ADD assets/sigem_configLocation.jar  $CATALINA_HOME/lib/sigem_configLocation.jar
ADD assets/tomcat-users.xml          $CATALINA_HOME/conf/tomcat-users.xml

# Instalación de bases de datos de SIGM
RUN chmod a+x /var/lib/sigm/*.sh && \
    /var/lib/sigm/deploy.sh

ENV BD_TYPE oracle
ENV BD_HOST localhost
ENV BD_PORT 1521
ENV BD_SID  XE


EXPOSE 8080
CMD ["/var/lib/sigm/run-tomcat.sh", "run"]

#
# Construir con:
#   docker build -t sigm/tomcat7-jre7:3.0.1-M2 .
#
# Ejecutar interactivo (y comprobar si falla algo con):
#   docker run -p 8080:8080 -i sigm/tomcat7-jre7:3.0.1-M2
#
