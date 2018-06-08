---
layout: post
status: publish
published: true
title: Instalaci&oacute;n de aplicaciones Ruby on Rails con Apache2+Passenger
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 594
wordpress_url: http://www.josedomingo.org/pledin/?p=594
date: '2012-01-09 13:42:18 +0000'
date_gmt: '2012-01-09 12:42:18 +0000'
categories:
- General
tags:
- Web 2.0
- Ruby on Rails
comments: []
---
<p>Siguiendo con la serie de art&iacute;culos introductorios a la programaci&oacute;n con Ruby on Rails vamos a mostrar como implantar una aplicaci&oacute;n ya desarrollada usando el servidor web Apache2 y el m&oacute;dulos passenger que nos permite que Apache ejecute c&oacute;digo Ruby. Este tutorial mostrar&aacute; la instalaci&oacute;n y configuraci&oacute;n del servidor web Apache2 par que sea capaz de servir la aplicaci&oacute;n "videoclub" que hab&iacute;amos construido en este <a href="http://www.josedomingo.org/pledin/2012/01/introduccion-a-ruby-on-rails-con-debian-squeeze/">otro art&iacute;culo</a>.</p>
<p><!--more-->Lo primero que vamos a hacer es instalar el servidor y el m&oacute;dulo passenger que nos permite la ejecuci&oacute;n de aplicaciones implementadas con Ruby, para ello:</p>
<pre class="brush: bash; gutter: false; first-line: 1">aptitude install apache2 libapache2-mod-passenger</pre>
<p>A continuaci&oacute;n copiamos nuestro proyecto al directorio de trabajo del servidor web:</p>
<pre class="brush: bash; gutter: false; first-line: 1">cp -R ~/proyectos/videoclub /var/www</pre>
<p>Hacemos que dicho directorio sea propiedad del usuario ww-data:</p>
<pre class="brush: bash; gutter: false; first-line: 1">chown -R www-data:www-data /var/www/videoclub</pre>
<p>Por &uacute;ltimo editamos el fichero /etc/apache2/sites-available/default, donde encontramos la configuraci&oacute;n del sitio web definido por defecto, y lo editamos dej&aacute;ndolo similar al siguiente:</p>
<pre class="brush: bash; gutter: false; first-line: 1"><VirtualHost *:80>
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
....</pre>
<p>Reiniciamos el servidor web:</p>
<pre class="brush: bash; gutter: false; first-line: 1">/etc/init.d/apache2 restart</pre>
<p>Y ya podemos acceder a nuestra aplicaci&oacute;n, por ejemplo, desde el mismo servidor visitando la URL hhtp://localhost/peliculas</p>
