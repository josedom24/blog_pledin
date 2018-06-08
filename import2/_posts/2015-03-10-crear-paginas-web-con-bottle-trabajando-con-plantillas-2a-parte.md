---
layout: post
status: publish
published: true
title: Crear p&aacute;ginas web con Bottle. Trabajando con plantillas (2&ordf; parte)
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1315
wordpress_url: http://www.josedomingo.org/pledin/?p=1315
date: '2015-03-10 13:49:41 +0000'
date_gmt: '2015-03-10 12:49:41 +0000'
categories:
- General
tags:
- Web
- Python
- bottle
comments: []
---
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/logo_nav2.png"><img class="aligncenter size-full wp-image-1317" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/logo_nav2.png" alt="logo_nav2" width="200" height="69" /></a></p>
<p>En la <a href="http://www.josedomingo.org/pledin/2015/03/crear-paginas-web-con-bottle-python-web-framework_1a_parte">entrada anterior</a> vimos una introducci&oacute;n al web framework Bottle para la realizaci&oacute;n de p&aacute;ginas web usando el lenguaje python. En esta entrada vamos a ver una de las herramientas m&aacute;s flexibles que nos ofrece este framework: las <a href="http://bottlepy.org/docs/dev/stpl.html">plantillas</a>. Bottle nos ofrece un motor de plantillas que nos facilita la creaci&oacute;n de p&aacute;ginas web. A las plantillas podemos enviar informaci&oacute;n y gestionarla con c&oacute;digo python. Para estudiar el uso de plantillas vamos a ver un ejemplo donde veremos los distintos conceptos relacionados con las plantillas.</p>
<pre>from bottle import Bottle,route,run,request,template
@route('/hello')
@route('/hello/')
@route('/hello/<name>')
def hello(name='Mundo'):
&nbsp;&nbsp;&nbsp; return template('template_hello.tpl', nombre=name)
@route('/suma/<num1>/<num2>')
def suma(num1,num2):
&nbsp;&nbsp;&nbsp; return template('template_suma.tpl',numero1=num1,numero2=num2)
@route('/lista')
def lista():
&nbsp;&nbsp;&nbsp; lista=["Manzana","Platano","Naranja"]
&nbsp;&nbsp;&nbsp; return template('template_lista.tpl',lista=lista)
@route('/dict')
def dict():
&nbsp;&nbsp;&nbsp; datos={"Nombre":"Jose","Telefono":645223344}
&nbsp;&nbsp;&nbsp; return template('template_dict.tpl',dict=datos)
run(host='0.0.0.0', port=8080)</pre>
<p><!--more--></p>
<h3>Uso de una plantilla simple (template_hello.tpl)</h3>
<p>En este caso la plantilla recibe una variable (<em>nombre</em>), con el nombre que hemos indicado en la URL. Si estudiamos la plantilla:</p>
<pre><!DOCTYPE html>
<html lang="es">
<head>
<strong><title>Hola, que tal {{nombre}}</title></strong>
<meta charset="utf-8" />
</head>
&nbsp;
<body>
&nbsp;&nbsp;&nbsp; <header>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <h1>Mi sitio web</h1>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <p>Mi sitio web creado en html5</p>
&nbsp;&nbsp;&nbsp; </header>
&nbsp;&nbsp;&nbsp; <h2>Vamos a saludar</h2>
&nbsp;&nbsp;&nbsp;<strong> % if nombre=="Mundo":</strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <p> Hola <strong>{{nombre}}</strong></p></strong>
<strong>&nbsp;&nbsp;&nbsp; %else:</strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <h1>Hola {{nombre.title()}}!</h1></strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <p>&iquest;C&oacute;mo est&aacute;s?</strong>
<strong>&nbsp;&nbsp;&nbsp; %end</strong>
</body>
</html></pre>
<ol>
<li>Vemos como podemos usar la variable en el c&oacute;digo html usando los caracteres <strong>{{ &nbsp;&nbsp; }}</strong>.</li>
<li>Con el s&iacute;mbolo <strong>%</strong> indicamos la inclusi&oacute;n de una l&iacute;nea python. Dentro de las plantillas no funciona el tabulado propio de python, por lo hay que indicar el final de los bucles y las condicionales con una instrucci&oacute;n <em><strong>end.</strong></em></li>
<li>C&oacute;mo podemos comprobar podemos hacer uso de los m&eacute;todos de la clase String (<em>{{nombre.tittle()}}</em>)</li>
</ol>
<h3><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle6.png"><img class="aligncenter size-full wp-image-1307" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle6.png" alt="bottle6" width="268" height="309" /></a>Env&iacute;o de varias variables a una plantilla (template_suma.tpl)</h3>
<p>En este caso vamos a realizar la suma de dos n&uacute;meros que recibimos en una ruta din&aacute;mica con dos variables (<em>num1 y num2</em>), en este ejemplo la plantilla recibir&aacute; esos dos valores en dos variables (<em>numero1 y numero2</em>):</p>
<pre>...
<body>
&nbsp;&nbsp;&nbsp; <header>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <strong><h1>Suma {{numero1}}+{{numero2}}</h1></strong>
&nbsp;&nbsp;&nbsp; </header>
&nbsp;&nbsp;&nbsp; <strong><%</strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; suma=int(numero1)+int(numero2)</strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if suma>0:</strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; resultado="positivo"</strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else:</strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; resultado="negativo"</strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; end</strong>
<strong>&nbsp;&nbsp;&nbsp; %></strong>
&nbsp;&nbsp;&nbsp; <strong><p> La suma es <strong>{{suma}}</strong> el resultado es {{resultado}}</p></strong>
...</pre>
<ol>
<li>En este caso estamos trabajando con dos variables: <em>{{numero1}}</em> y <em>{{numero2}}.</em></li>
<li>Con el s&iacute;mbolo <% y %> indicamos un bloque en python. Tenemos que usar la instrucci&oacute;n <strong><em>end </em></strong>para indicar el final de la condicional.</li>
<li>Hemos usados dos variables nuevas: <em>suma </em>donde guardamos la suma de los dos n&uacute;meros y<em>&nbsp; resultado, </em>cadena donde guardamos si el resultados es positivo o negativo.</li>
<li>Si queremos escribir estas dos variables en el html tenemos que usar los caracteres <strong>{{ }}</strong>.</li>
</ol>
<h3><img class="aligncenter size-full wp-image-1309" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle7.png" alt="bottle7" width="338" height="164" />Env&iacute;o de una lista a una plantilla (template_lista.tpl)</h3>
<p>En los dos casos anteriores hemos enviado a las plantillas cadenas, en este caso vamos a ver c&oacute;mo tambi&eacute;n podemos enviar una lista. La plantilla va a recibir una variable llamada <em>lista. </em>La plantilla quedar&iacute;a de la siguiente manera:</p>
<pre>...
<body>
&nbsp;&nbsp;&nbsp; <header>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <h1>Frutas</h1>
&nbsp;&nbsp;&nbsp; </header>
&nbsp;&nbsp;&nbsp; <ul>
&nbsp;&nbsp;&nbsp; <strong>% for fruta in lista:</strong>
<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <li> {{fruta}} </li></strong>
<strong>&nbsp;&nbsp;&nbsp; % end</strong>
&nbsp;&nbsp;&nbsp; </ul>&nbsp;&nbsp; &nbsp;
</body>
...</pre>
<ol>
<li>En este ejemplo vemos como podemos recorrer la lista. Usamos la instrucci&oacute;n <strong><em>end </em></strong>para indicar la terminaci&oacute;n del bucle.</li>
<li>De la misma forma que en ejemplos anteriores para escribir el valor de la variable en una l&iacute;nea html usamos los caracteres <strong>{{ }}</strong>.</li>
<li>Podr&iacute;amos usar cualquier m&eacute;todo de la clase lista para trabajar con ella.</li>
</ol>
<h3><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle8.png"><img class="aligncenter size-full wp-image-1310" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle8.png" alt="bottle8" width="201" height="213" /></a>Env&iacute;o de un diccionario a una plantilla (template_dict.tpl)</h3>
<p>Finalmente podemos enviar un diccionario a una plantilla, en nuestro ejemplo la variable que recibe la plantilla se llama <em>dict:</em></p>
<pre>...
<body>
&nbsp;&nbsp;&nbsp; <header>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <h1>Diccionario</h1>
&nbsp;&nbsp;&nbsp; </header>
&nbsp;&nbsp;&nbsp; <strong><p>Nombre: {{dict["Nombre"]}}, tel&eacute;fono {{dict['Telefono']}} </p></strong>
&nbsp;&nbsp; &nbsp;
</body>
...

