# Moodle a közoktatás számára

A **COVID-19** terjedése miatt Március 16-tól bezárnak a közoktatási intézmények és távoktatásra állnak át. Mivel nem tudom, hogy mennyire vannak felkészítve az iskolák erre, ezért biztos ami biztos alapon összeraktam egy gyors Moodle telepítőt.

## Célok
- Megkönnyíteni az iskolai rendszergazdák munkáját
- Egységes felület biztosítása iskolánként a tananyagok megosztására és a tanár-diák kommunikáció elősegítése
- Gyors beüzemelés után további beállítási lehetőségek biztosítása

## A rendszerhez szükségek előkövetelmények
- [Docker 18.x](https://docs.docker.com/install/) vagy újabb
- [Docker-Compose 1.25.x](https://docs.docker.com/compose/install/) (csak Linux esetén)
- [GitBash](https://gitforwindows.org/) (Csak Windows esetén)

## Használata
### Működési elv
2 konténert indít el a rendszer (Moodle és MariaDB), melyek automatikusan konfigurálásra kerülnek a .env fájlokkal. Ez kb. 2-3 percet vesz igénybe és máris kész egy működő Moodle szerver.<br>
Windows, Linux, és macOS rendszereken ugyan úgy működnek a konténerek.
### Előzetes beállítások
1. Módosítsuk a moodle_conf.env fájlban a következő értéket: <br>
  - MOODLE_DATABASE_PASSWORD=**moodle-bot-pw-changeme**
  - MOODLE_PASSWORD=**init_user**
2. Módosítsuk a mariadb_conf.env fájlban a következő értékeket: <br>
  - MARIADB_PASSWORD=**moodle-bot-pw-changeme**
  - MARIADB_ROOT_PASSWORD=**soe_master_pw_changeme**
3. Windows esetén még:
  - Hyper-V engedélyezése
  - Docker elindítása

_Figyeljünk arra, hogy a MOODLE_DATABASE_PASSWORD meg kell egyezzen a MARIADB_PASSWORD-el._<br><br>
**A moodle_conf.env és mariadb_conf.env fájlokat indítás után titkosítva tároljuk! Csak akkor és addig legyenek olvasható szöveg formátumban, ameddig indítjuk vagy leállítjuk a konténereket!**

### SSL cert beállítása - **_KÖTELEZŐ!_**
#### Meglévő cert használata
1. Hozzunk létre a docker-compose.yml fájl mellé egy moodle_cert mappát.
2. Másoljuk bele a privát kulcs fájlt és a cert fájlt, nevezzük át őket server.key és server.crt nevűekre.

#### Átmeneti saját (self-signed) cert generálása
Windows rendszeren GitBash-ben, Linux és macOS esetén terminálban adjuk ki a következő parancsot ebben a mappában.
Kövessük az utasításokat és adjuk meg a megfelelő értékeket. A böngészők nem biztonságos kapcsolatnak fogják minősíteni a honlapot azonban az adatfolyam tikos marad. A fals minősítés oka, hogy nem hivatalos szerv állította ki ebben az esetben a cert-et. A titkosítás megléte [Wireshark](https://www.wireshark.org/) programmal tesztelhető.
```
bash cert-generator-openssl.sh
```

### Indítás
Windows rendszeren GitBash-ben, Linux és macOS esetén terminálban adjuk ki a következő parancsot ebben a mappában.
A "-d kapcsoló opcionális, elrejti a logokat."
```
docker-compose up -d
```

### Leállítás
Windows rendszeren GitBash-ben, Linux és macOS esetén terminálban adjuk ki a következő parancsot ebben a mappában.
```
docker-compose down
```
_Az adatok megmaradnak a volume-okon, indításkor a rendszer újraindulásakor minden **megmarad**._

### Oldal elérése
A szerver domainján, IP címén a **8443**-mas porton. A port változtatható a docker-compose.yml fájlban.

### Adatok
Az adatok Docker Volume-ként tárolódnak a lokális gépen **_bitnami-docker-moodle_mariadb_data_** és **_bitnami-docker-moodle_moodle_data_** néven. Ezeknek a biztonsági mentéséről gondoskodnia kell ez intézménynek. Segítség: [Docker volumes](https://docs.docker.com/storage/volumes/)

### Jótanácsok
- Érdemes 2 rendszert indítani, az egyik legyen az éles, a másik amivel lehet tesztelni különbüző beállításokat. Csupán duplikáljuk az egész mappát, az újat nevezzük át, lépjünk be és a fenti paranccsal indítsuk el a rendszert!
