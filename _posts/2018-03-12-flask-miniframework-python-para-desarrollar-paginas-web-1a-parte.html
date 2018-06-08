---
layout: post
status: publish
published: true
title: 'flask: Miniframework python para desarrollar p&aacute;ginas web (1&ordf; parte)'
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1918
wordpress_url: https://www.josedomingo.org/pledin/?p=1918
date: '2018-03-12 20:42:51 +0000'
date_gmt: '2018-03-12 19:42:51 +0000'
categories:
- General
tags:
- Web
- Python
- Flask
comments: []
---
<p><a class="thumbnail" href="https://www.josedomingo.org/pledin/wp-content/uploads/2018/03/flask.png"><img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/03/flask.png" alt="" width="460" height="180" class="aligncenter size-full wp-image-1919" /></a> Flask es un "micro" framework escrito en Python y concebido para facilitar el desarrollo de aplicaciones Web bajo el patr&oacute;n MVC.</p>
<h2>&iquest;Por qu&eacute; usar flask?</h2>
<ul>
<li>Flask es un "micro" framework: se enfoca en proporcionar lo m&iacute;nimo necesario para que puedas poner a funcionar una aplicaci&oacute;n b&aacute;sica en cuesti&oacute;n de minutos. Se necesitamos m&aacute;s funcionalidades podemos extenderlo con las <a href="http://flask.pocoo.org/extensions/">Flask extensions</a>.</li>
<li>Incluye un servidor web de desarrollo para que puedas probar tus aplicaciones sin tener que instalar un servidor web.</li>
<li>Tambi&eacute;n trae un depurador y soporte integrado para pruebas unitarias. </li>
<li>Es compatible con python3, por lo tanto podemos usar la codificaci&oacute;n de caracteres unicode, y 100% compatible con el est&aacute;ndar WSGI.</li>
<li>Buen manejo de rutas: Con el uso de un decorador python podemos hacer que nuestra aplicaci&oacute;n con URL simples y limpias.</li>
<li>Flask soporta el uso de cookies seguras y el uso de sesiones.</li>
<li>Flask se apoya en el motor de plantillas Jinja2, que nos permite de forma sencilla renderizar vistas y respuestas.</li>
<li>Flask no tiene ORMs, wrappers o configuraciones complejas, eso lo convierte en un candidato ideal para aplicaciones &aacute;giles o que no necesiten manejar ninguna dependencia. Si necesitas trabajar con base de datos s&oacute;lo tenemos que utilizar una extensi&oacute;n.</li>
<li>Este framework resulta ideal para construir servicios web (como APIs REST) o aplicaciones de contenido est&aacute;tico.</li>
<li>Flask es Open Source y est&aacute; amparado bajo una licencia BSD.</li>
<li>Puedes ver el c&oacute;digo en <a href="https://github.com/pallets/flask">Github</a>, la <a href="https://github.com/pallets/flask">documentaci&oacute;n</a> es muy completa y te puedes suscribir a su <a href="http://flask.pocoo.org/mailinglist/">lista de correos</a> para mantenerte al d&iacute;a de las actualizaciones.</li>
</ul>
<p><!--more--></p>
<h2>Instalaci&oacute;n de flask</h2>
<p>Vamos a realizar la instalaci&oacute;n de Flask utilizando la herramienta <code>pip</code> en un entorno virtual creado con <code>virtualenv</code>. La instalaci&oacute;n de Flask depende de dos paquetes: <a href="http://werkzeug.pocoo.org/">Werkzeug</a>, una librer&iacute;a WSGI para Python y <a href="http://jinja.pocoo.org/docs/2.9/">jinja2</a> como motor de plantillas.</p>
<h3>Creando el entorno virtual</h3>
<p>Como Flask es compatible con python3 vamos a crear un entorno virtual compatible con la versi&oacute;n 3 del interprete python. Para ello nos aseguremos que tenemos la utilidad instalada:</p>
<pre><code># apt-get install python-virtualenv
</code></pre>
<p>Y creamos el entorno virtual:</p>
<pre><code>$ virtualenv -p /usr/bin/python3 flask
</code></pre>
<p>Para activar nuestro entorno virtual:</p>
<pre><code>$ source flask/bin/activate
(flask)$ 
</code></pre>
<p>Y a continuaci&oacute;n instalamos Flask:</p>
<pre><code>(flask)$ pip install Flask
</code></pre>
<p>Si nos aparece el siguiente aviso durante la instalaci&oacute;n:</p>
<pre><code>WARNING: The C extension could not be compiled, speedups are not enabled.
Failure information, if any, is above.
Retrying the build without the C extension now.
</code></pre>
<p>La instalaci&oacute;n se realiza bien, pero no se habilita el aumento de rendimiento de jinja2.</p>
<p>Puedes volver a realizar la instalaci&oacute;n despu&eacute;s de instalar el siguiente paquete:</p>
<pre><code># apt-get install python3-dev
</code></pre>
<p>Al finalizar podemos comprobar los paquetes python instalados:</p>
<pre><code>(flask)$ pip freeze
Flask==0.12.2
Jinja2==2.9.6
MarkupSafe==1.0
Werkzeug==0.12.2
click==6.7
itsdangerous==0.24
</code></pre>
<p>Podemos guardar las dependencias en un fichero <code>requirements.txt</code>:</p>
<pre><code># pip freeze > requirements.txt
</code></pre>
<p>La utilizaci&oacute;n del fichero ˋrequirements.txtˋ, donde vamos a ir guardando los paquetes python (y sus versiones) de nuestra instalaci&oacute;n, nos va a posibilitar posteriormente poder crear otro entrono virtual con los mismos paquetes:</p>
<pre><code># pip install -r requirements.txt
</code></pre>
<p>Y finalmente comprobamos la versi&oacute;n de flask que tenemos instalada:</p>
<pre><code>(flask)$ flask --version
Flask 0.12.2
Python 3.4.2 (default, Oct  8 2014, 10:45:20) 
[GCC 4.9.1]
</code></pre>
<h2>Corriendo una aplicaci&oacute;n sencilla</h2>
<p>Escribimos nuestra primera aplicaci&oacute;n flask, en un fichero <code>app.py</code>:</p>
<pre><code>from flask import Flask
app = Flask(__name__)   

