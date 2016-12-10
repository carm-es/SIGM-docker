
SIGM (postgres 9.2) en Docker
================================

Este directorio permite construir la base de datos de SIGM
sobre PostGreSQL 9.2 en Debian 8 *(Jessie)*


El fichero **Dockerfile** está basado en [postgres:9.2](https://hub.docker.com/_/postgres/), al 
que se ha añadido el soporte para 
[ejecutar los scripts de inicialización de la base de datos](https://carm-es.github.io/SIGM/3.0.1/Documentaci%C3%B3n-t%C3%A9cnica/instalaci%C3%B3n/Configuraci%C3%B3n-para-PostgreSQL-9.0.3.html).

Esta imagen puede usarse para **testear una versión concreta de SIGM** o bien para **depurar el 
procedimiento y documentación de inicialización de la base de datos**, durante el desarrollo.


### Cómo usar esta imagen

Primero genere la imagen:
```
docker build -t sigm/postgresql-9.2:3.0.1-M2 .
```

Luego podrá ejecutarla mediante:
```
docker run -p 5432:5432 -d sigm/postgresql-9.2:3.0.1-M2
```

Todas las contraseñas son `passw0rd`.


Si quiere visualizar cómo se ejecutan los scripts de inicialización de la base de datos, use:
```
docker run -p 5432:5432 -i sigm/postgresql-9.2:3.0.1-M2
```

### Personalización

Existen dos variables en el fichero `Dokerfile` que controlan el despliegue de la versión de SIGM:

* **`SIGM_VERSION`** que permite indicar la versión de SIGM a desplegar. Hasta ahora sólo se ha probado para [3.0.1-M2](https://github.com/carm-es/SIGM/tree/3.0.1-M2)
* **`SIGM_REPO`** que apunta al repositorio de artefactos generados con la compilación de SIGM *(resultado de ejecutar: `mvn deploy ...`)*

El despliege tratará de descargar el fichero `$SIGM_REPO/es/ieci/tecdoc/sigem/sigem_bd_dist/$SIGM_VERSION/sigem_bd_dist-${SIGM_VERSION}-bd.zip` que contiene todos los scripts de inicialización de las distintas base de datos.

Para tareas de desarrollo y depuración también se comentar la definición de `SIGM_REPO`, copiar el fichero `sigem_bd_dist-${SIGM_VERSION}-bd.zip` al mismo directorio que `Dockerfile` y descomentar:
```  
#ADD sigem_bd_dist-${SIGM_VERSION}-bd.zip /var/lib/sigm/sigem_bd_dist-${SIGM_VERSION}-bd.zip 
``` 

Cada vez que cambie el `.zip` deberá ejecutar:
```
 docker build -t sigm/postgresql-9.2:3.0.1-M2 .
 docker run -p 5432:5432 -i sigm/postgresql-9.2:3.0.1-M2
```

También podrá personalizar la imagen para comprobar el despliegue de SIGM sobre otras versiones de Postgres, de forma rápida. Para ello deberá editar el fichero `Dockerfile` y cambiar:
```
# Selección de versión de Postgres a usar
#   https://hub.docker.com/_/postgres/
FROM postgres:9.2
``` 


