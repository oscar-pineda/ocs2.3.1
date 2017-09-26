FROM phusion/baseimage:0.9.22
MAINTAINER Oscar Pineda <oscar.pineda@alkanza.us>

RUN apt-get update ; \
    apt-get update ; \
    apt-get install -y --no-install-recommends \
    apache2 \
    apt-utils \
    make \
    gzip \
    mysql-client ; \
    add-apt-repository ppa:ondrej/php -y ; \
    apt-get update ; \
    apt-get install -y --no-install-recommends php5.6 \
    php5.6-gd \
    php5.6-soap \
    php5.6-mbstring \
    php5.6-mysql \
    php5.6-cgi \
    php5.6-curl \
    php5.6-snmp \
    libapache2-mod-php5.6 \
    php5.6-xmlrpc \
    php5.6-xml \
    php5.6-pspell \
    php5.6-mbstring \
    perl \
    build-essential \
    libxml2 \
    libxml-simple-perl \
    libc6-dev \
    libnet-ip-perl \
    libxml-libxml-perl \
    libapache2-mod-perl2 \
    libdbi-perl \
    libapache-dbi-perl \
    libdbd-mysql-perl \
    libio-compress-perl \
    libxml-simple-perl \
    libsoap-lite-perl \
    libarchive-zip-perl \
    libnet-ip-perl \
    libphp-pclzip \
    libsoap-lite-perl \
    libarchive-zip-perl \
    libmodule-build-perl \
    wget \
    tar ; \
    cpan -i XML::Entities ; \
    a2enmod php5.6
ADD OCSNG_UNIX_SERVER-2.3.1.tar.gz /tmp/

WORKDIR /tmp/OCSNG_UNIX_SERVER-2.3.1/Apache
RUN perl Makefile.PL ;\
    make ;\
    make install ;\
    cp -R blib/lib/Apache /usr/local/share/perl/5.22.1 ; \
    cp /tmp/OCSNG_UNIX_SERVER-2.3.1/etc/logrotate.d/ocsinventory-server /etc/logrotate.d/ ; \
    mkdir -p /etc/ocsinventory-server/plugins ;\ 
    mkdir -p /etc/ocsinventory-server/perl;\
    mkdir -p /usr/share/ocsinventory-reports

WORKDIR /tmp/OCSNG_UNIX_SERVER-2.3.1
RUN cp -R ocsreports /usr/share/ocsinventory-reports/ ;\
    chown www-data:www-data -R /usr/share/ocsinventory-reports/ocsreports ;\
    mkdir -p /var/lib/ocsinventory-reports/download ;\
    mkdir -p /var/lib/ocsinventory-reports/ipd ;\
    mkdir -p /var/lib/ocsinventory-reports/logs ;\
    mkdir -p /var/lib/ocsinventory-reports/scripts ;\
    mkdir -p /var/lib/ocsinventory-reports/snmp ;\
    chown www-data:www-data -R /var/lib/ocsinventory-reports ;\
    cp binutils/ipdiscover-util.pl /usr/share/ocsinventory-reports/ocsreports/ipdiscover-util.pl ;\
    chown www-data:www-data -R /usr/share/ocsinventory-reports/ocsreports/ipdiscover-util.pl ;\
    chmod 755 /usr/share/ocsinventory-reports/ocsreports/ipdiscover-util.pl ;\
    ln -s /usr/share/ocsinventory-reports/ocsreports/ /var/www/html/ocsreports ; \
    chown www-data:www-data -R /var/lib/ocsinventory-reports

COPY dbconfig.inc.php /usr/share/ocsinventory-reports/ocsreports
COPY ocsinventory-reports.conf /etc/apache2/conf-available
COPY z-ocsinventory-server.conf /etc/apache2/conf-available

RUN chown www-data:www-data  /usr/share/ocsinventory-reports/ocsreports/dbconfig.inc.php ;\
    ln -s /etc/apache2/conf-available/ocsinventory-reports.conf /etc/apache2/conf-enabled/ocsinventory-reports.conf ;\
    ln -s /etc/apache2/conf-available/z-ocsinventory-server.conf /etc/apache2/conf-enabled/z-ocsinventory-server.conf ;\
    echo 'ServerName localhost' >> /etc/apache2/apache2.conf ;\
    
EXPOSE 80
EXPOSE 443  
