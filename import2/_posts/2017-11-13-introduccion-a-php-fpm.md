---
layout: post
status: publish
published: true
title: Introducci&oacute;n a PHP-FPM
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1875
wordpress_url: https://www.josedomingo.org/pledin/?p=1875
date: '2017-11-13 21:19:49 +0000'
date_gmt: '2017-11-13 20:19:49 +0000'
categories:
- General
tags:
- Web
- php
comments: []
---
<p>FPM (FastCGI Process Manager) es una implementaci&oacute;n alternativa al PHP FastCGI. FPM se encarga de interpretar c&oacute;digo PHP. Aunque normalmente se utiliza junto a un servidor web (Apache2 o ngnix), en este art&iacute;culo vamos a hacer una introducci&oacute;n a PHP-FPM de manera aislada, vamos a estudiar algunos par&aacute;metros de configuraci&oacute;n y estudiar su funcionamiento.</p>
<p>Para instalarlo en Debian 9:</p>
<pre><code>apt install php7.0-fpm php7.0
</code></pre>
<h2>Configuraci&oacute;n de php-fpm</h2>
<p>Con esto hemos instalado php 7.0 y php-fpm. Veamos primeros algunos ficheros de configuraci&oacute;n de php:</p>
<p>La configuraci&oacute;n de php est&aacute; dividida seg&uacute;n desde se use:</p>
<ul>
<li><code>/etc/php/7.0/cli</code>: Configuraci&oacute;n de php para <code>php7.0-cli</code>, cuando se utiliza php desde la l&iacute;nea de comandos.</li>
<li><code>/etc/php/7.0/fpm</code>: Configuraci&oacute;n de php para php-fpm</li>
<li><code>/etc/php/7.0/mods-available</code>: M&oacute;dulos disponibles de php que puedes estar configurados en cualquiera de los escenarios anteriores.</li>
</ul>
<p><!--more--></p>
<p>Si nos fijamos en la configuraci&oacute;n de php para php-fpm:</p>
<ul>
<li><code>/etc/php/7.0/fpm/conf.d</code>: M&oacute;dulos instalados en esta configuraci&oacute;n de php (enlaces simb&oacute;licos a <code>/etc/php/7.0/mods-available</code>).</li>
<li><code>/etc/php/7.0/fpm/php-fpm.conf</code>: Configuraci&oacute;n general de php-fpm.</li>
<li><code>/etc/php/7.0/fpm/php.ini</code>: Configuraci&oacute;n de php para este escenario.</li>
<li><code>/etc/php/7.0/fpm/pool.d</code>: Directorio con distintos pool de configuraci&oacute;n. Cada aplicaci&oacute;n puede tener una configuraci&oacute;n distinta (procesos distintos) de php-fpm.</li>
</ul>
<p>Por defecto tenemos un pool cuya configuraci&oacute;n la encontramos en <code>/etc/php/7.0/fpm/pool.d/www.conf</code>, en este fichero podemos configurar muchos par&aacute;metros, los m&aacute;s importantes son:</p>
<ul>
<li><code>[www]</code>: Es el nombre del pool, si tenemos varios, cada uno tiene que tener un nombre.</li>
<li><code>user</code> y <code>grorup</code>: Usuario y grupo con el que se va ejecutar los procesos.</li>
<li>
<p><code>listen</code>: Se indica el socket unix o el socket TCP donde van a escuchar los procesos:</p>
<ul>
<li>Por defecto, escucha por un socket unix: <code>listen = /run/php/php7.0-fpm.sock</code></li>
<li>Si queremos que escuche por un socket TCP: <code>listen = 127.0.0.1:9000</code></li>
<li>En el caso en que queramos que escuche en cualquier direcci&oacute;n: <code>listen = 9000</code></li>
</ul>
</li>
<li>
<p>Directivas de procesamiento, gesti&oacute;n de procesos:</p>
<ul>
<li><code>pm</code>: Por defecto igual a <code>dynamic</code> (el n&uacute;mero de procesos se crean y destruyen de forma din&aacute;mica). Otros valores: <code>static</code> o <code>ondemand</code>.</li>
<li>Otras directivas: <code>pm.max_children</code>, <code>pm.start_servers</code>, <code>pm.min_spare_servers</code>,...</li>
</ul>
</li>
<li>
<p><code>pm.status_path = /status</code>: No es necesaria, pero vamos a activar la URL de <code>status</code> para comprobar el estado del proceso.</p>
</li>
</ul>
<p>Por &uacute;ltimo reiniciamos el servicio:</p>
<pre><code>systemctl restart php7.0-fpm
</code></pre>
<h2>Pruebas de funcionamiento</h2>
<ol>
<li>
<p>Suponemos que tenemos configurado por defecto, por lo tanto los procesos est&aacute;n escuchando en un socket UNIX:</p>
<pre><code>listen = /run/php/php7.0-fpm.sock
</code></pre>
<p>Para enviar ficheros php a los procesos para su interpretaci&oacute;n vamos a utilizar el programa <code>cgi-fcgi</code>:</p>
<pre><code>apt-get install libfcgi0ldbl
</code></pre>
<p>Y a continuaci&oacute;n accedemos a la URL <code>/status</code>, para ello:</p>
<pre><code>SCRIPT_NAME=/status SCRIPT_FILENAME=/status REQUEST_METHOD=GET cgi-fcgi -bind -connect /run/php/php7.0-fpm.sock 

