FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG EXTRA_LOCALES=""
ARG WITH_ALL_LOCALES="no"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates cron curl gzip libargon2-1 libaudit1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 locales procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "7.3.29-1" --checksum 4b49e675e788f7298302bad951add6783f5500238b4c9bfc02db2a792ed4990b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "apache" "2.4.48-1" --checksum 0296bc7dd5f621eba6f948433a6c7fc04a45876f42f6395cea5888b707f1ad11
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.30-0" --checksum 47107f86621bb184307e47bbb15244d076575f0e0f7d339f198ef312b6f3f285
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "libphp" "7.3.29-0" --checksum 4d12ca46685c94e8502990d417a466a919d1aa5d9528b29a45df3284686bbbf9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.0-3" --checksum 8179ad1371c9a7d897fe3b1bf53bbe763f94edafef19acad2498dd48b3674efe
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "moodle" "3.11.1-0" --checksum 21740f1fd2f2a5800ec5b9f4eb990c4624a342622b061096d510195036df509b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.13.0-0" --checksum fd7257c2736164d02832dbf72e2c1ed9d875bf3e32f0988520796bc503330129
RUN chmod g+rwX /opt/bitnami
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN sed -i -e '/pam_loginuid.so/ s/^#*/#/' /etc/pam.d/cron
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_AU.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

COPY rootfs /
RUN /opt/bitnami/scripts/locales/add-extra-locales.sh
RUN /opt/bitnami/scripts/apache/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
RUN /opt/bitnami/scripts/apache-modphp/postunpack.sh
RUN /opt/bitnami/scripts/moodle/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_ENABLE_CUSTOM_PORTS="no" \
    APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    BITNAMI_APP_NAME="moodle" \
    BITNAMI_IMAGE_VERSION="3.11.1-debian-10-r3" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    MYSQL_CLIENT_ENABLE_SSL="no" \
    MYSQL_CLIENT_SSL_CA_FILE="" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/apache/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080 8443

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/moodle/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/moodle/run.sh" ]
