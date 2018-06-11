---
id: 628
title: 'Introducción a django: creación de una aplicación CRUD'
date: 2012-01-31T00:01:46+00:00


guid: http://www.josedomingo.org/pledin/?p=628
permalink: /2012/01/introduccion-a-django-creacion-de-una-aplicacion-crud/


tags:
  - django
  - Python
  - Web 2.0
---
<img class="alignleft" src="https://www.djangoproject.com/m/img/site/hdr_logo.gif" alt="" width="117" height="41" />

En este artículo vamos a introducir los conceptos fundamentales del framework [django](https://www.djangoproject.com/) para ello lo vamos a hacer a partir de un desarrollo de una aplicación [CRUD](http://es.wikipedia.org/wiki/CRUD) muy sencilla. Según la Wikipedia: [**Django**](http://es.wikipedia.org/wiki/Django) es un [framework](http://es.wikipedia.org/wiki/Framework "Framework") de desarrollo web de [código abierto](http://es.wikipedia.org/wiki/Open_Source "Open Source"), escrito en [Python](http://es.wikipedia.org/wiki/Python "Python"), que cumple en cierta medida el paradigma del [Modelo Vista Controlador](http://es.wikipedia.org/wiki/Modelo_Vista_Controlador "Modelo Vista Controlador"). Nosotros suponemos que ya tenemos [instalada la herramienta](http://informatica.gonzalonazareno.org/plataforma/mod/page/view.php?id=4932) en nuestro sistema operativo Debian Squeeze, y vamos a desarrollar una aplicación que nos permita crear, modificar, listar y eliminar información sobre enlaces webs.

**Comenzando nuestro proyecto**

Para crear un nuevo proyecto utilizamos la siguiente instrucción:

<pre class="brush: actionscript3; gutter: false; first-line: 1">django-admin startproject linkdump</pre>

Nuestra aplicación se va a llamar linkdump, el comando anterior crea un directorio linkdump en el que podemos encontrar los siguientes ficheros:

  * \_\_init\_\_.py: Define nuestro directorio como un módulo Python válido.
  * manage.py: Utilidad para gestionar nuestro proyecto: arrancar servidor de pruebas, sincronizar modelos, etc.
  * settings.py: Configuración del proyecto.
  * urls.py: Gestión de las urls. Este fichero sería el controlador de la aplicación. Mapea las url entrantes a funciones Python definidas en módulos.

<!--more-->A continuación vamos a definir los parámetros de acceso a nuestra base de datos, nosotros vamos a usar el gestor de base de datos mysql, para ello modificamos algunas líneas del fichero settings.py:

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

Suponemos también que la base de datos ya ha sido creada. Y creamos las tablas necesarias para la administración de nuestra página con el comando:

<pre class="brush: actionscript3; gutter: false; first-line: 1">python manage.py syncdb</pre>

Durante el proceso de creación de las tablas se nos pide los datos del usuario administrador de nuestra página: nombre de usuario, correo electrónico y contraseña.
  
**Creando una aplicación**
  
Vamos a realizar una aplicación simple que nos permita gestionar una tabla con información de enlaces URL. Par ello vamos a crear una aplicación (que se llamará linktracker) en nuestro proyecto:

<pre class="brush: actionscript3; gutter: false; first-line: 1">python manage.py startapp linktracker</pre>

Vamos a crear el modelo de datos de nuestra aplicación que consistirá en una tabla donde guardaremos dos campos: link\_description y link\_url, para ello añadimos en el fichero linktracker/models.py:

<pre class="brush: actionscript3; gutter: false; first-line: 1">from django.db import models

# Create your models here.
class Link (models.Model):
    link_description = models.CharField(max_length=200)
    link_url = models.CharField(max_length=200)</pre>

Añadimos nuestra aplicación (linkdump.linktracker) en la lista INSTALLED_APPS que encontramos en el fichero settings.py y volvemos a actualiza nuestra base de datos, para crear la nueva tabla:

<pre class="brush: actionscript3; gutter: false; first-line: 1">python manage.py syncdb</pre>

Para no complicar nuestro ejemplo no vamos a usar un método de protección que django implementa para el envio de formularios usando el método post, por lo que comentamos la siguiente línea del fichero settings.py

<pre class="brush: actionscript3; gutter: false; first-line: 1">#'django.middleware.csrf.CsrfViewMiddleware',</pre>

**Activando el sitio de administración**
  
La aplicación de administración de nuestro sitio no está activada por defecto, para hacerlo tenemos que descomentar de la lista INSTALLED_APPS que encontramos en settings.py la línea:

<pre class="brush: actionscript3; gutter: false; first-line: 1">'django.contrib.admin',</pre>

y volvemos a actualizar nuestra base de datos para crear los elementos necesarios para la aplicación de administración:

<pre class="brush: actionscript3; gutter: false; first-line: 1">python manage.py syncdb</pre>

Para que funcione nuestra página de administración tenemos que descomentar en el fichero urls.py la línea referida a la aplicación admin:

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

Activamos nuestro servidor web y probamos la página de administración:

<pre class="brush: actionscript3; gutter: false; first-line: 1">python manage.py runserver</pre>

El siguiente paso es hacer que nuestra tabla con la información de los links pueda ser gestionada desde la página de administración, para ello creamos un nuevo fichero llamado admin.py dentro de la carpeta de nuestra aplicación linktracker con el siguiente contenido:

<pre class="brush: actionscript3; gutter: false; first-line: 1">from linktracker.models import Link
from django.contrib import admin

admin.site.register(Link)</pre>

[<img class="alignnone size-full wp-image-635" title="Pantallazo-1" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/Pantallazo-11-e1327963848392.png" alt="" width="449" height="151" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/Pantallazo-11-e1327963848392.png 749w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/Pantallazo-11-e1327963848392-300x100.png 300w" sizes="(max-width: 449px) 100vw, 449px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/Pantallazo-11.png)
  
**Añadiendo funciones a nuestra página**

Para ello tenemos que ir añadiendo a nuestro controlador las acciones que e realizarán al acceder a determinadas URL. Para ello vamos a crear nuestra primera vista donde mostraremos los datos de nuestra tabla. Modificamos el fichero urls.py y añadimos los siguiente:

<pre class="brush: actionscript3; gutter: false; first-line: 1">url (r'^links/$', 'linkdump.linktracker.views.list'),</pre>

Muchas de las vistas que vamos a crear utilizan una plantilla html (template). Para guardar estas plantillas crea un directorio llamado template dentro de tu aplicación y añádelo a la lista TEMPLATE_DIRS que encontrarás en el fichero settings.py. Para crear la vista &#8220;list&#8221; añadimos el siguiente contenido al fichero linktracker/views.py:

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

Y creamos la plantilla en linktracker/template/links/list.html:

<pre class="brush: actionscript3; gutter: false; first-line: 1">{% if link_list %}
    &lt;ul&gt;
         {% for link in link_list %}
             &lt;li&gt;&lt;a href='{{ link.link_url }}'&gt;
                 {{link.link_description}}&lt;/a&gt;&lt;/li&gt;
         {% endfor %}
    &lt;/ul&gt;
{% else %}
    &lt;p&gt;No links found.&lt;/p&gt;
{% endif %}</pre>

Inicia el servidor web y accede a http://127.0.0.1/:8000/links y verás los resultados.

**Preparando nuestra aplicación CRUD (create, read, update y delete)**

Hasta ahora tenemos una vista que nos muestra los links que tenemos guardados en nuestra tabla. A continuación necesitamos modificar nuestra vista para que acepte parámetros get de tal forma que podamos indicarles que operación queremos realizar: añadir, modificar, borrar&#8230; Para ello en linktracker/views.py tenemos que realizar dos cambios: cambiamos la definición del método list y añadimos el parámetro message para que se transmita en cada llamada, quedaría así:

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

Y modificamos la plantilla:

<pre class="brush: actionscript3; gutter: false; first-line: 1">{% if message %}
 &lt;b&gt;{{ message }}&lt;/b&gt;
 &lt;p&gt;
 {% endif %}
 {% if link_list %}
     &lt;table&gt;
     {% for link in link_list %}
         &lt;tr bgcolor='{% cycle FFFFFF,EEEEEE as rowcolor %}'&gt;
              &lt;td&gt;&lt;a href='{{ link.link_url }}'&gt;{{ link.link_description }}&lt;/a&gt;&lt;/td&gt;
              &lt;td&gt;&lt;a href='/links/edit/{{ link.id }}'&gt;Edit&lt;/a&gt;&lt;/td&gt;
              &lt;td&gt;&lt;a href='/links/delete/{{ link.id }}'&gt;Delete&lt;/a&gt;&lt;/td&gt;
         &lt;/tr&gt;
     {% endfor %}
     &lt;/table&gt;
     &lt;p&gt;
 {% else %}
     &lt;p&gt;No links found.&lt;/p&gt;
 {% endif %}
 &lt;p&gt;
 &lt;a href='/links/new'&gt;Add Link&lt;/a&gt;</pre>

**Añadir enlaces**

Es hora de dar una nueva funcionalidad a nuestra página, en este caso vamos a añadir dos nuevas acciones: new, que muestra el formulario para añadir un nuevo en lace y add que es la encargada de guardar un nuevo registro en la base de datos. Para ello añadimos dos nuevas líneas en el fichero urls.py:

<pre class="brush: actionscript3; gutter: false; first-line: 1">url (r'^links/new', 'linkdump.linktracker.views.new'),
url (r'^links/add', 'linkdump.linktracker.views.add'),</pre>

Y definimos los dos nuevos métodos en nuestra vista (linktracker/views.py):

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

Y creamos la  plantilla linktrcker/template/links/form.html:

<pre class="brush: actionscript3; gutter: false; first-line: 1">&lt;form action="/links/{{ action }}/" method="post"&gt;
    Description:
    &lt;input name=link_description value="{{ description }}"&gt;&lt;br /&gt;
    URL:
    &lt;input name=link_url value="{{ url }}"&gt;&lt;br /&gt;
    &lt;input type=submit value="{{ button }}"&gt;
&lt;/form&gt;</pre>

**Modificando enlaces**
  
Vamos a añadir una nueva funcionalidad de modificar la información de un enlace, en este caso en la URL tenemos que indicar que enlace vamos a modificar, para ello añadimos una nueva acción en urls.py:

<pre class="brush: actionscript3; gutter: false; first-line: 1">url (r'^links/edit/(?P&lt;id&gt;\d+)', 'linkdump.linktracker.views.edit'),</pre>

Creamos un nuevo método en nuestra vista (linktracker/views.py), fíjate que vamos a usar la misma plantilla que ne le punto anterior:

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

Por último hacemos algo similar para la acción update que modifica en la base de datos el dato, añadimos en urls.py:

<pre class="brush: actionscript3; gutter: false; first-line: 1">url (r'^links/update/(?P&lt;id&gt;\d+)', 'linkdump.linktracker.views.update'),</pre>

Y en la vista (linktracker/views.py) un nuevo método:

<pre class="brush: actionscript3; gutter: false; first-line: 1">def update(request, id):
    link = Link.objects.get(id=id)
    link.link_description = request.POST["link_description"]
    link.link_url = request.POST["link_url"]
    link.save()
    return list(request, message="Link updated!")</pre>

**Borrando enlaces**
  
Para terminar añadamos la opción de borrar un enlace, para ello volvemos a añadir una nueva  acción al fichero urls.py:

<pre class="brush: actionscript3; gutter: false; first-line: 1">url (r'^links/delete/(?P&lt;id&gt;\d+)', 'linkdump.linktracker.views.delete'),</pre>

Y añadimos el método correspondiente en linktracker/views.py:

<pre class="brush: actionscript3; gutter: false; first-line: 1">def delete(request, id):
    Link.objects.get(id=id).delete()
    return list(request, message="Link deleted!")</pre>

Bueno, esto esto arrancando el servidor web del framework puedes ver como funciona:

[<img class="alignnone size-full wp-image-636" title="Pantallazo" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/Pantallazo1.png" alt="" width="296" height="186" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/Pantallazo1.png)

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->