Expires: Thu, 01 Jan 1970 00:00:00 GMT
Cache-Control: no-cache, no-store, must-revalidate, max-age=0
Content-type: text/plain;charset=UTF-8      

pool:                 www
process manager:      dynamic
start time:           13/Nov/2017:19:32:50 +0000
start since:          38
accepted conn:        6
listen queue:         0
max listen queue:     0
listen queue len:     0
idle processes:       1
active processes:     1
total processes:      2
max active processes: 1
max children reached: 0
slow requests:        0
</code></pre>
<p>Si queremos ejecutar un fichero php, vamos a crear un directorio <code>/var/www</code> y vamos a guardar un fichero <code>holamundo.php</code> con el siguiente contenido:</p>
<pre><code><?php echo "Hola Mundo!!!";?>
</code></pre>
<p>A continuaci&oacute;n vamos a indicar el directorio de trabajo en el fichero <code>/etc/php/7.0/fpm/pool.d/www.conf</code>:</p>
<pre><code>chroot = /var/www
</code></pre>
<p>Inicializamos el servicio:</p>
<pre><code>systemctl restart php7.0-fpm
</code></pre>
<p>Y podr&iacute;amos ejecutar el fichero de la siguiente manera:</p>
<pre><code>SCRIPT_NAME=/holamundo.php SCRIPT_FILENAME=/holamundo.php REQUEST_METHOD=GET cgi-fcgi -bind -connect /run/php/php7.0-fpm.sock 

Content-type: text/html; charset=UTF-8

Hola Mundo!!!       
</code></pre>
</li>
<li>
<p>Si suponemos que hemos configurado php-fpm para que escuche en un socket TCP:</p>
<pre><code>listen = 127.0.0.1:9000
</code></pre>
<p>Para realizar las pruebas que hemos probado anteriormente:</p>
<pre><code>SCRIPT_NAME=/status SCRIPT_FILENAME=/status REQUEST_METHOD=GET cgi-fcgi -bind -connect 127.0.0.1:9000

SCRIPT_NAME=/holamundo.php SCRIPT_FILENAME=/holamundo.php REQUEST_METHOD=GET cgi-fcgi -bind -connect 127.0.0.1:9000
</code></pre>
</li>
</ol>
<h2>Conclusiones</h2>
<p>En muchas ocasiones cuando se instala apchache2 o ngninx junto a php-fpm nos cuesta entender como funciona la interpretaci&oacute;n del c&oacute;digo PHP por medio de php-fpm. en este art&iacute;culo he tratado de hacer una introducci&oacute;n a este servicio de manera independiente al servidor web para que se entienda un poco mejor. Espero que haya sido de utilidad.</p>
