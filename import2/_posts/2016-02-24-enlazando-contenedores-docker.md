---
layout: post
status: publish
published: true
title: Enlazando contenedores docker
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1686
wordpress_url: http://www.josedomingo.org/pledin/?p=1686
date: '2016-02-24 20:36:25 +0000'
date_gmt: '2016-02-24 19:36:25 +0000'
categories:
- General
tags:
- Virtualizaci&oacute;n
- docker
comments: []
---
<p style="text-align: justify;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/wordpress-mysql-db-merge-180x180.png" rel="attachment wp-att-1699"><img class="size-full wp-image-1699 aligncenter" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/wordpress-mysql-db-merge-180x180.png" alt="wordpress-mysql-db-merge-180x180" width="180" height="180" /></a></p>
<p style="text-align: justify;">En los art&iacute;culos anteriores hemos estudiado como trabajar con im&aacute;genes y contenedores docker. En todos los ejemplos que hemos mostrado, los contenedores han trabajado ofreciendo uno o varios servicios, pero no se han comunicado o enlazado con ning&uacute;n otro. En realidad ser&iacute;a muy deseable trabajar con el paradigma de "microservicio" donde cada contenedor ofrezca un servicio que funcione de forma aut&oacute;noma y aislada del resto, pero que tenga cierta relaci&oacute;n con otro contenedor (que ofrezca tambi&eacute;n un s&oacute;lo servicio) para que entre todos ofrezcan una infraestructura m&aacute;s o menos compleja. En esta entrada vamos a mostrar un ejemplo de como podemos aislar servicios en distintos contenedores y enlazarlos para que trabajen de forma conjunta.</p>
<h2 style="text-align: justify;">Instalaci&oacute;n de wordpress en docker</h2>
<p style="text-align: justify;">M&aacute;s concretamente vamos a crear un contenedor con un servidor web con wordpress instalado que lo vamos a enlazar con otro contenedor con un servidor de base de datos mysql. Para realizar el ejemplo vamos a utilizar las im&aacute;genes oficiales de wordpress y mysql que encontramos en docker hub.</p>
<pre>$ docker images
REPOSITORY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SIZE
wordpress&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; latest&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 55f2580b9cc9&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5 days ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 516.5 MB
mysql&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; latest&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; e13b20a4f248&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5 days ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 361.2 MB
debian&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; latest&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 256adf7015ca&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5 days ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 125.1 MB
ubuntu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14.04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14b59d36bae0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5 days ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 187.9 MB</pre>
<p style="text-align: justify;">Docker nos permite un mecanismo de enlace entre contenedores, posibilitando enviar informaci&oacute;n de forma segura entre ellos y pudiendo compartir informaci&oacute;n entre ellos, por ejemplo las variables de entorno. Para establecer la asociaci&oacute;n entre contenedores es necesario usar el nombre con el que creamos el contenedor, el nombre sirve como punto de referencia para enlazarlo con otros contenedores.</p>
<p style="text-align: justify;">Por lo tanto, lo primero que vamos a hacer es crear un contenedor desde la imagen mysql con el nombre <em>servidor_mysql</em>, siguiendo las instrucci&oacute;n del <a href="https://hub.docker.com/_/mysql/">repositorio</a> de docker hub:</p>
<pre>$ docker run --name servidor_mysql -e MYSQL_ROOT_PASSWORD=asdasd -d mysql</pre>
<p style="text-align: justify;">En este caso s&oacute;lo hemos indicado la variable de entrono <em>MYSQL_ROOT_PASSWORD</em>, que es obligatoria, indicando la contrase&ntilde;a del usuario root. Si seguimos las instrucciones del <a href="https://hub.docker.com/_/mysql/">repositorio</a> de docker hub podemos observar que podr&iacute;amos haber creado m&aacute;s variables, por ejemplo:&nbsp; <em>MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD</em>.</p>
<p>A continuaci&oacute;n vamos a crear un nuevo contenedor, con el nombre <em>servidor_wp</em>, con el servidor web a partir de la imagen wordpress, enlazado con el contenedor anterior.</p>
<pre>$ docker run --name servidor_wp -p 80:80 --link servidor_mysql:mysql -d wordpress</pre>
<p style="text-align: justify;">Para realizar la asociaci&oacute;n entre contenedores hemos utilizado el par&aacute;metro <code>--link</code>, donde se indica el nombre del contenedor enlazado y un alias por el que nos podemos referir a &eacute;l.<!--more--></p>
<p style="text-align: justify;">Podemos comprobar los contenedores con los que est&aacute; asociado un determinado contenedor con la siguiente instrucci&oacute;n:</p>
<pre>$ docker inspect -f "{{ .HostConfig.Links }}" servidor_wp
 [/servidor_mysql:/servidor_wp/mysql]</pre>
