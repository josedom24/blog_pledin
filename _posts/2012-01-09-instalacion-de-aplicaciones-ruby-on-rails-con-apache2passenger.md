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
Siguiendo con la serie de artículos introductorios a la programación con Ruby on Rails vamos a mostrar como implantar una aplicación ya desarrollada usando el servidor web Apache2 y el módulos passenger que nos permite que Apache ejecute código Ruby. Este tutorial mostrará la instalación y configuración del servidor web Apache2 par que sea capaz de servir la aplicación &#8220;videoclub&#8221; que habíamos construido en este [otro artículo](http://www.josedomingo.org/pledin/2012/01/introduccion-a-ruby-on-rails-con-debian-squeeze/).

<!--more-->Lo primero que vamos a hacer es instalar el servidor y el módulo passenger que nos permite la ejecución de aplicaciones implementadas con Ruby, para ello:

<pre class="brush: bash; gutter: false; first-line: 1">aptitude install apache2 libapache2-mod-passenger</pre>

A continuación copiamos nuestro proyecto al directorio de trabajo del servidor web:

<pre class="brush: bash; gutter: false; first-line: 1">cp -R ~/proyectos/videoclub /var/www</pre>

Hacemos que dicho directorio sea propiedad del usuario ww-data:

<pre class="brush: bash; gutter: false; first-line: 1">chown -R www-data:www-data /var/www/videoclub</pre>

Por último editamos el fichero /etc/apache2/sites-available/default, donde encontramos la configuración del sitio web definido por defecto, y lo editamos dejándolo similar al siguiente:

<pre class="brush: bash; gutter: false; first-line: 1">&lt;VirtualHost *:80&gt;
SetEnv RAILS_ENV development

        ServerAdmin webmaster@localhost

        DocumentRoot /var/www/videoclub/public
        &lt;Directory /&gt;
                Options FollowSymLinks
                AllowOverride None
        &lt;/Directory&gt;
        &lt;Directory /var/www/videoclub/public&gt;
                Order allow,deny
                allow from all
        &lt;/Directory&gt;
....</pre>

Reiniciamos el servidor web:

<pre class="brush: bash; gutter: false; first-line: 1">/etc/init.d/apache2 restart</pre>

Y ya podemos acceder a nuestra aplicación, por ejemplo, desde el mismo servidor visitando la URL hhtp://localhost/peliculas

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->