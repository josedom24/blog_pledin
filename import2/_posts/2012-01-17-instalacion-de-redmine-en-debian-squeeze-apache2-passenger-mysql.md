---
layout: post
status: publish
published: true
title: Instalaci&oacute;n de Redmine en Debian Squeeze + Apache2 + Passenger + mySql
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 610
wordpress_url: http://www.josedomingo.org/pledin/?p=610
date: '2012-01-17 09:18:16 +0000'
date_gmt: '2012-01-17 08:18:16 +0000'
categories:
- General
tags:
- CMS
- Apache
- Ruby on Rails
- Redmine
comments: []
---
<p style="text-align: justify;"><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2012/01/redmine1.jpeg"><img class="size-thumbnail wp-image-615 alignleft" title="redmine" src="http://www.josedomingo.org/pledin/wp-content/uploads/2012/01/redmine1-150x150.jpg" alt="" width="150" height="150" /></a>Redmine es una herramienta para la gesti&oacute;n de proyectos y el seguimiento de errores escrita usando el framework Ruby on Rails. Incluye un calendario y unos diagramas de Gantt para la representaci&oacute;n visual de la l&iacute;nea del tiempo de los proyectos. Es software libre y de c&oacute;digo abierto, disponible bajo la Licencia P&uacute;blica General de GNU v2.</p>
<p>Vamos a instalar redmine desde los archivos fuentes bajados de la p&aacute;gina oficial, en un servidor Debian Squeeze con servidor web Apache2 con el m&oacute;dulo passenger y el gestor de base de datos mysql. Partimos de los dos art&iacute;culos anteriores escritos en esta p&aacute;gina:<a title="Introducci&oacute;n a Ruby on Rails con Debian Squeeze" href="http://www.josedomingo.org/pledin/2012/01/introduccion-a-ruby-on-rails-con-debian-squeeze/"> Introducci&oacute;n a Ruby on Rails con Debian Squeeze</a> y <a title="Instalaci&oacute;n de aplicaciones Ruby on Rails con Apache2+Passenger" href="http://www.josedomingo.org/pledin/2012/01/instalacion-de-aplicaciones-ruby-on-rails-con-apache2passenger/">Instalaci&oacute;n de aplicaciones Ruby on Rails con Apache2+Passenger.</a></p>
<p><a title="Instalaci&oacute;n de aplicaciones Ruby on Rails con Apache2+Passenger" href="http://www.josedomingo.org/pledin/2012/01/instalacion-de-aplicaciones-ruby-on-rails-con-apache2passenger/"><!--more--></a></p>
<p>1) Descargamos los ficheros fuentes de la <a href="http://rubyforge.org/frs/?group_id=1850">p&aacute;gina oficial</a>, nosotros vamos a descargar la versi&oacute;n 1.3.0. La descomprimimos y lo guardamos en /var/www, de esta manera en la carpeta /var/www/redmine-1.3.0 tendremos la aplicaci&oacute;n guardada.</p>
<p>2) Creamos la base de datos y un usuario mysql para acceder a dicha base de datos:</p>
<pre class="brush: bash; gutter: false; first-line: 1">create database redmine character set utf8;
grant all privileges on redmine.* to 'redmine'@'localhost' identified by 'my_password';</pre>
<p>3) Configuramos los datos de acceso a la base de datos, para ello:</p>
<pre class="brush: bash; gutter: false; first-line: 1">cd /var/www/redmine-1.3.0
cp config/database.yml.example config/database.yml</pre>
<p>Y editamos el fichero dej&aacute;ndolo de la siguiente manera:</p>
<pre class="brush: bash; gutter: false; first-line: 1">production:
  adapter: mysql
  database: redmine
  host: localhost
  username: redmine
  password: my_password
  encoding: utf8</pre>
<p>4) Generamos una identificador de inicio</p>
<pre class="brush: bash; gutter: false; first-line: 1">rake generate_session_store</pre>
<p>Y migramos la base de datos:</p>
<pre class="brush: bash; gutter: false; first-line: 1">RAILS_ENV=production rake db:migrate</pre>
<p>En este paso obtenemos un error, ya que necesito la versi&oacute;n 1.1.0 de la gema rack. para ello:</p>
<pre class="brush: bash; gutter: false; first-line: 1">gem install rack -v 1.1.0</pre>
<p>Por &uacute;ltimo realizamos la configuraci&oacute;n inicial con:</p>
<pre class="brush: bash; gutter: false; first-line: 1">RAILS_ENV=production rake redmine:load_default_data</pre>
<p>y escogemos el idioma , en nuwstro caso "es".</p>
<p>5) Podemos comprobar su funcionamiento usando el servidor web webrick:</p>
<pre class="brush: bash; gutter: false; first-line: 1">ruby script/server -b 192.168.100.10 -e production</pre>
<p>y accediendo a la URL http://192.168.100.10:3000</p>
<p>6) Para que funcione usando apache2 con el m&oacute;dulo passenger, nos aseguramos que el m&oacute;dulo passenger y el m&oacute;dulo rewrite est&eacute;n activos:</p>
<pre class="brush: bash; gutter: false; first-line: 1">a2enmod passenger
a2enmod rewrite</pre>
<p>Y creamos un fichero de configuraci&oacute;n de un virtual host de la siguiente manera:</p>
<pre class="brush: bash; gutter: false; first-line: 1"><VirtualHost *:80>
SetEnv RAILS_ENV production

ServerAdmin webmaster@localhost

DocumentRoot /var/www/redmine-1.3.0/public
<Directory />
Options FollowSymLinks
AllowOverride None
</Directory>
<Directory /var/www/redmine-1.3.0/public>
Order allow,deny
allow from all
AllowOverride All
&nbsp;</Directory>
...</pre>
<p>Reiniciamos el servicio y probamos a acceder a la p&aacute;gina con la URL http://192.168.100.10</p>
