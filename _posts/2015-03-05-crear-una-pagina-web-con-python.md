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
![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webp5.png)

Aunque de forma general se utilizan distintos [framework](https://wiki.python.org/moin/WebFrameworks) (el más popular es [django](https://www.djangoproject.com/)) para el desarrollo de aplicaciones web con Python. En este artículo voy a introducir los conceptos necesarios para crear una página web desarrollada con python, servida por un servidor web Apache, sin utilizar ningún framework. Para ello es necesario conocer el concepto de WSGI **Web Server Gateway Interface**, que es una especificación de una interface simple y universal entre los servidores web y las aplicaciones web o frameworks desarrolladas con python.

Nuestro objetivo es configurar el servidor apache para que puede comunicarse con una aplicación WSGI  y de esta manera, podamos servir páginas desarrolladas en python.

## Instalación y configuración del servidor web

Instalamos el servidor web apache2 y el módulo que permite ofrecer una interfaz wsgi:

    # apt-get install apache2 libapache2-mod-wsgi

## Crear los directorios necesarios

Los directorios necesarios para nuestra aplicación son los siguientes:

    /var/www/python# mkdir mypythonapp
    /var/www/python# mkdir public_html
    /var/www/python# mkdir logs

* `mypythonapp`: Es un directorio privado, no servido por el servidor web, donde guardaremos nuestra aplicación python wsgi.
* `public_html`: Corresponde al `DocumentRoot` del servidor web, y en el se guardará todo el contenido estático de nuestra aplicación: CSS, javascript, imágenes, ficheros para descargar,...
* `logs`: Directorio donde vamos a almacenar el fichero de logs del servidor web.

## Configuración del VirtualHost

Una vez que tenemos creado nuestra estructura de directorio, vamos a configurar el virtual host de nuestro servidor web. Podríamos crear un nuevo virtual host para nuestra aplicación, pero en este ejemplo vamos a modificar directamente el virtual host `default` de apache, para ello editamos el fichero `/etc/apache2/sites-availables/default` e indicamos la siguiente configuración:

    <VirtualHost *:80>
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/python/public_html
            WSGIScriptAlias / /var/www/python/mypythonapp/controller.py
            ErrorLog /var/www/python/logs/errors.log
            CustomLog /var/www/python/logs/access.log combined
            <Directory />
                    Options FollowSymLinks
                    AllowOverride None
            </Directory>
            <Directory /var/www/python/public_html>
                    Options Indexes FollowSymLinks MultiViews
                    AllowOverride None
                    Order allow,deny
                    allow from all
            </Directory>
    </VirtualHost>

## Creación de la aplicación WSGI

Todas las peticiones que hagamos a nuestro servidor estarán manejadas por la aplicación WSGI `controller.py` que estará guardada en el directorio `mypythonapp`. Esta aplicación será la responsable de manejar las peticiones, y de devolver la respuesta adecuada según la URI solicitada. En esta aplicación tendremos que definir una función, que actúe con cada petición del usuario. Esta función, **deberá ser una función WSGI aplicación válida**. Esto significa que:

1. Deberá llamarse `application`
2. Deberá recibir dos parámetros: `environ`, del módulo `os`, que provee un diccionario de las peticiones HTTP estándar y otras variables de entorno, y la función `start_response`, de WSGI, encargada de entregar la respuesta HTTP al usuario.

        # -*- coding: utf-8 -*-
        def application(environ, start_response):
            # Guardo la salida que devolveré como respuesta
            respuesta = "<p>Página web construida con <strong>Python!!!</strong></p>"
            # Se genera una respuesta al navegador 
            start_response('200 OK', [('Content-Type', 'text/html; charset=utf-8')])
            return respuesta

Y obtenemos el siguiente resultado:

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webpython.png)

## Creando una aplicación web un "poco más compleja"

El controlador que hemos hecho anteriormente no tiene en cuenta la URL con la que hemos accedido al servidor y siempre va a generar la misma respuesta. Utilizando la información sobre la petición que tenemos guardada en el diccionario `environ` podemos construir diferentes respuestas según la petición, por ejemplo teniendo en cuenta la URL de acceso.

El diccionario `environ` que se recibe con cada pedido HTTP, contiene las variables estándard de la especificación CGI, entre ellas:

* `REQUEST_METHOD`: método "GET", "POST", etc.
* `SCRIPT_NAME`: la parte inicial de la "ruta", que corresponde a la aplicación.
* `PATH_INFO`: la segunda parte de la "ruta", determina la "ubicación" virtual dentro de la aplicación.
* `QUERY_STRING`: la porción de la URL que sigue al "?", si existe.
* `CONTENT_TYPE`, `CONTENT_LENGTH` de la petición HTTP.
* `SERVER_NAME`, `SERVER_PORT`, que combinadas con `SCRIPT_NAME` y `PATH_INFO` dan la URL.
* `SERVER_PROTOCOL`: la versión del protocolo ("HTTP/1.0" or "HTTP/1.1").

De esta forma podemos hacer un controlador de la siguiente manera, para comprobar la URL de acceso:

    # -*- coding: utf-8 -*-
    def application(environ, start_response):
        if environ["PATH_INFO"]=="/":
            respuesta = "<p>Página inicial</p>"
        elif environ["PATH_INFO"]=="/hola":
            respuesta = "<p>Bienvenidos a mi página web</p>"
        else:
            respuesta = "<p><trong>Página incorrecta</strong></p>"
        start_response('200 OK', [('Content-Type', 'text/html; charset=utf-8')])
        return respuesta

Obteniendo el siguiente resultado:

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webp1.png)

En este último ejemplo vamos a ver cómo podemos trabajar con parámetros enviados por el método GET:

    # -*- coding: utf-8 -*-
    def application(environ, start_response):
        if environ["PATH_INFO"]=="/":
            respuesta = "<p>Página inicial</p>"
        elif environ["PATH_INFO"]=="/suma":
            params=environ["QUERY_STRING"].split("&")
            suma=0
            for par in params:
                    suma=suma+int(par.split("=")[1])
            respuesta="<p>La suma es %d</p>" % suma
        else:
            respuesta = "<p><trong>Página incorrecta</strong></p>"
        start_response('200 OK', [('Content-Type', 'text/html; charset=utf-8')])
        return respuesta

Y vemos el resultado:

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/webp4.png)

Bueno para terminar dejo las páginas en las que me he basado para escribir este artículo: [http://librosweb.es/libro/python/capitulo\_13/python\_bajo_apache.html](http://librosweb.es/libro/python/capitulo_13/python_bajo_apache.html), [http://python.org.ar/WSGI.](http://python.org.ar/WSGI)

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->