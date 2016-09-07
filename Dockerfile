FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=moodle \
    BITNAMI_IMAGE_VERSION=3.1.0-r1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

RUN bitnami-pkg unpack apache-2.4.23-1 --checksum c8d14a79313c5e47dbf617e9a55e88ff91d8361357386bab520aabccd35c59d8
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976
RUN bitnami-pkg install php-5.6.24-1 --checksum 6cdb5736757bfe0a950034d0dc85a48c3e4ab02bec64c90f0c44454069362e65
RUN bitnami-pkg install libphp-5.6.21-2 --checksum 83d19b750b627fa70ed9613504089732897a48e1a7d304d8d73dec61a727b222

# Install moodle
RUN bitnami-pkg unpack moodle-3.1.0-1 --checksum b397661d41a2970ef4f8e520486b8351beef6c1dc0e4493760a44f5f930ba99d

COPY rootfs /

VOLUME ["/bitnami/moodle", "/bitnami/apache"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "apache"]
