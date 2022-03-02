FROM debian:stable

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https lsb-release ca-certificates net-tools lsof wget sudo less \
    && apt-get install --no-install-recommends -y git curl build-essential unzip \
    && apt-get install --no-install-recommends -y nano \
    && apt-get autoremove -y && apt-get clean

ARG PHPVER=7.4
RUN apt-get update \
    && apt-get install --no-install-recommends -y php${PHPVER} php${PHPVER}-cli php${PHPVER}-pgsql php${PHPVER}-mysql php${PHPVER}-curl php${PHPVER}-json php${PHPVER}-gd php${PHPVER}-intl php${PHPVER}-sqlite3 php${PHPVER}-gmp php${PHPVER}-geoip php${PHPVER}-mbstring php${PHPVER}-redis php${PHPVER}-xml php${PHPVER}-zip php${PHPVER}-xdebug \
    && apt-get install --no-install-recommends -y php${PHPVER}-xdebug \
    && apt-get install -y apache2 libapache2-mod-php${PHPVER} php${PHPVER}-pgsql php${PHPVER}-cli php${PHPVER}-mbstring php${PHPVER}-json php${PHPVER}-xml php${PHPVER}-zip php${PHPVER}-curl \
    && apt-get upgrade -y \
    && apt-get autoremove -y && apt-get clean \
    && a2dismod mpm_event && a2enmod php${PHPVER}

RUN apt-get install -y php-symfony-console
RUN apt-get install -y postgresql

# expose postgresql from remote access
RUN sed -i "s|#listen_addresses = 'localhost'|listen_addresses = '*' |g" /etc/postgresql/13/main/postgresql.conf
RUN echo "host  all  all  0.0.0.0/0  md5" >> /etc/postgresql/13/main/pg_hba.conf
RUN echo "host  all  all  ::/0       md5" >> /etc/postgresql/13/main/pg_hba.conf

RUN echo "phar.readonly = Off" >> /etc/php/${PHPVER}/cli/conf.d/42-phar-readonly.ini \
    && echo "memory_limit=-1" >> /etc/php/${PHPVER}/cli/conf.d/42-memory-limit.ini \
    && echo "date.timezone=Europe/Paris" >> /etc/php/${PHPVER}/cli/conf.d/68-date-timezone.ini

RUN curl -sS https://getcomposer.org/installer | php -- --version=1.10.25 --install-dir=/usr/local/bin --filename=composer \
    && chmod 755 /usr/local/bin/composer

COPY src/ /var/www/pialab-back/
COPY docker/000-default.conf /etc/apache2/sites-available/
RUN mkdir -p --mode=777 /var/www/pialab-back/var

# TODO: issue on libs versions -- waiting for Sf upgrade
# RUN cd /var/www/pialab-back/ \
#   && composer install

RUN a2enmod rewrite

COPY docker/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /var/www/pialab-back/
EXPOSE 80/tcp


CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]

LABEL author=PiaLab
LABEL description='PiaLab backend - Login directly using the account "test" with password "test" (which is super admin) pointing on http://server/index.php.'
