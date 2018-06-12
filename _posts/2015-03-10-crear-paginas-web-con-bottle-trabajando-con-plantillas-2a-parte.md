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
[<img class="aligncenter size-full wp-image-1317" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/logo_nav2.png" alt="logo_nav2" width="200" height="69" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/logo_nav2.png){.thumbnail}

En la [entrada anterior](http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-python-web-framework_1a_parte) vimos una introducción al web framework Bottle para la realización de páginas web usando el lenguaje python. En esta entrada vamos a ver una de las herramientas más flexibles que nos ofrece este framework: las [plantillas](http://bottlepy.org/docs/dev/stpl.html). Bottle nos ofrece un motor de plantillas que nos facilita la creación de páginas web. A las plantillas podemos enviar información y gestionarla con código python. Para estudiar el uso de plantillas vamos a ver un ejemplo donde veremos los distintos conceptos relacionados con las plantillas.

<pre>from bottle import Bottle,route,run,request,template
@route('/hello')
@route('/hello/')
@route('/hello/&lt;name&gt;')
def hello(name='Mundo'):
    return template('template_hello.tpl', nombre=name)
@route('/suma/&lt;num1&gt;/&lt;num2&gt;')
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
run(host='0.0.0.0', port=8080)</pre>

<!--more-->

### Uso de una plantilla simple (template_hello.tpl)

En este caso la plantilla recibe una variable (_nombre_), con el nombre que hemos indicado en la URL. Si estudiamos la plantilla:

<pre>&lt;!DOCTYPE html&gt;
&lt;html lang="es"&gt;
&lt;head&gt;
<strong>&lt;title&gt;Hola, que tal {{nombre}}&lt;/title&gt;</strong>
&lt;meta charset="utf-8" /&gt;
&lt;/head&gt;
 
&lt;body&gt;
    &lt;header&gt;
       &lt;h1&gt;Mi sitio web&lt;/h1&gt;
       &lt;p&gt;Mi sitio web creado en html5&lt;/p&gt;
    &lt;/header&gt;
    &lt;h2&gt;Vamos a saludar&lt;/h2&gt;
   <strong> % if nombre=="Mundo":</strong>
<strong>      &lt;p&gt; Hola &lt;strong&gt;{{nombre}}&lt;/strong&gt;&lt;/p&gt;</strong>
<strong>    %else:</strong>
<strong>      &lt;h1&gt;Hola {{nombre.title()}}!&lt;/h1&gt;</strong>
<strong>      &lt;p&gt;¿Cómo estás?</strong>
<strong>    %end</strong>
&lt;/body&gt;
&lt;/html&gt;</pre>

  1. Vemos como podemos usar la variable en el código html usando los caracteres **{{    }}**.
  2. Con el símbolo **%** indicamos la inclusión de una línea python. Dentro de las plantillas no funciona el tabulado propio de python, por lo hay que indicar el final de los bucles y las condicionales con una instrucción _**end.**_
  3. Cómo podemos comprobar podemos hacer uso de los métodos de la clase String (_{{nombre.tittle()}}_)

### [<img class="aligncenter size-full wp-image-1307" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle6.png" alt="bottle6" width="268" height="309" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle6.png 268w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle6-260x300.png 260w" sizes="(max-width: 268px) 100vw, 268px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle6.png){.thumbnail}Envío de varias variables a una plantilla (template_suma.tpl)

En este caso vamos a realizar la suma de dos números que recibimos en una ruta dinámica con dos variables (_num1 y num2_), en este ejemplo la plantilla recibirá esos dos valores en dos variables (_numero1 y numero2_):

<pre>...
&lt;body&gt;
    &lt;header&gt;
       <strong>&lt;h1&gt;Suma {{numero1}}+{{numero2}}&lt;/h1&gt;</strong>
    &lt;/header&gt;
    <strong>&lt;%</strong>
<strong>      suma=int(numero1)+int(numero2)</strong>
<strong>      if suma&gt;0:</strong>
<strong>        resultado="positivo"</strong>
<strong>      else:</strong>
<strong>        resultado="negativo"</strong>
<strong>      end</strong>
<strong>    %&gt;</strong>
    <strong>&lt;p&gt; La suma es &lt;strong&gt;{{suma}}&lt;/strong&gt; el resultado es {{resultado}}&lt;/p&gt;</strong>
...</pre>

  1. En este caso estamos trabajando con dos variables: _{{numero1}}_ y _{{numero2}}._
  2. Con el símbolo <% y %> indicamos un bloque en python. Tenemos que usar la instrucción **_end_** para indicar el final de la condicional.
  3. Hemos usados dos variables nuevas: _suma_ donde guardamos la suma de los dos números y_  resultado,_ cadena donde guardamos si el resultados es positivo o negativo.
  4. Si queremos escribir estas dos variables en el html tenemos que usar los caracteres **{{ }}**.

### <img class="aligncenter size-full wp-image-1309" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle7.png" alt="bottle7" width="338" height="164" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle7.png 338w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle7-300x146.png 300w" sizes="(max-width: 338px) 100vw, 338px" />Envío de una lista a una plantilla (template_lista.tpl)

En los dos casos anteriores hemos enviado a las plantillas cadenas, en este caso vamos a ver cómo también podemos enviar una lista. La plantilla va a recibir una variable llamada _lista._ La plantilla quedaría de la siguiente manera:

<pre>...
&lt;body&gt;
    &lt;header&gt;
       &lt;h1&gt;Frutas&lt;/h1&gt;
    &lt;/header&gt;
    &lt;ul&gt;
    <strong>% for fruta in lista:</strong>
<strong>      &lt;li&gt; {{fruta}} &lt;/li&gt;</strong>
<strong>    % end</strong>
    &lt;/ul&gt;    
&lt;/body&gt;
...</pre>

  1. En este ejemplo vemos como podemos recorrer la lista. Usamos la instrucción **_end_** para indicar la terminación del bucle.
  2. De la misma forma que en ejemplos anteriores para escribir el valor de la variable en una línea html usamos los caracteres **{{ }}**.
  3. Podríamos usar cualquier método de la clase lista para trabajar con ella.

### [<img class="aligncenter size-full wp-image-1310" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle8.png" alt="bottle8" width="201" height="213" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle8.png){.thumbnail}Envío de un diccionario a una plantilla (template_dict.tpl)

Finalmente podemos enviar un diccionario a una plantilla, en nuestro ejemplo la variable que recibe la plantilla se llama _dict:_

<pre>...
&lt;body&gt;
    &lt;header&gt;
       &lt;h1&gt;Diccionario&lt;/h1&gt;
    &lt;/header&gt;
    <strong>&lt;p&gt;Nombre: {{dict["Nombre"]}}, teléfono {{dict['Telefono']}} &lt;/p&gt;</strong>
    
&lt;/body&gt;
...

</pre>

  1. Vemos como accedemos a los distintos campos del diccionario _dict[&#8216;Telefono&#8217;]._
  2. Podríamos usar cualquier método de diccionario para trabajar con ellos.

## [<img class="aligncenter size-full wp-image-1312" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle9.png" alt="bottle9" width="310" height="154" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle9.png 310w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle9-300x149.png 300w" sizes="(max-width: 310px) 100vw, 310px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle9.png){.thumbnail}Ejemplo final: Temperaturas

Para ilustrar un ejemplo donde se desarrolla una pagina web completa vamos a utilizar el código que encontrarás en el siguiente [repositorio GitHub](https://github.com/josedom24/bottle_lm), concretamente en la carpeta [5_Temperaturas](https://github.com/josedom24/bottle_lm/tree/master/5_temperaturas). Este programa muestra una lista de los municipios de la provincia de Sevilla y podemos obtener de cada uno de ellos la temperatura máxima y mínima del día actual.

<pre>from bottle import route, default_app, template, run, static_file, error
from lxml import etree
@route('/')
def index():
    doc=etree.parse("sevilla.xml")
    muni=doc.findall("municipio")
    return template("index.tpl", mun=muni)
@route('/&lt;cod&gt;/&lt;name&gt;')
def temp(cod,name):
	doc=etree.parse("http://www.aemet.es/xml/municipios/localidad_"+cod+".xml")
	p=doc.find("prediccion/dia")
	max=p.find("temperatura").find("maxima").text
	min=p.find("temperatura").find("minima").text
	return template("temp.tpl",name=name,max=max,min=min)

@route('/static/&lt;filepath:path&gt;')
def server_static(filepath):
    return static_file(filepath, root='static')

@error(404)
def error404(error):
    return 'Nothing here, sorry'

run(host='0.0.0.0', port=8080)

</pre>

  * Cuando accedemos a la página principal, mostramos una lista de todas las localidades de la provincia de Sevilla. Creamos una lista de enlaces a la siguiente URL: _/cod_postal/nombre._ Esta información la hemos leído de un [fichero xml](https://raw.githubusercontent.com/josedom24/bottle_lm/master/5_temperaturas/sevilla.xml), utilizando la [librería lxml](http://www.josedomingo.org/pledin/2015/01/trabajar-con-ficheros-xml-desde-python_1/ "Trabajar con ficheros xml desde python (1ª parte)"). La platilla _index.tpl_ recibe la lista de objetos _Element_ del árbol xml donde se guarda la información de los municipios.

<pre>% include('header.tpl', title='Temperaturas')
&lt;h1&gt;Municipios de Sevilla&lt;/h1&gt;
	&lt;ul&gt;
	% for m in mun:
		&lt;li&gt;&lt;a href="/{{m.attrib["value"][-5:]}}/{{m.text}}"&gt;{{m.text}}&lt;/a&gt;&lt;/li&gt;
	%end
	&lt;/ul&gt;
% include('footer.tpl')
</pre>

<p style="padding-left: 30px;">
  En la plantilla observamos el uso de la función <em>include</em> que nos permite añadir código html a nuestra plantilla. Indicar que también se puede mandar variables a las plantillas que incluimos. Puedes ver en los siguientes enlaces las plantillas: <a href="https://raw.githubusercontent.com/josedom24/bottle_lm/master/5_temperaturas/header.tpl">header.tpl</a> y <a href="https://raw.githubusercontent.com/josedom24/bottle_lm/master/5_temperaturas/footer.tpl">footer.tpl</a>.
</p>

  * Cuando accedemos a la URL _/cod_postal/nombre_ se lee el fichero xml con los datos climáticos del municipio (el nombre del fichero contiene el código postal) de la página de la [aemet](http://www.aemet.es). La plantilla _temp.tpl_ recibe tras variables: el nombre del municipio, la temperatura máxima y la mínima.

<pre>% include('header.tpl', title='Temperaturas '+name)
    &lt;h1&gt;{{name}}&lt;/h1&gt;
		&lt;p&gt;Temperatura máxima:{{max}}ºC&lt;/p&gt;
		&lt;p&gt;temperatura mínima:{{min}}ºC&lt;/p&gt;
		&lt;a href=".."&gt;Volver&lt;/a&gt;
% include('footer.tpl')</pre>

  * Para servir contenido estático, como por ejemplo la hoja de estilo o las imágenes, tenemos que definir una ruta en nuestro programa que identifique el path donde se encuentran los ficheros estáticos, en nuestro caso lo vamos a guardar en un directorio llamado _static_ y utilizar la función _static_file_ para devolver el fichero indicado_._ Utilizando esta forma de servir contenido estático, los ficheros pueden estar guardados en subdirectorios dentro del directorio _static._

<pre>...
@route('/static/&lt;filepath:path&gt;')
def server_static(filepath):
    return static_file(filepath, root='static')
...
</pre>

  * Finalmente si queremos manejar el código de error 404 cuando accedemos a una URL incorrecta, podemos usar el siguiente código:

<pre>@error(404)
def error404(error):
    return 'Nothing here, sorry'</pre>

[<img class="aligncenter size-full wp-image-1325" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_t1.png" alt="bottle_t1" width="506" height="796" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_t1.png 506w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_t1-191x300.png 191w" sizes="(max-width: 506px) 100vw, 506px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_t1.png){.thumbnail}
  
[<img class="aligncenter size-full wp-image-1326" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_t2.png" alt="bottle_t2" width="446" height="612" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_t2.png 446w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_t2-219x300.png 219w" sizes="(max-width: 446px) 100vw, 446px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_t2.png){.thumbnail}

[<img class="aligncenter size-full wp-image-1328" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_p3.png" alt="bottle_p3" width="265" height="100" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/03/bottle_p3.png){.thumbnail}

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->