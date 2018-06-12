---
id: 1286
title: 'Crear páginas web con Bottle: Python Web Framework (1ª parte)'
date: 2015-03-09T10:18:12+00:00


guid: http://www.josedomingo.org/pledin/?p=1286
permalink: /2015/03/crear-paginas-web-con-bottle-python-web-framework_1a_parte/


tags:
  - bottle
  - Python
  - Web
---
[<img class=" size-full wp-image-1289 aligncenter" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/logo_nav.png" alt="logo_nav" width="200" height="69" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/logo_nav.png){.thumbnail}

En la [entrada anterior](http://www.josedomingo.org/pledin/2015/03/crear-una-pagina-web-con-python/ "Crear una página web con Python") vimos como crear aplicaciones web en python. Un **framework para aplicaciones web** es un _[framework](http://es.wikipedia.org/wiki/Framework "Framework")_ diseñado para apoyar el desarrollo de [sitios web](http://es.wikipedia.org/wiki/Sitio_web "Sitio web") dinámicos, [aplicaciones web](http://es.wikipedia.org/wiki/Aplicaci%C3%B3n_web "Aplicación web") y [servicios web](http://es.wikipedia.org/wiki/Servicio_web "Servicio web"). Y un **framework** es un conjunto de herramientas y programas que nos facilitan la realización y el desarrollo de un producto software. En este artículo vamos a usar un web framework escrito en Python para desarrollar páginas web. Vamos a usar el framework **bottle** que podemos definir cómo indica en su [página oficial](http://bottlepy.org/docs/dev/index.html#):

> Bottle is a fast, simple and lightweight [WSGI](http://www.wsgi.org/){.reference.external} micro web-framework for [Python](http://python.org/){.reference.external}.

##  Instalación de Bottle

Para obtener la última versión del framework vamos a usar la utilidad **pip** que nos permita la instalación de aplicaciones python:

<pre># apt-get install python-pip
# pip install bottle</pre>

<!--more-->

## Empezamos con el &#8220;Hola Mundo&#8221;

Vamos a ir estudiando distintos ejemplos para ir introduciendo los distintos conceptos sobre bottle. El primer ejemplo vamos a realizar una página web que nos de la bienvenida:

<pre>from bottle import route, run

@route('/hello')
def hello():
    return "&lt;h1&gt;Hola mundo&lt;/h1&gt;"

run(host='localhost', port=8080, debug=True)
</pre>

  * La utilidad `@router` (en inglés _framework decorator_) nos permite definir las rutas de la URL que vamos a tratar. En este ejemplo cuando accedemos a _http://localhost:8080/hello_ veremos nuestra página web.
  * Para cada ruta o conjunto de rutas se define una función que debe devolver el código html que se mostrará al acceder a la ruta especificada.
  * La función `run()` ejecuta un servidor web, en este caso se puede acceder desde localhost en el puerto 8080, esto nos permite ir probando cómo va quedando nuestra aplicación web. [<img class="aligncenter size-full wp-image-1296" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle1.png" alt="bottle1" width="253" height="100" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle1.png){.thumbnail}

## Trabajando con rutas dinámicas

Una **ruta dinámica** nos permite definir rutas utilizando variables, por lo que podemos filtrar más de una URL. Veamos un ejemplo:

<pre>from bottle import route, run

@route('/')
@route('/hello/&lt;name&gt;')
def greet(name='Stranger'):
    return 'Hello %s, how are you?'%name

run(host='localhost', port=8080, debug=True)
</pre>

  * En este ejemplo vemos como definimos dos rutas que van a mostrar la misma página web.
  * La segunda ruta es dinámica ya que el segundo parámetro es una variable.
  * El valor de la variable de la ruta hay que enviarla a la función. En este caso hemos utilizado un parámetro con un valor por defecto (&#8220;_Stranger_&#8220;) en la función.

<table>
  <tr>
    <td>
      <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle2.png"><img class="size-full wp-image-1297" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle2.png" alt="bottle2" width="269" height="86" /></a>
    </td>
    
    <td style="text-align: center;">
      <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle3.png"><img class="aligncenter size-full wp-image-1298" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle3.png" alt="bottle3" width="256" height="86" /></a>
    </td>
  </tr>
</table>

## Formularios. Envío de información por el método POST

Si usamos rutas dinámicas estamos accediendo a la página web usando el método **GET** de forma predeterminada. Podemos crear rutas dónde indiquemos que hemos usado el método **POST** para recibir  la información. Veamos un ejemplo:

<pre>from bottle import Bottle,route,run,request
@route('/login') 
def login():
    return '''
        &lt;form action="/login" method="post"&gt;
            Username: &lt;input name="username" type="text" /&gt;
            Password: &lt;input name="password" type="password" /&gt;
            &lt;input value="Login" type="submit" /&gt;
        &lt;/form&gt;'''

@route('/login',method='POST') 
def do_login():
    username = request.forms.get('username')
    password = request.forms.get('password')
    if username=="pepe" and password=="asdasd":
        return "&lt;p&gt;Your login information was correct.&lt;/p&gt;"
    else:
        return "&lt;p&gt;Login failed.&lt;/p&gt;"

run(host='localhost', port=8080)</pre>

  * En este ejemplo hemos definido dos rutas que se correponden con la misma URL, pero la segunda será seleccionada cuando se haya enviado información usando el método POST (en este ejemplo se envía la información de un formulario usando ese método).
  * El objeto `request` almacena la información recibida. Con el método `request.forms.get` podemos obtener el parámetro que indicamos con el atributo _name_ en el elemento _input_ del formulario.

<table>
  <tr>
    <td>
      <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle4.png"><img class="aligncenter size-full wp-image-1301" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle4.png" alt="bottle4" width="315" height="153" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle4.png 315w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle4-300x146.png 300w" sizes="(max-width: 315px) 100vw, 315px" /></a>
    </td>
    
    <td style="text-align: center;">
      <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle5.png"><img class="aligncenter size-full wp-image-1302" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle5.png" alt="bottle5" width="319" height="82" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle5.png 319w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle5-300x77.png 300w" sizes="(max-width: 319px) 100vw, 319px" /></a>
    </td>
  </tr>
</table>

Todos los ejemplos que hemos estudiado lo puedes encontrar en el siguiente repositorio GitHub: <https://github.com/josedom24/bottle_lm>. En la [próxima entrada](http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-trabajando-con-plantillas-2a-parte), estudiaremos las plantillas de bottle, que nos permitirán el desarrollo de páginas web de una forma muy sencilla y flexible.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->