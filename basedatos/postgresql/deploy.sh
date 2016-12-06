#!/bin/bash
#
#

 WorkDir="/var/lib/sigm"
 DB="PostgreSQL"

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
 
 # Averiguar la ruta donde copiar los diccionarios
 tsearch=$( find /usr/share -type d -name tsearch_data )

 # Instalar directorios
 cp -f $WorkDir/$DB/diccionarios_busqueda_documental/posterior_igual_8.3/* $tsearch/


 # Crear usuarios PostGres
 cat >$WorkDir/CreateUsers.sql <<EOSQL

  CREATE USER sigemadmin WITH PASSWORD 'passw0rd';
  CREATE DATABASE db_sigemadmin
    WITH OWNER=sigemadmin
         ENCODING = 'LATIN9'
         CONNECTION LIMIT = -1;
   GRANT ALL PRIVILEGES ON DATABASE db_sigemadmin TO sigemadmin;


  CREATE USER fwktd_dir3 WITH PASSWORD 'passw0rd';
  CREATE DATABASE db_fwktd_dir3
    WITH OWNER=fwktd_dir3
         ENCODING = 'LATIN9'
         CONNECTION LIMIT = -1;
   GRANT ALL PRIVILEGES ON DATABASE db_fwktd_dir3 TO fwktd_dir3;


  CREATE USER registrods_000 WITH PASSWORD 'passw0rd';
  CREATE DATABASE db_registrods_000
    WITH OWNER=registrods_000
         ENCODING = 'LATIN9'
         CONNECTION LIMIT = -1;
   GRANT ALL PRIVILEGES ON DATABASE db_registrods_000 TO registrods_000;


  CREATE USER fwktd_sirds_000 WITH PASSWORD 'passw0rd';
  CREATE DATABASE db_fwktd_sirds_000
    WITH OWNER=fwktd_sirds_000
         ENCODING = 'LATIN9'
         CONNECTION LIMIT = -1;
   GRANT ALL PRIVILEGES ON DATABASE db_fwktd_sirds_000 TO fwktd_sirds_000;


  CREATE USER fwktd_auditds_000 WITH PASSWORD 'passw0rd';
  CREATE DATABASE db_fwktd_auditds_000
    WITH OWNER=fwktd_auditds_000
         ENCODING = 'LATIN9'
         CONNECTION LIMIT = -1;
   GRANT ALL PRIVILEGES ON DATABASE db_fwktd_auditds_000 TO fwktd_auditds_000;


  CREATE USER tramitadords_000 WITH PASSWORD 'passw0rd';
  CREATE DATABASE db_tramitadords_000
    WITH OWNER=tramitadords_000
         ENCODING = 'LATIN9'
         CONNECTION LIMIT = -1;
   GRANT ALL PRIVILEGES ON DATABASE db_tramitadords_000 TO tramitadords_000;


  CREATE USER etramitacionds_000 WITH PASSWORD 'passw0rd';
  CREATE DATABASE db_etramitacionds_000
    WITH OWNER=etramitacionds_000
         ENCODING = 'LATIN9'
         CONNECTION LIMIT = -1;
   GRANT ALL PRIVILEGES ON DATABASE db_etramitacionds_000 TO etramitacionds_000;


  CREATE USER archivods_000 WITH PASSWORD 'passw0rd';
  CREATE DATABASE db_archivods_000
    WITH OWNER=archivods_000
         ENCODING = 'LATIN9'
         CONNECTION LIMIT = -1;
   GRANT ALL PRIVILEGES ON DATABASE db_archivods_000 TO archivods_000;

EOSQL


 # Inicializacion de la Base de datos
 cat >/docker-entrypoint-initdb.d/SIGM.sh  <<EOF

gosu postgres psql --username "$POSTGRES_USER" <$WorkDir/CreateUsers.sql


gosu postgres psql --username sigemadmin --dbname db_sigemadmin  <$WorkDir/$DB/sigemAdmin/sigemAdmin.sql 


gosu postgres psql --username fwktd_dir3 --dbname db_fwktd_dir3  <$WorkDir/$DB/dir3/fwktd-dir3-create.sql
gosu postgres psql --username fwktd_dir3 --dbname db_fwktd_dir3  <$WorkDir/$DB/dir3/fwktd-dir3-insert.sql


gosu postgres psql --username registrods_000 --dbname db_registrods_000 <$WorkDir/$DB/registro/01.1_create_tables_registro_sigem_postgres.sql
gosu postgres psql --username registrods_000 --dbname db_registrods_000 <$WorkDir/$DB/registro/01.2_create_tables_invesdoc_registro_sigem_postgres.sql
gosu postgres psql --username registrods_000 --dbname db_registrods_000 <$WorkDir/$DB/registro/01.3_create_views_invesdoc_registro_sigem_postgres.sql
gosu postgres psql --username registrods_000 --dbname db_registrods_000 <$WorkDir/$DB/registro/02.1_create_indexes_constraints_registro_sigem_postgres.sql
gosu postgres psql --username registrods_000 --dbname db_registrods_000 <$WorkDir/$DB/registro/02.2_create_indexes_constraints_invesdoc_registro_sigem_postgres.sql
gosu postgres psql --username registrods_000 --dbname db_registrods_000 <$WorkDir/$DB/registro/03.1_insert_data_registro_sigem_postgres.sql


gosu postgres psql --username fwktd_sirds_000 --dbname db_fwktd_sirds_000 <$WorkDir/$DB/sir/fwktd-sir-create.sql
gosu postgres psql --username fwktd_sirds_000 --dbname db_fwktd_sirds_000 <$WorkDir/$DB/sir/fwktd-sir-insert.sql
gosu postgres psql --username fwktd_sirds_000 --dbname db_fwktd_sirds_000 <$WorkDir/$DB/sir/fwktd-dm-bd-create.sql
gosu postgres psql --username fwktd_sirds_000 --dbname db_fwktd_sirds_000 <$WorkDir/$DB/sir/fwktd-dm-bd-insert.sql


gosu postgres psql --username fwktd_auditds_000 --dbname db_fwktd_auditds_000 <$WorkDir/$DB/audit/fwktd-audit-create.sql
gosu postgres psql --username fwktd_auditds_000 --dbname db_fwktd_auditds_000 <$WorkDir/$DB/tramitador/50-tramitador_auditoria_datos.sql
gosu postgres psql --username fwktd_auditds_000 --dbname db_fwktd_auditds_000 <$WorkDir/$DB/registro/06-insert_data_registro_auditoria_datos_postgres.sql


gosu postgres psql --username archivods_000 --dbname db_archivods_000  <$WorkDir/$DB/archivo/01.archivo-create-tables-postgres.sql
gosu postgres psql --username archivods_000 --dbname db_archivods_000  <$WorkDir/$DB/archivo/02.archivo-create-indexes-postgres.sql
gosu postgres psql --username archivods_000 --dbname db_archivods_000  <$WorkDir/$DB/archivo/03.archivo-insert-data-postgres.sql
gosu postgres psql --username archivods_000 --dbname db_archivods_000  <$WorkDir/$DB/archivo/04.archivo-insert-text-postgres.sql
gosu postgres psql --username archivods_000 --dbname db_archivods_000  <$WorkDir/$DB/archivo/05.archivo-create-functions-postgres.sql
gosu postgres psql --username archivods_000 --dbname db_archivods_000  <$WorkDir/$DB/archivo/06.archivo-personalization-postgres.sql
gosu postgres psql --username archivods_000 --dbname db_archivods_000  <$WorkDir/$DB/archivo/complementario/archivo-organizacion-bd/01.archivo-organizacion-bd-create-tables-postgres.sql
gosu postgres psql --username archivods_000 --dbname db_archivods_000  <$WorkDir/$DB/archivo/complementario/archivo-organizacion-bd/02.archivo-organizacion-bd-create-indexes-postgres.sql
gosu postgres psql --username archivods_000 --dbname db_archivods_000  <$WorkDir/$DB/archivo/complementario/archivo-busqueda-documental/posterior_igual_8.3/01.archivo-create-documentary-search-postgres.sql
gosu postgres psql --username archivods_000 --dbname db_archivods_000  <$WorkDir/$DB/archivo/complementario/archivo-busqueda-documental/posterior_igual_8.3/02.archivo-insert-documentary-search-postgres.sql


gosu postgres psql --username etramitacionds_000 --dbname db_etramitacionds_000  <$WorkDir/$DB/eTramitacion/01_create_tables.sql
gosu postgres psql --username etramitacionds_000 --dbname db_etramitacionds_000  <$WorkDir/$DB/eTramitacion/02_create_indexes_constraints.sql
gosu postgres psql --username etramitacionds_000 --dbname db_etramitacionds_000  <$WorkDir/$DB/eTramitacion/03_insert_data.sql
gosu postgres psql --username etramitacionds_000 --dbname db_etramitacionds_000  <$WorkDir/$DB/eTramitacion/04_insert_data_tasks.sql
gosu postgres psql --username etramitacionds_000 --dbname db_etramitacionds_000  <$WorkDir/$DB/csv/fwktd-csv-create.sql
gosu postgres psql --username etramitacionds_000 --dbname db_etramitacionds_000  <$WorkDir/$DB/eTramitacion/05_insert_data_csv_fwktd_module.sql


gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/01-create_tables.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/02-create_indexes_constraints.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/03-create_sequences.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/04-create_views.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/05-create_procedures.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/06-datos_iniciales.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/07-plantillas_iniciales.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/08-informes_estadisticos.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/21-prototipos_create_tables.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/22-prototipos_create_indexes_constraints.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/23-prototipos_create_sequences.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/24-prototipos_datos.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/25-prototipos_plantillas.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/26-prototipos_actualizacion_permisos.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/27-prototipos_configuracion_publicador.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/41-prototipos_v1.9_create_tables.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/42-prototipos_v1.9_create_indexes_constraints.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/43-prototipos_v1.9_create_sequences.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/44-prototipos_v1.9_datos.sql
gosu postgres psql --username tramitadords_000 --dbname db_tramitadords_000  <$WorkDir/$DB/tramitador/45-prototipos_v1.9_plantillas.sql



EOF

