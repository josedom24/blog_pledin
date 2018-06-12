---
id: 1271
title: Crear una página web con Python
date: 2015-03-05T22:33:15+00:00


guid: http://www.josedomingo.org/pledin/?p=1271
permalink: /2015/03/crear-una-pagina-web-con-python/


tags:
  - Apache
  - Python
  - Web
---
[<img class=" size-full wp-image-1282 alignleft" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webp5.png" alt="webp5" width="214" height="214" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webp5.png 214w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webp5-150x150.png 150w" sizes="(max-width: 214px) 100vw, 214px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webp5.png){.thumbnail}Aunque de forma general se utilizan distintos [framework](https://wiki.python.org/moin/WebFrameworks) (el más popular es [django](https://www.djangoproject.com/)) para el desarrollo de aplicaciones web con Python. En este artículo voy a introducir los conceptos necesarios para crear una página web desarrollada con python, servida por un servidor web Apache, sin utilizar ningún framework. Para ello es necesario conocer el concepto de WSGI **Web Server Gateway Interface**, que es una especificación de una interface simple y universal entre los servidores web y las aplicaciones web o frameworks desarrolladas con python.

Nuestro objetivo es configurar el servidor apache para que puede comunicarse con una aplicación WSGI  y de esta manera, podamos servir páginas desarrolladas en python.

<!--more-->

## Instalación y configuración del servidor web

Instalamos el servidor web apache2 y el módulo que permite ofrecer una interfaz wsgi:

<pre># apt-get install apache2 libapache2-mod-wsgi</pre>

## Crear los directorios necesarios

Los directorios necesarios para nuestra aplicación son los siguientes:

<pre>/var/www/python# mkdir mypythonapp
/var/www/python# mkdir public_html
/var/www/python# mkdir logs</pre>

  * **_mypythonapp_**: Es un directorio privado, no servido por el servidor web, donde guardaremos nuestra aplicación python wsgi.
  * _**public_html**_: Corresponde al _DocumentRoot_ del servidor web, y en el se guardará todo el contenido estático de nuestra aplicación: CSS, javascript, imágenes, ficheros para descargar, &#8230;
  * _**logs**_: Directorio donde vamos a almacenar el fichero de logs del servidor web.

## Configuración del VirtualHost

Una vez que tenemos creado nuestra estructura de directorio, vamos a configurar el virtual host de nuestro servidor web. Podríamos crear un nuevo virtual host para nuestra aplicación, pero en este ejemplo vamos a modificar directamente el virtual host _default_ de apache, para ello editamos el fichero _/etc/apache2/sites-availables/default_ e indicamos la siguiente configuración:

<pre>&lt;VirtualHost *:80&gt;
        ServerAdmin webmaster@localhost

        <strong>DocumentRoot /var/www/python/public_html</strong>
<strong>        WSGIScriptAlias / /var/www/python/mypythonapp/controller.py</strong>
<strong>        ErrorLog /var/www/python/logs/errors.log</strong>
<strong>        CustomLog /var/www/python/logs/access.log combined</strong>
        &lt;Directory /&gt;
                Options FollowSymLinks
                AllowOverride None
        &lt;/Directory&gt;
        <strong>&lt;Directory /var/www/python/public_html&gt;</strong>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride None
                Order allow,deny
                allow from all
        &lt;/Directory&gt;
&lt;/VirtualHost&gt;</pre>

## Creación de la aplicación WSGI

Todas las peticiones que hagamos a nuestro servidor estarán manejadas por la aplicación WSGI _controller.py_ que estará guardada en el directorio _mypythonapp_. Esta aplicación será la responsable de manejar las peticiones, y de devolver la respuesta adecuada según la URI solicitada. En esta aplicación tendremos que definir una función, que actúe con cada petición del usuario. Esta función, **deberá ser una función WSGI aplicación válida**. Esto significa que:

  1. Deberá llamarse `application`
  2. Deberá recibir dos parámetros: `environ`, del módulo `os`, que provee un diccionario de las peticiones HTTP estándar y otras variables de entorno, y la función `start_response`, de WSGI, encargada de entregar la respuesta HTTP al usuario.

<pre># -*- coding: utf-8 -*-
def application(environ, start_response):
    # Guardo la salida que devolveré como respuesta
    respuesta = "&lt;p&gt;Página web construida con &lt;strong&gt;Python!!!&lt;/strong&gt;&lt;/p&gt;"
    # Se genera una respuesta al navegador 
    start_response('200 OK', [('Content-Type', 'text/html; charset=utf-8')])
    return respuesta

</pre>

Y obtenemos el siguiente resultado:

[<img class="aligncenter size-full wp-image-1276" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webpython.png" alt="webpython" width="352" height="117" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webpython.png 352w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webpython-300x100.png 300w" sizes="(max-width: 352px) 100vw, 352px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webpython.png){.thumbnail}

## Creando una aplicación web un &#8220;poco más compleja&#8221;

El controlador que hemos hecho anteriormente no tiene en cuenta la URL con la que hemos accedido al servidor y siempre va a generar la misma respuesta. Utilizando la información sobre la petición que tenemos guardada en el diccionario `environ` podemos construir diferentes respuestas según la petición, por ejemplo teniendo en cuenta la URL de acceso.

<p class="line862">
  El diccionario <tt>environ</tt> que se recibe con cada pedido HTTP, contiene las variables estándard de la especificación CGI, entre ellas: <span id="line-29" class="anchor"></span>
</p>

  * REQUEST_METHOD: método &#8220;GET&#8221;, &#8220;POST&#8221;, tec. <span id="line-30" class="anchor"></span>
  * SCRIPT_NAME : la parte inicial de la &#8220;ruta&#8221;, que corresponde a la aplicación <span id="line-31" class="anchor"></span>
  * PATH_INFO: la segunda parte de la &#8220;ruta&#8221;, determina la &#8220;ubicación&#8221; virtual dentro de la aplicación <span id="line-32" class="anchor"></span>
  * QUERY_STRING: la porción de la URL que sigue al &#8220;?&#8221;, si existe <span id="line-33" class="anchor"></span>
  * CONTENT\_TYPE, CONTENT\_LENGTH de la petición HTTP <span id="line-34" class="anchor"></span>
  * SERVER\_NAME, SERVER\_PORT, que combinadas con SCRIPT\_NAME y PATH\_INFO dan la URL <span id="line-35" class="anchor"></span>
  * SERVER_PROTOCOL: la versión del protocolo (&#8220;HTTP/1.0&#8221; or &#8220;HTTP/1.1&#8221;)

De esta forma podemos hacer un controlador de la siguiente manera, para comprobar la URL de acceso:

<pre># -*- coding: utf-8 -*-
def application(environ, start_response):
    if environ["PATH_INFO"]=="/":
        respuesta = "&lt;p&gt;Página inicial&lt;/p&gt;"
    elif environ["PATH_INFO"]=="/hola":
        respuesta = "&lt;p&gt;Bienvenidos a mi página web&lt;/p&gt;"
    else:
        respuesta = "&lt;p&gt;&lt;trong&gt;Página incorrecta&lt;/strong&gt;&lt;/p&gt;"
    start_response('200 OK', [('Content-Type', 'text/html; charset=utf-8')])
    return respuesta</pre>

Obteniendo el siguiente resultado:

[<img class="aligncenter size-full wp-image-1278" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webp1.png" alt="webp1" width="694" height="94" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webp1.png 694w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webp1-300x41.png 300w" sizes="(max-width: 694px) 100vw, 694px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webp1.png){.thumbnail}En este último ejemplo vamos a ver cómo podemos trabajar con parámetros enviados por el método GET:

<pre># -*- coding: utf-8 -*-
def application(environ, start_response):
    if environ["PATH_INFO"]=="/":
        respuesta = "&lt;p&gt;Página inicial&lt;/p&gt;"
    elif environ["PATH_INFO"]=="/suma":
        params=environ["QUERY_STRING"].split("&")
        suma=0
        for par in params:
                suma=suma+int(par.split("=")[1])
        respuesta="&lt;p&gt;La suma es %d&lt;/p&gt;" % suma
    else:
        respuesta = "&lt;p&gt;&lt;trong&gt;Página incorrecta&lt;/strong&gt;&lt;/p&gt;"
    start_response('200 OK', [('Content-Type', 'text/html; charset=utf-8')])
    return respuesta</pre>

Y vemos el resultado:

[<img class="aligncenter size-full wp-image-1280" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webp4.png" alt="webp4" width="358" height="93" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webp4.png 358w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webp4-300x78.png 300w" sizes="(max-width: 358px) 100vw, 358px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webp4.png){.thumbnail}Bueno para terminar dejo las páginas en las que me he basado para escribir este artículo: [http://librosweb.es/libro/python/capitulo\_13/python\_bajo_apache.html](http://librosweb.es/libro/python/capitulo_13/python_bajo_apache.html), [http://python.org.ar/WSGI.](http://python.org.ar/WSGI)

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->