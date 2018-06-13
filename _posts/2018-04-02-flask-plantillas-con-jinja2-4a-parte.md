---
id: 1962
title: 'flask: Plantillas con jinja2 (4ª parte)'
date: 2018-04-02T13:07:57+00:00


guid: https://www.josedomingo.org/pledin/?p=1962
permalink: /2018/04/flask-plantillas-con-jinja2-4a-parte/


tags:
  - Flask
  - Python
  - Web
---
[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask.png" alt="" width="460" height="180" class="aligncenter size-full wp-image-1919" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask.png){.thumbnail}

# Plantillas con jinja2

[Jinja2](http://jinja.pocoo.org) es un motor de plantilla desarrollado en Python. Flask utiliza jinja2 para generar documentos HTML válidos de una manera muy sencilla y eficiente.

Por dependencias al instalar Flask instalamos jinja2. En esta unidad vamos a estudiar los elementos principales de jinja2, para más información accede a la [documentación oficial de jinja2](http://jinja.pocoo.org/docs).

## Una plantilla simple

Veamos un ejemplo para entender como funciona jinja2:

    from jinja2 import Template
    
    temp1="Hola {{nombre}}"
    print(Template(temp1).render(nombre="Pepe"))
    

La salida es `Hola Pepe`. La plantilla se compone de una variable `{{nombre}}` que es sustituida por el valor de la variable `nombre` al renderizar o generar la plantilla.

## Elementos de una plantilla

Una plantilla puede estar formada por texto, y algunos de los siguientes elementos:

  * Variables, se indican con `{{ ... }}`
  * Instrucciones, se indican con `{% ... %}`
  * Comentarios, se indican con `{# ... #}`

<!--more-->

## Variables en las plantillas

Las variables en la plantillas se sustituyen por los valores que se pasan a la plantilla al renderizarlas. Si enviamos una lista o un diccionario puedo acceder los valores de dos maneras:

    {{ foo.bar }}
    {{ foo['bar'] }}
    

Veamos algunos ejemplos:

    temp2='<a href="{{ url }}"> {{ enlace }}</a>'
    print(Template(temp2).render(url="http://www.flask.com",enlace="Flask"))    
    
    temp3='<a href="{{ datos[0] }}"> {{ datos[1] }}</a>'
    print(Template(temp3).render(datos=["http://www.flask.com","Flask"]))   
    
    temp4='<a href="{{ datos.url }}"> {{ datos.enlace }}</a>'
    print(Template(temp4).render(datos={"url":"http://www.flask.com","enlace":"Flask"}))
    

El resultado de las tres plantillas es:

    <a href="http://www.flask.com"> Flask</a>
    

## Filtros de variables

Un filtro me permite modificar una variable. Son distintas funciones que me modifican o calculan valores a partir de las variables, se indican separadas de las variables por `|` y si tienen parámetros se indican entre paréntesis. Veamos algunos ejemplos:

    temp5='Hola {{nombre|striptags|title}}'
    print(Template(temp5).render(nombre="   pepe  "))   
    
    temp6="los datos son {{ lista|join(', ') }}"
    print(Template(temp6).render(lista=["amarillo","verde","rojo"]))    
    
    temp6="El ultimo elemento tiene {{ lista|last|length}} caracteres"
    print(Template(temp6).render(lista=["amarillo","verde","rojo"]))
    

Por defecto los caracteres (`>`, `<`, `&`, `"`) no se escapan, si queremos mostrarlo en nuestra página HTML tenemos que escapar los caracteres:

    temp7="La siguiente cadena muestra todos los caracteres: {{ info|e }}"
    print(Template(temp7).render(info="<hola&que&tal>"))
    

Y por tanto la salida es:

    La siguiente cadena muestra todos los caracteres: &lt;hola&amp;que&amp;tal&gt;
    

Para ver todos los filtros accede a la [lista de filtros](http://jinja.pocoo.org/docs/2.9/templates/#builtin-filters) en la documentación.

## Instrucciones en las plantillas

### for

Nos permite recorrer una secuencia, veamos un ejemplo sencillo. Es compatible con la sentencia `for` de python.

    temp7='''
    <ul>
    {% for elem in elems -%}
    <li>{{loop.index}} - {{ elem }}</li>
    {% endfor -%}
    </ul>
    '''
    print(Template(temp7).render(elems=["amarillo","verde","rojo"]))
    

La salida es:

    <ul>
    <li>1 - amarillo</li>
    <li>2 - verde</li>
    <li>3 - rojo</li>
    </ul>
    

El `-` detrás del bloque `for` evita que se añada una línea en blanco.

En un bloque `for` tenemos acceso a varias variables, veamos las más interesantes:

  * `loop.index`: La iteración actual del bucle (empieza a contar desde 1).
  * `loop.index0`: La iteración actual del bucle (empieza a contar desde 0).
  * `loop.first`: True si estamos en la primera iteración.
  * `loop.last`: True si estamos en la última iteración.
  * `loop.length`: Número de iteraciones del bucle.

### if

Nos permite preguntar por el valor de una variable o si una variable existe. Es compatible con la sentencia `if` de python.

Ejemplo:

    temp9='''
    {% if elems %}
    <ul>
    {% for elem in elems -%}
        {% if elem is divisibleby 2 -%}
            <li>{{elem}} es divisible por 2.</li>
        {% else -%}
            <li>{{elem}} no es divisible por 2.</li>
        {% endif -%}
    {% endfor -%}
    </ul>
    {% endif %}
    '''
    print(Template(temp9).render(elems=[1,2,3,4]))
    

Y la salida será:

    <ul>
        <li>1 no es divisible por 2.</li>
        <li>2 es divisible por 2.</li>
        <li>3 no es divisible por 2.</li>
        <li>4 es divisible por 2.</li>
    </ul>
    

Tenemos un conjunto de tests para realizar comprobaciones, por ejemplo `divisibleby` devuelve True si un número es divible por el que indiquemos. Hay más tests que podemos utilizar. Para ver todos los tests accede a la [lista de tests](http://jinja.pocoo.org/docs/2.9/templates/#builtin-tests) en la documentación.

# Generando páginas HTML con Flask y Jinja2

Flask utiliza por defecto jinja2 para generar documentos HTML, para generar una plantilla utilizamos la función `render_template` que recibe como parámetro el fichero donde guardamos la plantilla y las variables que se pasan a esta.

Las plantillas las vamos a guardar en ficheros en el directorio `templates` (dentro del directorio `aplicacion`).

## Plantilla simple

Veamos un ejemplo de cómo podemos generar HTML a partir de una plantilla en Flask, el programa será el siguiente:

    ...
    @app.route('/hola/')
    @app.route('/hola/<nombre>')
    def saluda(nombre=None):
        return render_template("template1.html",nombre=nombre)
    

La plantilla:

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
        {% if nombre %}
          <h1>Hola {{nombre|title}}</h1>
          <p>¿Cómo estás?</p>
        {%else%}
          <p>No has indicado un nombre</p>
        {% endif %}
    </body>
    </html>
    

Y la salida:

[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/template1.png" alt="" width="264" height="340" class="aligncenter size-full wp-image-1963" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/template1.png){.thumbnail}

## Envío de varias variables a una plantilla

En este caso veremos un ejemplo donde mandamos varias variables a la plantilla:

    @app.route('/suma/<num1>/<num2>')
    def suma(num1,num2):
        try:
            resultado=int(num1)+int(num2)
        except:
            abort(404)
        return render_template("template2.html",num1=num1,num2=num2,resultado=resultado)
    

La plantilla:

    ...
        <h2>Suma</h2>
        {% if resultado>0 %}
          <p>El resultado es positivo</p>
        {%else%}
          <p>El resultado es negativo</p>
        {% endif %}
        <h3>{{resultado}}</h3>
    ...
    

Y la salida:

[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/template2.png" alt="" width="283" height="323" class="aligncenter size-full wp-image-1964" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/template2.png){.thumbnail}

## Generando páginas de error con plantillas

Como vemos en el ejemplo anterior, si los números no se pueden sumar se generara una respuesta 404, podemos también generar esta página a partir de una plantilla:

    @app.errorhandler(404)
    def page_not_found(error):
        return render_template("error.html",error="Página no encontrada..."), 404
    

La plantilla:

    ...
        <header>
           <h1>{{error}}</h1>
           <img src="{{ url_for('static', filename='img/tux.png')}}"/>
        </header>   
    ...
    

## Uso de for en una plantilla

En este caso vamos a mostrar la tabla de multiplicar de un número, en la plantilla vamos a generar un bucle con 10 iteraciones usando el tipo de datos `range`:

    @app.route('/tabla/<numero>')
    def tabla(numero):
        try:
            numero=int(numero)
        except:
            abort(404)
        return render_template("template3.html",num=numero)
    

La plantilla:

    ...
        <h2>Tabla de multiplicar</h2>
        {% for i in range(1,11) -%}
          <p>{{num}} * {{i}} = {{num*i}}</p>
        {% endfor -%}
    ...
    

Y la salida:

[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/template3.png" alt="" width="266" height="605" class="aligncenter size-full wp-image-1965" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/template3.png){.thumbnail}

## Envío de diccionario a una plantilla

En realidad vamos a mandar una lista de diccionarios, donde tenemos información para construir un enlace:

    @app.route('/enlaces')
    def enlaces():
        enlaces=[{"url":"http://www.google.es","texto":"Google"},
                {"url":"http://www.twitter.com","texto":"Twitter"},
                {"url":"http://www.facbook.com","texto":"Facebook"},
                ]
        return render_template("template4.html",enlaces=enlaces)
    

La plantilla:

    ...
        <h2>Enlaces</h2>
        {% if enlaces %}
        <ul>
        {% for enlace in enlaces -%}
          <li><a href="{{ enlace.url }}">{{ enlace.texto }}</a></li>
        {% endfor -%}
        </ul>
        {% else %}
            <p>No hay enlaces></p>
        {% endif %}
    ...
    

Y la salida:

[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/template4.png" alt="" width="261" height="318" class="aligncenter size-full wp-image-1966" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/template4.png){.thumbnail}

# Herencia de plantillas

La herencia de plantillas nos permite hacer un esqueleto de plantilla, para que todas las páginas de nuestro sitio web sean similares. En la unidad anterior hicimos una plantilla independiente para cada página, eso tiene un problema: si queremos cambiar algo que es común a todas las páginas hay que cambiarlo en todos los ficheros.

En nuestro caso vamos a crear una plantilla base de donde se van a heredar todas las demás, e indicaremos los bloques que las plantillas hijas pueden sobreescribir.

## La plantilla base

Vamos a crear una plantilla `base.html` donde indicaremos las partes comunes de todas nuestras páginas, e indicaremos los bloques que las otras plantillas pueden reescribir.

    <!DOCTYPE html>
    <html lang="es">
    <head>
    <title>{% block title %}{% endblock %}</title>
    <link rel="stylesheet" href="{{url_for("static", filename='css/style.css')}}">
    <meta charset="utf-8" />
    </head>
    
    <body>
        <header>
           <h1>Mi sitio web</h1>
           <p>Mi sitio web creado en html5</p>
        </header>
        {% block content %}{% endblock %}
    </body>
    </html>
    

Algunas consideraciones:

  1. Hemos creado dos bloques (`title` y `content`) en las plantillas hijas vamos a poder rescribir esos dos bloque para poner el título de la página y el contenido. Podríamos indicar todos los bloques que necesitamos.
  2. Hemos incluido una hoja de estilo que está en nuestro contenido estático (directorio `static`)

## Herencia de plantillas

A continuación, veamos la primera plantilla (`tample1.html`) utilizando la técnica de herencia:

    {% extends "base.html" %}
    {% block title %}Hola, que tal {{nombre}}{% endblock %}
    {% block content %}
        <h2>Vamos a saludar</h2>
        {% if nombre %}
          <h1>Hola {{nombre|title}}</h1>
          <p>¿Cómo estás?</p>
        {%else%}
          <p>No has indicado un nombre</p>
        {% endif %}
    {% endblock %}
    

Observamos cómo hemos reescrito los dos bloques.

Ejecuta el programa y comprueba que se genera el documento HTML completo, comprueba también que se está usando una hoja de estilo.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->