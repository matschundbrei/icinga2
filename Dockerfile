# Container image that runs your code
FROM ubuntu:18.04
MAINTAINER Bjoern Lulay
ARG VERSION=latest

#Installation apt sources
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt update \
    && apt upgrade -y \
    && apt install -y --no-install-recommends \
    apache2 wget apt-transport-https ca-certificates gnupg curl apt-utils

#Installing Icinga
RUN export DEBIAN_FRONTEND=noninteractive \
    && wget -O - https://packages.icinga.com/icinga.key | apt-key add - \
    && echo "deb https://packages.icinga.com/ubuntu icinga-bionic main" > /etc/apt/sources.list.d/icinga.list \
    && apt update \
    && apt install -y --install-recommends \
    icinga2 icingacli \
    icingaweb2 \
    icingaweb2-module-doc \
    icingaweb2-module-monitoring \
    monitoring-plugins \
    nagios-nrpe-plugin \
    nagios-plugins-contrib \
    nagios-snmp-plugins \
    libmonitoring-plugin-perl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    icinga2 api setup \
    icinga2 feature enable ido-mysql

#Copy Vhost to apache config
#COPY config/000-default.conf /etc/apache2/sites-available
#COPY config/default-ssl.conf /etc/apache2/sites-available

# Define mountable directories.
VOLUME /etc/icinga2/

# Define working directory.
WORKDIR /etc/icinga2

#Open Port 80
EXPOSE 80

#Open Port 443
#EXPOSE 443
# Needed ENV variables to run apache
# see /etc/apache2/envvars
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2

#Start apache
CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]

