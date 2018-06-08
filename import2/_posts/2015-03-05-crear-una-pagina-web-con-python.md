---
layout: post
status: publish
published: true
title: Crear una p&aacute;gina web con Python
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1271
wordpress_url: http://www.josedomingo.org/pledin/?p=1271
date: '2015-03-05 22:33:15 +0000'
date_gmt: '2015-03-05 21:33:15 +0000'
categories:
- General
tags:
- Web
- Python
- Apache
comments: []
---
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/webp5.png"><img class=" size-full wp-image-1282 alignleft" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/webp5.png" alt="webp5" width="214" height="214" /></a>Aunque de forma general se utilizan distintos <a href="https://wiki.python.org/moin/WebFrameworks">framework</a> (el m&aacute;s popular es <a href="https://www.djangoproject.com/">django</a>) para el desarrollo de aplicaciones web con Python. En este art&iacute;culo voy a introducir los conceptos necesarios para crear una p&aacute;gina web desarrollada con python, servida por un servidor web Apache, sin utilizar ning&uacute;n framework. Para ello es necesario conocer el concepto de WSGI <b>Web Server Gateway Interface</b>, que es una especificaci&oacute;n de una interface simple y universal entre los servidores web y las aplicaciones web o frameworks desarrolladas con python.</p>
<p>Nuestro objetivo es configurar el servidor apache para que puede comunicarse con una aplicaci&oacute;n WSGI&nbsp; y de esta manera, podamos servir p&aacute;ginas desarrolladas en python.</p>
<p><!--more--></p>
<h2>Instalaci&oacute;n y configuraci&oacute;n del servidor web</h2>
<p>Instalamos el servidor web apache2 y el m&oacute;dulo que permite ofrecer una interfaz wsgi:</p>
<pre># apt-get install apache2 libapache2-mod-wsgi</pre>
<h2>Crear los directorios necesarios</h2>
<p>Los directorios necesarios para nuestra aplicaci&oacute;n son los siguientes:</p>
<pre>/var/www/python# mkdir mypythonapp
/var/www/python# mkdir public_html
/var/www/python# mkdir logs</pre>
<ul>
<li><strong><em>mypythonapp</em></strong>: Es un directorio privado, no servido por el servidor web, donde guardaremos nuestra aplicaci&oacute;n python wsgi.</li>
<li><em><strong>public_html</strong></em>: Corresponde al <em>DocumentRoot</em> del servidor web, y en el se guardar&aacute; todo el contenido est&aacute;tico de nuestra aplicaci&oacute;n: CSS, javascript, im&aacute;genes, ficheros para descargar, ...</li>
<li><em><strong>logs</strong></em>: Directorio donde vamos a almacenar el fichero de logs del servidor web.</li>
</ul>
<h2>Configuraci&oacute;n del VirtualHost</h2>
<p>Una vez que tenemos creado nuestra estructura de directorio, vamos a configurar el virtual host de nuestro servidor web. Podr&iacute;amos crear un nuevo virtual host para nuestra aplicaci&oacute;n, pero en este ejemplo vamos a modificar directamente el virtual host <em>default</em> de apache, para ello editamos el fichero <em>/etc/apache2/sites-availables/default</em> e indicamos la siguiente configuraci&oacute;n:</p>
<pre><VirtualHost *:80>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ServerAdmin webmaster@localhost

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <strong>DocumentRoot /var/www/python/public_html</strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; WSGIScriptAlias / /var/www/python/mypythonapp/controller.py</strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ErrorLog /var/www/python/logs/errors.log</strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CustomLog /var/www/python/logs/access.log combined</strong>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <Directory />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Options FollowSymLinks
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; AllowOverride None
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </Directory>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <strong><Directory /var/www/python/public_html></strong>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Options Indexes FollowSymLinks MultiViews
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; AllowOverride None
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Order allow,deny
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allow from all
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </Directory>
</VirtualHost></pre>
<h2>Creaci&oacute;n de la aplicaci&oacute;n WSGI</h2>
<p>Todas las peticiones que hagamos a nuestro servidor estar&aacute;n manejadas por la aplicaci&oacute;n WSGI <em>controller.py</em> que estar&aacute; guardada en el directorio <em>mypythonapp</em>. Esta aplicaci&oacute;n ser&aacute; la responsable de manejar las peticiones, y de devolver la respuesta adecuada seg&uacute;n la URI solicitada. En esta aplicaci&oacute;n tendremos que definir una funci&oacute;n, que act&uacute;e con cada petici&oacute;n del usuario. Esta funci&oacute;n, <strong>deber&aacute; ser una funci&oacute;n WSGI aplicaci&oacute;n v&aacute;lida</strong>. Esto significa que:</p>
<ol>
<li>Deber&aacute; llamarse <code>application</code></li>
<li>Deber&aacute; recibir dos par&aacute;metros: <code>environ</code>, del m&oacute;dulo <code>os</code>, que provee un diccionario de las peticiones HTTP est&aacute;ndar y otras variables de entorno, y la funci&oacute;n <code>start_response</code>, de WSGI, encargada de entregar la respuesta HTTP al usuario.</li>
</ol>
<pre># -*- coding: utf-8 -*-
def application(environ, start_response):
&nbsp;&nbsp;&nbsp; # Guardo la salida que devolver&eacute; como respuesta
&nbsp;&nbsp;&nbsp; respuesta = "<p>P&aacute;gina web construida con <strong>Python!!!</strong></p>"
&nbsp;&nbsp;&nbsp; # Se genera una respuesta al navegador 
&nbsp;&nbsp;&nbsp; start_response('200 OK', [('Content-Type', 'text/html; charset=utf-8')])
&nbsp;&nbsp;&nbsp; return respuesta

