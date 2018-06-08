---
layout: post
status: publish
published: true
title: Ejemplos de ficheros Dockerfile, creando im&aacute;genes docker
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1645
wordpress_url: http://www.josedomingo.org/pledin/?p=1645
date: '2016-02-17 10:55:41 +0000'
date_gmt: '2016-02-17 09:55:41 +0000'
categories:
- General
tags:
- Virtualizaci&oacute;n
- docker
comments: []
---
<p style="text-align: justify;">En la entrada: <a href="http://www.josedomingo.org/pledin/2016/02/dockerfile-creacion-de-imagenes-docker/">Dockerfile: Creaci&oacute;n de im&aacute;genes docker</a>, estudiamos el mecanismo de creaci&oacute;n de im&aacute;genes docker, con el comando <em>docker buid</em> y los ficheros <em>Dockerfile</em>. En esta entrada vamos a estudiar algunos ejemplos de ficheros <em>Dockerfile</em> y c&oacute;mo creamos y usamos las im&aacute;genes generadas a partir de ellos.</p>
<p>Tenemos dos im&aacute;genes en nuestro sistema, que son las que vamos a utilizar como im&aacute;genes base para crear nuestras im&aacute;genes:</p>
<pre>$ docker images
REPOSITORY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SIZE
debian&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; latest&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9a02f494bef8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 125.1 MB
ubuntu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14.04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3876b81b5a81&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 187.9 MB</pre>
<h2 style="text-align: justify;">Creaci&oacute;n una imagen con el servidor web Apache2</h2>
<p style="text-align: justify;">En este caso vamos a crear un directorio nuevo que va a ser el contexto donde podemos guardar los ficheros que se van a enviar al <em>docker engine,</em> en este caso el fichero<em> index.html</em> que vamos a copiar a nuestro servidor web:</p>
<pre>$ mkdir apache
$ cd apache
~/apache$ echo "<h1>Prueba de funcionamiento contenedor docker</h1>">index.html</pre>
<p>En ese directorio vamos a crear un fichero <em>Dockerfile</em>, con el siguiente contenido:</p>
<pre>FROM debian
MAINTAINER Jos&eacute; Domingo Mu&ntilde;oz "josedom24@gmail.com"