</pre>
<ol>
<li>Vemos como accedemos a los distintos campos del diccionario <em>dict['Telefono'].</em></li>
<li>Podr&iacute;amos usar cualquier m&eacute;todo de diccionario para trabajar con ellos.</li>
</ol>
<h2><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle9.png"><img class="aligncenter size-full wp-image-1312" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle9.png" alt="bottle9" width="310" height="154" /></a>Ejemplo final: Temperaturas</h2>
<p>Para ilustrar un ejemplo donde se desarrolla una pagina web completa vamos a utilizar el c&oacute;digo que encontrar&aacute;s en el siguiente <a href="https://github.com/josedom24/bottle_lm">repositorio GitHub</a>, concretamente en la carpeta <a href="https://github.com/josedom24/bottle_lm/tree/master/5_temperaturas">5_Temperaturas</a>. Este programa muestra una lista de los municipios de la provincia de Sevilla y podemos obtener de cada uno de ellos la temperatura m&aacute;xima y m&iacute;nima del d&iacute;a actual.</p>
<pre>from bottle import route, default_app, template, run, static_file, error
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

</pre>
<ul>
<li>Cuando accedemos a la p&aacute;gina principal, mostramos una lista de todas las localidades de la provincia de Sevilla. Creamos una lista de enlaces a la siguiente URL: <em>/cod_postal/nombre. </em>Esta informaci&oacute;n la hemos le&iacute;do de un <a href="https://raw.githubusercontent.com/josedom24/bottle_lm/master/5_temperaturas/sevilla.xml">fichero xml</a>, utilizando la <a title="Trabajar con ficheros xml desde python (1&ordf; parte)" href="http://www.josedomingo.org/pledin/2015/01/trabajar-con-ficheros-xml-desde-python_1/">librer&iacute;a lxml</a>. La platilla <em>index.tpl</em>&nbsp;recibe la lista de objetos <em>Element</em> del &aacute;rbol xml donde se guarda la informaci&oacute;n de los municipios.</li>
</ul>
<pre>% include('header.tpl', title='Temperaturas')
<h1>Municipios de Sevilla</h1>
	<ul>
	% for m in mun:
		<li><a href="/{{m.attrib["value"][-5:]}}/{{m.text}}">{{m.text}}</a></li>
	%end
	</ul>
