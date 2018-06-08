---
layout: post
status: publish
published: true
title: Ejemplos del m&oacute;dulo rewrite en Apache 2.2
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 512
wordpress_url: http://www.josedomingo.org/pledin/?p=512
date: '2011-10-28 01:22:11 +0000'
date_gmt: '2011-10-27 23:22:11 +0000'
categories:
- General
tags:
- Web
- Manuales
- Apache
comments: []
---
<p>Este art&iacute;culo lo he escrito para explicar en <a href="http://informatica.gonzalonazareno.org/plataforma/course/view.php?id=40">clase</a> a mis alumnos del ciclo formativo de grado superior de Administraci&oacute;n de Sistemas Inform&aacute;ticos en Red, una introducci&oacute;n al m&oacute;dulo rewrite de Apache.</p>
<p>El m&oacute;dulo rewrite nos va a permitir acceder a una URL e internamente estar accediendo a otra. Ayudado por los ficheros .htaccess, el m&oacute;dulo rewrite nos va a ayudar a formar URL amigables que son m&aacute;s consideradas por los motores de b&uacute;squedas y mejor recordadas por los humanos. Por ejemplo estas URL:</p>
<p><strong>www.dominio.com/articulos/muestra.php?id=23</strong><br />
<strong>www.dominio.com/pueblos/pueblo.php?nombre=torrelodones</strong></p>
<p>Es mucho mejor escribirlas como:</p>
<p><strong>www.dominio.com/articulos/23.php </strong><br />
<strong>www.dominio.com/pueblos/torrelodones.php</strong></p>
<h2>Ejemplo 1: Reescribir URL</h2>
<p>Si tenemos el siguiente fichero php (<a href="http://informatica.gonzalonazareno.org/plataforma/file.php/40/php.txt">descargar</a>) llamado operacion.php, podr&iacute;amos usarlo de la siguiente manera:</p>
<p>http://localhost/operacion.php?op=suma&amp;op1=6&amp;op2=8</p>
<p>Y si queremos reescribir la URL y que usemos en vez de php html, de esta forma:</p>
<p>http://localhost/operacion.html?op=suma&amp;op1=6&amp;op2=8</p>
<p>Para ello activamos el mod_rewite, y escribimos un .htaccess de la siguiente manera:</p>
<p>Options FollowSymLinks<br />
RewriteEngine On<br />
RewriteRule ^operacion\.html$ operacion.php</p>
<h2><strong>Ejemplo 2: Cambiar la extensi&oacute;n de los ficheros</strong></h2>
<p>Si queremos usar la extensi&oacute;n do en vez de html podr&iacute;amos usar este .htacces</p>
<p>Options FollowSymLinks<br />
RewriteEngine On<br />
RewriteRule ^(.+)\.do$ $1.html<strong></strong> [nc]</p>
<p>Esto puede ser penalizado por los motores de b&uacute;squeda ya que podemos acceder a la misma p&aacute;gina con dos URL distintas, para solucionar esto podemos hacer una redirecci&oacute;n:</p>
<p>RewriteRule ^(.+)\.do$ $1.html<strong></strong> [r,nc]</p>
<h2><strong>Ejemplo 3: Crear URL amigables</strong></h2>
<p>Como hab&iacute;amos visto anteriormente el fichero operacion.php se pod&iacute;a ejecutar de la siguiente manera:</p>
<p>http://localhost/operacion.php?op=suma&amp;op1=6&amp;op2=8</p>
<p>Creando una URL amigable podr&iacute;amos llamar a este fichero de la siguiente manera:</p>
<p>http://localhost/suma/8/6</p>
<p>&iquest;C&oacute;mo podemos conseguir esto?</p>
<p>Crea un .htaccess con el siguiente contenido:</p>
<p>Options FollowSymLinks<br />
RewriteEngine On<br />
RewriteBase /<br />
RewriteRule ^([a-z]+)/([0-9]+)/([0-9]+)$ operacion.php?op=$1&amp;op1=$2&amp;op2=$3</p>
<h2><strong>Ejemplo 4: Acortar URL</strong></h2>
<p>Supongamos que dentro de nuestro DocumentRoot tenemos una carpeta b&uacute;squeda con un fichero buscar.php (<a href="http://informatica.gonzalonazareno.org/plataforma/file.php/40/buscar.txt">descargar</a>). Este fichero me permite obtener la p&aacute;gina de b&uacute;squeda de google con el par&aacute;metro dado, de esta forma:</p>
<p>http://localhost/busqueda/buscar.php?id=hola</p>
<p>Nos gustar&iacute;a poder crear una URL m&aacute;s corta que haga lo mismo, escribir&iacute;amos en nuestro .htaccess un RewriteRule de la siguiente forma:</p>
<p>RewriteRule ^buscar busqueda/buscar.php</p>
<p>De esta forma acceder&iacute;amos por medio de la URL:</p>
<p>http://localhost/buscar?id=hola</p>
<p>Ejercicio: Siguiendo las t&eacute;cnicas anteriormente vistas, realiza una reescritura de URL para que pudieramos realizar b&uacute;squedas con URL de la siguiente manera:</p>
<p>http://localhost/buscar/hola.html</p>
<h2><strong>Ejemplo 5: Uso del RewriteCond</strong></h2>
<p>Ls directiva <a href="http://httpd.apache.org/docs/2.0/mod/mod_rewrite.html#rewritecond">RewriteCond</a> nos permite especificar una condici&oacute;n que si se cumple se ejecuta la directiva RewriteRule posterior. Se pueden poner varias condiciones con RewriteCond, en este caso cuando se cumplen todas se ejecuta la directiva RewriteRule posterior.</p>
<p>Como vemos en la documentaci&oacute;n podemos preguntar por varios par&aacute;metros , entre los que destacamos los siguientes:</p>
<p><strong>%{HTTP_USER_AGENT}</strong>: Informaci&oacute;n del cliente que accede.<br />
Por ejemplo, podemos mostrar una p&aacute;gina distinta para cada navegador:</p>
<p>RewriteCond %{HTTP_USER_AGENT} ^Mozilla<br />
RewriteRule ^/$ /index.max.html [L]</p>
<p>RewriteCond %{HTTP_USER_AGENT} ^Lynx<br />
RewriteRule ^/$ /index.min.html [L]</p>
<p>RewriteRule ^/$ /index.html [L]</p>
<p><strong>%{QUERY_STRING}</strong>: Guarda la cadena de par&aacute;metros de una URL din&aacute;mica.Por ejemplo:</p>
<p>Ten&iacute;amos un fichero index.php que recib&iacute;a un par&aacute;metro lang, para traducir el mensaje de bienvenida.</p>
<p>http://localhost/index.php?lang=es</p>
<p>Actualmente hemos cambiado la forma de traducir, y se han creado distintos directorios para cada idioma y dentro un index.php con el mensaje traducido.</p>
<p>http://localhost/es/index.php</p>
<p>Sin embargo se quiere seguir utilizando la misma forma de traducir.</p>
<p>RewriteCond %{QUERY_STRING} lang=(.*)<br />
RewriteRule ^index\.php$ /%1/$1</p>
<p><strong>%{REMOTE_ADDR}</strong>: Direcci&oacute;n de destino. Por ejemplo puedo denegar el acceso a una direcci&oacute;n:</p>
<p>RewriteCond %{REMOTE_ADDR} 145.164.1.8<br />
RewriteRule ^(.*)$ / [R,NC,L]</p>
<p>Tambi&eacute;n podemos controlar la reescritura de URL seg&uacute;n la hora y la fecha, para saber m&aacute;s lee este <a href="http://www.askapache.com/htaccess/time_hour-rewritecond-time.html">art&iacute;culo</a>.</p>
<p><strong>%{HTTP_REFERER}:</strong> Guarda la URL que accede a nuestra p&aacute;gina y %{<strong>REQUEST_URI}</strong> guarda la URI, URL sin nombre de dominio. Podemos evitar el Hot_Linking, o uso de recursos de tu servidor desde otra web. Por ejemplo, un caso muy com&uacute;n es usar im&aacute;genes alojadas en tu servidor puestas en otras web. Para ello podemos escribir el siguiente .htaccess:</p>
<p>RewriteCond %{HTTP_REFERER} !^$<br />
RewriteCond %{HTTP_REFERER} !^http://(www\.)?dominio\.com/ [NC]<br />
RewriteCond %{REQUEST_URI} !hotlink\.(gif|png) [NC]<br />
RewriteRule .*\.(gif|jpg|png)$ http://www.dominio.com/image/hotlink.png [NC]</p>
<p>En el anterior ejemplo el primer RewriteCond permite la solicitud directa pero no desde otras p&aacute;ginas (referrer vac&iacute;o). La siguiente l&iacute;nea indica que si el navegador ha enviado una cabecera Referrer y esta no contiene la palabra "dominio.com" se ejecutar&aacute; el RewriteRule. La ultima instrucci&oacute;n RewriteCond indica que si en la url solicitada se encuentra el nombre de la imagen "hotlink" no se realizar&aacute; el RewrtieRule; esto se pone porque la imagen hotlink.png va a ser la que vamos a usar en RewriteRule y si no ponemos este RewriteCond tambi&eacute;n ser&iacute;a redirigida la solicitud a esta imagen. La &uacute;ltima instrucci&oacute;n del ejemplo es el RewriteRule que indica que cualquier solicitud a una imagen desde otro referrer ser&aacute; reescrita en el servidor hacia la imagen hotlink.png y esta ser&aacute; la imagen que se vea en la web que te est&eacute; intentando robar la imagen.</p>
<p>Ejercicio: Realiza un .htaccess para evitar el hot-linking. Puedes usar esta esta <a href="http://informatica.gonzalonazareno.org/plataforma/file.php/40/hotlink.gif">imagen</a> para realizar el ejercicio.</p>
<h2><strong>Ejemplo 6: URL amigables con WordPress</strong></h2>
<p>Ejercicio: Instala wordpress en tu servidor con el m&oacute;dulo rewrite desactivado, comprueba que las URL no son amigables. Activa el m&oacute;dulo y a continuaci&oacute;n configura el blog para que tenga URL amigables (Settings->Permalink).</p>
