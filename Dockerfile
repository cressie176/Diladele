FROM ubuntu:14.04
MAINTAINER diladele@stephen-cresswell.net

RUN echo cachebust 29/12/2014

# Configure Ubuntu
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
RUN apt-get update
RUN apt-get -y upgrade
RUN locale-gen en_GB en_GB.UTF-8
RUN ln -sf /bin/bash /bin/sh

# Install basics
RUN apt-get install -y wget curl man dnsutils bc

# Install supervisor
RUN apt-get install -y supervisor

# Install Diladele pre-requisits
RUN apt-get install -y python-setuptools python-ldap apache2 libapache2-mod-wsgi sqlite

# Install Squid HTTPS Filtering pre-requisits
RUN apt-get install -y devscripts build-essential fakeroot libssl-dev ssl-cert squid-langpack squidclient=3.3.8-1ubuntu6.2

# Install Django
RUN easy_install django==1.6.8

# Build, Install & Configure Squid with HTTPS Filtering
RUN cd /usr/src && apt-get source -y squid3=3.3.8-1ubuntu6.2
RUN cd /usr/src && apt-get build-dep -y squid3=3.3.8-1ubuntu6.2
ADD container_files/usr/src/squid3-3.3.8/debian/rules /usr/src/squid3-3.3.8/debian/rules
RUN cd /usr/src/squid3-3.3.8 && debuild -us -uc
RUN cd /usr/src && dpkg --install squid3_3.3.8-1ubuntu6.2_amd64.deb squid3-common_3.3.8-1ubuntu6.2_all.deb squid3-dbg_3.3.8-1ubuntu6.2_amd64.deb
RUN ln -s /usr/lib/squid3/ssl_crtd /bin/ssl_crtd
RUN /bin/ssl_crtd -c -s /var/spool/squid3_ssldb
RUN chown -R proxy:proxy /var/spool/squid3_ssldb
RUN apt-mark hold squid3 squid3-common
ADD container_files/etc/squid3/squid.conf /etc/squid3/squid.conf
ADD container_files/usr/local/bin/squid3 /usr/local/bin/squid3
RUN chmod +x /usr/local/bin/squid3

# Install & Configure Diladele
RUN cd usr/src && curl -L http://packages.diladele.com/qlproxy/4.0.0.8174/amd64/release/ubuntu14/qlproxy-4.0.0.8174_amd64.deb -O
RUN cd usr/src && dpkg --install qlproxy-4.0.0.8174_amd64.deb
RUN a2ensite qlproxy.conf
RUN a2dissite 000-default
RUN mkdir -p /var/log/qlproxy
ADD container_files/opt/qlproxy/bin/* /opt/qlproxy/bin/
RUN chmod +x /opt/qlproxy/bin/restart.sh /opt/qlproxy/bin/reload.sh
ADD container_files/usr/local/bin/qlproxy /usr/local/bin/qlproxy
RUN chmod +x /usr/local/bin/qlproxy
RUN mkdir -p /mnt/qlproxy/backup
RUN ln -s /mnt/qlproxy/backup /opt/qlproxy/backup

# Add cron jobs
ADD container_files/etc/cron.hourly/* /etc/cron.hourly/
RUN chmod +x /etc/cron.hourly/*

# Configure Supervisor
ADD container_files/etc/supervisor/conf.d/* /etc/supervisor/conf.d/
CMD /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

