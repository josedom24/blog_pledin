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
![redmine]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/redmine1-150x150.jpg)
  
Redmine es una herramienta para la gestión de proyectos y el seguimiento de errores escrita usando el framework Ruby on Rails. Incluye un calendario y unos diagramas de Gantt para la representación visual de la línea del tiempo de los proyectos. Es software libre y de código abierto, disponible bajo la Licencia Pública General de GNU v2.

Vamos a instalar redmine desde los archivos fuentes bajados de la página oficial, en un servidor Debian Squeeze con servidor web Apache2 con el módulo `passenger` y el gestor de base de datos mysql. Partimos de los dos artículos anteriores escritos en esta página: [Introducción a Ruby on Rails con Debian Squeeze](http://www.josedomingo.org/pledin/2012/01/introduccion-a-ruby-on-rails-con-debian-squeeze/ "Introducción a Ruby on Rails con Debian Squeeze") y [Instalación de aplicaciones Ruby on Rails con Apache2+Passenger.](http://www.josedomingo.org/pledin/2012/01/instalacion-de-aplicaciones-ruby-on-rails-con-apache2passenger/ "Instalación de aplicaciones Ruby on Rails con Apache2+Passenger")

1. Descargamos los ficheros fuentes de la [página oficial](http://rubyforge.org/frs/?group_id=1850), nosotros vamos a descargar la versión 1.3.0. La descomprimimos y lo guardamos en /var/www, de esta manera en la carpeta /var/www/redmine-1.3.0 tendremos la aplicación guardada.
2. Creamos la base de datos y un usuario mysql para acceder a dicha base de datos:

        create database redmine character set utf8;
        grant all privileges on redmine.* to 'redmine'@'localhost' identified by 'my_password';

3. Configuramos los datos de acceso a la base de datos, para ello:

        cd /var/www/redmine-1.3.0
        cp config/database.yml.example config/database.yml

    Y editamos el fichero dejándolo de la siguiente manera:

        production:
          adapter: mysql
          database: redmine
          host: localhost
          username: redmine
          password: my_password
          encoding: utf8

4. Generamos una identificador de inicio

        rake generate_session_store

    Y migramos la base de datos:

        RAILS_ENV=production rake db:migrate

    En este paso obtenemos un error, ya que necesito la versión 1.1.0 de la gema rack. para ello:

        gem install rack -v 1.1.0

    Por último realizamos la configuración inicial con:

        RAILS_ENV=production rake redmine:load_default_data

    y escogemos el idioma , en nuestro caso "es".

5. Podemos comprobar su funcionamiento usando el servidor web webrick:

        ruby script/server -b 192.168.100.10 -e production

    y accediendo a la URL `http://192.168.100.10:3000`

6. Para que funcione usando apache2 con el módulo `passenger`, nos aseguramos que el módulo `passenger` y el módulo `rewrite` estén activos:

        a2enmod passenger
        a2enmod rewrite

    Y creamos un fichero de configuración de un virtual host de la siguiente manera:

        <VirtualHost *:80>
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
          </Directory>
        ...

Reiniciamos el servicio y probamos a acceder a la página con la URL `http://192.168.100.10`.