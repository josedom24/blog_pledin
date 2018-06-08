---
layout: post
status: publish
published: true
title: Instalaci&oacute;n de drupal en heroku
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1388
wordpress_url: http://www.josedomingo.org/pledin/?p=1388
date: '2015-11-30 21:33:48 +0000'
date_gmt: '2015-11-30 20:33:48 +0000'
categories:
- General
tags:
- php
- CMS
- Cloud Computing
- PaaS
- Heroku
- drupal
comments: []
---
<p style="text-align: center;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/11/intro.png"><img class="aligncenter size-full wp-image-1389" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/11/intro.png" alt="intro" width="789" height="231" /></a></p>
<p style="text-align: justify;"><a href="https://www.heroku.com/">Heroku</a> es una aplicaci&oacute;n que nos ofrece un servicio de Cloud Computing <a href="https://en.wikipedia.org/wiki/Platform_as_a_service">PaaS</a> (Plataforma como servicio). Como leemos en la <a href="https://es.wikipedia.org/wiki/Heroku">Wikipedia</a> es propiedad de <a href="http://www.salesforce.com">Salesforce.com</a> y es una de las primeras plataformas de computaci&oacute;n en la nube, que fue desarrollada desde junio de 2007, con el objetivo de soportar solamente el lenguaje de programaci&oacute;n Ruby, pero posteriormente se ha extendido el soporte a Java, Node.js, Scala, Clojure y Python y PHP.</p>
<h3 id="caractersticas-de-heroku" style="text-align: justify;">Caracter&iacute;sticas de heroku</h3>
<p style="text-align: justify;">La funcionalidad ofrecida por heroku esta disponible con el uso de <em><strong>dynos</strong></em>, que son una adaptaci&oacute;n de los contenedores Linux y nos ofrecen la capacidad de computo dentro de la plataforma.</p>
<p style="text-align: justify;">Cada dyno ejecuta distintos procesos, por ejemplo ejecuta los servidores web y los servidores de bases de datos, o cualquier otro proceso que le indiquemos en un fichero <a href="https://devcenter.heroku.com/articles/deploying-php#the-procfile"><em>Procfile</em></a>. Las caracter&iacute;sticas principales de los dynos son:</p>
<ul>
<li style="text-align: justify;"><strong>Escabilidad</strong>: Si, por ejemplo, tenemos muchas peticiones a nuestra aplicaci&oacute;n podemos hacer un escalado horizontal, es decir, podemos crear m&aacute;s dynos que respondan las peticiones. La carga de peticiones se balancear&aacute; entre los dynos existentes. Adem&aacute;s podemos hacer una escalabilidad vertical, en este caso lo que hacemos es cambiar las caracter&iacute;sticas hardware de nuestro dyno, por ejemplo aumentar la cantidad de RAM. Las caracter&iacute;sticas de escabilidad no est&aacute;n activadas en el plan gratuito de heroku. Adem&aacute;s la escabilidad no es autom&aacute;tica, hay que realizarla manualmente.</li>
<li style="text-align: justify;"><strong>Redundancia</strong>: En el momento en que podemos tener varios dynos detr&aacute;s de una balanceado de carga, nuestra aplicaci&oacute;n es redundante. Es decir, si alg&uacute;n dyno tiene un problema, los dem&aacute;s responder&iacute;an las peticiones.</li>
<li style="text-align: justify;"><strong>Aislamiento y seguridad</strong>: Cada uno de los dynos est&aacute; aislado de los dem&aacute;s. Esto nos ofrece seguridad frente a la ejecuci&oacute;n de procesos en otros dynos, adem&aacute;s tambi&eacute;n nos ofrece protecci&oacute;n para que ning&uacute;n dyno consuma todos los recursos de la m&aacute;quina.</li>
<li style="text-align: justify;"><strong>Sistema de archivo ef&iacute;mero</strong>: Cada dyno posee un sistema de archivo cuya principal caracter&iacute;stica es que es ef&iacute;mero. Es decir los datos de nuestra aplicaci&oacute;n (por ejemplo ficheros subidos) no son accesibles desde otros dynos, y si reiniciamos el dyno estos datos se pierden. Es muy recomendable tener los datos de la aplicaci&oacute;n en un sistema externo, por ejemplo un almac&eacute;n de objetos, como Amanzon S3 o OpenStack Swift.</li>
<li style="text-align: justify;"><strong>Direccionamiento IP</strong>: Cuando tenemos varios dynos, cada uno de ellos puede estar ejecut&aacute;ndose en m&aacute;quinas diferentes. El acceso a nuestra aplicaci&oacute;n siempre se hace desde un balanceador de carga (<a href="https://devcenter.heroku.com/articles/http-routing">routers</a>). Esto significa que los dynos no tienen una ip est&aacute;tica, y el acceso a ellos siempre se hace a la direcci&oacute;n IP que tiene el balanceador. Cuando se reinicia un dyno se puede ejecutar en otra m&aacute;quina, y por lo tanto puede cambiar de direcci&oacute;n IP.</li>
<li style="text-align: justify;"><strong>Interfaces de red</strong>: Cada dyno tiene una interfaz de red con un direccionamiento privado /30, en el rango 172.16.0.0/12. Por lo tanto cada dyno est&aacute; conecta a una red independiente que no comparte con ning&uacute;n otro dyno. Para acceder a &eacute;l, como hemos indicado anteriormente, habr&aacute; que hacerlo a trav&eacute;s de la ip p&uacute;blica que tiene asignada el balanceador de carga.</li>
</ul>
<p><!--more--></p>
<h3 id="despliegue-de-una-aplicacin-web-en-heroku" style="text-align: justify;">Despliegue de la aplicaci&oacute;n web drupal en Heroku</h3>
<p style="text-align: justify;">En este ejemplo vamos a utilizar la capa gratuita que nos ofrece Heroku, que tiene las siguientes caracter&iacute;sticas:</p>
<ul style="text-align: justify;">
<li>Podemos crear un dyno, que puede ejecutar un m&aacute;ximo de dos tipos de procesos. Para m&aacute;s informaci&oacute;n sobre la ejecuci&oacute;n de los procesos ver: <a href="https://devcenter.heroku.com/articles/process-model">https://devcenter.heroku.com/articles/process-model</a>.</li>
<li>Nuestro dyno utiliza 512 Mb de RAM</li>
<li>Tras 30 minutos de inactividad el dyno se para (sleep), adem&aacute;s debe estar parado 6 horas cada 24 horas.</li>
<li>Podemos utilizar una base de datos postgreSQL con no m&aacute;s de 10.000 registros</li>
<li>Para m&aacute;s informaci&oacute;n de los planes ofrecido por heroku puedes visitar: <a href="https://www.heroku.com/pricing#dynos-table-modal">https://www.heroku.com/pricing#dynos-table-modal</a></li>
</ul>
<p style="text-align: justify;">Para ampliar la funcionalidad de nuestra aplicaci&oacute;n podemos a&ntilde;adir a nuestro dyno distintos <a href="https://elements.heroku.com/addons">add-ons</a>. Algunos lo podemos usar de forma gratuita y otros son de pago. El add-ons de mysql (ClearDB mysql) no lo podemos usar en el plan gratuito, por lo que vamos a usar una base de datos postgreSQL.</p>
<p style="text-align: justify;">Siguiendo las<a href="https://www.drupal.org/documentation/install"> instrucciones de instalaci&oacute;n</a> de la p&aacute;gina oficial hemos instalado la &uacute;ltima versi&oacute;n del CMS drupal en un servidor local, hemos utilizado como base de datos un servidor postgreSQL (<strong>Recordatorio:</strong> es necesario instalar el paquete <em>php5-pgsql</em> que es la libreria PHP de postgreSQL). Como hemos indicado anteriormente heroku nos ofrece una infraestructura para desplegar nuestra aplicaci&oacute;n web cuyo sistema de archivo es ef&iacute;mero, por lo tanto no podemos realizar la instalaci&oacute;n de las aplicaciones web directamente en heroku, ya que cada vez que reiniciemos nuestro dyno perderemos los ficheros creados, por ejemplo el fichero de configuraci&oacute;n. Vamos a hacer una migraci&oacute;n desde el entorno de pruebas (servidor local) a nuestro entorno de producci&oacute;n (dyno de herku).</p>
<h4 style="text-align: justify;">Instalaci&oacute;n de Heroku CLI</h4>
<p style="text-align: justify;">Como podemos ver en esta <a href="https://toolbelt.heroku.com/">p&aacute;gina</a>, tenemos que ejecutar un script bash que nos bajamos con la siguiente instrucci&oacute;n y que realizar&aacute; la instalci&oacute;n de los paquetes necesarios y la configuraci&oacute;n inicial.</p>
<pre>wget -O- <a href="https://toolbelt.heroku.com/install-ubuntu.sh">https://toolbelt.heroku.com/install-ubuntu.sh</a> | sh</pre>
<p style="text-align: justify;">Ahora tenemos que iniciar sesi&oacute;n en heroku, utilizando el correo electr&oacute;nico y la contrase&ntilde;a que hemos indicado durante el registro de la cuenta. La primera vez que ejecutamos la siguiente instrucci&oacute;n, se termina de configurar el cliente heroku:</p>
<pre># heroku login
heroku-cli: Installing Toolbelt v4... done.
For more information on Toolbelt v4: https://github.com/heroku/heroku-cli
heroku-cli: Adding dependencies... done
heroku-cli: Installing core plugins... done
Enter your Heroku credentials.
Email: tucorreo@electronico.com
Password (typing will be hidden):</pre>
<p style="text-align: justify;">Para ver la versi&oacute;n del cliente que estamos utilizando, adem&aacute;s salen los plugins instalados:</p>
<pre># heroku version
heroku-toolbelt/3.42.22 (x86_64-linux-gnu) ruby/2.1.5
heroku-cli/4.27.6-e59743f (amd64-linux) go1.5.1</pre>
<p style="text-align: justify;">Para pedir informaci&oacute;n de las funciones disponibles podemos pedir la ayuda:</p>
<pre># heroku help</pre>
<h4>Subir nuestra clave p&uacute;lica para acceder a nuestro dyno</h4>
<p>Sguiendo la <a href="https://devcenter.heroku.com/articles/keys">documentaci&oacute;n oficial</a>, es necesario subir una clave p&uacute;blica para permitr el acceso por SSH a nuestro dyno:</p>
<pre><span class="function"># heroku keys:add
</span><span class="string">Found existing public key: ~/.ssh/id_rsa.pub
</span><span class="string">Uploading SSH public key /Users/adam/.ssh/id_rsa.pub... done</span></pre>
<h4 style="text-align: justify;">Creaci&oacute;n de nuestra primera aplicaci&oacute;n</h4>
<p style="text-align: justify;">Para crear nuestra primera aplicaci&oacute;n (dyno) ejecutamos la siguiente instrucci&oacute;n:</p>
<pre># heroku apps:create pledinjd
Creating pledinjd... done, stack is cedar-14
https://pledinjd.herokuapp.com/ | https://git.heroku.com/pledinjd.git</pre>
<p style="text-align: justify;">Se ha creado un nuevo dyno con un repositorio git, que a continuaci&oacute;n vamos a clonar. Adem&aacute;s se ha generado un FQHN que nos permite acceder a nuestra aplicaci&oacute;n:</p>
<p style="text-align: justify;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/11/drupal1.png"><img class="size-full wp-image-1398 alignnone" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/11/drupal1.png" alt="drupal1" width="577" height="250" /></a></p>
<p style="text-align: justify;">A continuaci&oacute;n vamos a clonar el repositorio y vamos a desplegar un fichero index.php de inicio:</p>
<pre># <strong>git clone https://git.heroku.com/pledinjd.git</strong>
Cloning into 'pledinjd'...
warning: You appear to have cloned an empty repository.
Checking connectivity... done.
# <strong>cd pledinjd/</strong>
pledinjd# <strong>echo "<h1>pledinjd funcionando</h1>">index.php</strong>
pledinjd# <strong>git add index.php</strong> 
pledinjd# <strong>git commit -m "El primer fichero"</strong>
pledinjd# <strong>git push origin master</strong>
Counting objects: 3, done.
Writing objects: 100% (3/3), 245 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
remote: Compressing source files... done.
remote: Building source:
remote: 
remote: -----> PHP app detected
remote: 
remote: ! WARNING: No 'composer.json' found.
remote: Using 'index.php' to declare PHP applications is considered legacy
remote: functionality and may lead to unexpected behavior.
remote: 
remote: -----> No runtime required in 'composer.json', defaulting to PHP 5.6.15.
remote: -----> Installing system packages...
remote: - PHP 5.6.15
remote: - Apache 2.4.16
remote: - Nginx 1.8.0
remote: -----> Installing PHP extensions...
remote: - zend-opcache (automatic; bundled)
remote: -----> Installing dependencies...
remote: Composer version 1.0.0-alpha11 2015-11-14 16:21:07
remote: -----> Preparing runtime environment...
remote: NOTICE: No Procfile, using 'web: vendor/bin/heroku-php-apache2'.
remote: -----> Discovering process types
remote: Procfile declares types -> web
remote: 
remote: -----> Compressing... done, 72.8MB
remote: -----> Launching... done, v3
remote: https://pledinjd.herokuapp.com/ deployed to Heroku
remote: 
remote: Verifying deploy... done.
To https://git.heroku.com/pledinjd.git
 * [new branch] master -> master</pre>
