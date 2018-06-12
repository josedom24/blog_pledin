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
![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_openshift.jpg)

En las entradas anteriores, hemos visto como crear una aplicación web con python usando el framework Bottle ([1ª parte](http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-python-web-framework_1a_parte/ "Crear páginas web con Bottle: Python Web Framework (1ª parte)") y [2ª parte](http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-trabajando-con-plantillas-2a-parte/ "Crear páginas web con Bottle. Trabajando con plantillas (2ª parte)")). En la entrada actual vamos a estudiar como desplegar una aplicación bottle en una infraestructura PaaS, concretamente en [OpenShift](http://www.openshift.com).

De forma resumida el procedimiento será crear una aplicación en OpenShift con el componente (cartridge) _python 2.7_, e inicializar esta aplicación con la librería de bottle y una distribución del framework configurado para que funcione en OpenShift.

## Creación de la aplicación OpenShift

Vamos a dar de alta un nuevo proyecto OpenShift, como componente software vamos a instalar el cartridge _Python 2.7_.

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os1.png)

A continuación vamos a configurar la nueva aplicación, indicando su nombre, y el repositorio git donde podemos obtener la versión de bottle configurada para OpenShift, ese repositorio lo encontramos en GitHub y su dirección es `https://github.com/openshift-quickstart/bottle-openshift-quickstart.git`.

Quedando de esta manera:

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os2.png)

Una vez creada la aplicación podemos clonar el repositorio git, y obtenemos los ficheros del framework bottle con los que empezar a trabajar:

    $ git clone ssh://55096945e0b8cd85fa0000d9@bottle-iesgn.rhcloud.com/~/git/bottle.git/
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
    data  libs  README.md  setup.py  wsgi

## El fichero setup.py

El primer fichero que nos interesa es `setup.py` que nos permite configurar nuestra aplicación.

    $ cat setup.py 
    from setuptools import setup
    setup(name='YourAppName',
          version='1.0',
          description='OpenShift App',
          author='Your Name',
          author_email='example@example.com',
          url='http://www.python.org/sigs/distutils-sig/',
          install_requires=['bottle'],
         )

Puedes cambiar la información del nombre, versión, descripción y autor de la aplicación. Lo que más nos interesa es la última línea donde definimos una lista con las librerías python que se tienen que instalar en nuestro proyecto de OpenShift (observamos que la librería bottle está instalada). Si queremos, por ejemplo, instalar la librería `lxml` para trabajar con ficheros xml, tendríamos que modificar el fichero, dejando la última línea de la siguiente manera:

    install_requires=['bottle','lxml'],

Cuando subamos el fichero modificado a OpenShift se instalarán las nuevas librearías que hayamos indicado en la lista.

## El fichero wsgi/mybottleapp.py

En el directorio `wsgi` encontramos la aplicación wsgi, en el fichero `application` (ese fichero no es necesario modificarlo), y el fichero donde voy a escribir mi programa python que se llama `mybottleapp.py`. Por ejemplo podríamos tener el siguiente contenido:

    from bottle import route, default_app

    @route('/name/<name>')
    def nameindex(name='Stranger'):
        return '<strong>Hello, %s!</strong>' % name

    @route('/')
    def index():
        return '<strong>Hello World!</strong>'

    # This must be added in order to do correct path lookups for the views
    import os
    from bottle import TEMPLATE_PATH
    TEMPLATE_PATH.append(os.path.join(os.environ['OPENSHIFT_REPO_DIR'], 'wsgi/views/')) 

    application=default_app()

Si acedemos a la aplicación:

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os3.png)

## Trabajando con plantillas

Las plantillas deben estar guardadas en un directorio llamado `views` que tenemos que crear en el directorio `wsgi`. Siguiendo un ejemplo que vimos en la [entrada anterior](http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-trabajando-con-plantillas-2a-parte/ "Crear páginas web con Bottle. Trabajando con plantillas (2ª parte)"), vamos a crear la platilla `template_hello.tpl` en un directorio `views` que previamente hemos creado. El contenido de este fichero sería:

    {% raw %}
    <!DOCTYPE html>
    <html lang="es">
    <head>
    <title>Hola, que tal {{nombre}}</title>
    <meta charset="utf-8" />
    </head>

    <body>
        <header>
           <h1>Mi sitio web</h1>
           <p>Mi sitio web creado en html5</p>
        </header>
        <h2>Vamos a saludar</h2>
        % if nombre=="Mundo":
          <p> Hola <strong>{{nombre}}</strong></p>
        %else:
          <h1>Hola {{nombre.title()}}!</h1>
          <p>¿Cómo estás?
        %end
    </body>
    </html>
    {% endraw %}

A continuación añadimos una nueva ruta a nuestro programa bottle en el fichero `myappbottle.py:`

    from bottle import route, default_app, template
    ...
    @route('/hello/')
    @route('/hello/<name>')
    def hello(name='Mundo'):
        return template('template_hello.tpl', nombre=name)
    ...


Subimos los cambios al repositorio git:

    $ git add views/template_hello.tpl
    $ git commit -am "Uso de una plantilla"
    $ git push

Y comprobamos el resultado:

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os4.png)

## Servir contenido estático

De forma similar a como vimos en la [entrada anterior](http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-trabajando-con-plantillas-2a-parte/ "Crear páginas web con Bottle. Trabajando con plantillas (2ª parte)"), hay que definir una ruta que nos permita servir contenido estático: imágenes, hojas de estilo, documentos,&#8230; En este caso la ruta que tenemos que poner nos va a permitir servir todos los ficheros que se encuentren en el directorio `wsgi/static` o en algún subdirectorio dentro del mismo.

    from bottle import route, default_app, template,static_file
    ...
    @route('/static/<filepath:path>')
    def server_static(filepath):
        return static_file(filepath, root=os.environ['OPENSHIFT_REPO_DIR']+"wsgi/static")
    ...

Suponiendo que hemos guardado una imagen en el directorio `static` y la hemos subido al repositorio git, podemos acceder a ella de esta forma:

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/os5.png)

## Accediendo al log de errores

Durante la codificación de nuestro programa podemos obtener algún código de error, para obtener más información de dicho error tenemos que acceder al fichero del log de nuestra aplicación, para ello tenemos que acceder a nuestra aplicación y obtener el contenido del siguiente fichero:

    ssh 55096945e0b8cd85fa0000d9@bottle-iesgn.rhcloud.com
    > tailf app-root/logs/python.log

Con este artículo termino una serie de entradas en las que he tratado de introducir la manera de crear aplicaciones web utilizando el lenguaje de programación python. Espero que haya sido de utilidad.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->