---
id: 594
title: Instalación de aplicaciones Ruby on Rails con Apache2+Passenger
date: 2012-01-09T13:42:18+00:00


guid: http://www.josedomingo.org/pledin/?p=594
permalink: /2012/01/instalacion-de-aplicaciones-ruby-on-rails-con-apache2passenger/


tags:
  - Ruby on Rails
  - Web 2.0
---
Siguiendo con la serie de artículos introductorios a la programación con Ruby on Rails vamos a mostrar como implantar una aplicación ya desarrollada usando el servidor web Apache2 y el módulo `passenger` que nos permite que Apache ejecute código Ruby. Este tutorial mostrará la instalación y configuración del servidor web Apache2 par que sea capaz de servir la aplicación "videoclub" que habíamos construido en este [otro artículo](http://www.josedomingo.org/pledin/2012/01/introduccion-a-ruby-on-rails-con-debian-squeeze/).

Lo primero que vamos a hacer es instalar el servidor y el módulo `passenger` que nos permite la ejecución de aplicaciones implementadas con Ruby, para ello:

    aptitude install apache2 libapache2-mod-passenger

A continuación copiamos nuestro proyecto al directorio de trabajo del servidor web:

    cp -R ~/proyectos/videoclub /var/www

Hacemos que dicho directorio sea propiedad del usuario `www-data`:

    chown -R www-data:www-data /var/www/videoclub

Por último editamos el fichero `/etc/apache2/sites-available/default`, donde encontramos la configuración del sitio web definido por defecto, y lo editamos dejándolo similar al siguiente:

    <VirtualHost *:80>
        SetEnv RAILS_ENV development
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/videoclub/public
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory /var/www/videoclub/public>
                Order allow,deny
                allow from all
        </Directory>
        ....

Reiniciamos el servidor web:

    /etc/init.d/apache2 restart

Y ya podemos acceder a nuestra aplicación, por ejemplo, desde el mismo servidor visitando la URL:

    http://localhost/peliculas

