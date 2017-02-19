#!/bin/bash
# creating certs with your own CA

RANDOMID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
TEMPFOLDER="/tmp/"$RANDOMID

mkdir $TEMPFOLDER

# generate key
openssl genrsa -out $TEMPFOLDER/cert-key.pem 4096

# generate CSR
openssl req -new -key $TEMPFOLDER/cert-key.pem -out $TEMPFOLDER/cert.csr -sha512

echo -n "Please enter the path of the CA cert: "
read -e capath
echo -n "Please enter the path of the CA key: "
read -e cakeypath

openssl x509 -req -in $TEMPFOLDER/cert.csr -CA $capath -CAkey $cakeypath \
        -CAcreateserial -out $TEMPFOLDER/cert-pub.pem -days 365 -sha512

rm $TEMPFOLDER/cert.csr

cat $capath >> $TEMPFOLDER/cert-pub.pem

echo -n "Where should I store the cert PRIVATE key?: "
read -e certprivpath
echo -n "Where should I store the cert public key?: "
read -e certpubpath

mv $TEMPFOLDER/cert-key.pem $certprivpath
mv $TEMPFOLDER/cert-pub.pem $certpubpath

rm -r $TEMPFOLDER
