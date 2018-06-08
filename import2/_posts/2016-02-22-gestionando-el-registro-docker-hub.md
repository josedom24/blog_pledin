---
layout: post
status: publish
published: true
title: Gestionando el registro Docker Hub
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1663
wordpress_url: http://www.josedomingo.org/pledin/?p=1663
date: '2016-02-22 18:29:52 +0000'
date_gmt: '2016-02-22 17:29:52 +0000'
categories:
- General
tags:
- Virtualizaci&oacute;n
- docker
comments: []
---
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub.png" rel="attachment wp-att-1664"><img class="aligncenter size-full wp-image-1664" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub.png" alt="dockerhub" width="1022" height="467" /></a></p>
<p style="text-align: justify;">En art&iacute;culos anteriores hemos estudiado la <a href="http://www.josedomingo.org/pledin/2016/02/ejemplos-de-ficheros-dockerfile-creando-imagenes-docker/">generaci&oacute;n de im&aacute;genes docker utilizando ficheros <em>Dockerfile</em></a> y construyendo la nueva imagen con el comando <em>docker buid</em>. Las im&aacute;genes generadas por este m&eacute;todo se crean en nuestro servidor docker. si queremos desplegar la aplicaci&oacute;n o el servicio "dockerizado" desde nuestro entorno de prueba/desarrollo a nuestro entorno de producci&oacute;n, es necesario llevarnos la imagen de un entono a otro. Para transferir la imagen de un equipo a otro tenemos dos posibilidades:</p>
<ul>
<li style="text-align: justify;">Podr&iacute;amos guardar la imagen en un fichero tar, que podemos copiar al otro equipo para restaurarlo en &eacute;l.</li>
<li style="text-align: justify;">Podr&iacute;amos guardar la imagen en un registro docker. Podemos instalar un registro en nuestra infraestructura o utilizar docker hub, que es una aplicaci&oacute;n web que nos proporciona la posibilidad de guardar nuestras im&aacute;genes. Una vez que la imagen esta guardada en el registro podemos descargarla desde el entorno de producci&oacute;n.</li>
</ul>
<p style="text-align: justify;">Para ver las distintas opciones que tenemos a nuestra disposici&oacute;n vamos a partir de la siguiente imagen que hemos creado:</p>
<pre>docker images 
REPOSITORY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SIZE
josedom24/apache2&nbsp;&nbsp; latest&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 04800781aed6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 17 seconds ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 183.7 MB
</pre>
<p><!--more--></p>
<h2>Exportaci&oacute;n/importaci&oacute;n de im&aacute;genes</h2>
<p style="text-align: justify;">Como hemos indicado anteriormente una imagen la podemos guardar en un fichero tar para exportarla a otro equipo.</p>
<p style="text-align: justify;">Para exportar una imagen ejecutamos el siguiente comando:</p>
<pre>$ docker save -o apache2.tar josedom24/apache2</pre>
<p style="text-align: justify;">Y se genera un fichero tar, que podemos ver:</p>
<pre>$ ls -alh
-rw-r--r-- 1 usuario usuario 184M feb 17 21:02 apache2.tar</pre>
<p style="text-align: justify;">Este fichero lo podemos guardar en cualquier medio de almacenamiento, o enviarlo por internet a otro equipo, donde realizar&iacute;amos la importaci&oacute;n:</p>
<pre>$ docker load -i apache2.tar josedom24/apache2</pre>
<h2 style="text-align: justify;">Guardando nuestras im&aacute;genes en docker hub</h2>
<p style="text-align: justify;">Otra opci&oacute;n que tenemos es guardar nuestra imagen en el registro docker hub, de esta forma ser&iacute;a muy sencillo descargarlo en otro equipo. Es necesario tener una cuenta en docker hub, nosotros ya tenemos una cuenta con el usuario <em>josedom24</em>.</p>
<p style="text-align: justify;">Para poder subir una imagen a nuestra cuenta de docker hub es necesario autentificarnos, para ello:</p>
<pre>$ docker login
Username: josedom24
Password: 
Email: xxxxxxxx@gmail.com
WARNING: login credentials saved in /home/usuario/.docker/config.json
Login Succeeded</pre>
<p style="text-align: justify;">Y podemos subir nuestra imagen con el comando:</p>
<pre>$ docker push josedom24/apache2
The push refers to a repository [docker.io/josedom24/apache2]
3155f6b09710: Pushed 
67331ad8a75e: Pushed 
5f70bf18a086: Pushed 
78dbfa5b7cbc: Pushed
latest: digest: sha256:bfe4d16f3e8d7f31b5f1bc0e1d989cbe6d762d1f4770fedf435685e24ee7bf8c size: 644</pre>
<p style="text-align: justify;">Podemos comprobar que la imagen se ha subido a docker hub: <a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub2.png" rel="attachment wp-att-1669"><img class="aligncenter size-large wp-image-1669" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub2-1024x357.png" alt="dockerhub2" width="770" height="268" /></a></p>
<p style="text-align: justify;">Ya podemos buscar la nueva imagen que hemos subido y bajarla en otro servidor:</p>
<pre>$ docker search josedom24
NAME&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DESCRIPTION&nbsp;&nbsp; STARS&nbsp;&nbsp;&nbsp;&nbsp; OFFICIAL&nbsp;&nbsp; AUTOMATED
josedom24/apache2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0</pre>
<pre>$ docker pull josedom24/apache2</pre>
<h2>Generaci&oacute;n autom&aacute;tica de im&aacute;genes en docker hub</h2>
<p style="text-align: justify;">Tambi&eacute;n podemos generar una imagen directamente en docker hub. Esta soluci&oacute;n es mucho m&aacute;s c&oacute;moda, porque no es necesario generar la imagen en nuestro ordenador para posteriormente subirla al registro. Para realizar la generaci&oacute;n autom&aacute;tica vamos a guardar los ficheros de nuestro contexto (el fichero Dockerfile y los ficheros que vamos a guardar en la imagen) en un repositorio en GitHub. Para realizar este ejemplo vamos a utilizar el contexto que utilizamos en la <a href="http://www.josedomingo.org/pledin/2016/02/ejemplos-de-ficheros-dockerfile-creando-imagenes-docker/">entrada anterio</a>r para crear la imagen con mysql. Lo primero que vamos a hacer es crear un repositorio en github donde vamos a guardar los ficheros del contexto:</p>
<pre>$ git clone git@github.com:josedom24/docker_mysql.git
Cloning into 'docker_mysql'...
$ cd docker_mysql</pre>
<p style="text-align: justify;">Copiamos los ficheros del contexto en nuestro repositorio:</p>
<pre>docker_mysql$ ls
Dockerfile&nbsp; my.cnf&nbsp; script.sh</pre>
<p style="text-align: justify;">Y los subimos al repositorio github:</p>
<pre>docker_mysql$ git add *
docker_mysql$ git commit -m "Contexto docker mysql"
docker_mysql$ git push</pre>
<p style="text-align: justify;">A continuaci&oacute;n desde docker hub tenemos que crear un <strong>"Automated Build":</strong></p>
<p style="text-align: justify;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub3.png" rel="attachment wp-att-1670"><img class="aligncenter size-full wp-image-1670" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub3.png" alt="dockerhub3" width="352" height="222" /></a></p>
<p style="text-align: justify;">La primera vez que lo hacemos tenemos que conectar docker con github y permitir que docker hub pueda acceder a nuestro repositorio, elegimos que nos vamos a conectar a github y seleccionamos la primera opci&oacute;n (Public and Private) donde permitamos m&aacute;s opciones de trabajo, finalmente desde github autorizamos a la aplicaci&oacute;n docker hub. Para conseguir todo esto tenemos que seguir los siguiente pasos:</p>
<p style="text-align: justify;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub4.png" rel="attachment wp-att-1677"><img class="aligncenter size-large wp-image-1677" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub4-1024x283.png" alt="dockerhub4" width="770" height="213" /></a><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub5.png" rel="attachment wp-att-1676"><img class="aligncenter size-large wp-image-1676" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub5-1024x409.png" alt="dockerhub5" width="770" height="308" /></a><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub6.png" rel="attachment wp-att-1675"><img class="aligncenter size-large wp-image-1675" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub6-1024x508.png" alt="dockerhub6" width="770" height="382" /></a><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub7.png" rel="attachment wp-att-1674"><img class="aligncenter size-large wp-image-1674" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub7-1024x536.png" alt="dockerhub7" width="770" height="403" /></a>Una vez realizado esta configuraci&oacute;n, ya podemos crear un <strong>"Automated Build", </strong>elegimos un repositorio github:</p>
<p style="text-align: justify;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub8-1.png" rel="attachment wp-att-1682"><img class="aligncenter size-large wp-image-1682" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub8-1-1024x528.png" alt="dockerhub8" width="770" height="397" /></a></p>
<p style="text-align: justify;">A continuaci&oacute;n configuro la imagen que voy a crear, como se puede observar si tengo distintas ramas en el repositorio github, se podr&aacute;n crear distintas im&aacute;genes con tag distintos:</p>
<p style="text-align: justify;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub9.png" rel="attachment wp-att-1683"><img class="aligncenter size-full wp-image-1683" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub9.png" alt="dockerhub9" width="973" height="836" /></a></p>
<p style="text-align: justify;">Y finalmente, tenemos nuestro nuevo repositorio. Si esperamos un tiempo prudencial para permitir que se cree la imagen o hacemos un nuevo push en el repositorio github, podremos obtener la siguiente informaci&oacute;n:</p>
<p style="text-align: justify;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub10.png" rel="attachment wp-att-1684"><img class="aligncenter size-large wp-image-1684" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub10-1024x558.png" alt="dockerhub10" width="770" height="420" /></a></p>
<ul>
<li style="text-align: justify;">Build details: Detalles de la construcci&oacute;n de la nueva imagen, por cada modificaci&oacute;n que hagamos en el repositorio github (push) se crear&aacute; una nueva tarea de construcci&oacute;n de la imagen.</li>
</ul>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub12.png" rel="attachment wp-att-1687"><img class="aligncenter size-large wp-image-1687" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub12-1024x323.png" alt="dockerhub12" width="770" height="243" /></a></p>
<ul>
<li>Dockerfile: Obtenemos el contenido del fichero utilizado para construir la imagen.</li>
</ul>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub13.png" rel="attachment wp-att-1688"><img class="aligncenter size-large wp-image-1688" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerhub13-1024x494.png" alt="dockerhub13" width="770" height="371" /></a>Por &uacute;ltimo podemos comprobar que tenemos acceso a la nueva imagen y que podemos descargarla:</p>
<pre>$ docker search josedom24
NAME&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DESCRIPTION&nbsp;&nbsp;&nbsp; STARS&nbsp;&nbsp;&nbsp;&nbsp; OFFICIAL&nbsp;&nbsp; AUTOMATED
josedom24/docker_mysql&nbsp;&nbsp; Docker mysql&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [OK]
josedom24/apache2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
$ docker pull josedom24/docker_mysql</pre>
<p>&nbsp;</p>
