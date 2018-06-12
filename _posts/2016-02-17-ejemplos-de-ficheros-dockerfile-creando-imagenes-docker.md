---
id: 1645
title: Ejemplos de ficheros Dockerfile, creando imágenes docker
date: 2016-02-17T10:55:41+00:00


guid: http://www.josedomingo.org/pledin/?p=1645
permalink: /2016/02/ejemplos-de-ficheros-dockerfile-creando-imagenes-docker/


tags:
  - docker
  - Virtualización
---
<p style="text-align: justify;">
  En la entrada: <a href="http://www.josedomingo.org/pledin/2016/02/dockerfile-creacion-de-imagenes-docker/">Dockerfile: Creación de imágenes docker</a>, estudiamos el mecanismo de creación de imágenes docker, con el comando <em>docker buid</em> y los ficheros <em>Dockerfile</em>. En esta entrada vamos a estudiar algunos ejemplos de ficheros <em>Dockerfile</em> y cómo creamos y usamos las imágenes generadas a partir de ellos.
</p>

Tenemos dos imágenes en nuestro sistema, que son las que vamos a utilizar como imágenes base para crear nuestras imágenes:

<pre>$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
debian              latest              9a02f494bef8        2 weeks ago         125.1 MB
ubuntu              14.04               3876b81b5a81        3 weeks ago         187.9 MB</pre>

<h2 style="text-align: justify;">
  Creación una imagen con el servidor web Apache2
</h2>

<p style="text-align: justify;">
  En este caso vamos a crear un directorio nuevo que va a ser el contexto donde podemos guardar los ficheros que se van a enviar al <em>docker engine,</em> en este caso el fichero<em> index.html</em> que vamos a copiar a nuestro servidor web:
</p>

<pre>$ mkdir apache
$ cd apache
~/apache$ echo "&lt;h1&gt;Prueba de funcionamiento contenedor docker&lt;/h1&gt;"&gt;index.html</pre>

En ese directorio vamos a crear un fichero _Dockerfile_, con el siguiente contenido:

<pre>FROM debian
MAINTAINER José Domingo Muñoz "josedom24@gmail.com"

RUN apt-get update && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80
ADD ["index.html","/var/www/html/"]

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]</pre>

<p style="text-align: justify;">
  En este caso utilizamos la imagen base de debian, instalamos el servidor web apache2, para reducir el tamaño, borramos la caché de paquetes apt y la lista de paquetes descargada, creamos varias variables de entorno (en este ejemplo no se van a utilizar, pero se podrían utilizar en cualquier fichero del contexto, por ejemplo para configurar el servidor web), exponemos el puerto http TCP/80, copiamos el fichero index.html al <em>DocumentRoot </em>y finalmente indicamos el comando que se va a ejecutar al crear el contenedor, y además, al usar el comando ENTRYPOINT, no permitimos ejecutar ningún otro comando durante la creación.
</p>

<p style="text-align: justify;">
  Vamos a generar la imagen:
</p>

<pre>~/apache$ docker build -t josedom24/apache2:1.0 .
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM debian
 ---&gt; 9a02f494bef8
Step 2 : MAINTAINER José Domingo Muñoz "josedom24@gmail.com"
 ---&gt; Running in 76f3f8fe0719
 ---&gt; fda7bdbf761c
Removing intermediate container 76f3f8fe0719
Step 3 : RUN apt-get update && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*
 ---&gt; Running in c50b14cc967d
Get:1 http://security.debian.org jessie/updates InRelease [63.1 kB]
Get:2 http://security.debian.org jessie/updates/main amd64 Packages [256 kB]
Ign http://httpredir.debian.org jessie InRelease
...
 ---&gt; 0dedcfe17eb9
Removing intermediate container c50b14cc967d
Step 4 : ENV APACHE_RUN_USER www-data
 ---&gt; Running in 85a85c09f96c
 ---&gt; dac18d113b15
Removing intermediate container 85a85c09f96c
Step 5 : ENV APACHE_RUN_GROUP www-data
 ---&gt; Running in 9e7511d92c74
 ---&gt; 8f5824bdc71a
