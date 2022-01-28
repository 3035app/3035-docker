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

RUN echo "phar.readonly = Off" >> /etc/php/${PHPVER}/cli/conf.d/42-phar-readonly.ini \
    && echo "memory_limit=-1" >> /etc/php/${PHPVER}/cli/conf.d/42-memory-limit.ini \
    && echo "date.timezone=Europe/Paris" >> /etc/php/${PHPVER}/cli/conf.d/68-date-timezone.ini

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod 755 /usr/local/bin/composer

COPY src/ /var/www/pialab-back/
COPY docker/.env /var/www/pialab-back/
COPY docker/000-default.conf /etc/apache2/sites-available/

# TODO: issue on libs versions -- waiting for Sf upgrade
# RUN cd /var/www/pialab-back/ \
#   && composer install
# alternative:
COPY docker/vendor/ /var/www/pialab-back/vendor/


RUN /etc/init.d/postgresql start \
    && echo "CREATE ROLE user_pialab SUPERUSER LOGIN PASSWORD 'password_pialab'" | sudo -u postgres psql template1 \
    && cd /var/www/pialab-back/ \
    && bin/console doctrine:database:create \
    && bin/console doctrine:migrations:migrate --no-interaction \
    && bin/console pia:user:create test@test.tld test --username=test \
    && bin/console pia:user:promote test@test.tld --role=ROLE_SUPER_ADMIN \
    && /etc/init.d/postgresql stop

RUN a2enmod rewrite

COPY docker/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /var/www/pialab-back/
EXPOSE 80/tcp

LABEL author=PiaLab
LABEL description='PiaLab backend - Login directly using the account "test" with password "test" (which is super admin) pointing on http://server/index.php.'
