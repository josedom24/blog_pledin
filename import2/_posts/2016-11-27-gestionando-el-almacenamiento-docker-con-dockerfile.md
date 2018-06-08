---
layout: post
status: publish
published: true
title: Gestionando el almacenamiento docker con Dockerfile
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1755
wordpress_url: http://www.josedomingo.org/pledin/?p=1755
date: '2016-11-27 19:16:51 +0000'
date_gmt: '2016-11-27 18:16:51 +0000'
categories:
- General
tags:
- Virtualizaci&oacute;n
- docker
- V&iexcl;
comments: []
---
<p style="text-align: justify;">En entradas anteriores: <a href="http://www.josedomingo.org/pledin/2016/02/dockerfile-creacion-de-imagenes-docker/">Dockerfile: Creaci&oacute;n de im&aacute;genes docker</a> y <a href="http://www.josedomingo.org/pledin/2016/02/ejemplos-de-ficheros-dockerfile-creando-imagenes-docker/">Ejemplos de ficheros Dockerfile, creando im&aacute;genes docker</a>, hemos estudiado la utilizaci&oacute;n de la herramiento <code>docker build</code> para construir im&aacute;genes docker a partir de fichero <em>Dockerfile</em>.</p>
<p style="text-align: justify;">En esta entrada vamos a utilizar la instrucci&oacute;n <code>VOLUME</code>, para crear vol&uacute;menes de datos en los contenedores que creemos a partir de la imagen que vamos a crear.</p>
<h2 style="text-align: justify;">Creaci&oacute;n de una imagen con un servidor web</h2>
<p style="text-align: justify;">Vamos a repetir el ejemplo que vimos en la entrada <a href="http://www.josedomingo.org/pledin/2016/02/ejemplos-de-ficheros-dockerfile-creando-imagenes-docker/">Ejemplos de ficheros Dockerfile, creando im&aacute;genes docker</a>, pero en este caso, al crear nuestro contenedor se van a crear dos vol&uacute;menes de datos: en uno se va a guardar el contenido de nuestro servidor (<em>/var/www</em>) y en otro se va a guardar los logs del servidor (<em>/var/log/apache2</em>). En este caso si tengo que eliminar el contenedor, puedo crear uno nuevo y la informaci&oacute;n del servidor no se perder&aacute;.</p>
<p>En este caso el fichero <em>Dockerfile</em> quedar&iacute;a:</p>
<pre>FROM ubuntu:14.04
MAINTAINER Jos&eacute; Domingo Mu&ntilde;oz "josedom24@gmail.com"

RUN apt-get update &amp;&amp; apt-get install -y apache2 &amp;&amp; apt-get clean &amp;&amp; rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

<strong>VOLUME /var/www /var/log/apache2</strong>
EXPOSE 80
ADD ["index.html","/var/www/html/"]

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]</pre>
<p style="text-align: justify;">Adem&aacute;s del fichero <em>Dockerfile</em>, tenemos el fichero index.html en nuestro contexto. con la siguiente instrucci&oacute;n construimos la nueva imagen:</p>
<pre>~/apache$ docker build -t josedom24/apache2:1.0 .</pre>
<p>Y podemos crear nuestro contenedor:</p>
<pre>$ docker run -d -p 80:80 --name servidor_web josedom24/apache2:1.0
78033d752c8f163576e5ef1a7435613a16954f4c138cf62f4d47a635fc5eb374sss</pre>
<p style="text-align: justify;">Nuestro contenedor est&aacute; ofreciendo la p&aacute;gina web, pero la informaci&oacute;n del servidor est&aacute; guardad de forma permanente en los vol&uacute;menes. Podemos comprobar que se han creado dos vol&uacute;menes:</p>
<pre>$ docker volume ls
DRIVER&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; VOLUME NAME
local&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8dc51c65f164b25854dac01257d3074de0a35bfd202d2d6b94de5c9e97884249
local&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; a611141be3434229ed22acab6a69fd591dc7ddd39c6321784c05100065ddb266</pre>
<p style="text-align: justify;">Y obteniendo informaci&oacute;n del contenedor, podemos obtener:</p>
<pre>$ docker inspect servidor_web 
..."Mounts": [
&nbsp;&nbsp;&nbsp; {
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "Name": "8dc51c65f164b25854dac01257d3074de0a35bfd202d2d6b94de5c9e97884249",
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "Source": "/mnt/sda1/var/lib/docker/volumes/8dc51c65f164b25854dac01257d3074de0a35bfd202d2d6b94de5c9e97884249/_data",
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "Destination": "/var/log/apache2",
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "Driver": "local",
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "Mode": "",
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "RW": true,
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "Propagation": ""
&nbsp;&nbsp;&nbsp; },
&nbsp;&nbsp;&nbsp; {
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "Name": "a611141be3434229ed22acab6a69fd591dc7ddd39c6321784c05100065ddb266",
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "Source": "/mnt/sda1/var/lib/docker/volumes/a611141be3434229ed22acab6a69fd591dc7ddd39c6321784c05100065ddb266/_data",
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "Destination": "/var/www",
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "Driver": "local",
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "Mode": "",
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "RW": true,
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "Propagation": ""
&nbsp;&nbsp;&nbsp; }
],
...</pre>
<p style="text-align: justify;">Si accedemos al Docker Engine podemos comprobar los ficheros que hay en cada uno de los vol&uacute;menes:</p>
<pre>$ docker-machine ssh nodo1
docker@nodo1:~$ sudo su
root@nodo1:/home/docker# cd /mnt/sda1/var/lib/docker/volumes/8dc51c65f164b25854dac01257d3074de0a35bfd202d2d6b94de5c9e97884249/_data
root@nodo1:/mnt/sda1/var/lib/docker/volumes/8dc51c65f164b25854dac01257d3074de0a35bfd202d2d6b94de5c9e97884249/_data# ls
access.log&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; error.log&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; other_vhosts_access.log</pre>
<p style="text-align: justify;">En el primer volumen vemos los ficheros correpondiente al log del servidor, y en el segundo tenemos los fichero del <em>document root</em>:</p>
<pre>cd /mnt/sda1/var/lib/docker/volumes/a611141be3434229ed22acab6a69fd591dc7ddd39c6321784c05100065ddb266/_data
root@nodo1:/mnt/sda1/var/lib/docker/volumes/a611141be3434229ed22acab6a69fd591dc7ddd39c6321784c05100065ddb266/_data# ls
html</pre>
<p style="text-align: justify;">Finalmente indicar que si borramos el contenedor, y creamos uno nuevo desde la misma imagen la informaci&oacute;n del servidor (logs y <em>document root</em>) no se habr&aacute; eliminado y la tendremos a nuestra disposici&oacute;n en el nuevo contenedor.</p>
