#!/bin/sh

#start FOG services
## inpired by https://github.com/ctic-sje-ifsc/container_imagens/tree/master/fog

echo "Starting tFTPd"
/bin/systemctl start tftpd-hpa
echo "Starting vsftpd"
/bin/systemctl start vsftpd
echo "Starting apache2"
apachectl -D FOREGROUND


