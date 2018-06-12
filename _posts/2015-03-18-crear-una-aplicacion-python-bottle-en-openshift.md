---
id: 1335
title: Crear una aplicación python bottle en Openshift
date: 2015-03-18T16:26:28+00:00


guid: http://www.josedomingo.org/pledin/?p=1335
permalink: /2015/03/crear-una-aplicacion-python-bottle-en-openshift/


tags:
  - bottle
  - OpenShift
  - Python
  - Web
---
[<img class="aligncenter wp-image-1336 size-medium" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_openshift-300x134.jpg" alt="bottle_openshift" width="300" height="134" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_openshift-300x134.jpg 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_openshift.jpg 580w" sizes="(max-width: 300px) 100vw, 300px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_openshift.jpg){.thumbnail}En las entradas anteriores, hemos visto como crear una aplicación web con python usando el framework Bottle ([1ª parte](http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-python-web-framework_1a_parte/ "Crear páginas web con Bottle: Python Web Framework (1ª parte)") y [2ª parte](http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-trabajando-con-plantillas-2a-parte/ "Crear páginas web con Bottle. Trabajando con plantillas (2ª parte)")). En la entrada actual vamos a estudiar como desplegar una aplicación bottle en una infraestructura PaaS, concretamente en [OpenShift](http://www.openshift.com).

De forma resumida el procedimiento será crear una aplicación en OpenShift con el componente (cartridge) _python 2.7_, e inicializar esta aplicación con la librería de bottle y una distribución del framework configurado para que funcione en OpenShift.

<!--more-->

## Creación de la aplicación OpenShift

Vamos a dar de alta un nuevo proyecto OpenShift, como componente software vamos a instalar el cartridge _Python 2.7_.

[<img class=" size-full wp-image-1338 alignnone" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os1.png" alt="os1" width="469" height="81" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os1.png 469w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os1-300x52.png 300w" sizes="(max-width: 469px) 100vw, 469px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os1.png){.thumbnail}

<p style="text-align: left;">
  A continuación vamos a configurar la nueva aplicación, indicando su nombre, y el repositorio git donde podemos obtener la versión de bottle configurada para OpenShift, ese repositorio lo encontramos en GitHub y su dirección es:
</p>

<pre>https://github.com/openshift-quickstart/bottle-openshift-quickstart.git</pre>

Quedando de esta manera:

[<img class=" size-full wp-image-1339 alignnone" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os2.png" alt="os2" width="772" height="404" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os2.png 772w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os2-300x157.png 300w" sizes="(max-width: 772px) 100vw, 772px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os2.png){.thumbnail}

Una vez creada la aplicación podemos clonar el repositorio git, y obtenemos los ficheros del framework bottle con los que empezar a trabajar:

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
data  libs  README.md  setup.py  wsgi</pre>

## El fichero setup.py

El primer fichero que nos interesa es _setup.py_ que nos permite configurar nuestra aplicación.

<pre>$ cat setup.py 
from setuptools import setup
setup(name='YourAppName',
      version='1.0',
      description='OpenShift App',
      author='Your Name',
      author_email='example@example.com',
      url='http://www.python.org/sigs/distutils-sig/',
      install_requires=['bottle'],
     )</pre>

Puedes cambiar la información del nombre, versión, descripción y autor de la aplicación. Lo que más nos interesa es la última línea donde definimos una lista con las librerías python que se tienen que instalar en nuestro proyecto de OpenShift (observamos que la librería bottle está instalada). Si queremos, por ejemplo, instalar la librería _lxml_ para trabajar con ficheros xml, tendríamos que modificar el fichero, dejando la última línea de la siguiente manera:

<pre>install_requires=['bottle','lxml'],</pre>

Cuando subamos el fichero modificado a OpenShift se instalarán las nuevas librearías que hayamos indicado en la lista.

## El fichero wsgi/mybottleapp.py

En el directorio _wsgi_ encontramos la aplicación wsgi, en el fichero _application_ (ese fichero no es necesario modificarlo), y el fichero donde voy a escribir mi programa python que se llama _mybottleapp.py._ Por ejemplo podríamos tener el siguiente contenido:

<pre>from bottle import route, default_app

@route('/name/&lt;name&gt;')
def nameindex(name='Stranger'):
    return '&lt;strong&gt;Hello, %s!&lt;/strong&gt;' % name
 
@route('/')
def index():
    return '&lt;strong&gt;Hello World!&lt;/strong&gt;'

# This must be added in order to do correct path lookups for the views
import os
from bottle import TEMPLATE_PATH
TEMPLATE_PATH.append(os.path.join(os.environ['OPENSHIFT_REPO_DIR'], 'wsgi/views/')) 

application=default_app()</pre>

Si acedemos a la aplicación:

[<img class=" size-full wp-image-1347 alignnone" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os3.png" alt="os3" width="323" height="95" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os3.png 323w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os3-300x88.png 300w" sizes="(max-width: 323px) 100vw, 323px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os3.png){.thumbnail}

## Trabajando con plantillas

Las plantillas deben estar guardadas en un directorio llamado _views_ que tenemos que crear en el directorio _wsgi._ Siguiendo un ejemplo que vimos en la [entrada anterior](http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-trabajando-con-plantillas-2a-parte/ "Crear páginas web con Bottle. Trabajando con plantillas (2ª parte)"), vamos a crear la platilla _template_hello.tpl_ en un directorio _views_ que previamente hemos creado. El contenido de este fichero sería:

<pre>&lt;!DOCTYPE html&gt;
&lt;html lang="es"&gt;
&lt;head&gt;
<strong>&lt;title&gt;Hola, que tal {{nombre}}&lt;/title&gt;</strong>
&lt;meta charset="utf-8" /&gt;
&lt;/head&gt;
 
&lt;body&gt;
    &lt;header&gt;
       &lt;h1&gt;Mi sitio web&lt;/h1&gt;
       &lt;p&gt;Mi sitio web creado en html5&lt;/p&gt;
    &lt;/header&gt;
    &lt;h2&gt;Vamos a saludar&lt;/h2&gt;
   <strong> % if nombre=="Mundo":</strong>
<strong>      &lt;p&gt; Hola &lt;strong&gt;{{nombre}}&lt;/strong&gt;&lt;/p&gt;</strong>
<strong>    %else:</strong>
<strong>      &lt;h1&gt;Hola {{nombre.title()}}!&lt;/h1&gt;</strong>
<strong>      &lt;p&gt;¿Cómo estás?</strong>
<strong>    %end</strong>
&lt;/body&gt;
&lt;/html&gt;
</pre>

A continuación añadimos una nueva ruta a nuestro programa bottle en el fichero _myappbottle.py:_

<pre>from bottle import route, default_app, <strong>template</strong>
...
@route('/hello/')
@route('/hello/&lt;name&gt;')
def hello(name='Mundo'):
    return template('template_hello.tpl', nombre=name)
...
</pre>

Subimos los cambios al repositorio git:

<pre>$ git add views/template_hello.tpl
$ git commit -am "Uso de una plantilla"
$ git push</pre>

Y comprobamos el resultado:

[<img class="alignnone size-full wp-image-1348" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os4.png" alt="os4" width="339" height="317" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os4.png 339w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os4-300x281.png 300w" sizes="(max-width: 339px) 100vw, 339px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os4.png){.thumbnail}

## Servir contenido estático

De forma similar a como vimos en la [entrada anterior](http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-trabajando-con-plantillas-2a-parte/ "Crear páginas web con Bottle. Trabajando con plantillas (2ª parte)"), hay que definir una ruta que nos permita servir contenido estático: imágenes, hojas de estilo, documentos,&#8230; En este caso la ruta que tenemos que poner nos va a permitir servir todos los ficheros que se encuentren en el directorio _wsgi/static_ o en algún subdirectorio dentro del mismo.

<pre>from bottle import route, default_app, template,<strong>static_file</strong>
...
@route('/static/&lt;filepath:path&gt;')
def server_static(filepath):
    return static_file(filepath, <span class="pl-vpf">root</span><span class="pl-k">=</span>os.environ[<span class="pl-s1"><span class="pl-pds">'</span>OPENSHIFT_REPO_DIR<span class="pl-pds">'</span></span>]<span class="pl-k">+</span><span class="pl-s1"><span class="pl-pds">"</span>wsgi/static<span class="pl-pds">"</span></span>)
...</pre>

Suponiendo que hemos guardado una imagen en el directorio _static_ y la hemos subido al repositorio git, podemos acceder a ella de esta forma:

[<img class="alignnone size-full wp-image-1352" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os5.png" alt="os5" width="431" height="371" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os5.png 431w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os5-300x258.png 300w" sizes="(max-width: 431px) 100vw, 431px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os5.png){.thumbnail}

## Accediendo al log de errores

Durante la codificación de nuestro programa podemos obtener algún código de error, para obtener más información de dicho error tenemos que acceder al fichero del log de nuestra aplicación, para ello tenemos que acceder a nuestra aplicación y obtener el contenido del siguiente fichero:

<pre>ssh 55096945e0b8cd85fa0000d9@bottle-iesgn.rhcloud.com
&gt; tailf app-root/logs/python.log</pre>

Con este artículo termino una serie de entradas en las que he tratado de introducir la manera de crear aplicaciones web utilizando el lenguaje de programación python. Espero que haya sido de utilidad.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->