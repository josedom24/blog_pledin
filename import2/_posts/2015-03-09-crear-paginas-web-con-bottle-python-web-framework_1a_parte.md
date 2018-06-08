---
layout: post
status: publish
published: true
title: 'Crear p&aacute;ginas web con Bottle: Python Web Framework (1&ordf; parte)'
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1286
wordpress_url: http://www.josedomingo.org/pledin/?p=1286
date: '2015-03-09 10:18:12 +0000'
date_gmt: '2015-03-09 09:18:12 +0000'
categories:
- General
tags:
- Web
- Python
- bottle
comments: []
---
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/logo_nav.png"><img class=" size-full wp-image-1289 aligncenter" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/logo_nav.png" alt="logo_nav" width="200" height="69" /></a></p>
<p>En la <a title="Crear una p&aacute;gina web con Python" href="http://www.josedomingo.org/pledin/2015/03/crear-una-pagina-web-con-python/">entrada anterior</a> vimos como crear aplicaciones web en python. Un <b>framework para aplicaciones web</b> es un <i><a title="Framework" href="http://es.wikipedia.org/wiki/Framework">framework</a></i> dise&ntilde;ado para apoyar el desarrollo de <a title="Sitio web" href="http://es.wikipedia.org/wiki/Sitio_web">sitios web</a> din&aacute;micos, <a title="Aplicaci&oacute;n web" href="http://es.wikipedia.org/wiki/Aplicaci%C3%B3n_web">aplicaciones web</a> y <a title="Servicio web" href="http://es.wikipedia.org/wiki/Servicio_web">servicios web</a>. Y un <strong>framework</strong> es un conjunto de herramientas y programas que nos facilitan la realizaci&oacute;n y el desarrollo de un producto software. En este art&iacute;culo vamos a usar un web framework escrito en Python para desarrollar p&aacute;ginas web. Vamos a usar el framework <strong>bottle</strong> que podemos definir c&oacute;mo indica en su <a href="http://bottlepy.org/docs/dev/index.html#">p&aacute;gina oficial</a>:</p>
<blockquote><p>Bottle is a fast, simple and lightweight <a class="reference external" href="http://www.wsgi.org/">WSGI</a> micro web-framework for <a class="reference external" href="http://python.org/">Python</a>.</p></blockquote>
<h2>&nbsp;Instalaci&oacute;n de Bottle</h2>
<p>Para obtener la &uacute;ltima versi&oacute;n del framework vamos a usar la utilidad <strong>pip </strong>que nos permita la instalaci&oacute;n de aplicaciones python:</p>
<pre># apt-get install python-pip
# pip install bottle</pre>
<p><!--more--></p>
<h2>Empezamos con el "Hola Mundo"</h2>
<p>Vamos a ir estudiando distintos ejemplos para ir introduciendo los distintos conceptos sobre bottle. El primer ejemplo vamos a realizar una p&aacute;gina web que nos de la bienvenida:</p>
<pre>from bottle import route, run

@route('/hello')
def hello():
    return "<h1>Hola mundo</h1>"

run(host='localhost', port=8080, debug=True)
</pre>
<ul>
<li>La utilidad <code>@router</code> (en ingl&eacute;s <em>framework decorator</em>) nos permite definir las rutas de la URL que vamos a tratar. En este ejemplo cuando accedemos a <em>http://localhost:8080/hello</em> veremos nuestra p&aacute;gina web.</li>
<li>Para cada ruta o conjunto de rutas se define una funci&oacute;n que debe devolver el c&oacute;digo html que se mostrar&aacute; al acceder a la ruta especificada.</li>
<li>La funci&oacute;n <code>run()</code> ejecuta un servidor web, en este caso se puede acceder desde localhost en el puerto 8080, esto nos permite ir probando c&oacute;mo va quedando nuestra aplicaci&oacute;n web. <a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle1.png"><img class="aligncenter size-full wp-image-1296" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle1.png" alt="bottle1" width="253" height="100" /></a></li>
</ul>
<h2>Trabajando con rutas din&aacute;micas</h2>
<p>Una <strong>ruta din&aacute;mica</strong> nos permite definir rutas utilizando variables, por lo que podemos filtrar m&aacute;s de una URL. Veamos un ejemplo:</p>
<pre>from bottle import route, run