<p style="text-align: justify;">En esta situaci&oacute;n el contenedor <em>servidor_web</em> puede acceder a informaci&oacute;n del contenedor <em>servidor_mysql</em>, para hacer esto docker construye un t&uacute;nel seguro entre los contenedores y no es necesario exponer ning&uacute;n puerto entre ellos (cuando hemos creado el contenedor <em>servidor_mysql</em> no hemos utilizado el par&aacute;metro <em>-p</em>), por lo tanto al <em>servidor_mysql</em> no se expone al exterior. Para facilitar la comunicaci&oacute;n entre contenedores, docker utiliza las variables de entrono y modifica el fichero<em> /etc/hosts</em>.</p>
<h3 style="text-align: justify;">Variables de entorno en contenedores asociados</h3>
<p style="text-align: justify;">Por cada asociaci&oacute;n de contenedores, docker crea una serie de variables de entorno, en este caso, en el contenedor <em>servidor_wp</em>, se crear&aacute;n las siguientes variables, donde se utiliza el nombre del alias indicada en el par&aacute;metro <code>--link</code>:</p>
<ul style="text-align: justify;">
<li>MYSQL_NAME: Con el nombre del contenedor <em>servidor_mysql.</em></li>
<li>MYSQL_PORT_3306_TCP_ADDR: Por cada puerto que expone la imagen desde la que hemos creado el contenedor se crea una variable de entorno de este tipo. El contenido de esta variable es la direcci&oacute;n IP del contenedor.</li>
<li>MYSQL_PORT_3306_TCP_PORT: De la misma manera se crea una por cada puerto expuesto por la imagen, en este caso guardamos el puerto expuesto.</li>
<li>MYSQL_PORT_3306_TCP_PROTOCOL: Una vez m&aacute;s se crean tantas variables como puertos hayamos expuesto. En esta variable se guarda el protocolo del puerto.</li>
<li>MYSQL_PORT: En esta variable se guarda la url del contenedor, con la ip del mismo y el puerto m&aacute;s bajo expuesto. Por ejemplo <em>MYSQL_PORT=tcp://172.17.0.82:3306.</em></li>
<li>Finalmente por cada variable de entorno definido en el contenedor enlazado, en este caso <em>servidor_mysql</em>, se crea una en el contenedor principal, en este caso <em>servidor_web. </em>Si en el contenedor_mysql hay una variable MYSQL_ROOT_PASSWORD, en el servidor web se crear&aacute; la variable MYSQL_ENV_MYSQL_ROOT_PASSWORD</li>
</ul>
<p style="text-align: justify;">Podemos comprobar esto creando un contenedor (que vamos a borrar inmediatamente, opciones <em>-rm</em>) donde vemos las variables de entorno.</p>
<pre>$ docker run --rm --name web2 --link servidor_mysql:mysql wordpress env
HOSTNAME=728f7e897f07
MYSQL_ENV_MYSQL_ROOT_PASSWORD=asdasd
MYSQL_PORT_3306_TCP_PORT=3306
MYSQL_PORT_3306_TCP=tcp://172.17.0.2:3306
MYSQL_ENV_MYSQL_VERSION=5.7.11-1debian8
MYSQL_NAME=/web2/mysql
MYSQL_PORT_3306_TCP_PROTO=tcp
MYSQL_PORT_3306_TCP_ADDR=172.17.0.2
MYSQL_PORT=tcp://172.17.0.2:3306
...</pre>
<p style="text-align: justify;">Por tanto llegamos a la conclusi&oacute;n que toda la informaci&oacute;n que necesitamos para instalar wordpress (direcci&oacute;n y puerto del servidor de base de datos, contrase&ntilde;a del usuario de la base de datos,...) lo tenemos a nuestra disposici&oacute;n en variables de entorno. El script bash que ejecutamos por defecto al crear el contenedor desde la imagen wordpress utilizar&aacute; toda esta informaci&oacute;n, que tiene en variables de entorno, para crear el fichero de configuraci&oacute;n de wordpress: <em>wp-config.php</em>. Adem&aacute;s podremos crear nuevas variables a la hora de crear el contenedor como nos informa en la documentaci&oacute;n del <a href="https://hub.docker.com/_/wordpress/">repositorio</a> de docker hub:</p>
<ul>
<li><code>-e WORDPRESS_DB_HOST=...</code> (defaults to the IP and port of the linked <code>mysql</code> container)</li>
<li><code>-e WORDPRESS_DB_USER=...</code> (defaults to "root")</li>
<li><code>-e WORDPRESS_DB_PASSWORD=...</code> (defaults to the value of the <code>MYSQL_ROOT_PASSWORD</code> environment variable from the linked <code>mysql</code> container)</li>
<li><code>-e WORDPRESS_DB_NAME=...</code> (defaults to "wordpress")</li>
<li><code>-e WORDPRESS_TABLE_PREFIX=...</code> (defaults to "", only set this when you need to override the default table prefix in wp-config.php)</li>
<li><code>-e WORDPRESS_AUTH_KEY=...</code>, <code>-e WORDPRESS_SECURE_AUTH_KEY=...</code>, <code>-e WORDPRESS_LOGGED_IN_KEY=...</code>, <code>-e WORDPRESS_NONCE_KEY=...</code>, <code>-e WORDPRESS_AUTH_SALT=...</code>, <code>-e WORDPRESS_SECURE_AUTH_SALT=...</code>, <code>-e WORDPRESS_LOGGED_IN_SALT=...</code>, <code>-e WORDPRESS_NONCE_SALT=...</code> (default to unique random SHA1s)</li>
</ul>
<h3 style="text-align: justify;">Actualizando el fichero /etc/hosts</h3>
<p style="text-align: justify;">Otro mecanismo que se realiza para permitir la comunicaci&oacute;n entre contenedores asociados es modificar el fichero <em>/etc/hosts</em> para que tengamos resoluci&oacute;n est&aacute;tica entre ellos. Si volvemos a crear un contenedor interactivo que conectemos al contenedor <em>servidor_mysql</em>, podemos comprobarlo:</p>
<pre>$ docker run --rm -i -t --name web3 --link servidor_mysql:mysql wordpress /bin/bash
root@ccc58b7ab132:/var/www/html# cat /etc/hosts
127.0.0.1 localhost
::1 localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.17.0.2 mysql 11615eb26fc9 servidor_mysql
172.17.0.4 ccc58b7ab132

