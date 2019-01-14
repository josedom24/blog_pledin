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
![django]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/python_django.jpg)

En este artículo vamos a introducir los conceptos fundamentales del framework [django](https://www.djangoproject.com/) para ello lo vamos a hacer a partir de un desarrollo de una aplicación [CRUD](http://es.wikipedia.org/wiki/CRUD) muy sencilla. Según la Wikipedia: [**Django**](http://es.wikipedia.org/wiki/Django) es un [framework](http://es.wikipedia.org/wiki/Framework "Framework") de desarrollo web de [código abierto](http://es.wikipedia.org/wiki/Open_Source "Open Source"), escrito en [Python](http://es.wikipedia.org/wiki/Python "Python"), que cumple en cierta medida el paradigma del [Modelo Vista Controlador](http://es.wikipedia.org/wiki/Modelo_Vista_Controlador "Modelo Vista Controlador"). Nosotros suponemos que ya tenemos [instalada la herramienta](http://informatica.gonzalonazareno.org/plataforma/mod/page/view.php?id=4932) en nuestro sistema operativo Debian Squeeze, y vamos a desarrollar una aplicación que nos permita crear, modificar, listar y eliminar información sobre enlaces webs.

## Comenzando nuestro proyecto

Para crear un nuevo proyecto utilizamos la siguiente instrucción:

    django-admin startproject linkdump

Nuestra aplicación se va a llamar **linkdump**, el comando anterior crea un directorio `linkdump` en el que podemos encontrar los siguientes ficheros:

* `__init__.py`: Define nuestro directorio como un módulo Python válido.
* `manage.py`: Utilidad para gestionar nuestro proyecto: arrancar servidor de pruebas, sincronizar modelos, etc.
* `settings.py`: Configuración del proyecto.
* `urls.py`: Gestión de las urls. Este fichero sería el controlador de la aplicación. Mapea las url entrantes a funciones Python definidas en módulos.

A continuación vamos a definir los parámetros de acceso a nuestra base de datos, nosotros vamos a usar el gestor de base de datos mysql, para ello modificamos algunas líneas del fichero `settings.py`:

    ...
    DATABASES = {
    'default': {
        'ENGINE': 'mysql',
        'NAME': 'bdurl',
        'USER': 'bduser',
        'PASSWORD': 'passuserbd',
        'HOST': '',
        'PORT': '',
    }
    ...

Suponemos también que la base de datos ya ha sido creada. Y creamos las tablas necesarias para la administración de nuestra página con el comando:

    python manage.py syncdb

Durante el proceso de creación de las tablas se nos pide los datos del usuario administrador de nuestra página: nombre de usuario, correo electrónico y contraseña.
  
### Creando una aplicación
  
Vamos a realizar una aplicación simple que nos permita gestionar una tabla con información de enlaces URL. Par ello vamos a crear una aplicación (que se llamará linktracker) en nuestro proyecto:

    python manage.py startapp linktracker

Vamos a crear el modelo de datos de nuestra aplicación que consistirá en una tabla donde guardaremos dos campos: `link_description` y `link_url`, para ello añadimos en el fichero `linktracker/models.py`:

    from django.db import models

    # Create your models here.
    class Link (models.Model):
        link_description = models.CharField(max_length=200)
        link_url = models.CharField(max_length=200)

Añadimos nuestra aplicación (`linkdump.linktracker`) en la lista `INSTALLED_APPS` que encontramos en el fichero `settings.py` y volvemos a actualiza nuestra base de datos, para crear la nueva tabla:

    python manage.py syncdb

Para no complicar nuestro ejemplo no vamos a usar un método de protección que django implementa para el envío de formularios usando el método post, por lo que comentamos la siguiente línea del fichero `settings.py`:

    #'django.middleware.csrf.CsrfViewMiddleware',

### Activando el sitio de administración
  
La aplicación de administración de nuestro sitio no está activada por defecto, para hacerlo tenemos que descomentar de la lista `INSTALLED_APPS` que encontramos en `settings.py` la línea:

    'django.contrib.admin',

y volvemos a actualizar nuestra base de datos para crear los elementos necesarios para la aplicación de administración:

    python manage.py syncdb

Para que funcione nuestra página de administración tenemos que descomentar en el fichero `urls.py` la línea referida a la aplicación admin:

    from django.conf.urls.defaults import *

    # Uncomment the next two lines to enable the admin:
    from django.contrib import admin
    admin.autodiscover()

    urlpatterns = patterns('',
        # Example:
        # (r'^linkdump/', include('linkdump.foo.urls')),

        # Uncomment the admin/doc line below to enable admin documentation:
        # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

        # Uncomment the next line to enable the admin:
        url (r'^admin/', include(admin.site.urls)),
    )

Activamos nuestro servidor web y probamos la página de administración:

    python manage.py runserver

El siguiente paso es hacer que nuestra tabla con la información de los links pueda ser gestionada desde la página de administración, para ello creamos un nuevo fichero llamado `admin.py` dentro de la carpeta de nuestra aplicación linktracker con el siguiente contenido:

    from linktracker.models import Link
    from django.contrib import admin

    admin.site.register(Link)

![django]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/Pantallazo-11.png)
  
### Añadiendo funciones a nuestra página

Para ello tenemos que ir añadiendo a nuestro controlador las acciones que e realizarán al acceder a determinadas URL. Para ello vamos a crear nuestra primera vista donde mostraremos los datos de nuestra tabla. Modificamos el fichero `urls.py` y añadimos los siguiente:

    url (r'^links/$', 'linkdump.linktracker.views.list'),

Muchas de las vistas que vamos a crear utilizan una plantilla html (template). Para guardar estas plantillas crea un directorio llamado `template` dentro de tu aplicación y añádelo a la lista `TEMPLATE_DIRS` que encontrarás en el fichero `settings.py`. Para crear la vista `list` añadimos el siguiente contenido al fichero `linktracker/views.py`:

    from django.core.context_processors import csrf
    from linkdump.linktracker.models import Link
    from django.template import Context, loader
    from django.shortcuts import render_to_response
    def list(request):
        link_list = Link.objects.all()
        return render_to_response(
            'links/list.html',
            {'link_list': link_list}
        )

Y creamos la plantilla en `linktracker/template/links/list.html`:

    {% raw %}
    {% if link_list %}
        <ul>
             {% for link in link_list %}
                 <li><a href='{{ link.link_url }}'>
                     {{link.link_description}}</a></li>
             {% endfor %}
        </ul>
    {% else %}
        <p>No links found.</p>
    {% endif %}
    {% endraw %}

Inicia el servidor web y accede a `http://127.0.0.1/:8000/links` y verás los resultados.

## Preparando nuestra aplicación CRUD (create, read, update y delete)

Hasta ahora tenemos una vista que nos muestra los links que tenemos guardados en nuestra tabla. A continuación necesitamos modificar nuestra vista para que acepte parámetros get de tal forma que podamos indicarles que operación queremos realizar: añadir, modificar, borrar... Para ello en `linktracker/views.py` tenemos que realizar dos cambios: cambiamos la definición del método `list` y añadimos el parámetro `message` para que se transmita en cada llamada, quedaría así:

    from linkdump.linktracker.models import Link
    from django.template import Context, loader
    from django.shortcuts import render_to_response
    def list(request, message = ""):
        link_list = Link.objects.all()
        return render_to_response(
            'links/list.html',
            {'link_list': link_list,'message': message}
        )

Y modificamos la plantilla:

    {% raw %}
    {% if message %}
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
     <a href='/links/new'>Add Link</a>
     {% endraw %}

## Añadir enlaces

Es hora de dar una nueva funcionalidad a nuestra página, en este caso vamos a añadir dos nuevas acciones: `new`, que muestra el formulario para añadir un nuevo enlace y `add` que es la encargada de guardar un nuevo registro en la base de datos. Para ello añadimos dos nuevas líneas en el fichero `urls.py`:

    url (r'^links/new', 'linkdump.linktracker.views.new'),
    url (r'^links/add', 'linkdump.linktracker.views.add'),

Y definimos los dos nuevos métodos en nuestra vista (`linktracker/views.py`):

    def new(request):
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
        return list(request, message="Link added!")

Y creamos la  plantilla `linktrcker/template/links/form.html`:

    {% raw %}
    <form action="/links/{{ action }}/" method="post">
        Description:
        <input name=link_description value="{{ description }}"><br />
        URL:
        <input name=link_url value="{{ url }}"><br />
        <input type=submit value="{{ button }}">
    </form>
    {% endraw %}
    
### Modificando enlaces
  
Vamos a añadir una nueva funcionalidad de modificar la información de un enlace, en este caso en la URL tenemos que indicar que enlace vamos a modificar, para ello añadimos una nueva acción en `urls.py`:

    url (r'^links/edit/(?P<id>\d+)', 'linkdump.linktracker.views.edit'),

Creamos un nuevo método en nuestra vista (`linktracker/views.py`), fíjate que vamos a usar la misma plantilla que ne le punto anterior:

    def edit(request, id):
        link = Link.objects.get(id=id)
        return render_to_response(
            'links/form.html',
            {'action': 'update/' + id,
            'button': 'Update',
            'description': link.link_description,
            'url': link.link_url
            }
        )

Por último hacemos algo similar para la acción `update` que modifica en la base de datos el dato, añadimos en `urls.py`:

    url (r'^links/update/(?P<id>\d+)', 'linkdump.linktracker.views.update'),

Y en la vista (`linktracker/views.py`) un nuevo método:

    def update(request, id):
        link = Link.objects.get(id=id)
        link.link_description = request.POST["link_description"]
        link.link_url = request.POST["link_url"]
        link.save()
        return list(request, message="Link updated!")

### Borrando enlaces
  
Para terminar añadamos la opción de borrar un enlace, para ello volvemos a añadir una nueva  acción al fichero `urls.py`:

    url (r'^links/delete/(?P<id>\d+)', 'linkdump.linktracker.views.delete'),

Y añadimos el método correspondiente en `linktracker/views.py`:

    def delete(request, id):
        Link.objects.get(id=id).delete()
        return list(request, message="Link deleted!")

Bueno, esto esto arrancando el servidor web del framework puedes ver como funciona:

![django]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/Pantallazo1.png)

{% include comentarios.html comments=site.data.comments.django %}