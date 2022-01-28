FROM debian:stable

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https lsb-release ca-certificates net-tools lsof wget sudo less \
    && apt-get install --no-install-recommends -y git curl build-essential unzip npm \
    && apt-get install --no-install-recommends -y nano \
    && apt-get autoremove -y && apt-get clean

COPY src/ /var/www/pialab-front/
COPY docker/environment.dev.ts /var/www/pialab-front/src/environments/

RUN npm install -g @angular/cli

RUN cd /var/www/pialab-front/ \
    && npm install

CMD cd /var/www/pialab-front/src/ \
    && ng serve --host 0.0.0.0

WORKDIR /var/www/pialab-front/

EXPOSE 4200

LABEL author=PiaLab
LABEL description="PiaLab frontend"
