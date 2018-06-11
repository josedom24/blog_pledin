---
id: 610
title: Instalación de Redmine en Debian Squeeze + Apache2 + Passenger + mySql
date: 2012-01-17T09:18:16+00:00


guid: http://www.josedomingo.org/pledin/?p=610
permalink: /2012/01/instalacion-de-redmine-en-debian-squeeze-apache2-passenger-mysql/


tags:
  - Apache
  - CMS
  - Redmine
  - Ruby on Rails
---
<p style="text-align: justify;">
  <a href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/redmine1.jpeg"><img class="size-thumbnail wp-image-615 alignleft" title="redmine" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/redmine1-150x150.jpg" alt="" width="150" height="150" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/redmine1-150x150.jpg 150w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/redmine1.jpeg 225w" sizes="(max-width: 150px) 100vw, 150px" /></a>Redmine es una herramienta para la gestión de proyectos y el seguimiento de errores escrita usando el framework Ruby on Rails. Incluye un calendario y unos diagramas de Gantt para la representación visual de la línea del tiempo de los proyectos. Es software libre y de código abierto, disponible bajo la Licencia Pública General de GNU v2.
</p>

Vamos a instalar redmine desde los archivos fuentes bajados de la página oficial, en un servidor Debian Squeeze con servidor web Apache2 con el módulo passenger y el gestor de base de datos mysql. Partimos de los dos artículos anteriores escritos en esta página: [Introducción a Ruby on Rails con Debian Squeeze](http://www.josedomingo.org/pledin/2012/01/introduccion-a-ruby-on-rails-con-debian-squeeze/ "Introducción a Ruby on Rails con Debian Squeeze") y [Instalación de aplicaciones Ruby on Rails con Apache2+Passenger.](http://www.josedomingo.org/pledin/2012/01/instalacion-de-aplicaciones-ruby-on-rails-con-apache2passenger/ "Instalación de aplicaciones Ruby on Rails con Apache2+Passenger")

[<!--more-->](http://www.josedomingo.org/pledin/2012/01/instalacion-de-aplicaciones-ruby-on-rails-con-apache2passenger/ "Instalación de aplicaciones Ruby on Rails con Apache2+Passenger")

1) Descargamos los ficheros fuentes de la [página oficial](http://rubyforge.org/frs/?group_id=1850), nosotros vamos a descargar la versión 1.3.0. La descomprimimos y lo guardamos en /var/www, de esta manera en la carpeta /var/www/redmine-1.3.0 tendremos la aplicación guardada.

2) Creamos la base de datos y un usuario mysql para acceder a dicha base de datos:

<pre class="brush: bash; gutter: false; first-line: 1">create database redmine character set utf8;
grant all privileges on redmine.* to 'redmine'@'localhost' identified by 'my_password';</pre>

3) Configuramos los datos de acceso a la base de datos, para ello:

<pre class="brush: bash; gutter: false; first-line: 1">cd /var/www/redmine-1.3.0
cp config/database.yml.example config/database.yml</pre>

Y editamos el fichero dejándolo de la siguiente manera:

<pre class="brush: bash; gutter: false; first-line: 1">production:
  adapter: mysql
  database: redmine
  host: localhost
  username: redmine
  password: my_password
  encoding: utf8</pre>

4) Generamos una identificador de inicio

<pre class="brush: bash; gutter: false; first-line: 1">rake generate_session_store</pre>

Y migramos la base de datos:

<pre class="brush: bash; gutter: false; first-line: 1">RAILS_ENV=production rake db:migrate</pre>

En este paso obtenemos un error, ya que necesito la versión 1.1.0 de la gema rack. para ello:

<pre class="brush: bash; gutter: false; first-line: 1">gem install rack -v 1.1.0</pre>

Por último realizamos la configuración inicial con:

<pre class="brush: bash; gutter: false; first-line: 1">RAILS_ENV=production rake redmine:load_default_data</pre>

y escogemos el idioma , en nuwstro caso &#8220;es&#8221;.

5) Podemos comprobar su funcionamiento usando el servidor web webrick:

<pre class="brush: bash; gutter: false; first-line: 1">ruby script/server -b 192.168.100.10 -e production</pre>

y accediendo a la URL http://192.168.100.10:3000

6) Para que funcione usando apache2 con el módulo passenger, nos aseguramos que el módulo passenger y el módulo rewrite estén activos:

<pre class="brush: bash; gutter: false; first-line: 1">a2enmod passenger
a2enmod rewrite</pre>

Y creamos un fichero de configuración de un virtual host de la siguiente manera:

<pre class="brush: bash; gutter: false; first-line: 1">&lt;VirtualHost *:80&gt;
SetEnv RAILS_ENV production

ServerAdmin webmaster@localhost

DocumentRoot /var/www/redmine-1.3.0/public
&lt;Directory /&gt;
Options FollowSymLinks
AllowOverride None
&lt;/Directory&gt;
&lt;Directory /var/www/redmine-1.3.0/public&gt;
Order allow,deny
allow from all
AllowOverride All
 &lt;/Directory&gt;
...</pre>

Reiniciamos el servicio y probamos a acceder a la página con la URL http://192.168.100.10

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->