RUN apt-get update &amp;&amp; apt-get install -y apache2 &amp;&amp; apt-get clean &amp;&amp; rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80
ADD ["index.html","/var/www/html/"]

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]</pre>
<p style="text-align: justify;">En este caso utilizamos la imagen base de debian, instalamos el servidor web apache2, para reducir el tama&ntilde;o, borramos la cach&eacute; de paquetes apt y la lista de paquetes descargada, creamos varias variables de entorno (en este ejemplo no se van a utilizar, pero se podr&iacute;an utilizar en cualquier fichero del contexto, por ejemplo para configurar el servidor web), exponemos el puerto http TCP/80, copiamos el fichero index.html al <em>DocumentRoot </em>y finalmente indicamos el comando que se va a ejecutar al crear el contenedor, y adem&aacute;s, al usar el comando ENTRYPOINT, no permitimos ejecutar ning&uacute;n otro comando durante la creaci&oacute;n.</p>
<p style="text-align: justify;">Vamos a generar la imagen:</p>
<pre>~/apache$ docker build -t josedom24/apache2:1.0 .
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM debian
&nbsp;---> 9a02f494bef8
Step 2 : MAINTAINER Jos&eacute; Domingo Mu&ntilde;oz "josedom24@gmail.com"
&nbsp;---> Running in 76f3f8fe0719
&nbsp;---> fda7bdbf761c
Removing intermediate container 76f3f8fe0719
Step 3 : RUN apt-get update &amp;&amp; apt-get install -y apache2 &amp;&amp; apt-get clean &amp;&amp; rm -rf /var/lib/apt/lists/*
&nbsp;---> Running in c50b14cc967d
Get:1 http://security.debian.org jessie/updates InRelease [63.1 kB]
Get:2 http://security.debian.org jessie/updates/main amd64 Packages [256 kB]
Ign http://httpredir.debian.org jessie InRelease
...
&nbsp;---> 0dedcfe17eb9
Removing intermediate container c50b14cc967d
Step 4 : ENV APACHE_RUN_USER www-data
&nbsp;---> Running in 85a85c09f96c
&nbsp;---> dac18d113b15
Removing intermediate container 85a85c09f96c
Step 5 : ENV APACHE_RUN_GROUP www-data
&nbsp;---> Running in 9e7511d92c74
&nbsp;---> 8f5824bdc71a
Removing intermediate container 9e7511d92c74
Step 6 : ENV APACHE_LOG_DIR /var/log/apache2
&nbsp;---> Running in 1b9173a822f8
&nbsp;---> 313e04f3a33a
Removing intermediate container 1b9173a822f8
Step 7 : EXPOSE 80
&nbsp;---> Running in 001ce73f08a6
&nbsp;---> 76f798e8d481
Removing intermediate container 001ce73f08a6
Step 8 : ADD index.html /var/www/html
&nbsp;---> 5ce11ae0b1e6
Removing intermediate container c8f418d3a0f6
Step 9 : ENTRYPOINT /usr/sbin/apache2ctl -D FOREGROUND
&nbsp;---> Running in 4ba6954632a5
&nbsp;---> 9109b0f27a08
Removing intermediate container 4ba6954632a5
Successfully built 9109b0f27a08</pre>
<p style="text-align: justify;">Generamos la nueva imagen con el comando <em>docker build</em> con la opci&oacute;n <em>-t </em>indicamos el nombre de la nueva imagen (para indicar el nombre de la imagen es recomendable usar nuestro nombre de usuario en el registro <em>docker hub</em>, para posteriormente poder guardarlas en el registro), mandamos todos los ficheros del contexto (indicado con el punto). Podemos comprobar que tenemos generado la nueva imagen:</p>
<pre>$ docker images 
REPOSITORY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SIZE
josedom24/apache2&nbsp;&nbsp; 1.0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9109b0f27a08&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4 minutes ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 183.7 MB
debian&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; latest&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9a02f494bef8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 125.1 MB
ubuntu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14.04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3876b81b5a81&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 187.9 MB</pre>
<p>A continuaci&oacute;n podemos crear un nuevo contenedor a partir de la nueva imagen:</p>
<pre>$ docker run -p 80:80 --name servidor_web josedom24/apache2:1.0</pre>
<p>Comprobamos que el contenedor est&aacute; creado:</p>
<pre>$ docker ps
CONTAINER ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; COMMAND&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STATUS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PORTS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NAMES
67013f91ba65&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; josedom24/apache&nbsp;&nbsp;&nbsp; "/usr/sbin/apache2ctl"&nbsp;&nbsp; 4 minutes ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Up 4 minutes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.0.0.0:80->80/tcp&nbsp;&nbsp; servidor_web</pre>
<p>Y podemos acceder al servidor docker, para ver la p&aacute;gina web:<br />
<a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile1.png" rel="attachment wp-att-1647"><img class="aligncenter size-full wp-image-1647" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile1.png" alt="dockerfile1" width="862" height="126" /></a><br />
<!--more--></p>
<h2>Creaci&oacute;n una imagen con el servidor de base de datos mysql</h2>
<p>En esta ocasi&oacute;n vamos a tener un contexto, un directorio con los siguientes ficheros:</p>
<pre>~/mysql$ ls
Dockerfile&nbsp; my.cnf&nbsp; script.sh</pre>
<p>El fichero de configuraci&oacute;n de mysql, <em>my.cnf</em>:</p>
<pre>[mysqld]
bind-address=0.0.0.0
console=1
general_log=1
general_log_file=/dev/stdout
log_error=/dev/stderr</pre>
<p>Un script bash, que va a ser el que se va a ejecutar por defecto cunado se crea un contenedor, <em>script.sh</em>:</p>
<pre>#!/bin/bash
set -e

chown -R mysql:mysql /var/lib/mysql
mysql_install_db --user mysql > /dev/null

MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-""}
MYSQL_DATABASE=${MYSQL_DATABASE:-""}
MYSQL_USER=${MYSQL_USER:-""}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

tfile=`mktemp`
if [[ ! -f "$tfile" ]]; then
&nbsp;&nbsp;&nbsp; return 1
fi

cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("$MYSQL_ROOT_PASSWORD") WHERE user='root';
EOF

if [[ $MYSQL_DATABASE != "" ]]; then
&nbsp;&nbsp;&nbsp; echo "CREATE DATABASE IF NOT EXISTS <p style="text-align: justify;">En la entrada: <a href="http://www.josedomingo.org/pledin/2016/02/dockerfile-creacion-de-imagenes-docker/">Dockerfile: Creaci&oacute;n de im&aacute;genes docker</a>, estudiamos el mecanismo de creaci&oacute;n de im&aacute;genes docker, con el comando <em>docker buid</em> y los ficheros <em>Dockerfile</em>. En esta entrada vamos a estudiar algunos ejemplos de ficheros <em>Dockerfile</em> y c&oacute;mo creamos y usamos las im&aacute;genes generadas a partir de ellos.</p>
<p>Tenemos dos im&aacute;genes en nuestro sistema, que son las que vamos a utilizar como im&aacute;genes base para crear nuestras im&aacute;genes:</p>
<pre>$ docker images
REPOSITORY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SIZE
debian&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; latest&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9a02f494bef8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 125.1 MB
ubuntu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14.04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3876b81b5a81&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 187.9 MB</pre>
<h2 style="text-align: justify;">Creaci&oacute;n una imagen con el servidor web Apache2</h2>
<p style="text-align: justify;">En este caso vamos a crear un directorio nuevo que va a ser el contexto donde podemos guardar los ficheros que se van a enviar al <em>docker engine,</em> en este caso el fichero<em> index.html</em> que vamos a copiar a nuestro servidor web:</p>
<pre>$ mkdir apache
$ cd apache
~/apache$ echo "<h1>Prueba de funcionamiento contenedor docker</h1>">index.html</pre>
<p>En ese directorio vamos a crear un fichero <em>Dockerfile</em>, con el siguiente contenido:</p>
<pre>FROM debian
MAINTAINER Jos&eacute; Domingo Mu&ntilde;oz "josedom24@gmail.com"

RUN apt-get update &amp;&amp; apt-get install -y apache2 &amp;&amp; apt-get clean &amp;&amp; rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80
ADD ["index.html","/var/www/html/"]

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]</pre>
<p style="text-align: justify;">En este caso utilizamos la imagen base de debian, instalamos el servidor web apache2, para reducir el tama&ntilde;o, borramos la cach&eacute; de paquetes apt y la lista de paquetes descargada, creamos varias variables de entorno (en este ejemplo no se van a utilizar, pero se podr&iacute;an utilizar en cualquier fichero del contexto, por ejemplo para configurar el servidor web), exponemos el puerto http TCP/80, copiamos el fichero index.html al <em>DocumentRoot </em>y finalmente indicamos el comando que se va a ejecutar al crear el contenedor, y adem&aacute;s, al usar el comando ENTRYPOINT, no permitimos ejecutar ning&uacute;n otro comando durante la creaci&oacute;n.</p>
<p style="text-align: justify;">Vamos a generar la imagen:</p>
<pre>~/apache$ docker build -t josedom24/apache2:1.0 .
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM debian
&nbsp;---> 9a02f494bef8
Step 2 : MAINTAINER Jos&eacute; Domingo Mu&ntilde;oz "josedom24@gmail.com"
&nbsp;---> Running in 76f3f8fe0719
&nbsp;---> fda7bdbf761c
Removing intermediate container 76f3f8fe0719
Step 3 : RUN apt-get update &amp;&amp; apt-get install -y apache2 &amp;&amp; apt-get clean &amp;&amp; rm -rf /var/lib/apt/lists/*
&nbsp;---> Running in c50b14cc967d
Get:1 http://security.debian.org jessie/updates InRelease [63.1 kB]
Get:2 http://security.debian.org jessie/updates/main amd64 Packages [256 kB]
Ign http://httpredir.debian.org jessie InRelease
...
&nbsp;---> 0dedcfe17eb9
Removing intermediate container c50b14cc967d
Step 4 : ENV APACHE_RUN_USER www-data
&nbsp;---> Running in 85a85c09f96c
&nbsp;---> dac18d113b15
Removing intermediate container 85a85c09f96c
Step 5 : ENV APACHE_RUN_GROUP www-data
&nbsp;---> Running in 9e7511d92c74
&nbsp;---> 8f5824bdc71a
Removing intermediate container 9e7511d92c74
Step 6 : ENV APACHE_LOG_DIR /var/log/apache2
&nbsp;---> Running in 1b9173a822f8
&nbsp;---> 313e04f3a33a
Removing intermediate container 1b9173a822f8
Step 7 : EXPOSE 80
&nbsp;---> Running in 001ce73f08a6
&nbsp;---> 76f798e8d481
Removing intermediate container 001ce73f08a6
Step 8 : ADD index.html /var/www/html
&nbsp;---> 5ce11ae0b1e6
Removing intermediate container c8f418d3a0f6
Step 9 : ENTRYPOINT /usr/sbin/apache2ctl -D FOREGROUND
&nbsp;---> Running in 4ba6954632a5
&nbsp;---> 9109b0f27a08
Removing intermediate container 4ba6954632a5
Successfully built 9109b0f27a08</pre>
<p style="text-align: justify;">Generamos la nueva imagen con el comando <em>docker build</em> con la opci&oacute;n <em>-t </em>indicamos el nombre de la nueva imagen (para indicar el nombre de la imagen es recomendable usar nuestro nombre de usuario en el registro <em>docker hub</em>, para posteriormente poder guardarlas en el registro), mandamos todos los ficheros del contexto (indicado con el punto). Podemos comprobar que tenemos generado la nueva imagen:</p>
<pre>$ docker images 
REPOSITORY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SIZE
josedom24/apache2&nbsp;&nbsp; 1.0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9109b0f27a08&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4 minutes ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 183.7 MB
debian&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; latest&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9a02f494bef8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 125.1 MB
ubuntu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14.04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3876b81b5a81&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 187.9 MB</pre>
<p>A continuaci&oacute;n podemos crear un nuevo contenedor a partir de la nueva imagen:</p>
<pre>$ docker run -p 80:80 --name servidor_web josedom24/apache2:1.0</pre>
<p>Comprobamos que el contenedor est&aacute; creado:</p>
<pre>$ docker ps
CONTAINER ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; COMMAND&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STATUS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PORTS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NAMES
67013f91ba65&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; josedom24/apache&nbsp;&nbsp;&nbsp; "/usr/sbin/apache2ctl"&nbsp;&nbsp; 4 minutes ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Up 4 minutes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.0.0.0:80->80/tcp&nbsp;&nbsp; servidor_web</pre>
<p>Y podemos acceder al servidor docker, para ver la p&aacute;gina web:<br />
<a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile1.png" rel="attachment wp-att-1647"><img class="aligncenter size-full wp-image-1647" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile1.png" alt="dockerfile1" width="862" height="126" /></a><br />
<!--more--></p>
<h2>Creaci&oacute;n una imagen con el servidor de base de datos mysql</h2>
<p>En esta ocasi&oacute;n vamos a tener un contexto, un directorio con los siguientes ficheros:</p>
<pre>~/mysql$ ls
Dockerfile&nbsp; my.cnf&nbsp; script.sh</pre>
<p>El fichero de configuraci&oacute;n de mysql, <em>my.cnf</em>:</p>
<pre>[mysqld]
bind-address=0.0.0.0
console=1
general_log=1
general_log_file=/dev/stdout
log_error=/dev/stderr</pre>
<p>Un script bash, que va a ser el que se va a ejecutar por defecto cunado se crea un contenedor, <em>script.sh</em>:</p>
$MYSQL_DATABASE<p style="text-align: justify;">En la entrada: <a href="http://www.josedomingo.org/pledin/2016/02/dockerfile-creacion-de-imagenes-docker/">Dockerfile: Creaci&oacute;n de im&aacute;genes docker</a>, estudiamos el mecanismo de creaci&oacute;n de im&aacute;genes docker, con el comando <em>docker buid</em> y los ficheros <em>Dockerfile</em>. En esta entrada vamos a estudiar algunos ejemplos de ficheros <em>Dockerfile</em> y c&oacute;mo creamos y usamos las im&aacute;genes generadas a partir de ellos.</p>
<p>Tenemos dos im&aacute;genes en nuestro sistema, que son las que vamos a utilizar como im&aacute;genes base para crear nuestras im&aacute;genes:</p>
<pre>$ docker images
REPOSITORY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SIZE
debian&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; latest&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9a02f494bef8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 125.1 MB
ubuntu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14.04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3876b81b5a81&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 187.9 MB</pre>
<h2 style="text-align: justify;">Creaci&oacute;n una imagen con el servidor web Apache2</h2>
<p style="text-align: justify;">En este caso vamos a crear un directorio nuevo que va a ser el contexto donde podemos guardar los ficheros que se van a enviar al <em>docker engine,</em> en este caso el fichero<em> index.html</em> que vamos a copiar a nuestro servidor web:</p>
<pre>$ mkdir apache
$ cd apache
~/apache$ echo "<h1>Prueba de funcionamiento contenedor docker</h1>">index.html</pre>
<p>En ese directorio vamos a crear un fichero <em>Dockerfile</em>, con el siguiente contenido:</p>
<pre>FROM debian
MAINTAINER Jos&eacute; Domingo Mu&ntilde;oz "josedom24@gmail.com"

RUN apt-get update &amp;&amp; apt-get install -y apache2 &amp;&amp; apt-get clean &amp;&amp; rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80
ADD ["index.html","/var/www/html/"]

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]</pre>
<p style="text-align: justify;">En este caso utilizamos la imagen base de debian, instalamos el servidor web apache2, para reducir el tama&ntilde;o, borramos la cach&eacute; de paquetes apt y la lista de paquetes descargada, creamos varias variables de entorno (en este ejemplo no se van a utilizar, pero se podr&iacute;an utilizar en cualquier fichero del contexto, por ejemplo para configurar el servidor web), exponemos el puerto http TCP/80, copiamos el fichero index.html al <em>DocumentRoot </em>y finalmente indicamos el comando que se va a ejecutar al crear el contenedor, y adem&aacute;s, al usar el comando ENTRYPOINT, no permitimos ejecutar ning&uacute;n otro comando durante la creaci&oacute;n.</p>
<p style="text-align: justify;">Vamos a generar la imagen:</p>
<pre>~/apache$ docker build -t josedom24/apache2:1.0 .
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM debian
&nbsp;---> 9a02f494bef8
Step 2 : MAINTAINER Jos&eacute; Domingo Mu&ntilde;oz "josedom24@gmail.com"
&nbsp;---> Running in 76f3f8fe0719
&nbsp;---> fda7bdbf761c
Removing intermediate container 76f3f8fe0719
Step 3 : RUN apt-get update &amp;&amp; apt-get install -y apache2 &amp;&amp; apt-get clean &amp;&amp; rm -rf /var/lib/apt/lists/*
&nbsp;---> Running in c50b14cc967d
Get:1 http://security.debian.org jessie/updates InRelease [63.1 kB]
Get:2 http://security.debian.org jessie/updates/main amd64 Packages [256 kB]
Ign http://httpredir.debian.org jessie InRelease
...
&nbsp;---> 0dedcfe17eb9
Removing intermediate container c50b14cc967d
Step 4 : ENV APACHE_RUN_USER www-data
&nbsp;---> Running in 85a85c09f96c
&nbsp;---> dac18d113b15
Removing intermediate container 85a85c09f96c
Step 5 : ENV APACHE_RUN_GROUP www-data
&nbsp;---> Running in 9e7511d92c74
&nbsp;---> 8f5824bdc71a
Removing intermediate container 9e7511d92c74
Step 6 : ENV APACHE_LOG_DIR /var/log/apache2
&nbsp;---> Running in 1b9173a822f8
&nbsp;---> 313e04f3a33a
Removing intermediate container 1b9173a822f8
Step 7 : EXPOSE 80
&nbsp;---> Running in 001ce73f08a6
&nbsp;---> 76f798e8d481
Removing intermediate container 001ce73f08a6
Step 8 : ADD index.html /var/www/html
&nbsp;---> 5ce11ae0b1e6
Removing intermediate container c8f418d3a0f6
Step 9 : ENTRYPOINT /usr/sbin/apache2ctl -D FOREGROUND
&nbsp;---> Running in 4ba6954632a5
&nbsp;---> 9109b0f27a08
Removing intermediate container 4ba6954632a5
Successfully built 9109b0f27a08</pre>
<p style="text-align: justify;">Generamos la nueva imagen con el comando <em>docker build</em> con la opci&oacute;n <em>-t </em>indicamos el nombre de la nueva imagen (para indicar el nombre de la imagen es recomendable usar nuestro nombre de usuario en el registro <em>docker hub</em>, para posteriormente poder guardarlas en el registro), mandamos todos los ficheros del contexto (indicado con el punto). Podemos comprobar que tenemos generado la nueva imagen:</p>
<pre>$ docker images 
REPOSITORY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SIZE
josedom24/apache2&nbsp;&nbsp; 1.0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9109b0f27a08&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4 minutes ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 183.7 MB
debian&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; latest&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9a02f494bef8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 125.1 MB
ubuntu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14.04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3876b81b5a81&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 187.9 MB</pre>
<p>A continuaci&oacute;n podemos crear un nuevo contenedor a partir de la nueva imagen:</p>
<pre>$ docker run -p 80:80 --name servidor_web josedom24/apache2:1.0</pre>
<p>Comprobamos que el contenedor est&aacute; creado:</p>
<pre>$ docker ps
CONTAINER ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; COMMAND&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STATUS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PORTS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NAMES
67013f91ba65&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; josedom24/apache&nbsp;&nbsp;&nbsp; "/usr/sbin/apache2ctl"&nbsp;&nbsp; 4 minutes ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Up 4 minutes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.0.0.0:80->80/tcp&nbsp;&nbsp; servidor_web</pre>
<p>Y podemos acceder al servidor docker, para ver la p&aacute;gina web:<br />
<a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile1.png" rel="attachment wp-att-1647"><img class="aligncenter size-full wp-image-1647" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile1.png" alt="dockerfile1" width="862" height="126" /></a><br />
<!--more--></p>
<h2>Creaci&oacute;n una imagen con el servidor de base de datos mysql</h2>
<p>En esta ocasi&oacute;n vamos a tener un contexto, un directorio con los siguientes ficheros:</p>
<pre>~/mysql$ ls
Dockerfile&nbsp; my.cnf&nbsp; script.sh</pre>
<p>El fichero de configuraci&oacute;n de mysql, <em>my.cnf</em>:</p>
<pre>[mysqld]
bind-address=0.0.0.0
console=1
general_log=1
general_log_file=/dev/stdout
log_error=/dev/stderr</pre>
<p>Un script bash, que va a ser el que se va a ejecutar por defecto cunado se crea un contenedor, <em>script.sh</em>:</p>
 CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

&nbsp;&nbsp;&nbsp; if [[ $MYSQL_USER != "" ]]; then
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; echo "GRANT ALL ON <p style="text-align: justify;">En la entrada: <a href="http://www.josedomingo.org/pledin/2016/02/dockerfile-creacion-de-imagenes-docker/">Dockerfile: Creaci&oacute;n de im&aacute;genes docker</a>, estudiamos el mecanismo de creaci&oacute;n de im&aacute;genes docker, con el comando <em>docker buid</em> y los ficheros <em>Dockerfile</em>. En esta entrada vamos a estudiar algunos ejemplos de ficheros <em>Dockerfile</em> y c&oacute;mo creamos y usamos las im&aacute;genes generadas a partir de ellos.</p>
<p>Tenemos dos im&aacute;genes en nuestro sistema, que son las que vamos a utilizar como im&aacute;genes base para crear nuestras im&aacute;genes:</p>
<pre>$ docker images
REPOSITORY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SIZE
debian&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; latest&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9a02f494bef8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 125.1 MB
ubuntu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14.04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3876b81b5a81&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 187.9 MB</pre>
<h2 style="text-align: justify;">Creaci&oacute;n una imagen con el servidor web Apache2</h2>
<p style="text-align: justify;">En este caso vamos a crear un directorio nuevo que va a ser el contexto donde podemos guardar los ficheros que se van a enviar al <em>docker engine,</em> en este caso el fichero<em> index.html</em> que vamos a copiar a nuestro servidor web:</p>
<pre>$ mkdir apache
$ cd apache
~/apache$ echo "<h1>Prueba de funcionamiento contenedor docker</h1>">index.html</pre>
<p>En ese directorio vamos a crear un fichero <em>Dockerfile</em>, con el siguiente contenido:</p>
<pre>FROM debian
MAINTAINER Jos&eacute; Domingo Mu&ntilde;oz "josedom24@gmail.com"

RUN apt-get update &amp;&amp; apt-get install -y apache2 &amp;&amp; apt-get clean &amp;&amp; rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80
ADD ["index.html","/var/www/html/"]

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]</pre>
<p style="text-align: justify;">En este caso utilizamos la imagen base de debian, instalamos el servidor web apache2, para reducir el tama&ntilde;o, borramos la cach&eacute; de paquetes apt y la lista de paquetes descargada, creamos varias variables de entorno (en este ejemplo no se van a utilizar, pero se podr&iacute;an utilizar en cualquier fichero del contexto, por ejemplo para configurar el servidor web), exponemos el puerto http TCP/80, copiamos el fichero index.html al <em>DocumentRoot </em>y finalmente indicamos el comando que se va a ejecutar al crear el contenedor, y adem&aacute;s, al usar el comando ENTRYPOINT, no permitimos ejecutar ning&uacute;n otro comando durante la creaci&oacute;n.</p>
<p style="text-align: justify;">Vamos a generar la imagen:</p>
<pre>~/apache$ docker build -t josedom24/apache2:1.0 .
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM debian
&nbsp;---> 9a02f494bef8
Step 2 : MAINTAINER Jos&eacute; Domingo Mu&ntilde;oz "josedom24@gmail.com"
&nbsp;---> Running in 76f3f8fe0719
&nbsp;---> fda7bdbf761c
Removing intermediate container 76f3f8fe0719
Step 3 : RUN apt-get update &amp;&amp; apt-get install -y apache2 &amp;&amp; apt-get clean &amp;&amp; rm -rf /var/lib/apt/lists/*
&nbsp;---> Running in c50b14cc967d
Get:1 http://security.debian.org jessie/updates InRelease [63.1 kB]
Get:2 http://security.debian.org jessie/updates/main amd64 Packages [256 kB]
Ign http://httpredir.debian.org jessie InRelease
...
&nbsp;---> 0dedcfe17eb9
Removing intermediate container c50b14cc967d
Step 4 : ENV APACHE_RUN_USER www-data
&nbsp;---> Running in 85a85c09f96c
&nbsp;---> dac18d113b15
Removing intermediate container 85a85c09f96c
Step 5 : ENV APACHE_RUN_GROUP www-data
&nbsp;---> Running in 9e7511d92c74
&nbsp;---> 8f5824bdc71a
Removing intermediate container 9e7511d92c74
Step 6 : ENV APACHE_LOG_DIR /var/log/apache2
&nbsp;---> Running in 1b9173a822f8
&nbsp;---> 313e04f3a33a
Removing intermediate container 1b9173a822f8
Step 7 : EXPOSE 80
&nbsp;---> Running in 001ce73f08a6
&nbsp;---> 76f798e8d481
Removing intermediate container 001ce73f08a6
Step 8 : ADD index.html /var/www/html
&nbsp;---> 5ce11ae0b1e6
Removing intermediate container c8f418d3a0f6
Step 9 : ENTRYPOINT /usr/sbin/apache2ctl -D FOREGROUND
&nbsp;---> Running in 4ba6954632a5
&nbsp;---> 9109b0f27a08
Removing intermediate container 4ba6954632a5
Successfully built 9109b0f27a08</pre>
<p style="text-align: justify;">Generamos la nueva imagen con el comando <em>docker build</em> con la opci&oacute;n <em>-t </em>indicamos el nombre de la nueva imagen (para indicar el nombre de la imagen es recomendable usar nuestro nombre de usuario en el registro <em>docker hub</em>, para posteriormente poder guardarlas en el registro), mandamos todos los ficheros del contexto (indicado con el punto). Podemos comprobar que tenemos generado la nueva imagen:</p>
<pre>$ docker images 
REPOSITORY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SIZE
josedom24/apache2&nbsp;&nbsp; 1.0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9109b0f27a08&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4 minutes ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 183.7 MB
debian&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; latest&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9a02f494bef8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 125.1 MB
ubuntu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14.04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3876b81b5a81&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 187.9 MB</pre>
<p>A continuaci&oacute;n podemos crear un nuevo contenedor a partir de la nueva imagen:</p>
<pre>$ docker run -p 80:80 --name servidor_web josedom24/apache2:1.0</pre>
<p>Comprobamos que el contenedor est&aacute; creado:</p>
<pre>$ docker ps
CONTAINER ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; COMMAND&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STATUS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PORTS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NAMES
67013f91ba65&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; josedom24/apache&nbsp;&nbsp;&nbsp; "/usr/sbin/apache2ctl"&nbsp;&nbsp; 4 minutes ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Up 4 minutes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.0.0.0:80->80/tcp&nbsp;&nbsp; servidor_web</pre>
<p>Y podemos acceder al servidor docker, para ver la p&aacute;gina web:<br />
<a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile1.png" rel="attachment wp-att-1647"><img class="aligncenter size-full wp-image-1647" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile1.png" alt="dockerfile1" width="862" height="126" /></a><br />
<!--more--></p>
<h2>Creaci&oacute;n una imagen con el servidor de base de datos mysql</h2>
<p>En esta ocasi&oacute;n vamos a tener un contexto, un directorio con los siguientes ficheros:</p>
<pre>~/mysql$ ls
Dockerfile&nbsp; my.cnf&nbsp; script.sh</pre>
<p>El fichero de configuraci&oacute;n de mysql, <em>my.cnf</em>:</p>
<pre>[mysqld]
bind-address=0.0.0.0
console=1
general_log=1
general_log_file=/dev/stdout
log_error=/dev/stderr</pre>
<p>Un script bash, que va a ser el que se va a ejecutar por defecto cunado se crea un contenedor, <em>script.sh</em>:</p>
$MYSQL_DATABASE<p style="text-align: justify;">En la entrada: <a href="http://www.josedomingo.org/pledin/2016/02/dockerfile-creacion-de-imagenes-docker/">Dockerfile: Creaci&oacute;n de im&aacute;genes docker</a>, estudiamos el mecanismo de creaci&oacute;n de im&aacute;genes docker, con el comando <em>docker buid</em> y los ficheros <em>Dockerfile</em>. En esta entrada vamos a estudiar algunos ejemplos de ficheros <em>Dockerfile</em> y c&oacute;mo creamos y usamos las im&aacute;genes generadas a partir de ellos.</p>
<p>Tenemos dos im&aacute;genes en nuestro sistema, que son las que vamos a utilizar como im&aacute;genes base para crear nuestras im&aacute;genes:</p>
<pre>$ docker images
REPOSITORY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SIZE
debian&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; latest&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9a02f494bef8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 125.1 MB
ubuntu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14.04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3876b81b5a81&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 187.9 MB</pre>
<h2 style="text-align: justify;">Creaci&oacute;n una imagen con el servidor web Apache2</h2>
<p style="text-align: justify;">En este caso vamos a crear un directorio nuevo que va a ser el contexto donde podemos guardar los ficheros que se van a enviar al <em>docker engine,</em> en este caso el fichero<em> index.html</em> que vamos a copiar a nuestro servidor web:</p>
<pre>$ mkdir apache
$ cd apache
~/apache$ echo "<h1>Prueba de funcionamiento contenedor docker</h1>">index.html</pre>
<p>En ese directorio vamos a crear un fichero <em>Dockerfile</em>, con el siguiente contenido:</p>
<pre>FROM debian
MAINTAINER Jos&eacute; Domingo Mu&ntilde;oz "josedom24@gmail.com"

RUN apt-get update &amp;&amp; apt-get install -y apache2 &amp;&amp; apt-get clean &amp;&amp; rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80
ADD ["index.html","/var/www/html/"]

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]</pre>
<p style="text-align: justify;">En este caso utilizamos la imagen base de debian, instalamos el servidor web apache2, para reducir el tama&ntilde;o, borramos la cach&eacute; de paquetes apt y la lista de paquetes descargada, creamos varias variables de entorno (en este ejemplo no se van a utilizar, pero se podr&iacute;an utilizar en cualquier fichero del contexto, por ejemplo para configurar el servidor web), exponemos el puerto http TCP/80, copiamos el fichero index.html al <em>DocumentRoot </em>y finalmente indicamos el comando que se va a ejecutar al crear el contenedor, y adem&aacute;s, al usar el comando ENTRYPOINT, no permitimos ejecutar ning&uacute;n otro comando durante la creaci&oacute;n.</p>
<p style="text-align: justify;">Vamos a generar la imagen:</p>
<pre>~/apache$ docker build -t josedom24/apache2:1.0 .
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM debian
&nbsp;---> 9a02f494bef8
Step 2 : MAINTAINER Jos&eacute; Domingo Mu&ntilde;oz "josedom24@gmail.com"
&nbsp;---> Running in 76f3f8fe0719
&nbsp;---> fda7bdbf761c
Removing intermediate container 76f3f8fe0719
Step 3 : RUN apt-get update &amp;&amp; apt-get install -y apache2 &amp;&amp; apt-get clean &amp;&amp; rm -rf /var/lib/apt/lists/*
&nbsp;---> Running in c50b14cc967d
Get:1 http://security.debian.org jessie/updates InRelease [63.1 kB]
Get:2 http://security.debian.org jessie/updates/main amd64 Packages [256 kB]
Ign http://httpredir.debian.org jessie InRelease
...
&nbsp;---> 0dedcfe17eb9
Removing intermediate container c50b14cc967d
Step 4 : ENV APACHE_RUN_USER www-data
&nbsp;---> Running in 85a85c09f96c
&nbsp;---> dac18d113b15
Removing intermediate container 85a85c09f96c
Step 5 : ENV APACHE_RUN_GROUP www-data
&nbsp;---> Running in 9e7511d92c74
&nbsp;---> 8f5824bdc71a
Removing intermediate container 9e7511d92c74
Step 6 : ENV APACHE_LOG_DIR /var/log/apache2
&nbsp;---> Running in 1b9173a822f8
&nbsp;---> 313e04f3a33a
Removing intermediate container 1b9173a822f8
Step 7 : EXPOSE 80
&nbsp;---> Running in 001ce73f08a6
&nbsp;---> 76f798e8d481
Removing intermediate container 001ce73f08a6
Step 8 : ADD index.html /var/www/html
&nbsp;---> 5ce11ae0b1e6
Removing intermediate container c8f418d3a0f6
Step 9 : ENTRYPOINT /usr/sbin/apache2ctl -D FOREGROUND
&nbsp;---> Running in 4ba6954632a5
&nbsp;---> 9109b0f27a08
Removing intermediate container 4ba6954632a5
Successfully built 9109b0f27a08</pre>
<p style="text-align: justify;">Generamos la nueva imagen con el comando <em>docker build</em> con la opci&oacute;n <em>-t </em>indicamos el nombre de la nueva imagen (para indicar el nombre de la imagen es recomendable usar nuestro nombre de usuario en el registro <em>docker hub</em>, para posteriormente poder guardarlas en el registro), mandamos todos los ficheros del contexto (indicado con el punto). Podemos comprobar que tenemos generado la nueva imagen:</p>
<pre>$ docker images 
REPOSITORY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SIZE
josedom24/apache2&nbsp;&nbsp; 1.0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9109b0f27a08&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4 minutes ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 183.7 MB
debian&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; latest&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9a02f494bef8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 125.1 MB
ubuntu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14.04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3876b81b5a81&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3 weeks ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 187.9 MB</pre>
<p>A continuaci&oacute;n podemos crear un nuevo contenedor a partir de la nueva imagen:</p>
<pre>$ docker run -p 80:80 --name servidor_web josedom24/apache2:1.0</pre>
<p>Comprobamos que el contenedor est&aacute; creado:</p>
<pre>$ docker ps
CONTAINER ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; COMMAND&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STATUS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PORTS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NAMES
67013f91ba65&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; josedom24/apache&nbsp;&nbsp;&nbsp; "/usr/sbin/apache2ctl"&nbsp;&nbsp; 4 minutes ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Up 4 minutes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.0.0.0:80->80/tcp&nbsp;&nbsp; servidor_web</pre>
<p>Y podemos acceder al servidor docker, para ver la p&aacute;gina web:<br />
<a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile1.png" rel="attachment wp-att-1647"><img class="aligncenter size-full wp-image-1647" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile1.png" alt="dockerfile1" width="862" height="126" /></a><br />
<!--more--></p>
<h2>Creaci&oacute;n una imagen con el servidor de base de datos mysql</h2>
<p>En esta ocasi&oacute;n vamos a tener un contexto, un directorio con los siguientes ficheros:</p>
<pre>~/mysql$ ls
Dockerfile&nbsp; my.cnf&nbsp; script.sh</pre>
<p>El fichero de configuraci&oacute;n de mysql, <em>my.cnf</em>:</p>
<pre>[mysqld]
bind-address=0.0.0.0
console=1
general_log=1
general_log_file=/dev/stdout
log_error=/dev/stderr</pre>
<p>Un script bash, que va a ser el que se va a ejecutar por defecto cunado se crea un contenedor, <em>script.sh</em>:</p>
.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
&nbsp;&nbsp;&nbsp; fi
fi

/usr/sbin/mysqld --bootstrap --verbose=0 < $tfile
rm -f $tfile

exec /usr/sbin/mysqld</pre>
<p style="text-align: justify;">Podemos ver que hace uso de varias variables de entorno:</p>
<pre>MYSQL_ROOT_PASSWORD
MYSQL_DATABASE
MYSQL_USER
MYSQL_PASSWORD</pre>
<p style="text-align: justify;">Que nos permiten especificar la contrase&ntilde;a del root, el nombre de una base de datos a crear, el nombre y contrase&ntilde;a de un nuevo usuario a crear.&nbsp; Estas variables de entorno se pueden indicar en el fichero <em>Dockerfile</em>, o con el par&aacute;metro <code>--env</code> en el comando <em>docker run</em>.</p>
<p style="text-align: justify;">El fichero <em>Dockerfile</em> tendr&aacute; el siguiente contenido:</p>
<pre>FROM ubuntu:14.04 
MAINTAINER Jos&eacute; Domingo Mu&ntilde;oz "josedom24@gmail.com"

RUN apt-get update &amp;&amp; apt-get -y upgrade
RUN apt-get install -y mysql-server

ADD my.cnf /etc/mysql/conf.d/my.cnf 
ADD script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

EXPOSE 3306

CMD ["/usr/local/bin/script.sh"]</pre>
<p style="text-align: justify;">Como vemos se instala mysql, se copia el fichero de configuraci&oacute;n y el script en bash que es el comando que se va a ejecutar por defecto al crear los contenedores. Generamos la imagen:</p>
<pre>~/mysql$ docker build -t josedom24/mysql:1.0 .</pre>
<p style="text-align: justify;">Y creamos un contenedor indicando la contrase&ntilde;a del root:</p>
<pre>$ docker run -d -p 3306:3306 --env MYSQL_ROOT_PASSWORD=asdasd --name servidor_mysql jose/mysql:1.0</pre>
<pre>$ docker ps
CONTAINER ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; COMMAND&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STATUS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PORTS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NAMES
8635e1392523&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; josedom24/mysq&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "/usr/local/bin/scrip"&nbsp;&nbsp; 3 seconds ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Up 3 seconds&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.0.0.0:3306->3306/tcp&nbsp;&nbsp; servidor_mysql</pre>
<p>Y accedemos al servidor mysql, utilizando la ip del servidor docker:</p>
<pre>mysql -u root -p -h 192.168.0.100</pre>
<p>Este ejemplo se basa en la imagen mysql que podemos encontrar en docker hub: <a href="https://hub.docker.com/r/mysql/mysql-server/">https://hub.docker.com/r/mysql/mysql-server/</a></p>
<h2>Creaci&oacute;n una imagen con con php a partir de nuestra imagen con apache2</h2>
<p style="text-align: justify;">En este &uacute;ltimo ejemplo, vamos a crear una imagen con php5 a parir de nuestra imagen con apache: <em>josedom24/apache2:1.0, </em>para ello en el directorio php creamos un fichero <em>index.php:</em></p>
<pre>~/php$ echo "<?php echo phpinfo();?>">index.php</pre>
<p>Y el fichero <em>Dockerfile</em>, con el siguiente contenido:</p>
<pre>FROM josedom24/apache2:1.0
MAINTAINER Jos&eacute; Domingo Mu&ntilde;oz "josedom24@gmail.com"

RUN apt-get update &amp;&amp; apt-get install -y php5 &amp;&amp; apt-get clean &amp;&amp; rm -rf /var/lib/apt/lists/*

EXPOSE 80
ADD ["index.php","/var/www/html/"]

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]</pre>
<p>Generamos la nueva imagen:</p>
<pre>~/php$ docker build -y josedom24/php5:1.0 .</pre>
<p>Creamos un nuevo contenedor, y realizamos la prueba de funcionamiento:</p>
<pre>$ docker run -d -p 8080:80 --name servidor_php josedom24/php5:1.0</pre>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile2.png" rel="attachment wp-att-1650"><img class="aligncenter size-full wp-image-1650" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile2.png" alt="dockerfile2" width="992" height="309" /></a></p>
<h2>Conclusiones</h2>
<p style="text-align: justify;">En esta entrada hemos visto una introducci&oacute;n a la creaci&oacute;n de im&aacute;genes docker utilizando ficheros <em>Dockerfile</em>. Para avanzar m&aacute;s sobre la utilizaci&oacute;n de este mecanismo de creaci&oacute;n de im&aacute;genes os sugiero que estudi&eacute;is los ficheros <em>Dockerfile</em> y los repositorios que podemos encontrar en el registro Docker Hub:</p>
<p style="text-align: justify;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile3.png" rel="attachment wp-att-1652"><img class="aligncenter size-large wp-image-1652" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile3-1024x474.png" alt="dockerfile3" width="770" height="356" /></a>En la siguiente entrada vamos a hacer una introducci&oacute;n al uso del registro docker hub, para guardar nuestras im&aacute;genes y poderlas desplegar en nuestro entorno de producci&oacute;n.</p>
