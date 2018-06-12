---
id: 1315
title: Crear páginas web con Bottle. Trabajando con plantillas (2ª parte)
date: 2015-03-10T13:49:41+00:00


guid: http://www.josedomingo.org/pledin/?p=1315
permalink: /2015/03/crear-paginas-web-con-bottle-trabajando-con-plantillas-2a-parte/


tags:
  - bottle
  - Python
  - Web
---
![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/logo_nav2.png)

En la [entrada anterior](http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-python-web-framework_1a_parte) vimos una introducción al web framework Bottle para la realización de páginas web usando el lenguaje python. En esta entrada vamos a ver una de las herramientas más flexibles que nos ofrece este framework: las [plantillas](http://bottlepy.org/docs/dev/stpl.html). Bottle nos ofrece un motor de plantillas que nos facilita la creación de páginas web. A las plantillas podemos enviar información y gestionarla con código python. Para estudiar el uso de plantillas vamos a ver un ejemplo donde veremos los distintos conceptos relacionados con las plantillas.

    from bottle import Bottle,route,run,request,template
    @route('/hello')
    @route('/hello/')
    @route('/hello/<name>')
    def hello(name='Mundo'):
        return template('template_hello.tpl', nombre=name)
    @route('/suma/<num1>/<num2>')
    def suma(num1,num2):
        return template('template_suma.tpl',numero1=num1,numero2=num2)
    @route('/lista')
    def lista():
        lista=["Manzana","Platano","Naranja"]
        return template('template_lista.tpl',lista=lista)
    @route('/dict')
    def dict():
        datos={"Nombre":"Jose","Telefono":645223344}
        return template('template_dict.tpl',dict=datos)
    run(host='0.0.0.0', port=8080)

## Uso de una plantilla simple (template_hello.tpl)

En este caso la plantilla recibe una variable (_nombre_), con el nombre que hemos indicado en la URL. Si estudiamos la plantilla:

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

1. Vemos como podemos usar la variable en el código html usando los caracteres {% raw %}`{{    }}`{% endraw %}.
2. Con el símbolo `%` indicamos la inclusión de una línea python. Dentro de las plantillas no funciona el tabulado propio de python, por lo hay que indicar el final de los bucles y las condicionales con una instrucción `end`.
3. Cómo podemos comprobar podemos hacer uso de los métodos de la clase String (`{{nombre.tittle()}}`)

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle6.png)

## Envío de varias variables a una plantilla (template_suma.tpl)

En este caso vamos a realizar la suma de dos números que recibimos en una ruta dinámica con dos variables (_num1 y num2_), en este ejemplo la plantilla recibirá esos dos valores en dos variables (_numero1 y numero2_):

    {% raw %}
    ...
    <body>
        <header>
           <h1>Suma {{numero1}}+{{numero2}}</h1>
        </header>
        <%
          suma=int(numero1)+int(numero2)
          if suma>0:
            resultado="positivo"
          else:
            resultado="negativo"
          end
        %>
        <p> La suma es <strong>{{suma}}</strong> el resultado es {{resultado}}</p>
    ...
    {% endraw %}

1. En este caso estamos trabajando con dos variables: {% raw %}`{{numero1}}` y `{{numero2}}.`{% endraw %}
2. Con el símbolo <% y %> indicamos un bloque en python. Tenemos que usar la instrucción `end` para indicar el final de la condicional.
3. Hemos usados dos variables nuevas: `suma` donde guardamos la suma de los dos números y `resultado`, cadena donde guardamos si el resultados es positivo o negativo.
4. Si queremos escribir estas dos variables en el html tenemos que usar los caracteres {% raw %}`{{ }}`.{% endraw %}

 ![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle7.png)
 
 ## Envío de una lista a una plantilla (template_lista.tpl)

En los dos casos anteriores hemos enviado a las plantillas cadenas, en este caso vamos a ver cómo también podemos enviar una lista. La plantilla va a recibir una variable llamada `lista`. La plantilla quedaría de la siguiente manera:

    {% raw %}
    ...
    <body>
        <header>
           <h1>Frutas</h1>
        </header>
        <ul>
        % for fruta in lista:
          <li> {{fruta}} </li>
        % end
        </ul>    
    </body>
    ...
    {% endraw %}

1. En este ejemplo vemos como podemos recorrer la lista. Usamos la instrucción `end`* para indicar la terminación del bucle.
2. De la misma forma que en ejemplos anteriores para escribir el valor de la variable en una línea html usamos los caracteres {% raw %}{{ }}{% endraw %}.
3. Podríamos usar cualquier método de la clase lista para trabajar con ella.

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle8.png)

## Envío de un diccionario a una plantilla (template_dict.tpl)

