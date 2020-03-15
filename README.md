# Moodle a közoktatás számára

A **COVID-19** terjedése miatt Március 16-tól bezárnak a közoktatási intézmények és távoktatásra állnak át. Mivel nem tudom, hogy mennyire vannak felkészítve az iskolák erre, ezért biztos ami biztos alapon összeraktam egy gyors Moodle telepítőt. A rendszer indítását és egyéb informatikai aspektusait itt részletezem. A honlap beállítását, kezelését, kurzusok adminisztrációját a _resources_ mappában találtható _install_v1.pdf_ tartalmazza.

## Közreműködés
Szívesen veszek minden közreműködést, akár a kód csiszolásában akár a telepítő minőségibbé tételében.

## Célok
- Megkönnyíteni az iskolai rendszergazdák munkáját
- Egységes felület biztosítása iskolánként a tananyagok megosztására és a tanár-diák kommunikáció elősegítése
- Gyors beüzemelés után további beállítási lehetőségek biztosítása

## A rendszerhez szükségek előkövetelmények
- [Docker 18.x](https://docs.docker.com/install/) vagy újabb
- [Docker-Compose 1.25.x](https://docs.docker.com/compose/install/) (Csak Linux esetén!)
- [GitBash](https://gitforwindows.org/) (Csak Windows esetén!)

## Használata
### Működési elv
2 konténert indít el a rendszer (Moodle és MariaDB), melyek automatikusan konfigurálásra kerülnek a .env fájlokkal. Ez kb. 2-3 percet vesz igénybe és máris kész egy működő Moodle szerver.<br>
Windows, Linux, és macOS rendszereken ugyan úgy működnek a konténerek.
### Előzetes beállítások
1. Módosítsuk a moodle_conf.env fájlban (legalább) a következő értéket: <br>
  - MOODLE_DATABASE_PASSWORD=**moodle-bot-pw-changeme**
  - MOODLE_PASSWORD=**init_user**
2. Módosítsuk a mariadb_conf.env fájlban (legalább) a következő értékeket: <br>
  - MARIADB_PASSWORD=**moodle-bot-pw-changeme**
  - MARIADB_ROOT_PASSWORD=**soe_master_pw_changeme**
3. Windows esetén még:
  - Hyper-V engedélyezése
  - Docker elindítása
  - Meghajtó [megosztása](https://docs.docker.com/docker-for-windows/#docker-settings-dialog) a Docker-rel

_Figyeljünk arra, hogy a MOODLE_DATABASE_PASSWORD meg kell egyezzen a MARIADB_PASSWORD-el._<br>
**A moodle_conf.env és mariadb_conf.env fájlokat indítás után titkosítsuk! Csak akkor és addig legyenek olvasható szöveg formátumban, ameddig indítjuk vagy leállítjuk a konténereket!** <br> Példa platform-független, ingyenes titkosító szoftverre: [Cryptomator](https://cryptomator.org/).

### SSL tanusítvány beállítása HTTPS-hez - **_KÖTELEZŐ ELSŐ LÉPÉS!_**
#### Meglévő cert használata
1. Hozzunk létre a docker-compose.yml fájl mellé egy moodle_cert mappát.
2. Másoljuk bele a privát kulcs fájlt és a cert fájlt, nevezzük át őket server.key és server.crt nevűekre.

#### Átmeneti saját (self-signed) cert generálása
Windows rendszeren GitBash-ben, Linux és macOS esetén terminálban adjuk ki a következő parancsot ebben a mappában.
```
bash cert-generator-openssl.sh
```
Kövessük az utasításokat és adjuk meg a megfelelő értékeket. A bekért adatok nem lesznek ellenőrizve, tesztelés esetén véletlenszerűek is lehetnek. A generált _server.csr_ fájl felhasználható hivatalos tanusítvány igénylésére is! <br> A böngészők nem biztonságos kapcsolatnak fogják minősíteni a honlapot azonban az adatfolyam tikos marad. A fals minősítés oka, hogy nem hivatalos szerv állította ki ebben az esetben a cert-et. <br> A titkosítás megléte [Wireshark](https://www.wireshark.org/) programmal tesztelhető.

### Indítás
Windows rendszeren GitBash-ben, Linux és macOS esetén terminálban adjuk ki a következő parancsot ebben a mappában.
```
source project-config.sh
docker-compose up -d
```

### Leállítás
Windows rendszeren GitBash-ben, Linux és macOS esetén terminálban adjuk ki a következő parancsot ebben a mappában.
```
source project-config.sh
docker-compose down
```
_Az adatok megmaradnak a volume-okon, indításkor/újraindításkor a rendszer minden adata **megmarad**._

### Oldal elérése
A szerver domainján vagy IP címén a **8443**-mas porton. A port változtatható a docker-compose.yml fájlban.
> https://iskolam-cime.hu:8443 <br>
> https://192.168.1.3:8443 <br>

### Logok megtekintése
#### Moodle
```
source project-config.sh
docker logs ${COMPOSE_PROJECT_NAME}_moodle_1
```

#### MariaDB
```
source project-config.sh
docker logs ${COMPOSE_PROJECT_NAME}_mariadb_1
```
### Adatok
Az adatok Docker Volume formában tárolódnak (biztonsági okokból) a lokális gépen. Ezeknek a biztonsági mentéséről gondoskodnia kell ez intézménynek. A volume nevek a _COMPOSE_PROJECT_NAME_ és a docker-compose.yml fájlban meghatározott volume névből tevődnek össze. Ha a COMPOSE_PROJECT_NAME értéke _elearning_, akkor a 2 tároló neve alap esetben:
> elearning_moodle_data <br>
> elearning_mariadb_data

Segítség: [Docker volumes](https://docs.docker.com/storage/volumes/)

### Jótanácsok
- Érdemes 2 rendszert indítani, az egyik legyen az éles, a másik amivel lehet tesztelni különbüző beállításokat.
  1. Duplikáljuk az egész mappát.
  2. Az project-config.sh-ban változtassuk meg a _COMPOSE_PROJECT_NAME_ környezeti változó értékét.
  3. Adjuk ki az indító utasítást.

A rendszer használatáért, abból következő esetleges károkért nem vállalok felelősséget! Használjátok odafigyeléssel! :)
