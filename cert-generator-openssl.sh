mkdir moodle_cert
docker run -it -v $(pwd)/moodle_cert:/export frapsoft/openssl genrsa -out /export/server.key 2048
docker run -it -v $(pwd)/moodle_cert:/export frapsoft/openssl req -new -key /export/server.key -out /export/server.csr
docker run -it -v $(pwd)/moodle_cert:/export frapsoft/openssl x509 -in /export/server.csr -out /export/server.crt -req -signkey /export/server.key -days 365
###Linux natív parancsok SSL certhez###
# openssl genrsa -out server.key 2048
# openssl req -new -key server.key -out server.csr
# openssl x509 -in server.csr -out server.crt -req -signkey server.key -days 365
###Opcionális - privát kulcs mentése jelszavas védelemmel###
# openssl rsa -des3 -in server.key -out privkey.pem
###Opcionális - privát kulcs kinyerése .pem fájlból jelszó megadásával###
# openssl rsa -in privkey.pem -out server.key
#cp server.key moodle_cert/
#cp server.crt moodle_cert/
echo "A generált fájlok a moodle_cert mappában kerültek elhelyezésre."
echo "A mappa privát kulcsot is tartalmaz! Gondoskodj róla, hogy illetéktelen ne férhessenek hozzá!"
ls moodle_cert/
