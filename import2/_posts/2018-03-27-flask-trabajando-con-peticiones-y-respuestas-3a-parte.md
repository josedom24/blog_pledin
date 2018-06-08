---
layout: post
status: publish
published: true
title: 'flask: Trabajando con peticiones y respuestas (3&ordf; parte)'
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1953
wordpress_url: https://www.josedomingo.org/pledin/?p=1953
date: '2018-03-27 17:24:15 +0000'
date_gmt: '2018-03-27 15:24:15 +0000'
categories:
- General
tags:
- Web
- Python
- Flask
comments: []
---
<p><a class="thumbnail" href="https://www.josedomingo.org/pledin/wp-content/uploads/2018/03/flask.png"><img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/03/flask.png" alt="" width="460" height="180" class="aligncenter size-full wp-image-1919" /></a></p>
<h1>Trabajando con peticiones HTTP</h1>
<p>Hemos indicado que nuestra aplicaci&oacute;n Flask recibe una petici&oacute;n HTTP, cuando la URL a la que accedemos se corresponde con una ruta y un m&eacute;todo indicada en una determinada <code>route</code> se ejecuta la funci&oacute;n correspondiente. Desde esta funci&oacute;n se puede acceder al objeto <code>request</code> que posee toda la informaci&oacute;n de la petici&oacute;n HTTP.</p>
<h2>El objeto request</h2>
<p>Veamos los atributos m&aacute;s importante que nos ofrece el objeto <code>request</code>:</p>
<pre><code>from flask import Flask, request
...
@app.route('/info',methods=["GET","POST"])
def inicio():
    cad=""
    cad+="URL:"+request.url+"<br/>"
    cad+="M&eacute;todo:"+request.method+"<br/>"
    cad+="header:<br/>"
    for item,value in request.headers.items():
        cad+="{}:{}<br/>".format(item,value)    
    cad+="informaci&oacute;n en formularios (POST):<br/>"
    for item,value in request.form.items():
        cad+="{}:{}<br/>".format(item,value)
    cad+="informaci&oacute;n en URL (GET):<br/>"
    for item,value in request.args.items():
        cad+="{}:{}<br/>".format(item,value)    
    cad+="Ficheros:<br/>"
    for item,value in request.files.items():
        cad+="{}:{}<br/>".format(item,value)
    return cad
</code></pre>
<ul>
<li><code>request.url</code>: La URL a la que accedemos.</li>
<li><code>request.path</code>: La ruta de la URL, quitamos el servidor y los par&aacute;metros con informaci&oacute;n.</li>
<li><code>request.method</code>: El m&eacute;todo HTTP con el qu&eacute; hemos accedido.</li>
<li><code>request.headers</code>: Las cabeceras de la petici&oacute;n HTTP. Tenemos atributos para acceder a cabeceras en concreto, por ejemplo, <code>request.user_agent</code>.</li>
<li><code>request.form</code>: Informaci&oacute;n recibida en el cuerpo de la petici&oacute;n cuando se utiliza el m&eacute;todo POST, normalmente se utiliza un formulario HTML para enviar esta informaci&oacute;n.</li>
<li><code>request.args</code>: Par&aacute;metros con informaci&oacute;n indicado en la URL en las peticiones GET.</li>
<li><code>request.files</code>: Ficheros para subir al servidor en una petici&oacute;n PUT o POST. <a class="thumbnail" href="https://www.josedomingo.org/pledin/wp-content/uploads/2018/03/flask3.png"><img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/03/flask3.png" alt="" width="1442" height="361" class="aligncenter size-full wp-image-1954" /></a></li>
</ul>
<p><!--more--></p>
<h2>Ejemplo: sumar dos n&uacute;meros</h2>
<pre><code>@app.route("/suma",methods=["GET","POST"])
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
</code></pre>
<p><a class="thumbnail" href="https://www.josedomingo.org/pledin/wp-content/uploads/2018/03/flask4.png"><img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/03/flask4.png" alt="" width="481" height="155" class="aligncenter size-full wp-image-1955" /></a><a class="thumbnail" href="https://www.josedomingo.org/pledin/wp-content/uploads/2018/03/flask5.png"><img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/03/flask5.png" alt="" width="528" height="104" class="aligncenter size-full wp-image-1956" /></a></p>
<h1>Generando respuestas HTTP, respuestas de error y redirecciones</h1>
<p>El decorador <code>router</code> gestiona la petici&oacute;n HTTP recibida y crea un objeto <code>reponse</code> con la respuesta HTTP: el c&oacute;digo de estado, las cabaceras y los datos devueltos. Esta respuesta la prepara a partir de lo que devuelve la funci&oacute;n <em>vista</em> ejecutada con cada <code>route</code>. Estas funciones pueden devolver tres tipos de datos:</p>
<ul>
<li>Una cadena, o la generaci&oacute;n de una plantilla (que veremos posteriormente). Por defecto se indica un c&oacute;digo 200 y las cabeceras por defecto.</li>
<li>Un objeto de la clase <code>response</code> generado con la funci&oacute;n <code>make_repsonse</code>, que recibe los datos devueltos, el c&oacute;digo de estado y las cabeceras.</li>
<li>Una tupla con los mismos datos: datos, cabeceras y c&oacute;digo de respuesta.</li>
</ul>
<h2>Ejemplo de respuestas</h2>
<p>Veamos el siguiente c&oacute;digo:</p>
<pre><code>@app.route('/string/')
def return_string():
    return 'Hello, world!'  

