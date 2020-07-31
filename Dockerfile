# Container image that runs your code
FROM alpine:3.12
MAINTAINER Bjoern Lulay
ARG VERSION=latest

RUN apk update; \
    apk upgrade; \
    apk add --no-cache apache2

COPY config/httpd.conf /etc/apache2

ENV APACHE_RUN_USER=apache \
    APACHE_RUN_GROUP=apache \
    APACHE_PID_FILE=/run/apache2/httpd.pid \
    APACHE_RUN_DIR=/run/apache2 \
    APACHE_LOCK_DIR=/var/lock/apache2 \
    APACHE_LOG_DIR=/var/log/apache2

EXPOSE 80

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]