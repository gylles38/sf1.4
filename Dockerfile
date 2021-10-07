# PHP 5.2 / SYMFONY 1.4 / PROPEL
FROM andres42/php5.2-apache2.2

ARG APACHE_WEB_DIR=/usr/local/apache2/htdocs/
ARG ARG_LOG=/usr/local/apache2/

RUN apt-get upgrade && \
    apt-get update

COPY . ${APACHE_WEB_DIR}

WORKDIR /home/sfprojects/jobeet

# SF1.4 prepare
RUN mkdir -p /home/sfprojects/jobeet && \
    cd /home/sfprojects/jobeet && \
    mkdir -p lib/vendor && \
    mv ${APACHE_WEB_DIR}symfony1-1.4.20.tar.gz lib/vendor/symfony1.tar.gz && \
    cd lib/vendor && \
    tar zxpf symfony1.tar.gz && \
    mv symfony1-1.4.20 symfony && \
    rm symfony1.tar.gz

#SF project init

RUN php lib/vendor/symfony/data/bin/symfony generate:project jobeet --orm=propel && \
    php symfony generate:app frontend && \
    chmod 777 cache/ log/

# conf apache
RUN cp ${APACHE_WEB_DIR}Webserver /usr/local/apache2/conf/httpd.conf && \
    rm ${APACHE_WEB_DIR}Webserver

RUN chgrp -R 0 ${ARG_LOG} && \
    chmod -R g=u ${ARG_LOG} && \
    chgrp -R 0 ${APACHE_WEB_DIR} && \
    chmod -R g=u ${APACHE_WEB_DIR}

EXPOSE 8080
