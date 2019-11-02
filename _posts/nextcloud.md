En este artículo os cuento mis entretenimiento en las últimas semanas, jugando con nextcloud y ampliando su espacio de almacenamiento usando la aplicación `rclone`. Con estas herramientas, y otras como un servidor `webdav` podemos automatizar fácilmente nuestras copias de seguridad en la nube. Veamos cada una de estas aplicaciones:

## Nextcloud

[Nextcloud](https://nextcloud.com/) es una aplicación web escrita en PHP cuyo objetivo es crear un servidor de alojamiento de archivos en cualquier servidor personal. Tiene la misma funcionalidad de otros servicios de almacenamiento en la nube, como Dropbox, pero la gran diferencia es que Nextcloud es de código abierto, por lo que podemos instalarlo y adaptarlos a nuestras necesidades.

Para poder instalar la aplicación Nextcloud necesitamos instalar un servidor LAMP, que podemos hacer de forma sencilla en *Debian Buster* de la siguiente forma:

1. Instalamos Apache2 como servidor web:

        apt install apache2

2. Instalamos el servidor de base de datos:

        apt install mariadb-server

    A continuación accedemos al servidor y creamos la base de datos y el usuario con el que nos vamos a conectar a la base de datos:

        $ mysql -u root -p

        > CREATE DATABASE nextcloud;
        > CREATE USER 'usernextcloud'@'localhost' IDENTIFIED BY 'passnextcloud';
        > GRANT ALL PRIVILEGES ON nextcloud.* to 'usernextcloud'@'localhost';
        > FLUSH PRIVILEGES;
        > quit

3. Instalamos la versión de php, así como la libería para que php pueda conectarse a la base de datos (por dependencia se instala el módulos de apache2 `libapache2-mod-php7.3` que permite que el servidor web ejecute código php):

        apt install php7.3 php7.3-mysql

A continuación nos bajamos la aplicación Nextcloud de la página oficial de descargas y lo descomprimimos en el el DocumentRoot, en nuestro caso como vamos a usar el virtualhost `default` será el directorio `/var/www/html/`.

Accedemos a nuestro servidor y comenzamos con la configuración de la aplicación:

Siguiendo la documentación necesitamos instalar algunas librerías más de php:

    apt install php-zip php-xml php-gd php-curl php-mbstring

Ya tenemos instalada nuestra aplicación Nextcloud.
