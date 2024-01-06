FROM amazonlinux
RUN yum -y update && yum -y install httpd && yum -y install php
COPY ./index.php /var/www/html/index.php
RUN mkdir /run/php-fpm
CMD /usr/sbin/php-fpm && /usr/sbin/httpd -D FOREGROUND
EXPOSE 80