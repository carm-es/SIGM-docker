# Selección de versión de Postgres a usar
#   https://hub.docker.com/_/postgres/
FROM postgres:9.2

MAINTAINER ignacio.barrancos@carm.es

# Instalar paquetes que faltan
RUN apt-get -qq update && \
    apt-get -q -y upgrade && \
    apt-get install -y unzip wget && \
    rm -rf /var/lib/apt/lists/*

# Fijar version de SIGM a desplegar
ENV SIGM_VERSION 3.0.1-M2

# Fijar Repositorio de artefactos
# Si no se establece habrá que añadir el fichero sigem_bd_dist-${SIGM_VERSION}-bd.zip
ENV SIGM_REPO http://casa.tecnoquia.com/SIGM/mvn-repo

# Desplegar scripts de creación de base de datos
RUN mkdir -p /var/lib/sigm 
ADD deploy.sh /var/lib/sigm/deploy.sh
##ADD sigem_bd_dist-${SIGM_VERSION}-bd.zip /var/lib/sigm/sigem_bd_dist-${SIGM_VERSION}-bd.zip 

# Instalación de bases de datos de SIGM
RUN chmod a+x /var/lib/sigm/deploy.sh && \
    /var/lib/sigm/deploy.sh

# Entorno castellando para PostGres
ADD set-spanish-lang-debian.sh /bin/set-spanish-lang-debian.sh
RUN chmod a+x /bin/set-spanish-lang-debian.sh && /bin/set-spanish-lang-debian.sh
ENV LANG		es_ES@euro

# Clave por defecto para todos los usuarios de base de datos
ENV POSTGRES_PASSWORD	passw0rd

#
# Construir con:
#   docker build -t sigm/postgresql-9.2:3.0.1-M2 .
#
# Ejecutar interactivo (y comprobar si falla algo con):
#   docker run -p 5432:5432 -i sigm/postgresql-9.2:3.0.1-M2
#