<p>Como se puede observar cuando se sube un nuevo fichero, se configura de forma adecuada el entorno de producci&oacute;n, reiniciando los servidores necesarios, y podemos acceder a nuestra nueva p&aacute;gina:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/11/drupal2.png"><img class="size-full wp-image-1400 alignnone" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/11/drupal2.png" alt="drupal2" width="452" height="138" /></a></p>
<h4>Migraci&oacute;n de la base de datos</h4>
<p>A continuaci&oacute;n, vamos a instalar un addons en nuestro proyecto que nos proporciona una base de datos postgreSQL:</p>
<pre># <strong>heroku addons:create heroku-postgresql</strong>
Creating postgresql-amorphous-6708... done, (free)
Adding postgresql-amorphous-6708 to pledinjd... done
Setting DATABASE_URL and restarting pledinjd... done, v4
Database has been created and is available
&nbsp;! This database is empty. If upgrading, you can transfer
&nbsp;! data from another database with pg:copy
Use `heroku addons:docs heroku-postgresql` to view documentation.</pre>
<p>Para ver informaci&oacute;n de los addons instalados:</p>
<pre># <strong>heroku addons</strong>
Add-on&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Plan&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Price
─────────────────────────────────────────────&nbsp; ─────────&nbsp; ─────
heroku-postgresql (postgresql-amorphous-6708)&nbsp; hobby-dev&nbsp; free 
&nbsp;└─ as DATABASE</pre>
<p>Y comprobamos que nuestra base de datos se identifica con el nombre DATABASE, y podemos pedir las credenciales para conectarnos a ella (nombre de la base de datos, usuario y contrase&ntilde;a y servidor de la base de datos) con el siguiente comando:</p>
<pre># <strong>heroku pg:credentials DATABASE</strong>
Connection info string:
&nbsp;&nbsp; "dbname=d3bo6f4g2gbilu host=ec2-54-83-202-218.compute-1.amazonaws.com port=5432 user=pwcbycuykpmhqb password=1dg2xwsRb6fcMRhHdtkfTlkahw sslmode=require"
Connection URL:
&nbsp;&nbsp;&nbsp; postgres://pwcbycuykpmhqb:1dg2xwsRb6fcMRhHdtkfTlkahw@ec2-54-83-202-218.compute-1.amazonaws.com:5432/d3bo6f4g2gbilu</pre>
<p>Nos queda hacer la migraci&oacute;n de la base de datos, para ello vamos a seguir las indicaciones de la <a href="https://devcenter.heroku.com/articles/heroku-postgres-import-export">documentaci&oacute;n oficial</a>, primero hacemos la copia de seguridad de la base de datos <em>drupal</em> en local y posteriormente la restauramos en heroku:</p>
<pre>pg_dump -Fc --no-acl --no-owner -h localhost -U jose drupal > drupal.dump</pre>
<p>Para restaurar la copia de seguridad es necesario que la copia que hemos realizado este accesible desde una URL (por ejemplo lo podemos subir a un almac&eacute;n de datos como Amazon S3), en este caso para agilizar el ejemplo lo he subido a nuestra aplicaci&oacute;n:</p>
<pre>pledinjd# git add drupal.dump 
pledinjd# git commit -m "Copia de seguridad BD"
pledinjd# git push

