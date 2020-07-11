# Container image that runs your code
FROM ubuntu:18.04
MAINTAINER Bjoern Lulay
ARG VERSION=latest

#Installation apt sources
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt update \
    && apt upgrade -y \
    && apt install -y --no-install-recommends \
    apache2 \
    wget \
    apt-transport-https \
    ca-certificates \
    gnupg \
    curl

#Installing Icinga
RUN export DEBIAN_FRONTEND=noninteractive \
    && wget -O - https://packages.icinga.com/icinga.key | apt-key add - \
    && echo "deb https://packages.icinga.com/ubuntu icinga-bionic main" > /etc/apt/sources.list.d/icinga.list \
    && apt update \
    && apt install -y --install-recommends \
    icinga2 \
    icinga2-ido-mysql \
    icingacli \
    icingaweb2 \
    icingaweb2-module-doc \
    icingaweb2-module-monitoring \
    monitoring-plugins \
    nagios-nrpe-plugin \
    nagios-plugins-contrib \
    nagios-snmp-plugins \
    libmonitoring-plugin-perl \
    && apt-get clean

#Open Port 80
EXPOSE 80

#Test
