---
layout: post
status: publish
published: true
title: 'Introducci&oacute;n a django: creaci&oacute;n de una aplicaci&oacute;n CRUD'
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 628
wordpress_url: http://www.josedomingo.org/pledin/?p=628
date: '2012-01-31 00:01:46 +0000'
date_gmt: '2012-01-30 23:01:46 +0000'
categories:
- General
tags:
- Web 2.0
- Python
- django
comments:
- id: 188
  author: joel
  author_email: joel11_23@hotmail.com
  author_url: http://notengo
  date: '2012-04-17 18:14:45 +0000'
  date_gmt: '2012-04-17 16:14:45 +0000'
  content: Exelente, simple y super interesante, arriba con este tipo de post
---
<p><img class="alignleft" src="https://www.djangoproject.com/m/img/site/hdr_logo.gif" alt="" width="117" height="41" /></p>
<p>En este art&iacute;culo vamos a introducir los conceptos fundamentales del framework <a href="https://www.djangoproject.com/">django</a> para ello lo vamos a hacer a partir de un desarrollo de una aplicaci&oacute;n <a href="http://es.wikipedia.org/wiki/CRUD">CRUD</a> muy sencilla. Seg&uacute;n la Wikipedia: <a href="http://es.wikipedia.org/wiki/Django"><strong>Django</strong></a> es un <a title="Framework" href="http://es.wikipedia.org/wiki/Framework">framework</a> de desarrollo web de <a title="Open Source" href="http://es.wikipedia.org/wiki/Open_Source">c&oacute;digo abierto</a>, escrito en <a title="Python" href="http://es.wikipedia.org/wiki/Python">Python</a>, que cumple en cierta medida el paradigma del <a title="Modelo Vista Controlador" href="http://es.wikipedia.org/wiki/Modelo_Vista_Controlador">Modelo Vista Controlador</a>. Nosotros suponemos que ya tenemos<a href="http://informatica.gonzalonazareno.org/plataforma/mod/page/view.php?id=4932"> instalada la herramienta</a> en nuestro sistema operativo Debian Squeeze, y vamos a desarrollar una aplicaci&oacute;n que nos permita crear, modificar, listar y eliminar informaci&oacute;n sobre enlaces webs.</p>
<p><strong>Comenzando nuestro proyecto</strong></p>
<p>Para crear un nuevo proyecto utilizamos la siguiente instrucci&oacute;n:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">django-admin startproject linkdump</pre>
<p>Nuestra aplicaci&oacute;n se va a llamar linkdump, el comando anterior crea un directorio linkdump en el que podemos encontrar los siguientes ficheros:</p>
<ul>
<li>__init__.py: Define nuestro directorio como un m&oacute;dulo Python v&aacute;lido.</li>
<li>manage.py: Utilidad para gestionar nuestro proyecto: arrancar servidor de pruebas, sincronizar modelos, etc.</li>
<li>settings.py: Configuraci&oacute;n del proyecto.</li>
<li>urls.py: Gesti&oacute;n de las urls. Este fichero ser&iacute;a el controlador de la aplicaci&oacute;n. Mapea las url entrantes a funciones Python definidas en m&oacute;dulos.</li>
</ul>
<p><!--more-->A continuaci&oacute;n vamos a definir los par&aacute;metros de acceso a nuestra base de datos, nosotros vamos a usar el gestor de base de datos mysql, para ello modificamos algunas l&iacute;neas del fichero settings.py:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">...
DATABASES = {
    'default': {
        'ENGINE': 'mysql',
        'NAME': 'bdurl',
        'USER': 'bduser',
        'PASSWORD': 'passuserbd',
        'HOST': '',
        'PORT': '',
    }
...</pre>
<p>Suponemos tambi&eacute;n que la base de datos ya ha sido creada. Y creamos las tablas necesarias para la administraci&oacute;n de nuestra p&aacute;gina con el comando:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">python manage.py syncdb</pre>
<p>Durante el proceso de creaci&oacute;n de las tablas se nos pide los datos del usuario administrador de nuestra p&aacute;gina: nombre de usuario, correo electr&oacute;nico y contrase&ntilde;a.<br />
<strong>Creando una aplicaci&oacute;n</strong><br />
Vamos a realizar una aplicaci&oacute;n simple que nos permita gestionar una tabla con informaci&oacute;n de enlaces URL. Par ello vamos a crear una aplicaci&oacute;n (que se llamar&aacute; linktracker) en nuestro proyecto:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">python manage.py startapp linktracker</pre>
<p>Vamos a crear el modelo de datos de nuestra aplicaci&oacute;n que consistir&aacute; en una tabla donde guardaremos dos campos: link_description y link_url, para ello a&ntilde;adimos en el fichero linktracker/models.py:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">from django.db import models

# Create your models here.
class Link (models.Model):
    link_description = models.CharField(max_length=200)
    link_url = models.CharField(max_length=200)</pre>
<p>A&ntilde;adimos nuestra aplicaci&oacute;n (linkdump.linktracker) en la lista INSTALLED_APPS que encontramos en el fichero settings.py y volvemos a actualiza nuestra base de datos, para crear la nueva tabla:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">python manage.py syncdb</pre>
<p>Para no complicar nuestro ejemplo no vamos a usar un m&eacute;todo de protecci&oacute;n que django implementa para el envio de formularios usando el m&eacute;todo post, por lo que comentamos la siguiente l&iacute;nea del fichero settings.py</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">#'django.middleware.csrf.CsrfViewMiddleware',</pre>
<p><strong>Activando el sitio de administraci&oacute;n</strong><br />
La aplicaci&oacute;n de administraci&oacute;n de nuestro sitio no est&aacute; activada por defecto, para hacerlo tenemos que descomentar de la lista INSTALLED_APPS que encontramos en settings.py la l&iacute;nea:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">'django.contrib.admin',</pre>
<p>y volvemos a actualizar nuestra base de datos para crear los elementos necesarios para la aplicaci&oacute;n de administraci&oacute;n:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">python manage.py syncdb</pre>
<p>Para que funcione nuestra p&aacute;gina de administraci&oacute;n tenemos que descomentar en el fichero urls.py la l&iacute;nea referida a la aplicaci&oacute;n admin:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">from django.conf.urls.defaults import *

# Uncomment the next two lines to enable the admin:
<strong>from django.contrib import admin</strong>
<strong>admin.autodiscover()</strong>

urlpatterns = patterns('',
    # Example:
    # (r'^linkdump/', include('linkdump.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    <strong>url (r'^admin/', include(admin.site.urls)),</strong>
)</pre>
<p>Activamos nuestro servidor web y probamos la p&aacute;gina de administraci&oacute;n:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">python manage.py runserver</pre>
<p>El siguiente paso es hacer que nuestra tabla con la informaci&oacute;n de los links pueda ser gestionada desde la p&aacute;gina de administraci&oacute;n, para ello creamos un nuevo fichero llamado admin.py dentro de la carpeta de nuestra aplicaci&oacute;n linktracker con el siguiente contenido:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">from linktracker.models import Link
from django.contrib import admin

admin.site.register(Link)</pre>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2012/01/Pantallazo-11.png"><img class="alignnone size-full wp-image-635" title="Pantallazo-1" src="http://www.josedomingo.org/pledin/wp-content/uploads/2012/01/Pantallazo-11-e1327963848392.png" alt="" width="449" height="151" /></a><br />
<strong>A&ntilde;adiendo funciones a nuestra p&aacute;gina</strong></p>
<p>Para ello tenemos que ir a&ntilde;adiendo a nuestro controlador las acciones que e realizar&aacute;n al acceder a determinadas URL. Para ello vamos a crear nuestra primera vista donde mostraremos los datos de nuestra tabla. Modificamos el fichero urls.py y a&ntilde;adimos los siguiente:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">url (r'^links/$', 'linkdump.linktracker.views.list'),</pre>
<p>Muchas de las vistas que vamos a crear utilizan una plantilla html (template). Para guardar estas plantillas crea un directorio llamado template dentro de tu aplicaci&oacute;n y a&ntilde;&aacute;delo a la lista TEMPLATE_DIRS que encontrar&aacute;s en el fichero settings.py. Para crear la vista "list" a&ntilde;adimos el siguiente contenido al fichero linktracker/views.py:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">from django.core.context_processors import csrf
from linkdump.linktracker.models import Link
from django.template import Context, loader
from django.shortcuts import render_to_response
def list(request):
    link_list = Link.objects.all()
    return render_to_response(
        'links/list.html',
        {'link_list': link_list}
    )</pre>
<p>Y creamos la plantilla en linktracker/template/links/list.html:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">{% if link_list %}
    <ul>
         {% for link in link_list %}
             <li><a href='{{ link.link_url }}'>
                 {{link.link_description}}</a></li>
         {% endfor %}
    </ul>
{% else %}
    <p>No links found.</p>
{% endif %}</pre>
<p>Inicia el servidor web y accede a http://127.0.0.1/:8000/links y ver&aacute;s los resultados.</p>
<p><strong>Preparando nuestra aplicaci&oacute;n CRUD (create, read, update y delete)</strong></p>
<p>Hasta ahora tenemos una vista que nos muestra los links que tenemos guardados en nuestra tabla. A continuaci&oacute;n necesitamos modificar nuestra vista para que acepte par&aacute;metros get de tal forma que podamos indicarles que operaci&oacute;n queremos realizar: a&ntilde;adir, modificar, borrar... Para ello en linktracker/views.py tenemos que realizar dos cambios: cambiamos la definici&oacute;n del m&eacute;todo list y a&ntilde;adimos el par&aacute;metro message para que se transmita en cada llamada, quedar&iacute;a as&iacute;:</p>
<pre class="brush: actionscript3; gutter: true; first-line: 1">from linkdump.linktracker.models import Link
from django.template import Context, loader
from django.shortcuts import render_to_response
<strong>def list(request, message = ""):</strong>
    link_list = Link.objects.all()
    return render_to_response(
        'links/list.html',
        {'link_list': link_list,
        <strong>'message': message</strong>
        }
    )</pre>
<p>Y modificamos la plantilla:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">{% if message %}
 <b>{{ message }}</b>
 <p>
 {% endif %}
 {% if link_list %}
     <table>
     {% for link in link_list %}
         <tr bgcolor='{% cycle FFFFFF,EEEEEE as rowcolor %}'>
              <td><a href='{{ link.link_url }}'>{{ link.link_description }}</a></td>
              <td><a href='/links/edit/{{ link.id }}'>Edit</a></td>
              <td><a href='/links/delete/{{ link.id }}'>Delete</a></td>
         </tr>
     {% endfor %}
     </table>
     <p>
 {% else %}
     <p>No links found.</p>
 {% endif %}
 <p>
 <a href='/links/new'>Add Link</a></pre>
<p><strong>A&ntilde;adir enlaces</strong></p>
<p>Es hora de dar una nueva funcionalidad a nuestra p&aacute;gina, en este caso vamos a a&ntilde;adir dos nuevas acciones: new, que muestra el formulario para a&ntilde;adir un nuevo en lace y add que es la encargada de guardar un nuevo registro en la base de datos. Para ello a&ntilde;adimos dos nuevas l&iacute;neas en el fichero urls.py:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">url (r'^links/new', 'linkdump.linktracker.views.new'),
url (r'^links/add', 'linkdump.linktracker.views.add'),</pre>
<p>Y definimos los dos nuevos m&eacute;todos en nuestra vista (linktracker/views.py):</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">def new(request):
    return render_to_response(
        'links/form.html',
        {'action': 'add',
        'button': 'Add'}
    )

def add(request):
    link_description = request.POST["link_description"]
    link_url = request.POST["link_url"]
    link = Link(
        link_description = link_description,
        link_url = link_url
    )
    link.save()
    return list(request, message="Link added!")</pre>
<p>Y creamos la&nbsp; plantilla linktrcker/template/links/form.html:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1"><form action="/links/{{ action }}/" method="post">
    Description:
    <input name=link_description value="{{ description }}"><br />
    URL:
    <input name=link_url value="{{ url }}"><br />
    <input type=submit value="{{ button }}">
</form></pre>
<p><strong>Modificando enlaces</strong><br />
Vamos a a&ntilde;adir una nueva funcionalidad de modificar la informaci&oacute;n de un enlace, en este caso en la URL tenemos que indicar que enlace vamos a modificar, para ello a&ntilde;adimos una nueva acci&oacute;n en urls.py:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">url (r'^links/edit/(?P<id>\d+)', 'linkdump.linktracker.views.edit'),</pre>
<p>Creamos un nuevo m&eacute;todo en nuestra vista (linktracker/views.py), f&iacute;jate que vamos a usar la misma plantilla que ne le punto anterior:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">def edit(request, id):
    link = Link.objects.get(id=id)
    return render_to_response(
        'links/form.html',
        {'action': 'update/' + id,
        'button': 'Update',
        'description': link.link_description,
        'url': link.link_url
        }
    )</pre>
<p>Por &uacute;ltimo hacemos algo similar para la acci&oacute;n update que modifica en la base de datos el dato, a&ntilde;adimos en urls.py:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">url (r'^links/update/(?P<id>\d+)', 'linkdump.linktracker.views.update'),</pre>
<p>Y en la vista (linktracker/views.py) un nuevo m&eacute;todo:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">def update(request, id):
    link = Link.objects.get(id=id)
    link.link_description = request.POST["link_description"]
    link.link_url = request.POST["link_url"]
    link.save()
    return list(request, message="Link updated!")</pre>
<p><strong>Borrando enlaces</strong><br />
Para terminar a&ntilde;adamos la opci&oacute;n de borrar un enlace, para ello volvemos a a&ntilde;adir una nueva&nbsp; acci&oacute;n al fichero urls.py:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">url (r'^links/delete/(?P<id>\d+)', 'linkdump.linktracker.views.delete'),</pre>
<p>Y a&ntilde;adimos el m&eacute;todo correspondiente en linktracker/views.py:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">def delete(request, id):
    Link.objects.get(id=id).delete()
    return list(request, message="Link deleted!")</pre>
<p>Bueno, esto esto arrancando el servidor web del framework puedes ver como funciona:</p>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2012/01/Pantallazo1.png"><img class="alignnone size-full wp-image-636" title="Pantallazo" src="http://www.josedomingo.org/pledin/wp-content/uploads/2012/01/Pantallazo1.png" alt="" width="296" height="186" /></a></p>
