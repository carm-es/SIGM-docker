#!/bin/bash
#
# Esto es necesario para que funcione el FTP en SIGM
#  https://carm-es.github.io/SIGM/3.0.1/Documentaci%C3%B3n-t%C3%A9cnica/instalaci%C3%B3n/Manual-de-instalaci%C3%B3n-AL-SIGM.html#problema-al-crear-ficheros-en-repositorios-documentales


 # Averiguar el hostname del equipo
 h=$(hostname -s)

 # Preparar nuevo etc/hosts
 cat <<EOF >/tmp/x
127.0.0.1	localhost $h
::1	localhost ip6-localhost ip6-loopback $h
EOF

 # Excluir de etc/hosts los localhost
 grep -v '^127.0.0.1' /etc/hosts | grep -v '^::1' >> /tmp/x

 # Sustituir
 cp -f /tmp/x /etc/hosts