pledinjd# <strong>heroku pg:backups restore 'http://pledinjd.herokuapp.com/drupal.dump' DATABASE --confirm pledinjd</strong>
Use Ctrl-C at any time to stop monitoring progress; the backup
will continue restoring. Use heroku pg:backups to check progress.
Stop a running restore with heroku pg:backups cancel.

r001 ---restore---> DATABASE
Restore completed</pre>
<p>Y podemos ver las tablas creadas:</p>
<pre># <strong>heroku pg:psql DATABASE</strong>
---> Connecting to DATABASE_URL
psql (9.4.5)
conexi&oacute;n SSL (protocolo: TLSv1.2, cifrado: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compresi&oacute;n: desactivado)
Digite &laquo;help&raquo; para obtener ayuda.

pledinjd::DATABASE=> \dt</pre>
<h4>Despliegue de nuestra aplicaci&oacute;n</h4>
<p>Vamos a copiar los ficheros desde nuestro servidor local, y vamos a modificar el fichero de configuraci&oacute;n con las credenciales de la base de datos de heroku:</p>
<pre>pledinjd# cp -r /var/www/pledinjd/drupal .</pre>
<p style="text-align: justify;">Y el fichero de configuraci&oacute;n <em>sites/default/settings.php</em> hay que modificarlo para configurar los par&aacute;metros de acceso a la base de datos de nuestro proyecto:</p>
<pre>$databases['default']['default'] = array (
&nbsp; 'database' => 'd3bo6f4g2gbilu',
&nbsp; 'username' => 'pwcbycuykpmhqb',
&nbsp; 'password' => '1dg2xwsRb6fcMRhHdtkfTlkahw',
&nbsp; 'prefix' => '',
&nbsp; 'host' => 'ec2-54-83-202-218.compute-1.amazonaws.com',
&nbsp; 'port' => '5432',
&nbsp; 'namespace' => 'Drupal\Core\Database\Driver\pgsql',
&nbsp; 'driver' => 'pgsql',
);</pre>
<p>Y a continuaci&oacute;n hacemos el despliegue:</p>
<pre>pledinjd# git add drupal
pledinjd# git commit -m "Despliegue de drupal"
pledinjd# git push</pre>
<h4>Instalando librerias PHP necesarias</h4>
<p>Si accedemos a nuestra aplicaci&oacute;n nos daremos cuenta que no funciona, podemos ver los logs de error de la misma ejecutando la siguente instrucci&oacute;n:</p>
<pre>pledinjd# heroku logs</pre>
<p style="text-align: justify;">Necesitamos instalar en nuestro dyno las librer&iacute;as PHP, la librer&iacute;a gr&aacute;fica <a href="http://docs.php.net/manual/es/book.image.php">gd</a> y la <a href="http://docs.php.net/mbstring">mbstring</a>. Para definir las librer&iacute;as que se han de instalar en heroku, siguiendo la<a href="https://devcenter.heroku.com/articles/deploying-php#deploy-your-application-to-heroku"> documentaci&oacute;n oficial</a>, tenemos que crear en la ra&iacute;z de nuestro repositorio git, un fichero <em>composer.json </em>con el siguiente contenido:</p>
<pre>pledinjd# cat composer.json 
{
 "require": {
 "ext-gd": "*",
 "ext-mbstring": "*"
 }
}</pre>
<p style="text-align: justify;">A partir de este fichero hay que crear el fichero <em>composer.lock</em>, utilizando la utilidad <em><a href="https://getcomposer.org/doc/00-intro.md">composer</a>, </em>que nos permite gestionar las dependencias de las librerias. Vamos a intalar la utilidad y generar el fichero pack:</p>
<pre>pledinjd# php -r "readfile('https://getcomposer.org/installer');" | php
pledinjd# php composer.phar update
pldinjd# git add composer.lock 
pledinjd# git commit -m "Librer&iacute;as"
pledinjd# git push</pre>
<p style="text-align: justify;">Y ya podemos acceder a nuestra aplicaci&oacute;n:</p>
<p style="text-align: justify;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/11/drupal3.png"><img class="size-full wp-image-1406 alignnone" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/11/drupal3.png" alt="drupal3" width="991" height="420" /></a></p>
<h3 style="text-align: justify;">Accediendo al dyno</h3>
<p>Podemos acceder a nuestro dyno con la siguiente instrucci&oacute;n:</p>
<pre># heroku run bash
Running bash on pledinjd... up, run.4539
~ $</pre>
<p>Accedemos al repositorio git, aunque podemos acceder al directorio padre:</p>
<pre>~ $ ls
Procfile&nbsp; composer.json&nbsp; composer.lock&nbsp;&nbsp; &nbsp;drupal&nbsp;&nbsp; &nbsp;drupal.dump&nbsp; index.php&nbsp;&nbsp; &nbsp;vendor
~ $ cd ..
/ $ ls
app&nbsp; bin&nbsp; dev&nbsp; etc&nbsp; home&nbsp; lib&nbsp; lib64&nbsp; lost+found&nbsp; proc&nbsp;&nbsp; &nbsp;sbin&nbsp; sys&nbsp; tmp&nbsp;&nbsp; &nbsp;usr&nbsp; var</pre>
<p>Como vimos anteriormente el dyno tiene una direcci&oacute;n en un rango /30:</p>
<pre>$ ip addr show eth0
27054: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
&nbsp;&nbsp;&nbsp; link/ether 1e:da:76:65:02:a9 brd ff:ff:ff:ff:ff:ff
&nbsp;&nbsp;&nbsp; inet 172.18.174.218/30 brd 172.18.174.219 scope global eth0
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; valid_lft forever preferred_lft forever
&nbsp;&nbsp;&nbsp; inet6 fe80::1cda:76ff:fe65:2a9/64 scope link 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; valid_lft forever preferred_lft forever</pre>
<p>Y la puerta de enlace es la otra direci&oacute;n disponible en la red, que debe coincidir con la interfaz en el balanceador de carga/router:</p>
<pre>$ ip route
default via 172.18.174.217 dev eth0 
172.18.174.216/30 dev eth0 proto kernel scope link src 172.18.174.218</pre>
<p>Y para terminar podemos observar que el dyno esta corriendo en una m&aacute;quina con 60Gb de RAM:</p>
<pre>$ free -h
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; total&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; used&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; free&nbsp;&nbsp;&nbsp;&nbsp; shared&nbsp;&nbsp;&nbsp; buffers&nbsp;&nbsp;&nbsp;&nbsp; cached
Mem:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 60G&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 58G&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.0G&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 70M&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.3G&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6.1G</pre>
<h3 style="text-align: justify;">Conclusiones</h3>
<p style="text-align: justify;">Si queremos usar heroku para desplegar aplicaciones web tradicionales escritas en PHP, como drupal, tenemos que tener en cuenta varias cosas:</p>
<ul>
<li style="text-align: justify;">Tniendo en cuenta que el sistema de ficheros es ef&iacute;mero, tenemos que subir nuestros datos de la aplicaci&oacute;n web en un sistema exerno, por ejmplo en un almacen de objetos como Amazon S3, apra ello es muy recomendable utilizar un plugin de drupal de <a href="https://www.drupal.org/project/amazons3">Amazon S3</a>.</li>
<li style="text-align: justify;">Heroku no manda correos, por lo tanto necesitamos un servicio externo como <a href="https://www.mandrill.com/">Mandrill</a>, por lo tanto podemos usar el plugin de drupal de <a href="https://www.drupal.org/project/mandrill">Mandrill</a>.</li>
</ul>
<p style="text-align: justify;">El alguna futura entrada del blog se posr&iacute;a realizar un despleigue de alguna aplicgaci&oacute;n web utilizado Python o Ruby y estudiar las funcionalidades que nos ofrece Heroku.</p>
<p>&nbsp;</p>