Removing intermediate container 9e7511d92c74
Step 6 : ENV APACHE_LOG_DIR /var/log/apache2
 ---&gt; Running in 1b9173a822f8
 ---&gt; 313e04f3a33a
Removing intermediate container 1b9173a822f8
Step 7 : EXPOSE 80
 ---&gt; Running in 001ce73f08a6
 ---&gt; 76f798e8d481
Removing intermediate container 001ce73f08a6
Step 8 : ADD index.html /var/www/html
 ---&gt; 5ce11ae0b1e6
Removing intermediate container c8f418d3a0f6
Step 9 : ENTRYPOINT /usr/sbin/apache2ctl -D FOREGROUND
 ---&gt; Running in 4ba6954632a5
 ---&gt; 9109b0f27a08
Removing intermediate container 4ba6954632a5
Successfully built 9109b0f27a08</pre>

<p style="text-align: justify;">
  Generamos la nueva imagen con el comando <em>docker build</em> con la opción <em>-t </em>indicamos el nombre de la nueva imagen (para indicar el nombre de la imagen es recomendable usar nuestro nombre de usuario en el registro <em>docker hub</em>, para posteriormente poder guardarlas en el registro), mandamos todos los ficheros del contexto (indicado con el punto). Podemos comprobar que tenemos generado la nueva imagen:
</p>

<pre>$ docker images 
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
josedom24/apache2   1.0                 9109b0f27a08        4 minutes ago       183.7 MB
debian              latest              9a02f494bef8        2 weeks ago         125.1 MB
ubuntu              14.04               3876b81b5a81        3 weeks ago         187.9 MB</pre>

A continuación podemos crear un nuevo contenedor a partir de la nueva imagen:

<pre>$ docker run -p 80:80 --name servidor_web josedom24/apache2:1.0</pre>

Comprobamos que el contenedor está creado:

<pre>$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
67013f91ba65        josedom24/apache    "/usr/sbin/apache2ctl"   4 minutes ago       Up 4 minutes        0.0.0.0:80-&gt;80/tcp   servidor_web</pre>

Y podemos acceder al servidor docker, para ver la página web:
  
<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile1.png" rel="attachment wp-att-1647"><img class="aligncenter size-full wp-image-1647" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile1.png" alt="dockerfile1" width="862" height="126" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile1.png 862w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile1-300x44.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile1-768x112.png 768w" sizes="(max-width: 862px) 100vw, 862px" /></a>
  
<!--more-->

## Creación una imagen con el servidor de base de datos mysql

En esta ocasión vamos a tener un contexto, un directorio con los siguientes ficheros:

<pre>~/mysql$ ls
Dockerfile  my.cnf  script.sh</pre>

El fichero de configuración de mysql, _my.cnf_:

<pre>[mysqld]
bind-address=0.0.0.0
console=1
general_log=1
general_log_file=/dev/stdout
log_error=/dev/stderr</pre>

Un script bash, que va a ser el que se va a ejecutar por defecto cunado se crea un contenedor, _script.sh_:

<pre>#!/bin/bash
set -e

chown -R mysql:mysql /var/lib/mysql
mysql_install_db --user mysql &gt; /dev/null

MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-""}
MYSQL_DATABASE=${MYSQL_DATABASE:-""}
MYSQL_USER=${MYSQL_USER:-""}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

tfile=`mktemp`
if [[ ! -f "$tfile" ]]; then
    return 1
fi

cat &lt;&lt; EOF &gt; $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("$MYSQL_ROOT_PASSWORD") WHERE user='root';
EOF

if [[ $MYSQL_DATABASE != "" ]]; then
    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" &gt;&gt; $tfile

    if [[ $MYSQL_USER != "" ]]; then
        echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" &gt;&gt; $tfile
    fi
fi

/usr/sbin/mysqld --bootstrap --verbose=0 &lt; $tfile
rm -f $tfile

exec /usr/sbin/mysqld</pre>

<p style="text-align: justify;">
  Podemos ver que hace uso de varias variables de entorno:
</p>

<pre>MYSQL_ROOT_PASSWORD
MYSQL_DATABASE
MYSQL_USER
MYSQL_PASSWORD</pre>

