---
id: 1928
title: 'flask: Enrutamiento (2ª parte)'
date: 2018-03-20T09:16:56+00:00


guid: https://www.josedomingo.org/pledin/?p=1928
permalink: /2018/03/flask-enrutamiento-2a-parte/


tags:
  - Flask
  - Python
  - Web
---
[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask.png" alt="" width="460" height="180" class="aligncenter size-full wp-image-1919" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/flask.png){.thumbnail}

# Enrutamiento: rutas

El objeto Flask `app` nos proporciona un decorador `router` que es capaz de filtrar la función _vista_ que se va ejecutar analizando la petición HTTP, fundamentalmente por la ruta y el método que se hace la petición.

## Trabajando con rutas

Veamos un ejemplo:

    ...
    @app.route('/')
    def inicio():
        return 'Página principal'   
    
    @app.route('/articulos/')
    def articulos():
        return 'Lista de artículos' 
    
    @app.route('/acercade')
    def acercade():
        return 'Página acerca de...'
    

En este caso se comprueba la ruta de la petición HTTP, y cuando coincide con alguna indicada en las rutas se ejecuta la función correspondiente devolviendo una respuesta HTTP.

<!--more-->

[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/rutas1.png" alt="" width="399" height="106" class="aligncenter size-full wp-image-1934" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/rutas1.png){.thumbnail} Si declaramos rutas terminando en `/` son consideradas como un directorio de un sistema de fichero, en este caso si se accede a la ruta sin la barra final se producirá una redirección a la ruta correcta.

[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta2.png" alt="" width="474" height="112" class="aligncenter size-full wp-image-1933" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta2.png){.thumbnail}

Si declaramos la rutas sin `/` final, se consideran un fichero del sistema de fichero, si accedemos a la ruta con el `/` nos devolverá una respuesta con código 404.

[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta3.png" alt="" width="469" height="112" class="aligncenter size-full wp-image-1932" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta3.png){.thumbnail} [<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta4.png" alt="" width="1031" height="157" class="aligncenter size-full wp-image-1931" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta4.png){.thumbnail}

Si la ruta de la petición HTTP no corresponde con ninguna que hayamos indicado se devolverá una respuesta con código de estado 404 indicando que no se ha encontrado el recurso.

## Rutas dinámicas

Podemos gestionar rutas variables, es decir que correspondan a un determinado patrón o expresión regular, por ejemplo:

    @app.route("/articulos/<int:id>")
    def mostrar_ariculo(id):
        return 'Vamos a mostrar el artículo con id:{}'.format(id)
    

[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta5.png" alt="" width="487" height="108" class="aligncenter size-full wp-image-1942" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta5.png){.thumbnail}

Otro ejemplo:

    @app.route("/hello/")
    @app.route("/hello/<string:nombre>")
    @app.route("/hello/<string:nombre>/<int:edad>")
    def hola(nombre=None,edad=None):
        if nombre and edad:
            return 'Hola, {0} tienes {1} años.'.format(nombre,edad)
        elif nombre:
            return 'Hola, {0}'.format(nombre)
        else:
            return 'Hola mundo'
    

[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta6.png" alt="" width="433" height="107" class="aligncenter size-large wp-image-1945" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta6.png){.thumbnail} [<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta7.png" alt="" width="481" height="109" class="aligncenter size-full wp-image-1944" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta7.png){.thumbnail} [<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta8.png" alt="" width="507" height="114" class="aligncenter size-full wp-image-1943" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta8.png){.thumbnail}

La parte dinámica de la ruta la podemos obtener como variable que recibe la función correspondiente. En el segundo ejemplo, además observamos que varias rutas pueden ejecutar una misma función. Aunque no es obligatorio podemos especificar el tipo de la variable capturada:

  * `string`: Acepta cualquier texto sin barras (por defecto)
  * `int`: Acepta enteros
  * `float`: Acepta valores reales
  * `path`: Acepta cadena de caracteres con barras

## Construcción de rutas

Podemos importar la función `url_for` que nos permite construir rutas a partir del nombre de la función asociada. De esta manera en la siguiente ruta voy a generar tres enlaces a las rutas dinámicas que hemos visto anteriormente:

    from flask import Flask, url_for
    ...
    @app.route("/enlaces")
    def enlaces():
            cad='<a href="{0}">Decir hola</a>({0})<br/>'.format(url_for("hola"))
            cad=cad+'<a href="{0}">Decir hola a pepe</a>({0})<br/>'.format(url_for("hola",nombre="pepe"))
            cad=cad+'<a href="{0}">Decir hola a pepe de 16 años</a>({0})'.format(url_for("hola",nombre="pepe",edad=16))
            return cad
    ...
    

Si accedemos a la URL observamos los enlaces y las URL a las que se enlazan: [<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta9.png" alt="" width="471" height="136" class="aligncenter size-full wp-image-1946" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/03/ruta9.png){.thumbnail}

# Enrutamiento: Métodos

Para acceder a las distintas URLs podemos utilizar varios métodos en nuestra petición HTTP. En nuestros ejemplos vamos a trabajar con el método GET y POST, que son los métodos que normalmente podemos utilizar desde un navegador web.

  * GET: Se realiza una petición para obtener un recurso del servidor web. Es el método más utilizado.
  * POST: Aunque con el método GET también podemos mandar información al servidor (por medio de parámetros escritas en la URL), utilizamos el método POST para enviar información a una determinada URL. Normalmente utilizamos los formularios HTML para enviar información al servidor por medio del método POST.

Por defecto las rutas indicadas en la funciones `route` sólo son accesibles utilizando el método GET. Si una URL recibe información por medio del método POST y no queremos que se acceda a ella con un método GET, se definirá de la siguiente manera:

    @app.route('/articulos/new',methods=["POST"])
    def articulos_new():
        return 'Está URL recibe información de un formulario con el método POST'
    

También en muchas ocasiones es deseable acceder a una URL con los dos métodos, de tal manera que haremos una cosa cuando acedemos con GET y haremos otra cuando se acceda con POST. Ejemplo:

    @app.route('/login', methods=['GET', 'POST'])
    def login():
        if request.method == 'POST':
            return 'Hemos accedido con POST'
        else:
            return 'Hemos accedido con GET'
    

En la próxima entrada estudiaremos como Flask gestiona las peticiones HTTP y genera las respuestas.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->