root@ccc58b7ab132:/var/www/html# ping servidor_mysql
PING mysql (172.17.0.2): 56 data bytes
64 bytes from 172.17.0.2: icmp_seq=0 ttl=64 time=0.106 ms
64 bytes from 172.17.0.2: icmp_seq=1 ttl=64 time=0.067 ms</pre>
<h2>Comprobaci&oacute;n de la instalaci&oacute;n de wordpress</h2>
<p style="text-align: justify;">Como hemos visto anteriormente, al crear el contenedor <em>servidor_wp </em>asociado al contenedor <em>servidor_mysql, </em>el script bash que se est&aacute; ejecutando en la creaci&oacute;n es capaz de configurar la conexi&oacute;n a la base de datos con los datos de las variables de entorno que se han creado, adem&aacute;s, al modificar su fichero <em>/etc/hosts</em>, es capaz de conectar al contenedor utilizando el nombre del mismo. Al exponer el puerto 80 podemos acceder con un navegador web y comprobar que el wordpress est&aacute; instalado, solo es necesario la configuraci&oacute;n del mismo, aunque no ser&aacute; necesario realizar la configuraci&oacute;n de la conexi&oacute;n a la base de datos:</p>
<p style="text-align: justify;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/link1.png" rel="attachment wp-att-1696"><img class="aligncenter size-full wp-image-1696" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/link1.png" alt="link1" width="696" height="636" /></a></p>
<p style="text-align: justify;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/ink2.png" rel="attachment wp-att-1697"><img class="aligncenter size-full wp-image-1697" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/ink2.png" alt="ink2" width="986" height="718" /></a></p>
<p style="text-align: justify;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/link3.png" rel="attachment wp-att-1698"><img class="aligncenter size-full wp-image-1698" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/link3.png" alt="link3" width="997" height="540" /></a></p>
<h2 style="text-align: justify;">Conclusiones</h2>
<p style="text-align: justify;">He escrito varios art&iacute;culos sobre docker, donde he intentado hacer una introducci&oacute;n y ofrecer una visi&oacute;n general de lo que nos puede ofrecer el trabajo con contenedores docker. Como dec&iacute;a en el <a href="http://www.josedomingo.org/pledin/2015/12/introduccion-a-docker/">primer art&iacute;culo</a>, el objetivo de estas entradas ha sido, desde el primer momento, obligarme a tener la experiencia de conocer los distintos conceptos referidos a docker sobre todo centrado en mostrarles a mis alumnos del m&oacute;dulo de "Implantaci&oacute;n de aplicaciones web" del Ciclo Formativo de Grado Superior <strong>"Administraci&oacute;n de Sistemas Inform&aacute;ticos y Redes"</strong> las grandes posibilidades que nos ofrece esta herramienta para la implantaci&oacute;n de aplicaciones web. Podr&iacute;a seguir escribiendo m&aacute;s entradas sobre docker, me queda por introducir, las redes, los vol&uacute;menes, herramientas especificas como<em> docker machine, docker compose, docker swarm</em>, y seguro que me dejo atr&aacute;s muchas m&aacute;s cosas, pero me voy a tomar un descanso, y m&aacute;s adelante ver&eacute; la posibilidad de seguir escribiendo. Tambi&eacute;n tendr&iacute;a que estudiar las posibilidades de orquestaci&oacute;n de contenedores, que como nos ofrece docker swarm tambi&eacute;n nos ofrece <em>Kubernetes</em> de google.</p>
