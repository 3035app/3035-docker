FROM debian:stable

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https lsb-release ca-certificates net-tools lsof wget sudo less \
    && apt-get install --no-install-recommends -y git curl build-essential unzip npm \
    && apt-get install --no-install-recommends -y nano \
    && apt-get autoremove -y && apt-get clean

COPY src/ /var/www/pialab-front/
COPY docker/environment.dev.ts /var/www/pialab-front/src/environments/

COPY docker/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN npm install -g @angular/cli

# RUN cd /var/www/pialab-front/ \
#    && npm install

WORKDIR /var/www/pialab-front/
EXPOSE 4200

CMD ["ng", "serve", "--host", "0.0.0.0"]

LABEL author=PiaLab
LABEL description="PiaLab frontend"