@app.route('/object/')
def return_object():
    headers = {'Content-Type': 'text/plain'}
    return make_response('Hello, world!', 200,headers)  

@app.route('/tuple/')
def return_tuple():
    return 'Hello, world!', 200, {'Content-Type':'text/plain'}
</code></pre>
<p>Puedes comprobar que devuelve cada una de las rutas.</p>
<h2>Respuestas de error</h2>
<p>Si queremos que en cualquier momento devolver una respuesta HTTP de error podemos utilizar la funci&oacute;n <code>abort</code>:</p>
<pre><code>@app.route('/login')
def login():
    abort(401)
    # Esta l&iacute;nea no se ejecuta
</code></pre>
<h2>Redirecciones</h2>
<p>Si queremos realizar una redicirecci&oacute;n HTTP a otra URL utilizamos la funci&oacute;n <code>redirect</code>:</p>
<pre><code>@app.route('/')
def index():
    return redirect(url_for('return_string'))
</code></pre>
<h1>Contenido est&aacute;tico</h1>
<p>Nuestra p&aacute;gina web necesita tener contenido est&aacute;tico: hoja de estilo, ficheros javascript, im&aacute;genes, documentos pdf, etc. Para acceder a ellos vamos a utilizar la funci&oacute;n <code>url_for</code>.</p>
<h2>&iquest;D&oacute;nde guardamos el contenido est&aacute;tico?</h2>
<p>Dentro de nuestro directorio vamos a crear un directorio llamado <code>static</code>, donde podemos crear la estructura de directorios adecuada para guardas nuestro contenido est&aacute;tico. Por ejemplo para guardar el CSS, el java script y las im&aacute;genes podr&iacute;amos crear una estrucutra como la siguiente:</p>
<pre><code>aplicacion
    static
        css
        js
        img
</code></pre>
<h2>Acceder al contenido est&aacute;tico</h2>
<p>Por ejemplo:</p>
<pre><code>url_for('static', filename='css/style.css')
</code></pre>
<p>Estariamos creando la ruta para acceder al fichero <code>style.css</code> que se encuentra en <code>static/css</code>.</p>
<p>Otro ejemplo:</p>
<pre><code>url_for('static', filename='img/tux.png')
</code></pre>
<p>Estar&iacute;amos creando la ruta para acceder al fichero <code>tux.png</code> que se encuentra en <code>static/img</code>.</p>
<h2>Mostrar una imagen</h2>
<pre><code>@app.route('/')
def inicio():
    return '<img src="'+url_for('static', filename='img/tux.png')+'"/>'
</code></pre>
<p>Y comprobamos que se muestra al acceder a la p&aacute;gina:</p>
<p><a class="thumbnail" href="https://www.josedomingo.org/pledin/wp-content/uploads/2018/03/img1.png"><img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/03/img1.png" alt="" width="288" height="370" class="aligncenter size-full wp-image-1958" /></a></p>