<p style="text-align: justify;">
  Que nos permiten especificar la contraseña del root, el nombre de una base de datos a crear, el nombre y contraseña de un nuevo usuario a crear.  Estas variables de entorno se pueden indicar en el fichero <em>Dockerfile</em>, o con el parámetro <code>--env</code> en el comando <em>docker run</em>.
</p>

<p style="text-align: justify;">
  El fichero <em>Dockerfile</em> tendrá el siguiente contenido:
</p>

<pre>FROM ubuntu:14.04 
MAINTAINER José Domingo Muñoz "josedom24@gmail.com"

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y mysql-server

ADD my.cnf /etc/mysql/conf.d/my.cnf 
ADD script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

EXPOSE 3306

CMD ["/usr/local/bin/script.sh"]</pre>

<p style="text-align: justify;">
  Como vemos se instala mysql, se copia el fichero de configuración y el script en bash que es el comando que se va a ejecutar por defecto al crear los contenedores. Generamos la imagen:
</p>

<pre>~/mysql$ docker build -t josedom24/mysql:1.0 .</pre>

<p style="text-align: justify;">
  Y creamos un contenedor indicando la contraseña del root:
</p>

<pre>$ docker run -d -p 3306:3306 --env MYSQL_ROOT_PASSWORD=asdasd --name servidor_mysql jose/mysql:1.0</pre>

<pre>$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
8635e1392523        josedom24/mysq      "/usr/local/bin/scrip"   3 seconds ago       Up 3 seconds        0.0.0.0:3306-&gt;3306/tcp   servidor_mysql</pre>

Y accedemos al servidor mysql, utilizando la ip del servidor docker:

<pre>mysql -u root -p -h 192.168.0.100</pre>

Este ejemplo se basa en la imagen mysql que podemos encontrar en docker hub: <https://hub.docker.com/r/mysql/mysql-server/>

## Creación una imagen con con php a partir de nuestra imagen con apache2

<p style="text-align: justify;">
  En este último ejemplo, vamos a crear una imagen con php5 a parir de nuestra imagen con apache: <em>josedom24/apache2:1.0, </em>para ello en el directorio php creamos un fichero <em>index.php:</em>
</p>

<pre>~/php$ echo "&lt;?php echo phpinfo();?&gt;"&gt;index.php</pre>

Y el fichero _Dockerfile_, con el siguiente contenido:

<pre>FROM josedom24/apache2:1.0
MAINTAINER José Domingo Muñoz "josedom24@gmail.com"

RUN apt-get update && apt-get install -y php5 && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80
ADD ["index.php","/var/www/html/"]

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]</pre>

Generamos la nueva imagen:

<pre>~/php$ docker build -y josedom24/php5:1.0 .</pre>

Creamos un nuevo contenedor, y realizamos la prueba de funcionamiento:

<pre>$ docker run -d -p 8080:80 --name servidor_php josedom24/php5:1.0</pre>

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile2.png" rel="attachment wp-att-1650"><img class="aligncenter size-full wp-image-1650" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile2.png" alt="dockerfile2" width="992" height="309" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile2.png 992w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile2-300x93.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile2-768x239.png 768w" sizes="(max-width: 992px) 100vw, 992px" /></a>

## Conclusiones

<p style="text-align: justify;">
  En esta entrada hemos visto una introducción a la creación de imágenes docker utilizando ficheros <em>Dockerfile</em>. Para avanzar más sobre la utilización de este mecanismo de creación de imágenes os sugiero que estudiéis los ficheros <em>Dockerfile</em> y los repositorios que podemos encontrar en el registro Docker Hub:
</p>

<p style="text-align: justify;">
  <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile3.png" rel="attachment wp-att-1652"><img class="aligncenter size-large wp-image-1652" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile3-1024x474.png" alt="dockerfile3" width="770" height="356" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile3-1024x474.png 1024w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile3-300x139.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile3-768x356.png 768w" sizes="(max-width: 770px) 100vw, 770px" /></a>En la siguiente entrada vamos a hacer una introducción al uso del registro docker hub, para guardar nuestras imágenes y poderlas desplegar en nuestro entorno de producción.
</p>

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->