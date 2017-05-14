FROM debian:testing

RUN apt-get update \
	&& apt-get -yq upgrade \
    && apt-get -yq install \
        nginx

ADD ./docker/nginx/nginx.conf /etc/nginx/
ADD ./docker/nginx/vhost.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/vhost.conf /etc/nginx/sites-enabled/vhost \
    && echo "upstream php-upstream { server ${DOCKER_API}:9000; }" > /etc/nginx/conf.d/upstream.conf \
    && rm /var/www/html/* \
    && touch /var/www/html/index.html

RUN usermod -u 1000 www-data

WORKDIR /app/server

CMD ["nginx"]