@route('/')
@route('/hello/<name>')
def greet(name='Stranger'):
    return 'Hello %s, how are you?'%name

run(host='localhost', port=8080, debug=True)
</pre>
<ul>
<li>En este ejemplo vemos como definimos dos rutas que van a mostrar la misma p&aacute;gina web.</li>
<li>La segunda ruta es din&aacute;mica ya que el segundo par&aacute;metro es una variable.</li>
<li>El valor de la variable de la ruta hay que enviarla a la funci&oacute;n. En este caso hemos utilizado un par&aacute;metro con un valor por defecto ("<em>Stranger</em>") en la funci&oacute;n.</li>
</ul>
<table>
<tbody>
<tr>
<td><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle2.png"><img class="size-full wp-image-1297" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle2.png" alt="bottle2" width="269" height="86" /></a></td>
<td style="text-align: center;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle3.png"><img class="aligncenter size-full wp-image-1298" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle3.png" alt="bottle3" width="256" height="86" /></a></td>
</tr>
</tbody>
</table>
<h2>Formularios. Env&iacute;o de informaci&oacute;n por el m&eacute;todo POST</h2>
<p>Si usamos rutas din&aacute;micas estamos accediendo a la p&aacute;gina web usando el m&eacute;todo <strong>GET </strong>de forma predeterminada. Podemos crear rutas d&oacute;nde indiquemos que hemos usado el m&eacute;todo <strong>POST</strong> para recibir&nbsp; la informaci&oacute;n. Veamos un ejemplo:</p>
<pre>from bottle import Bottle,route,run,request
@route('/login') 
def login():
    return '''
        <form action="/login" method="post">
            Username: <input name="username" type="text" />
            Password: <input name="password" type="password" />
            <input value="Login" type="submit" />
        </form>'''

@route('/login',method='POST') 
def do_login():
    username = request.forms.get('username')
    password = request.forms.get('password')
    if username=="pepe" and password=="asdasd":
        return "<p>Your login information was correct.</p>"
    else:
        return "<p>Login failed.</p>"

run(host='localhost', port=8080)</pre>
<ul>
<li>En este ejemplo hemos definido dos rutas que se correponden con la misma URL, pero la segunda ser&aacute; seleccionada cuando se haya enviado informaci&oacute;n usando el m&eacute;todo POST (en este ejemplo se env&iacute;a la informaci&oacute;n de un formulario usando ese m&eacute;todo).</li>
<li>El objeto <code>request</code> almacena la informaci&oacute;n recibida. Con el m&eacute;todo <code>request.forms.get</code> podemos obtener el par&aacute;metro que indicamos con el atributo <em>name</em> en el elemento<em> input</em> del formulario.</li>
</ul>
<table>
<tbody>
<tr>
<td><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle4.png"><img class="aligncenter size-full wp-image-1301" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle4.png" alt="bottle4" width="315" height="153" /></a></td>
<td style="text-align: center;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle5.png"><img class="aligncenter size-full wp-image-1302" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle5.png" alt="bottle5" width="319" height="82" /></a></td>
</tr>
</tbody>
</table>
<p>Todos los ejemplos que hemos estudiado lo puedes encontrar en el siguiente repositorio GitHub: <a href="https://github.com/josedom24/bottle_lm">https://github.com/josedom24/bottle_lm</a>. En la <a href="http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-trabajando-con-plantillas-2a-parte">pr&oacute;xima entrada</a>, estudiaremos las plantillas de bottle, que nos permitir&aacute;n el desarrollo de p&aacute;ginas web de una forma muy sencilla y flexible.</p>
