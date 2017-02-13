#!/bin/bash


echo "Inicializando sigemAdmin" >&2
sqlcmd -S localhost -U sigemadmin -P passw0rd -d db_sigemadmin <sigemAdmin/sigemAdmin.sql 


echo "Inicializando fwktd-dir3DS" >&2
sqlcmd -S localhost -U fwktd_dir3 -P passw0rd -d db_fwktd_dir3 <dir3/fwktd-dir3-create.sql
sqlcmd -S localhost -U fwktd_dir3 -P passw0rd -d db_fwktd_dir3 <dir3/fwktd-dir3-insert.sql

