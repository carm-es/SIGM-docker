# Selección de versión de SQLServer a usar
#   https://github.com/Microsoft/mssql-docker
#   https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-docker
FROM microsoft/mssql-server-linux

MAINTAINER ignacio.barrancos@carm.es

# Configurar opciones para MSSqlServer
ENV ACCEPT_EULA Y
ENV SA_PASSWORD Passw0rd 

# Instalar paquetes que faltan
RUN apt-get -qq update && \
    apt-get -q -y upgrade && \
    apt-get install -y unzip wget apt-transport-https 

# Preparar repositorios de Microsoft
RUN wget https://packages.microsoft.com/keys/microsoft.asc && \
    apt-key add microsoft.asc && \
    rm microsoft.asc 

# Descargar herramientas de administración de SqlServer
RUN wget https://packages.microsoft.com/config/ubuntu/16.04/prod.list -O /etc/apt/sources.list.d/msprod.list && \
    apt-get -qq update && \
    apt-get install -y mssql-tools && \
    rm -rf /var/lib/apt/lists/*

# Configurar PATH
ENV PATH  /opt/mssql-tools/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Entorno castellando
ADD assets/set-spanish-lang-debian.sh /bin/set-spanish-lang-debian.sh
RUN chmod a+x /bin/set-spanish-lang-debian.sh && /bin/set-spanish-lang-debian.sh
ENV LANG	es_ES.utf8
ENV COLLATION	SQL_Latin1_General_CP1_CI_AS

# Variables para Oracle
##### TODO ENV NLS_LANG		spanish_spain.WE8ISO8859P15
##### TODO ENV ORACLE_HOME		/u01/app/oracle/product/11.2.0/xe
##### TODO ENV SQLPLUS		$ORACLE_HOME/bin/sqlplus

# Fijar version de SIGM a desplegar
ENV SIGM_VERSION 3.0.1-M2

# Fijar Repositorio de artefactos
# Si no se establece habrá que añadir el fichero sigem_bd_dist-${SIGM_VERSION}-bd.zip
ENV SIGM_REPO https://inexus.carm.es/nexus/content/repositories/sigm

# Desplegar scripts de creación de base de datos
RUN mkdir -p /var/lib/sigm 
ADD assets/deploy.sh 		/var/lib/sigm/deploy.sh
ADD assets/create-databases.sql /var/lib/sigm/create-databases.sql
ADD assets/initdb.sh		/var/lib/sigm/initdb.sh
## ADD sigem_bd_dist-${SIGM_VERSION}-bd.zip /var/lib/sigm/sigem_bd_dist-${SIGM_VERSION}-bd.zip 

# Preparación de scripts de bases de datos de SIGM
RUN chmod a+x /var/lib/sigm/deploy.sh && \
    /var/lib/sigm/deploy.sh

# Inicializacion de la base de datos
##### TODO ADD assets/initdb.sh	/var/lib/sigm/initdb.sh
##### TODO RUN chmod a+x /var/lib/sigm/initdb.sh && \
##### TODO     /var/lib/sigm/initdb.sh && \
##### TODO     rm -fr /var/lib/sigm 


#
# Construir con:
#   docker build -t sigm/sqlserver-2016:3.0.1-M2 .
#
# Ejecutar interactivo (y comprobar si falla algo con):
#   docker run -p 1433:1433 -d sigm/sqlserver-2016:3.0.1-M2
#