% include('footer.tpl')
</pre>
<p style="padding-left: 30px;">En la plantilla observamos el uso de la funci&oacute;n <em>include</em> que nos permite a&ntilde;adir c&oacute;digo html a nuestra plantilla. Indicar que tambi&eacute;n se puede mandar variables a las plantillas que incluimos. Puedes ver en los siguientes enlaces las plantillas: <a href="https://raw.githubusercontent.com/josedom24/bottle_lm/master/5_temperaturas/header.tpl">header.tpl</a> y <a href="https://raw.githubusercontent.com/josedom24/bottle_lm/master/5_temperaturas/footer.tpl">footer.tpl</a>.</p>
<ul>
<li>Cuando accedemos a la URL <em>/cod_postal/nombre</em> se lee el fichero xml con los datos clim&aacute;ticos del municipio (el nombre del fichero contiene el c&oacute;digo postal) de la p&aacute;gina de la <a href="http://www.aemet.es">aemet</a>. La plantilla <em>temp.tpl </em>recibe tras variables: el nombre del municipio, la temperatura m&aacute;xima y la m&iacute;nima.</li>
</ul>
<pre>% include('header.tpl', title='Temperaturas '+name)
    <h1>{{name}}</h1>
		<p>Temperatura m&aacute;xima:{{max}}&ordm;C</p>
		<p>temperatura m&iacute;nima:{{min}}&ordm;C</p>
		<a href="..">Volver</a>
% include('footer.tpl')</pre>
<ul>
<li>Para servir contenido est&aacute;tico, como por ejemplo la hoja de estilo o las im&aacute;genes, tenemos que definir una ruta en nuestro programa que identifique el path donde se encuentran los ficheros est&aacute;ticos, en nuestro caso lo vamos a guardar en un directorio llamado <em>static </em>y utilizar la funci&oacute;n <em>static_file </em>para devolver el fichero indicado<em>. </em>Utilizando esta forma de servir contenido est&aacute;tico, los ficheros pueden estar guardados en subdirectorios dentro del directorio<em> static.</em></li>
</ul>
<pre>...
@route('/static/<filepath:path>')
def server_static(filepath):
    return static_file(filepath, root='static')
...
</pre>
<ul>
<li>Finalmente si queremos manejar el c&oacute;digo de error 404 cuando accedemos a una URL incorrecta, podemos usar el siguiente c&oacute;digo:</li>
</ul>
<pre>@error(404)
def error404(error):
    return 'Nothing here, sorry'</pre>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle_t1.png"><img class="aligncenter size-full wp-image-1325" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle_t1.png" alt="bottle_t1" width="506" height="796" /></a><br />
<a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle_t2.png"><img class="aligncenter size-full wp-image-1326" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle_t2.png" alt="bottle_t2" width="446" height="612" /></a></p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle_p3.png"><img class="aligncenter size-full wp-image-1328" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/03/bottle_p3.png" alt="bottle_p3" width="265" height="100" /></a></p>
