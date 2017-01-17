
SIGM (tomcat7-jre7) en Docker
================================

Este directorio permite construir el servidor de aplicaciones de SIGM
sobre Tomcat7 y Java7 en Debian 8 *(Jessie)*


El fichero **Dockerfile** está basado en [tomcat:7-jre7](https://hub.docker.com/_/tomcat/), al 
que se ha añadido el soporte para 
[descargar y configurar las aplicaciones Web](https://carm-es.github.io/SIGM/3.0.1/Documentaci%C3%B3n-t%C3%A9cnica/instalaci%C3%B3n/Configuraci%C3%B3n-para-Tomcat-7.0.16.html) que forman parte de SIGM.

Esta imagen puede usarse para **testear una versión concreta de SIGM** o bien para **depurar el 
procedimiento y documentación de configuración del servidor de aplicaciones**, durante el desarrollo.


### Cómo usar esta imagen

Primero genere la imagen:
```
docker build -t sigm/tomcat7-jre7:3.0.1-M2 .
```

Luego podrá ejecutarla mediante:
```
docker run -p 8080:8080 -d sigm/tomcat7-jre7:3.0.1-M2
```

Una vez iniciado el servidor podrá acceder a las siguientes URLs:

* [http://localhost:8080/manager/html](http://localhost:8080/manager/html) Para acceder al administrador de Tomcat. Use como credenciales `tomcat/passw0rd`.
* [http://localhost:8080/probe/](http://localhost:8080/probe/) Para acceder a PSI Probe y monitorizar el servidor Tomcat. Use como credenciales `tomcat/passw0rd`.
* [http://localhost:8080/portal/](http://localhost:8080/portal/) Para acceder a la pantalla de acceso de SIGM.


Para acceder a las aplicaciones de administración, use: `administrador/administrador`

Para acceder a las aplicaciones de gestión, use: 
* `sigem/sigem`
* `REGISTRO_TELEMATICO/REGISTRO_TELEMATICO`
* `tramitador/tramitador`
* `archivo/archivo`



### Personalización

Existen dos variables en el fichero `Dokerfile` que controlan el despliegue de la versión de SIGM:

* **`SIGM_VERSION`** que permite indicar la versión de SIGM a desplegar. Hasta ahora sólo se ha probado para [3.0.1-M2](https://github.com/carm-es/SIGM/tree/3.0.1-M2)
* **`SIGM_REPO`** que apunta al repositorio de artefactos generados con la compilación de SIGM *(resultado de ejecutar: `mvn deploy ...`)*

El despliegue descargará con `wget` de la URL `SIGM_REPO` todos los Wars y ZIPs necesarios para ejecutar la versión `SIGM_VERSION` en el 
servidor de aplicaciones.

Además, existe una variable que permite configurar el servidor de base de datos a usar: `CONEXION_BBDD` y su valor contendrá siempre `BD_TYPE:BD_HOST:BD_PORT:BD_SID`, donde...

* **`BD_TYPE`** indica el tipo de servidor de base de datos que usará el servidor de aplicaciones. Los posibles valores que aceptará esta variable son: `oracle`, `postgresql`, `db2` ó `sqlserver`.
* **`BD_HOST`** indica la dirección IP del servidor de base de datos *(ejemplos: 192.168.2.45, localhost, ...)*
* **`BD_PORT`** indica el puerto TCP donde escuchará conexiones el servidor de base de datos *(ejemplos: 1521, 8456, ...)*
* **`BD_SID`** especifica el SID de la base de datos (sólo para el tipo `oracle`),  *(ejemplos: XE, SIGMDES, ...)*

Esta variable puede indicarse en línea, al ejecutar el docker:

```
docker run -p 8080:8080 -e CONEXION_BBDD=postgres:192.168.3.120:5436:: -d sigm/tomcat7-jre7:3.0.1-M2
```

Si desea conectar este docker a una base de datos ya existente, revise el fichero `config/ConexionBD.cfg`. En él se configuran los usuarios, contraseñas y bases de datos a los que conectarán las aplicaciones. Inicialmente está preconfigurado para conectar a alguno de los dockers de SIGM para base de datos, pero si su intención es probar una versión del servidor de aplicaciones contra otra base de datos deberá editar este fichero y personalizarlo para su caso. Luego tendrá que ejecutar `docker build` antes de poder ejecutar `docker run`.

El listado de WARs a desplegar se indica en `config/Contextos.cfg`: Elimine las líneas que se corresponden a los Wars que no tiene interés en usar. Luego deberá ejecutar `docker build` antes de poder ejecutar `docker run`.


También podrá personalizar la imagen para comprobar el despliegue de SIGM sobre otras versiones de Tomcat y Jre, de forma rápida. Para ello deberá editar el fichero `Dockerfile` y cambiar:

```
# Selección de versión de Tomcat a usar
#   https://hub.docker.com/_/tomcat/
FROM tomcat:7-jre7
``` 


