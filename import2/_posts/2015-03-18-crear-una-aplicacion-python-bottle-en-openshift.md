---
layout: post
status: publish
published: true
title: Crear una aplicaci&oacute;n python bottle en Openshift
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1335
wordpress_url: http://www.josedomingo.org/pledin/?p=1335
date: '2015-03-18 16:26:28 +0000'
date_gmt: '2015-03-18 15:26:28 +0000'
categories:
- General
tags:
- Web
- Python
- OpenShift
- bottle
comments: []
---
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle_openshift.jpg"><img class="aligncenter wp-image-1336 size-medium" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle_openshift-300x134.jpg" alt="bottle_openshift" width="300" height="134" /></a>En las entradas anteriores, hemos visto como crear una aplicaci&oacute;n web con python usando el framework Bottle (<a title="Crear p&aacute;ginas web con Bottle: Python Web Framework (1&ordf; parte)" href="http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-python-web-framework_1a_parte/">1&ordf; parte</a> y <a title="Crear p&aacute;ginas web con Bottle. Trabajando con plantillas (2&ordf; parte)" href="http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-trabajando-con-plantillas-2a-parte/">2&ordf; parte</a>). En la entrada actual vamos a estudiar como desplegar una aplicaci&oacute;n bottle en una infraestructura PaaS, concretamente en <a href="http://www.openshift.com">OpenShift</a>.</p>
<p>De forma resumida el procedimiento ser&aacute; crear una aplicaci&oacute;n en OpenShift con el componente (cartridge) <em>python 2.7</em>, e inicializar esta aplicaci&oacute;n con la librer&iacute;a de bottle y una distribuci&oacute;n del framework configurado para que funcione en OpenShift.</p>
<p><!--more--></p>
<h2>Creaci&oacute;n de la aplicaci&oacute;n OpenShift</h2>
<p>Vamos a dar de alta un nuevo proyecto OpenShift, como componente software vamos a instalar el cartridge <em>Python 2.7</em>.</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/os1.png"><img class=" size-full wp-image-1338 alignnone" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/os1.png" alt="os1" width="469" height="81" /></a></p>
<p style="text-align: left;">A continuaci&oacute;n vamos a configurar la nueva aplicaci&oacute;n, indicando su nombre, y el repositorio git donde podemos obtener la versi&oacute;n de bottle configurada para OpenShift, ese repositorio lo encontramos en GitHub y su direcci&oacute;n es:</p>
<pre>https://github.com/openshift-quickstart/bottle-openshift-quickstart.git</pre>
<p>Quedando de esta manera:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/os2.png"><img class=" size-full wp-image-1339 alignnone" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/os2.png" alt="os2" width="772" height="404" /></a></p>
<p>Una vez creada la aplicaci&oacute;n podemos clonar el repositorio git, y obtenemos los ficheros del framework bottle con los que empezar a trabajar:</p>
<pre>$ git clone ssh://55096945e0b8cd85fa0000d9@bottle-iesgn.rhcloud.com/~/git/bottle.git/
Cloning into 'bottle'...
The authenticity of host 'bottle-iesgn.rhcloud.com (54.237.128.196)' can't be established.
RSA key fingerprint is cf:ee:77:cb:0e:fc:02:d7:72:7e:ae:80:c0:90:88:a7.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'bottle-iesgn.rhcloud.com,54.237.128.196' (RSA) to the list of known hosts.
remote: Counting objects: 60, done.
remote: Compressing objects: 100% (32/32), done.
remote: Total 60 (delta 23), reused 60 (delta 23)
Receiving objects: 100% (60/60), 7.98 KiB, done.
Resolving deltas: 100% (23/23), done.
$ cd bottle/
~/bottle$ ls
data&nbsp; libs&nbsp; README.md&nbsp; setup.py&nbsp; wsgi</pre>
<h2>El fichero setup.py</h2>
<p>El primer fichero que nos interesa es <em>setup.py </em>que nos permite configurar nuestra aplicaci&oacute;n.</p>
<pre>$ cat setup.py 
from setuptools import setup
setup(name='YourAppName',
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; version='1.0',
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; description='OpenShift App',
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; author='Your Name',
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; author_email='example@example.com',
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; url='http://www.python.org/sigs/distutils-sig/',
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; install_requires=['bottle'],
&nbsp;&nbsp;&nbsp;&nbsp; )</pre>
<p>Puedes cambiar la informaci&oacute;n del nombre, versi&oacute;n, descripci&oacute;n y autor de la aplicaci&oacute;n. Lo que m&aacute;s nos interesa es la &uacute;ltima l&iacute;nea donde definimos una lista con las librer&iacute;as python que se tienen que instalar en nuestro proyecto de OpenShift (observamos que la librer&iacute;a bottle est&aacute; instalada). Si queremos, por ejemplo, instalar la librer&iacute;a <em>lxml</em> para trabajar con ficheros xml, tendr&iacute;amos que modificar el fichero, dejando la &uacute;ltima l&iacute;nea de la siguiente manera:</p>
<pre>install_requires=['bottle','lxml'],</pre>
<p>Cuando subamos el fichero modificado a OpenShift se instalar&aacute;n las nuevas librear&iacute;as que hayamos indicado en la lista.</p>
<h2>El fichero wsgi/mybottleapp.py</h2>
<p>En el directorio <em>wsgi </em>encontramos la aplicaci&oacute;n wsgi, en el fichero <em>application </em>(ese fichero no es necesario modificarlo), y el fichero donde voy a escribir mi programa python que se llama <em>mybottleapp.py.</em> Por ejemplo podr&iacute;amos tener el siguiente contenido:</p>
<pre>from bottle import route, default_app