@app.route('/')
def hello_world():
    return 'Hello, World!'

if __name__ == '__main__':
    app.run()
</code></pre>
<ol>
<li>El objeto <code>app</code> de la clase Flask es nuestra aplicaci&oacute;n WSGI, que nos permitir&aacute; posteriormente desplegar nuestra aplicaci&oacute;n en un servidor Web. Se le pasa como par&aacute;metro el m&oacute;dulo actual (<code>__name__</code>).</li>
<li>El decorador <code>router</code> nos permite filtrar la petici&oacute;n HTTP recibida, de tal forma que si la petici&oacute;n se realiza a la URL <code>/</code> se ejecutar&aacute; la funci&oacute;n <strong>vista</strong> <code>hello_word</code>.</li>
<li>La funci&oacute;n <strong>vista</strong> que se ejecuta devuelve una respuesta HTTP. En este caso devuelve una cadena de caracteres que se ser&aacute; los datos de la respuesta.</li>
<li>Finalmente si ejecutamos este m&oacute;dulo se ejecuta el m&eacute;todo <code>run</code> que ejecuta un servidor web para que podamos probar la aplicaci&oacute;n.</li>
</ol>
<p>De esta forma podemos ejecutar nuestra primera aplicaci&oacute;n:</p>
<pre><code>$ python3 app.py
* Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
</code></pre>
<p>Y podemos acceder a la URL <code>http://127.0.0.1:5000/</code> desde nuestro navegador y ver el resultado.</p>
<p><a class="thumbnail" href="https://www.josedomingo.org/pledin/wp-content/uploads/2018/03/flask2.png"><img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/03/flask2.png" alt="" width="406" height="113" class="aligncenter size-full wp-image-1923" /></a> O podemos ejecutar:</p>
<pre><code>$ curl http://127.0.0.1:5000
Hello, World!
</code></pre>
<h3>Configuraci&oacute;n del servidor web de desarrollo</h3>
<p>Podemos cambiar la direcci&oacute;n y el puerto desde donde nuestro servidor web va a responder. Por ejemplo si queremos acceder a nuestra aplicaci&oacute;n desde cualquier direcci&oacute;n en el puerto 8080:</p>
<pre><code>...
app.run('0.0.0.0',8080)

$ python3 app.py
* Running on http://0.0.0.0:8080/ (Press CTRL+C to quit)
</code></pre>
<h3>Modo "debug"</h3>
<p>Si activamos este modo durante el proceso de desarrollo de nuestra aplicaci&oacute;n tendremos a nuestra disposici&oacute;n una herramienta de depuraci&oacute;n que nos permitir&aacute; estudiar los posibles errores cometidos, adem&aacute;s se activa el modo "reload" que inicia autom&aacute;ticamente el servidor de desarrollo cuando sea necesario. Para activar este modo:</p>
<pre><code>...
app.run(debug=True)

$ python3 app.py
* Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
* Restarting with stat
* Debugger is active!
* Debugger PIN: 106-669-497
</code></pre>
<p>El <code>Debugger PIN</code> lo utilizaremos para utilizar la herramienta de depuraci&oacute;n.</p>
<p>En la prox&iacute;ma entrada seguiremos trabajando con flask y aprenderemos a trabajar con las rutas que nuestra aplicaci&oacute;n va a responder.</p>
