---
id: 1918
title: 'flask: Miniframework python para desarrollar páginas web (1ª parte)'
date: 2018-03-12T20:42:51+00:00


guid: https://www.josedomingo.org/pledin/?p=1918
permalink: /2018/03/flask-miniframework-python-para-desarrollar-paginas-web-1a-parte/


tags:
  - Flask
  - Python
  - Web
---
[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask.png" alt="" width="460" height="180" class="aligncenter size-full wp-image-1919" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask.png){.thumbnail} Flask es un &#8220;micro&#8221; framework escrito en Python y concebido para facilitar el desarrollo de aplicaciones Web bajo el patrón MVC.

## ¿Por qué usar flask?

  * Flask es un &#8220;micro&#8221; framework: se enfoca en proporcionar lo mínimo necesario para que puedas poner a funcionar una aplicación básica en cuestión de minutos. Se necesitamos más funcionalidades podemos extenderlo con las [Flask extensions](http://flask.pocoo.org/extensions/).
  * Incluye un servidor web de desarrollo para que puedas probar tus aplicaciones sin tener que instalar un servidor web.
  * También trae un depurador y soporte integrado para pruebas unitarias. 
  * Es compatible con python3, por lo tanto podemos usar la codificación de caracteres unicode, y 100% compatible con el estándar WSGI.
  * Buen manejo de rutas: Con el uso de un decorador python podemos hacer que nuestra aplicación con URL simples y limpias.
  * Flask soporta el uso de cookies seguras y el uso de sesiones.
  * Flask se apoya en el motor de plantillas Jinja2, que nos permite de forma sencilla renderizar vistas y respuestas.
  * Flask no tiene ORMs, wrappers o configuraciones complejas, eso lo convierte en un candidato ideal para aplicaciones ágiles o que no necesiten manejar ninguna dependencia. Si necesitas trabajar con base de datos sólo tenemos que utilizar una extensión.
  * Este framework resulta ideal para construir servicios web (como APIs REST) o aplicaciones de contenido estático.
  * Flask es Open Source y está amparado bajo una licencia BSD.
  * Puedes ver el código en [Github](https://github.com/pallets/flask), la [documentación](https://github.com/pallets/flask) es muy completa y te puedes suscribir a su [lista de correos](http://flask.pocoo.org/mailinglist/) para mantenerte al día de las actualizaciones.

<!--more-->

## Instalación de flask

Vamos a realizar la instalación de Flask utilizando la herramienta `pip` en un entorno virtual creado con `virtualenv`. La instalación de Flask depende de dos paquetes: [Werkzeug](http://werkzeug.pocoo.org/), una librería WSGI para Python y [jinja2](http://jinja.pocoo.org/docs/2.9/) como motor de plantillas.

### Creando el entorno virtual

Como Flask es compatible con python3 vamos a crear un entorno virtual compatible con la versión 3 del interprete python. Para ello nos aseguremos que tenemos la utilidad instalada:

    # apt-get install python-virtualenv
    

Y creamos el entorno virtual:

    $ virtualenv -p /usr/bin/python3 flask
    

Para activar nuestro entorno virtual:

    $ source flask/bin/activate
    (flask)$ 
    

Y a continuación instalamos Flask:

    (flask)$ pip install Flask
    

Si nos aparece el siguiente aviso durante la instalación:

    WARNING: The C extension could not be compiled, speedups are not enabled.
    Failure information, if any, is above.
    Retrying the build without the C extension now.
    

La instalación se realiza bien, pero no se habilita el aumento de rendimiento de jinja2.

Puedes volver a realizar la instalación después de instalar el siguiente paquete:

    # apt-get install python3-dev
    

Al finalizar podemos comprobar los paquetes python instalados:

    (flask)$ pip freeze
    Flask==0.12.2
    Jinja2==2.9.6
    MarkupSafe==1.0
    Werkzeug==0.12.2
    click==6.7
    itsdangerous==0.24
    

Podemos guardar las dependencias en un fichero `requirements.txt`:

    # pip freeze > requirements.txt
    

La utilización del fichero ˋrequirements.txtˋ, donde vamos a ir guardando los paquetes python (y sus versiones) de nuestra instalación, nos va a posibilitar posteriormente poder crear otro entrono virtual con los mismos paquetes:

    # pip install -r requirements.txt
    

Y finalmente comprobamos la versión de flask que tenemos instalada:

    (flask)$ flask --version
    Flask 0.12.2
    Python 3.4.2 (default, Oct  8 2014, 10:45:20) 
    [GCC 4.9.1]
    

## Corriendo una aplicación sencilla

Escribimos nuestra primera aplicación flask, en un fichero `app.py`:

    from flask import Flask
    app = Flask(__name__)   
    
    @app.route('/')
    def hello_world():
        return 'Hello, World!'
    
    if __name__ == '__main__':
        app.run()
    

  1. El objeto `app` de la clase Flask es nuestra aplicación WSGI, que nos permitirá posteriormente desplegar nuestra aplicación en un servidor Web. Se le pasa como parámetro el módulo actual (`__name__`).
  2. El decorador `router` nos permite filtrar la petición HTTP recibida, de tal forma que si la petición se realiza a la URL `/` se ejecutará la función **vista** `hello_word`.
  3. La función **vista** que se ejecuta devuelve una respuesta HTTP. En este caso devuelve una cadena de caracteres que se será los datos de la respuesta.
  4. Finalmente si ejecutamos este módulo se ejecuta el método `run` que ejecuta un servidor web para que podamos probar la aplicación.

De esta forma podemos ejecutar nuestra primera aplicación:

    $ python3 app.py
    * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
    

Y podemos acceder a la URL `http://127.0.0.1:5000/` desde nuestro navegador y ver el resultado.

[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask2.png" alt="" width="406" height="113" class="aligncenter size-full wp-image-1923" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask2.png){.thumbnail} O podemos ejecutar:

    $ curl http://127.0.0.1:5000
    Hello, World!
    

### Configuración del servidor web de desarrollo

Podemos cambiar la dirección y el puerto desde donde nuestro servidor web va a responder. Por ejemplo si queremos acceder a nuestra aplicación desde cualquier dirección en el puerto 8080:

    ...
    app.run('0.0.0.0',8080)
    
    $ python3 app.py
    * Running on http://0.0.0.0:8080/ (Press CTRL+C to quit)
    

### Modo &#8220;debug&#8221;

Si activamos este modo durante el proceso de desarrollo de nuestra aplicación tendremos a nuestra disposición una herramienta de depuración que nos permitirá estudiar los posibles errores cometidos, además se activa el modo &#8220;reload&#8221; que inicia automáticamente el servidor de desarrollo cuando sea necesario. Para activar este modo:

    ...
    app.run(debug=True)
    
    $ python3 app.py
    * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
    * Restarting with stat
    * Debugger is active!
    * Debugger PIN: 106-669-497
    

El `Debugger PIN` lo utilizaremos para utilizar la herramienta de depuración.

En la proxíma entrada seguiremos trabajando con flask y aprenderemos a trabajar con las rutas que nuestra aplicación va a responder.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->