</pre>
<p>Y obtenemos el siguiente resultado:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/webpython.png"><img class="aligncenter size-full wp-image-1276" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/webpython.png" alt="webpython" width="352" height="117" /></a></p>
<h2>Creando una aplicaci&oacute;n web un "poco m&aacute;s compleja"</h2>
<p>El controlador que hemos hecho anteriormente no tiene en cuenta la URL con la que hemos accedido al servidor y siempre va a generar la misma respuesta. Utilizando la informaci&oacute;n sobre la petici&oacute;n que tenemos guardada en el diccionario <code>environ</code> podemos construir diferentes respuestas seg&uacute;n la petici&oacute;n, por ejemplo teniendo en cuenta la URL de acceso.</p>
<p class="line862">El diccionario <tt>environ</tt> que se recibe con cada pedido HTTP, contiene las variables est&aacute;ndard de la especificaci&oacute;n CGI, entre ellas: <span id="line-29" class="anchor"></span></p>
<ul>
<li>REQUEST_METHOD: m&eacute;todo "GET", "POST", tec. <span id="line-30" class="anchor"></span></li>
<li>SCRIPT_NAME : la parte inicial de la "ruta", que corresponde a la aplicaci&oacute;n <span id="line-31" class="anchor"></span></li>
<li>PATH_INFO: la segunda parte de la "ruta", determina la "ubicaci&oacute;n" virtual dentro de la aplicaci&oacute;n <span id="line-32" class="anchor"></span></li>
<li>QUERY_STRING: la porci&oacute;n de la URL que sigue al "?", si existe <span id="line-33" class="anchor"></span></li>
<li>CONTENT_TYPE, CONTENT_LENGTH de la petici&oacute;n HTTP <span id="line-34" class="anchor"></span></li>
<li>SERVER_NAME, SERVER_PORT, que combinadas con SCRIPT_NAME y PATH_INFO dan la URL <span id="line-35" class="anchor"></span></li>
<li>SERVER_PROTOCOL: la versi&oacute;n del protocolo ("HTTP/1.0" or "HTTP/1.1")</li>
</ul>
<p>De esta forma podemos hacer un controlador de la siguiente manera, para comprobar la URL de acceso:</p>
<pre># -*- coding: utf-8 -*-
def application(environ, start_response):
&nbsp;&nbsp;&nbsp; if environ["PATH_INFO"]=="/":
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; respuesta = "<p>P&aacute;gina inicial</p>"
&nbsp;&nbsp;&nbsp; elif environ["PATH_INFO"]=="/hola":
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; respuesta = "<p>Bienvenidos a mi p&aacute;gina web</p>"
&nbsp;&nbsp;&nbsp; else:
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; respuesta = "<p><trong>P&aacute;gina incorrecta</strong></p>"
&nbsp;&nbsp;&nbsp; start_response('200 OK', [('Content-Type', 'text/html; charset=utf-8')])
&nbsp;&nbsp;&nbsp; return respuesta</pre>
<p>Obteniendo el siguiente resultado:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/webp1.png"><img class="aligncenter size-full wp-image-1278" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/webp1.png" alt="webp1" width="694" height="94" /></a>En este &uacute;ltimo ejemplo vamos a ver c&oacute;mo podemos trabajar con par&aacute;metros enviados por el m&eacute;todo GET:</p>
<pre># -*- coding: utf-8 -*-
def application(environ, start_response):
&nbsp;&nbsp;&nbsp; if environ["PATH_INFO"]=="/":
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; respuesta = "<p>P&aacute;gina inicial</p>"
&nbsp;&nbsp;&nbsp; elif environ["PATH_INFO"]=="/suma":
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; params=environ["QUERY_STRING"].split("&amp;")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; suma=0
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for par in params:
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; suma=suma+int(par.split("=")[1])
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; respuesta="<p>La suma es %d</p>" % suma
&nbsp;&nbsp;&nbsp; else:
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; respuesta = "<p><trong>P&aacute;gina incorrecta</strong></p>"
&nbsp;&nbsp;&nbsp; start_response('200 OK', [('Content-Type', 'text/html; charset=utf-8')])
&nbsp;&nbsp;&nbsp; return respuesta</pre>
<p>Y vemos el resultado:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/webp4.png"><img class="aligncenter size-full wp-image-1280" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/webp4.png" alt="webp4" width="358" height="93" /></a>Bueno para terminar dejo las p&aacute;ginas en las que me he basado para escribir este art&iacute;culo: <a href="http://librosweb.es/libro/python/capitulo_13/python_bajo_apache.html">http://librosweb.es/libro/python/capitulo_13/python_bajo_apache.html</a>, <a href="http://python.org.ar/WSGI">http://python.org.ar/WSGI.</a></p>