Finalmente podemos enviar un diccionario a una plantilla, en nuestro ejemplo la variable que recibe la plantilla se llama `dict`:

    {% raw %}
    ...
    <body>
        <header>
           <h1>Diccionario</h1>
        </header>
        <p>Nombre: {{dict["Nombre"]}}, teléfono {{dict['Telefono']}} </p>

    </body>
    ...
    {% endraw %}

1. Vemos como accedemos a los distintos campos del diccionario `dict["Telefono"]`.
2. Podríamos usar cualquier método de diccionario para trabajar con ellos.

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle9.png)

## Ejemplo final: Temperaturas

Para ilustrar un ejemplo donde se desarrolla una pagina web completa vamos a utilizar el código que encontrarás en el siguiente [repositorio GitHub](https://github.com/josedom24/bottle_lm), concretamente en la carpeta [5_Temperaturas](https://github.com/josedom24/bottle_lm/tree/master/5_temperaturas). Este programa muestra una lista de los municipios de la provincia de Sevilla y podemos obtener de cada uno de ellos la temperatura máxima y mínima del día actual.

    from bottle import route, default_app, template, run, static_file, error
    from lxml import etree
    @route('/')
    def index():
        doc=etree.parse("sevilla.xml")
        muni=doc.findall("municipio")
        return template("index.tpl", mun=muni)
    @route('/<cod>/<name>')
    def temp(cod,name):
    	doc=etree.parse("http://www.aemet.es/xml/municipios/localidad_"+cod+".xml")
    	p=doc.find("prediccion/dia")
    	max=p.find("temperatura").find("maxima").text
    	min=p.find("temperatura").find("minima").text
    	return template("temp.tpl",name=name,max=max,min=min)

    @route('/static/<filepath:path>')
    def server_static(filepath):
        return static_file(filepath, root='static')

    @error(404)
    def error404(error):
        return 'Nothing here, sorry'

    run(host='0.0.0.0', port=8080)

* Cuando accedemos a la página principal, mostramos una lista de todas las localidades de la provincia de Sevilla. Creamos una lista de enlaces a la siguiente URL: `/cod_postal/nombre`. Esta información la hemos leído de un [fichero xml](https://raw.githubusercontent.com/josedom24/bottle_lm/master/5_temperaturas/sevilla.xml), utilizando la [librería lxml](http://www.josedomingo.org/pledin/2015/01/trabajar-con-ficheros-xml-desde-python_1/ "Trabajar con ficheros xml desde python (1ª parte)"). La platilla `index.tpl` recibe la lista de objetos `Element` del árbol xml donde se guarda la información de los municipios.

        {% raw %}
        % include('header.tpl', title='Temperaturas')
        <h1>Municipios de Sevilla</h1>
        	<ul>
        	% for m in mun:
        		<li><a href="/{{m.attrib["value"][-5:]}}/{{m.text}}">{{m.text}}</a></li>
        	%end
        	</ul>
        % include('footer.tpl')
        {% endraw %}

En la plantilla observamos el uso de la función `include` que nos permite añadir código html a nuestra plantilla. Indicar que también se puede mandar variables a las plantillas que incluimos. Puedes ver en los siguientes enlaces las plantillas: <a href="https://raw.githubusercontent.com/josedom24/bottle_lm/master/5_temperaturas/header.tpl">`header.tpl`</a> y <a href="https://raw.githubusercontent.com/josedom24/bottle_lm/master/5_temperaturas/footer.tpl">`footer.tpl`</a>.

* Cuando accedemos a la URL `/cod_postal/nombre` se lee el fichero xml con los datos climáticos del municipio (el nombre del fichero contiene el código postal) de la página de la [aemet](http://www.aemet.es). La plantilla `temp.tpl` recibe tras variables: el nombre del municipio, la temperatura máxima y la mínima.

        {% raw %}
        % include('header.tpl', title='Temperaturas '+name)
            <h1>{{name}}</h1>
        		<p>Temperatura máxima:{{max}}ºC</p>
        		<p>temperatura mínima:{{min}}ºC</p>
        		<a href="..">Volver</a>
        % include('footer.tpl')
        {% endraw %}

* Para servir contenido estático, como por ejemplo la hoja de estilo o las imágenes, tenemos que definir una ruta en nuestro programa que identifique el path donde se encuentran los ficheros estáticos, en nuestro caso lo vamos a guardar en un directorio llamado `static` y utilizar la función `static_file` para devolver el fichero indicado. Utilizando esta forma de servir contenido estático, los ficheros pueden estar guardados en subdirectorios dentro del directorio `static`.

        ...
        @route('/static/<filepath:path>')
        def server_static(filepath):
            return static_file(filepath, root='static')
        ...

* Finalmente si queremos manejar el código de error 404 cuando accedemos a una URL incorrecta, podemos usar el siguiente código:

        @error(404)
        def error404(error):
            return 'Nothing here, sorry'

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_t1.png)
  
![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_t2.png)

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_p3.png)

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->