@route('/name/<name>')
def nameindex(name='Stranger'):
&nbsp;&nbsp;&nbsp; return '<strong>Hello, %s!</strong>' % name
&nbsp;
@route('/')
def index():
&nbsp;&nbsp;&nbsp; return '<strong>Hello World!</strong>'

# This must be added in order to do correct path lookups for the views
import os
from bottle import TEMPLATE_PATH
TEMPLATE_PATH.append(os.path.join(os.environ['OPENSHIFT_REPO_DIR'], 'wsgi/views/')) 

application=default_app()</pre>
<p>Si acedemos a la aplicaci&oacute;n:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/os3.png"><img class=" size-full wp-image-1347 alignnone" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/os3.png" alt="os3" width="323" height="95" /></a></p>
<h2>Trabajando con plantillas</h2>
<p>Las plantillas deben estar guardadas en un directorio llamado <em>views </em>que tenemos que crear en el directorio <em>wsgi. </em>Siguiendo un ejemplo que vimos en la <a title="Crear p&aacute;ginas web con Bottle. Trabajando con plantillas (2&ordf; parte)" href="http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-trabajando-con-plantillas-2a-parte/">entrada anterior</a>, vamos a crear la platilla <em>template_hello.tpl </em>en un directorio <em>views </em>que previamente hemos creado. El contenido de este fichero ser&iacute;a:</p>
<pre><!DOCTYPE html>
<html lang="es">
<head>
<strong><title>Hola, que tal {{nombre}}</title></strong>
<meta charset="utf-8" />
</head>
&nbsp;
<body>
&nbsp;&nbsp;&nbsp; <header>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <h1>Mi sitio web</h1>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <p>Mi sitio web creado en html5</p>
&nbsp;&nbsp;&nbsp; </header>
&nbsp;&nbsp;&nbsp; <h2>Vamos a saludar</h2>
&nbsp;&nbsp;&nbsp;<strong> % if nombre=="Mundo":</strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <p> Hola <strong>{{nombre}}</strong></p></strong>
<strong>&nbsp;&nbsp;&nbsp; %else:</strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <h1>Hola {{nombre.title()}}!</h1></strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <p>&iquest;C&oacute;mo est&aacute;s?</strong>
<strong>&nbsp;&nbsp;&nbsp; %end</strong>
</body>
</html>
</pre>
<p>A continuaci&oacute;n a&ntilde;adimos una nueva ruta a nuestro programa bottle en el fichero <em>myappbottle.py:</em></p>
<pre>from bottle import route, default_app, <strong>template</strong>
...
@route('/hello/')
@route('/hello/<name>')
def hello(name='Mundo'):
&nbsp;&nbsp;&nbsp; return template('template_hello.tpl', nombre=name)
...
</pre>
<p>Subimos los cambios al repositorio git:</p>
<pre>$ git add views/template_hello.tpl
$ git commit -am "Uso de una plantilla"
$ git push</pre>
<p>Y comprobamos el resultado:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/os4.png"><img class="alignnone size-full wp-image-1348" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/os4.png" alt="os4" width="339" height="317" /></a></p>
<h2>Servir contenido est&aacute;tico</h2>
<p>De forma similar a como vimos en la <a title="Crear p&aacute;ginas web con Bottle. Trabajando con plantillas (2&ordf; parte)" href="http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-trabajando-con-plantillas-2a-parte/">entrada anterior</a>, hay que definir una ruta que nos permita servir contenido est&aacute;tico: im&aacute;genes, hojas de estilo, documentos,... En este caso la ruta que tenemos que poner nos va a permitir servir todos los ficheros que se encuentren en el directorio <em>wsgi/static</em> o en alg&uacute;n subdirectorio dentro del mismo.</p>
<pre>from bottle import route, default_app, template,<strong>static_file</strong>
...
@route('/static/<filepath:path>')
def server_static(filepath):
    return static_file(filepath, <span class="pl-vpf">root</span><span class="pl-k">=</span>os.environ[<span class="pl-s1"><span class="pl-pds">'</span>OPENSHIFT_REPO_DIR<span class="pl-pds">'</span></span>]<span class="pl-k">+</span><span class="pl-s1"><span class="pl-pds">"</span>wsgi/static<span class="pl-pds">"</span></span>)
...</pre>
<p>Suponiendo que hemos guardado una imagen en el directorio <em>static </em>y la hemos subido al repositorio git, podemos acceder a ella de esta forma:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/os5.png"><img class="alignnone size-full wp-image-1352" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/os5.png" alt="os5" width="431" height="371" /></a></p>
<h2>Accediendo al log de errores</h2>
<p>Durante la codificaci&oacute;n de nuestro programa podemos obtener alg&uacute;n c&oacute;digo de error, para obtener m&aacute;s informaci&oacute;n de dicho error tenemos que acceder al fichero del log de nuestra aplicaci&oacute;n, para ello tenemos que acceder a nuestra aplicaci&oacute;n y obtener el contenido del siguiente fichero:</p>
<pre>ssh 55096945e0b8cd85fa0000d9@bottle-iesgn.rhcloud.com
> tailf app-root/logs/python.log</pre>
<p>Con este art&iacute;culo termino una serie de entradas en las que he tratado de introducir la manera de crear aplicaciones web utilizando el lenguaje de programaci&oacute;n python. Espero que haya sido de utilidad.</p>
