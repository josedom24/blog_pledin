---
title: 'Gestionando nuestro almacenamiento en la nube con nextcloud y rclone'
permalink: /2019/11/almacenamiento-nube-nextcloud-rclone/
tags:
  - Cloud
  - rclone
  - nextcloud
---

En este artículo os cuento mis entretenimientos en las últimas semanas, jugando con nextcloud y ampliando su espacio de almacenamiento usando la aplicación `rclone`. Con estas herramientas podemos automatizar fácilmente nuestras copias de seguridad en la nube. Veamos cada una de estas aplicaciones:

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

4. A continuación nos bajamos la aplicación Nextcloud de la página oficial de descargas (en el momento de escribir este manual hemos descargado la versión 17.0.1), lo descomprimimos y copiamos todos los ficheros y directorios en el `DocumentRoot`, en nuestro caso como vamos a usar el virtualhost `default` será el directorio `/var/www/html/`.

        # cd /tmp
        /tmp# wget https://download.nextcloud.com/server/releases/nextcloud-17.0.1.zip
        /tmp# unzip nextcloud-17.0.1.zip
        /tmp# cd nextcloud
        /tmp/nextcloud# cp -r * /var/www/html
        /tmp/nextcloud# cd /var/www/html
        /var/www/html# chown -R www-data: .

5. Accedemos a nuestro servidor desde un cliente, para ello en cliente vamos a configurar la resolución estática, en el fichero `/etc/hosts` añadimos la siguiente línea (la ip de nuestro servidor es 192.168.100.36):

        192.168.100.36  www.example.org

y comenzamos con la configuración de la aplicación:

![nextcloud1]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2019/11/nextcloud1.png){: .align-center }

Siguiendo la documentación necesitamos instalar algunas librerías más de php:

        apt install php-zip php-xml php-gd php-curl php-mbstring

Ya tenemos instalada nuestra aplicación Nextcloud:

![nextcloud2]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2019/11/nextcloud2.png){: .align-center }

## Almacenmaiento externo

La aplicación "Almacenamiento externo" en nextcloud nos permite añadir a nuestro almacenamiento un directorio donde el contenido está en otro servicio. Para poder usar esta opción tenemos que activarlo en la configuración de aplicaciones, para ello elegimos las opciones **Aplicaciones** y activamos **External storage support**:

![nextcloud3]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2019/11/nextcloud3.png){: .align-center }

A continuación podemos configurar el "almacenamiento externo" accediendo a **Configuración** y eligiendo **Almacenamiento Externo**:

![nextcloud4]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2019/11/nextcloud4.png){: .align-center }

Vemos que podemos añadir almacenamiento de diferentes fuentes: 

![nextcloud5]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2019/11/nextcloud5.png){: .align-center }

A continuación añadiremos directorios locales a nuestro almacenamiento, pero antes de ello veamos el siguiente punto.

## Montar directorios locales con rclone

En el [artículo anterior](https://www.josedomingo.org/pledin/2019/11/rclone-almacenamiento-nube/) habíamos visto la herramienta`rclone`, que nos permitía gestionar el almacenamiento de distintos servicios de almacenamiento en la nube. `rclone` lo tenemos configurado en la misma máquina donde hemos instalado nextcloud y recordamos que habíamos configurado dos servicios de almacenamiento y con el usuario sin privilegios (suponemos que el usuario se llama `vagrant`) podemos ver los servicios que tenemos configurados:

        $ rclone listremotes
        dropbox:
        mega1:

Una de las posibilidades que nos ofrece `rclone` es poder montar en un directorio de la máquina cualquier servicio que tengamos configurado, para ello vamos a usar `fuse` que nos permite montar un sistema de fichero con un usuario sin privilegios, por lo que lo primero es instalarlo como superusuario:

        # apt install fuse

Además tenemos que cambiar una configuración para que puedan acceder al directorio montado otros usuarios (en nuestro caso es necesario porque posteriormente accederá el usuario `www-data` de apache2), para ello descomentamos en el fichero `/etc/fuse.conf` la siguiente línea:

        user_allow_other

A continuación el usuario sin privilegios ya puede montar en un directorio sus ficheros de dropbox:

        $ mkdir ficheros_dropbox

        $ rclone mount -v dropbox:/ ficheros_dropbox --daemon --allow-other
        
        $ ls ficheros_dropbox/
        Comenzar.pdf  Photos  prueba  Public

La opción `--daemon` permite crear un proceso demonio responsable de mantener el directorio montado, y la opción `--allow-other` permite que otros usuarios accedan al directorio. Tenemos muchas más opciones de configuración que podemos ver en la documentación de [rclone mount](https://rclone.org/commands/rclone_mount/).

Si necesitaremos desmontar el directorio:

        $ fusermount -u /home/vagrant/ficheros_dropbox

## Integración de nextrcloud con rclone

Ahora que ya tenemos montado los ficheros de nuestro dropbox en un directorio es hora de configura el **Almacenamiento externo** de nextcloud para montarlo en nuestro servidor, para ello configuramos un nuevo almacenamiento externo:

![nextcloud6]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2019/11/nextcloud6.png){: .align-center }

Y efectivamente comprobamos que tenemos acceso a los ficheros de dropbox desde nuestro nextcloud:

![nextcloud7]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2019/11/nextcloud7.png){: .align-center }

## Conclusiones

Con las utilidades que hemos estudiados podemos de una forma fácil centralizar todos nuestros servicios de almacenamiento en nuestro servidor nextcloud, de esta menera por ejemplo sería muy sencillo hacer un backup de nuestros datos en distintos servicios además de hacer crecer el almacenamiento disponible de nuestra "nube" personal.