#!/bin/bash


apt-get update && apt-get upgrade 
apt-get install proftpd 
apt-get install proftpd-mod-crypto


systemctl stop proftpd

USERNAME="Merry"
USERNAME2="Pippin"
PASSWORD="kalimac"
PASSWORD2="secondbreakfast"

useradd $USERNAME
useradd $USERNAME2

echo -e "$PASSWORD\n$PASSWORD" | passwd $USERNAME
echo -e "$PASSWORD2\n$PASSWORD2" | passwd $USERNAME2

echo "Les utilisateurs $USERNAME et $USERNAME2 ont été créés avec succès !"

cp /FTP/conf_files/proftpd.conf /etc/proftpd/conf.d 
cp /FTP/conf_files/modules.conf /etc/proftpd/conf.d

echo "Les fichiers de configuration de proftpd ont été copiés avec succès !"

ln -sf /etc/proftpd/conf.d/proftpd.conf /etc/proftpd/proftpd.conf
ln -sf /etc/proftpd/conf.d/modules.conf /etc/proftpd/modules.conf

echo "Les liens symboliques ont été créés avec succès !"

cd /etc/proftpd
mkdir ssl
cd ssl
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -out proftpd-rsa.pem -keyout proftpd-key.pem

echo "Les clés SSL ont été générées avec succès !"

systemctl start proftpd

