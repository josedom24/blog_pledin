---
id: 1953
title: 'flask: Trabajando con peticiones y respuestas (3ª parte)'
date: 2018-03-27T17:24:15+00:00


guid: https://www.josedomingo.org/pledin/?p=1953
permalink: /2018/03/flask-trabajando-con-peticiones-y-respuestas-3a-parte/


tags:
  - Flask
  - Python
  - Web
---
[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask.png" alt="" width="460" height="180" class="aligncenter size-full wp-image-1919" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask.png){.thumbnail}

# Trabajando con peticiones HTTP

Hemos indicado que nuestra aplicación Flask recibe una petición HTTP, cuando la URL a la que accedemos se corresponde con una ruta y un método indicada en una determinada `route` se ejecuta la función correspondiente. Desde esta función se puede acceder al objeto `request` que posee toda la información de la petición HTTP.

## El objeto request

Veamos los atributos más importante que nos ofrece el objeto `request`:

    from flask import Flask, request
    ...
    @app.route('/info',methods=["GET","POST"])
    def inicio():
        cad=""
        cad+="URL:"+request.url+"<br/>"
        cad+="Método:"+request.method+"<br/>"
        cad+="header:<br/>"
        for item,value in request.headers.items():
            cad+="{}:{}<br/>".format(item,value)    
        cad+="información en formularios (POST):<br/>"
        for item,value in request.form.items():
            cad+="{}:{}<br/>".format(item,value)
        cad+="información en URL (GET):<br/>"
        for item,value in request.args.items():
            cad+="{}:{}<br/>".format(item,value)    
        cad+="Ficheros:<br/>"
        for item,value in request.files.items():
            cad+="{}:{}<br/>".format(item,value)
        return cad
    

  * `request.url`: La URL a la que accedemos.
  * `request.path`: La ruta de la URL, quitamos el servidor y los parámetros con información.
  * `request.method`: El método HTTP con el qué hemos accedido.
  * `request.headers`: Las cabeceras de la petición HTTP. Tenemos atributos para acceder a cabeceras en concreto, por ejemplo, `request.user_agent`.
  * `request.form`: Información recibida en el cuerpo de la petición cuando se utiliza el método POST, normalmente se utiliza un formulario HTML para enviar esta información.
  * `request.args`: Parámetros con información indicado en la URL en las peticiones GET.
  * `request.files`: Ficheros para subir al servidor en una petición PUT o POST. [<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask3.png" alt="" width="1442" height="361" class="aligncenter size-full wp-image-1954" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask3.png){.thumbnail}

<!--more-->

## Ejemplo: sumar dos números

    @app.route("/suma",methods=["GET","POST"])
    def sumar():
        if request.method=="POST":
            num1=request.form.get("num1")
            num2=request.form.get("num2")
            return "<h1>El resultado de la suma es {}</h1>".format(str(int(num1)+int(num2)))
        else:
            return '''<form action="/suma" method="POST">
                    <label>N1:</label>
                    <input type="text" name="num1"/>
                    <label>N2:</label>
                    <input type="text" name="num2"/><br/><br/>
                    <input type="submit"/>
                    </form>'''
    

[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask4.png" alt="" width="481" height="155" class="aligncenter size-full wp-image-1955" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask4.png){.thumbnail}[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask5.png" alt="" width="528" height="104" class="aligncenter size-full wp-image-1956" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask5.png){.thumbnail}

# Generando respuestas HTTP, respuestas de error y redirecciones

El decorador `router` gestiona la petición HTTP recibida y crea un objeto `reponse` con la respuesta HTTP: el código de estado, las cabaceras y los datos devueltos. Esta respuesta la prepara a partir de lo que devuelve la función _vista_ ejecutada con cada `route`. Estas funciones pueden devolver tres tipos de datos:

  * Una cadena, o la generación de una plantilla (que veremos posteriormente). Por defecto se indica un código 200 y las cabeceras por defecto.
  * Un objeto de la clase `response` generado con la función `make_repsonse`, que recibe los datos devueltos, el código de estado y las cabeceras.
  * Una tupla con los mismos datos: datos, cabeceras y código de respuesta.

## Ejemplo de respuestas

Veamos el siguiente código:

    @app.route('/string/')
    def return_string():
        return 'Hello, world!'  
    
    @app.route('/object/')
    def return_object():
        headers = {'Content-Type': 'text/plain'}
        return make_response('Hello, world!', 200,headers)  
    
    @app.route('/tuple/')
    def return_tuple():
        return 'Hello, world!', 200, {'Content-Type':'text/plain'}
    

Puedes comprobar que devuelve cada una de las rutas.

## Respuestas de error

Si queremos que en cualquier momento devolver una respuesta HTTP de error podemos utilizar la función `abort`:

    @app.route('/login')
    def login():
        abort(401)
        # Esta línea no se ejecuta
    

## Redirecciones

Si queremos realizar una redicirección HTTP a otra URL utilizamos la función `redirect`:

    @app.route('/')
    def index():
        return redirect(url_for('return_string'))
    

# Contenido estático

Nuestra página web necesita tener contenido estático: hoja de estilo, ficheros javascript, imágenes, documentos pdf, etc. Para acceder a ellos vamos a utilizar la función `url_for`.

## ¿Dónde guardamos el contenido estático?

Dentro de nuestro directorio vamos a crear un directorio llamado `static`, donde podemos crear la estructura de directorios adecuada para guardas nuestro contenido estático. Por ejemplo para guardar el CSS, el java script y las imágenes podríamos crear una estrucutra como la siguiente:

    aplicacion
        static
            css
            js
            img
    

## Acceder al contenido estático

Por ejemplo:

    url_for('static', filename='css/style.css')
    

Estariamos creando la ruta para acceder al fichero `style.css` que se encuentra en `static/css`.

Otro ejemplo:

    url_for('static', filename='img/tux.png')
    

Estaríamos creando la ruta para acceder al fichero `tux.png` que se encuentra en `static/img`.

## Mostrar una imagen

    @app.route('/')
    def inicio():
        return '<img src="'+url_for('static', filename='img/tux.png')+'"/>'
    

Y comprobamos que se muestra al acceder a la página:

[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/img1.png" alt="" width="288" height="370" class="aligncenter size-full wp-image-1958" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/img1.png){.thumbnail}

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->