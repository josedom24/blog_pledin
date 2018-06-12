---
id: 1755
title: Gestionando el almacenamiento docker con Dockerfile
date: 2016-11-27T19:16:51+00:00


guid: http://www.josedomingo.org/pledin/?p=1755
permalink: /2016/11/gestionando-el-almacenamiento-docker-con-dockerfile/


tags:
  - docker
  - V¡
  - Virtualización
---
<p style="text-align: justify;">
  En entradas anteriores: <a href="http://www.josedomingo.org/pledin/2016/02/dockerfile-creacion-de-imagenes-docker/">Dockerfile: Creación de imágenes docker</a> y <a href="http://www.josedomingo.org/pledin/2016/02/ejemplos-de-ficheros-dockerfile-creando-imagenes-docker/">Ejemplos de ficheros Dockerfile, creando imágenes docker</a>, hemos estudiado la utilización de la herramiento <code>docker build</code> para construir imágenes docker a partir de fichero <em>Dockerfile</em>.
</p>

<p style="text-align: justify;">
  En esta entrada vamos a utilizar la instrucción <code>VOLUME</code>, para crear volúmenes de datos en los contenedores que creemos a partir de la imagen que vamos a crear.
</p>

<h2 style="text-align: justify;">
  Creación de una imagen con un servidor web
</h2>

<p style="text-align: justify;">
  Vamos a repetir el ejemplo que vimos en la entrada <a href="http://www.josedomingo.org/pledin/2016/02/ejemplos-de-ficheros-dockerfile-creando-imagenes-docker/">Ejemplos de ficheros Dockerfile, creando imágenes docker</a>, pero en este caso, al crear nuestro contenedor se van a crear dos volúmenes de datos: en uno se va a guardar el contenido de nuestro servidor (<em>/var/www</em>) y en otro se va a guardar los logs del servidor (<em>/var/log/apache2</em>). En este caso si tengo que eliminar el contenedor, puedo crear uno nuevo y la información del servidor no se perderá.
</p>

En este caso el fichero _Dockerfile_ quedaría:

<pre>FROM ubuntu:14.04
MAINTAINER José Domingo Muñoz "josedom24@gmail.com"

RUN apt-get update && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

<strong>VOLUME /var/www /var/log/apache2</strong>
EXPOSE 80
ADD ["index.html","/var/www/html/"]

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]</pre>

<p style="text-align: justify;">
  Además del fichero <em>Dockerfile</em>, tenemos el fichero index.html en nuestro contexto. con la siguiente instrucción construimos la nueva imagen:
</p>

<pre>~/apache$ docker build -t josedom24/apache2:1.0 .</pre>

Y podemos crear nuestro contenedor:

<pre>$ docker run -d -p 80:80 --name servidor_web josedom24/apache2:1.0
78033d752c8f163576e5ef1a7435613a16954f4c138cf62f4d47a635fc5eb374sss</pre>

<p style="text-align: justify;">
  Nuestro contenedor está ofreciendo la página web, pero la información del servidor está guardad de forma permanente en los volúmenes. Podemos comprobar que se han creado dos volúmenes:
</p>

<pre>$ docker volume ls
DRIVER              VOLUME NAME
local               8dc51c65f164b25854dac01257d3074de0a35bfd202d2d6b94de5c9e97884249
local               a611141be3434229ed22acab6a69fd591dc7ddd39c6321784c05100065ddb266</pre>

<p style="text-align: justify;">
  Y obteniendo información del contenedor, podemos obtener:
</p>

<pre>$ docker inspect servidor_web 
..."Mounts": [
    {
        "Name": "8dc51c65f164b25854dac01257d3074de0a35bfd202d2d6b94de5c9e97884249",
        "Source": "/mnt/sda1/var/lib/docker/volumes/8dc51c65f164b25854dac01257d3074de0a35bfd202d2d6b94de5c9e97884249/_data",
        "Destination": "/var/log/apache2",
        "Driver": "local",
        "Mode": "",
        "RW": true,
        "Propagation": ""
    },
    {
        "Name": "a611141be3434229ed22acab6a69fd591dc7ddd39c6321784c05100065ddb266",
        "Source": "/mnt/sda1/var/lib/docker/volumes/a611141be3434229ed22acab6a69fd591dc7ddd39c6321784c05100065ddb266/_data",
        "Destination": "/var/www",
        "Driver": "local",
        "Mode": "",
        "RW": true,
        "Propagation": ""
    }
],
...</pre>

<p style="text-align: justify;">
  Si accedemos al Docker Engine podemos comprobar los ficheros que hay en cada uno de los volúmenes:
</p>

<pre>$ docker-machine ssh nodo1
docker@nodo1:~$ sudo su
root@nodo1:/home/docker# cd /mnt/sda1/var/lib/docker/volumes/8dc51c65f164b25854dac01257d3074de0a35bfd202d2d6b94de5c9e97884249/_data
root@nodo1:/mnt/sda1/var/lib/docker/volumes/8dc51c65f164b25854dac01257d3074de0a35bfd202d2d6b94de5c9e97884249/_data# ls
access.log               error.log                other_vhosts_access.log</pre>

<p style="text-align: justify;">
  En el primer volumen vemos los ficheros correpondiente al log del servidor, y en el segundo tenemos los fichero del <em>document root</em>:
</p>

<pre>cd /mnt/sda1/var/lib/docker/volumes/a611141be3434229ed22acab6a69fd591dc7ddd39c6321784c05100065ddb266/_data
root@nodo1:/mnt/sda1/var/lib/docker/volumes/a611141be3434229ed22acab6a69fd591dc7ddd39c6321784c05100065ddb266/_data# ls
html</pre>

<p style="text-align: justify;">
  Finalmente indicar que si borramos el contenedor, y creamos uno nuevo desde la misma imagen la información del servidor (logs y <em>document root</em>) no se habrá eliminado y la tendremos a nuestra disposición en el nuevo contenedor.
</p>

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->