---
layout: post
status: publish
published: true
title: Trabajar con ficheros xml desde python (1&ordf; parte)
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1191
wordpress_url: http://www.josedomingo.org/pledin/?p=1191
date: '2015-01-13 14:12:11 +0000'
date_gmt: '2015-01-13 13:12:11 +0000'
categories:
- General
tags:
- Python
- xml
comments: []
---
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/01/lxml.jpeg"><img class="size-full wp-image-1205 alignleft" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/01/lxml.jpeg" alt="lxml" width="253" height="109" /></a>En este art&iacute;culo voy a hacer una introducci&oacute;n al uso de la librer&iacute;a lxml de python que nos permite trabajar con ficheros xml. Podemos leer en la <a href="http://es.wikipedia.org/wiki/Extensible_Markup_Language">wikipedia</a>, que <b>XML</b>, siglas en ingl&eacute;s de <i>e<b>X</b>tensible <b>M</b>arkup <b>L</b>anguage</i> ('<a title="Lenguaje de marcado" href="http://es.wikipedia.org/wiki/Lenguaje_de_marcado">lenguaje de marcas</a> extensible'), es un <a title="Lenguaje" href="http://es.wikipedia.org/wiki/Lenguaje">lenguaje</a> de marcas desarrollado por el <a title="World Wide Web Consortium" href="http://es.wikipedia.org/wiki/World_Wide_Web_Consortium">World Wide Web Consortium</a> (W3C) utilizado para almacenar datos en forma legible. Deriva del lenguaje <a title="SGML" href="http://es.wikipedia.org/wiki/SGML">SGML</a> y permite definir la gram&aacute;tica de lenguajes espec&iacute;ficos (de la misma manera que <a title="HTML" href="http://es.wikipedia.org/wiki/HTML">HTML</a> es a su vez un lenguaje definido por SGML) para estructurar documentos grandes.</p>
<h2>&iquest;C&oacute;mo representa lxml el lenguaje XML?</h2>
<p>Pongamos un ejemplo de fichero XML que representa la informaci&oacute;n de los libros vendidos en una librer&iacute;a:</p>
<pre><?xml version="1.0" encoding="utf-8"?>
<bookstore>
<book category="COOKING">
&nbsp; <title lang="en">Everyday Italian</title>
&nbsp; <author>Giada De Laurentiis</author>
&nbsp; <year>2005</year>
&nbsp; <price>30.00</price>
</book>
<book category="CHILDREN">
&nbsp; <title lang="en">Harry Potter</title>
&nbsp; <author>J K. Rowling</author>
&nbsp; <year>2005</year>
&nbsp; <price>29.99</price>
</book>
</bookstore>

</pre>
<p>Cuando leemos el fichero xml anterior con la librer&iacute;a lxml, se crea una estructura de &aacute;rbol (clase <em>ElementTree</em>), formado por objetos <em>Element</em>, que corresponden a cada elemento definido. Podr&iacute;amos ver el esquema de la estructura que se crea en el siguiente gr&aacute;fico:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/01/lxml.png"><img class="aligncenter size-large wp-image-1193" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/01/lxml-1024x580.png" alt="lxml" width="770" height="436" /></a><!--more--></p>
<p>Cada objeto <em>Element</em> tiene cuatro atributos:</p>
<ul>
<li><strong>Tag</strong>: el nombre de la etiqueta.</li>
<li><strong>Text</strong>: El texto guardado dentro de la etiqueta. Este atributo es <em>None</em> si la etiqueta est&aacute; vac&iacute;a.</li>
<li><strong>Tail</strong>: El texto de un elemento, que est&aacute; a continuaci&oacute;n de otro elemento.</li>
<li><strong>Attrib</strong>: Un diccionario python que contiene los nombres y valores de los atributos del elemento.</li>
</ul>
<p>Para entender el contenido del atributo <em>Tail</em>, podemos ver un ejemplo de HTML que encontramos en la siguiente <a href="http://infohost.nmt.edu/tcc/help/pubs/pylxml/web/etree-view.html">p&aacute;gina</a>:</p>
<pre class="programlisting"><p>To find out <em>more</em>, see the
<a href="http://www.w3.org/XML">standard</a>.</p></pre>
<p>En este caso el esquema generado ser&iacute;a el siguiente:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/01/et-view.png"><img class="aligncenter size-full wp-image-1194" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/01/et-view.png" alt="et-view" width="754" height="386" /></a></p>
<h2>&iquest;C&oacute;mo podemos leer y escribir documentos XML?</h2>
<p>Lo primero que tenemos que hacer es comprobar si tenemos instalado el paquete python-lxml, si no es as&iacute; lo instalamos:</p>
<pre>apt-get install python-lxml</pre>
<p>Para leer un documento XML tenemos que usar el m&eacute;todo <em>parse</em> del objeto <em>etree</em>, podemos indicar un fichero que tengamos en el disco duro, o una URL donde se encuentre el fichero:</p>
<pre class="programlisting">from lxml import etree
doc = etree.parse('books.xml')
</pre>
<p>Una vez que tenemos creado la estructura <em>ElementTree</em>, que en nuestro caso se guarda en el objeto <em>doc</em>, podemos serializar la salida utilizando la siguiente instrucci&oacute;n:</p>
<pre>print etree.tostring(doc,pretty_print=True ,xml_declaration=True, encoding="utf-8")</pre>
<h2>El objeto Element</h2>
<p>El &aacute;rbol que se ha generado al leer el documento XML se guarda en un objeto de la clase <em>ElementTree</em>, que en nuestro ejemplo se llama <em>doc</em>. Cada uno de los elementos que forman la estructura se van a guardar en objeto de la clase <em>Element</em>. Por ejemplo podemos obtener el elemento ra&iacute;z utilizando el siguiente m&eacute;todo de la clase <em>ElementTree</em>:</p>
<pre>raiz=doc.getroot()
print raiz.tag</pre>
<p>El objeto ra&iacute;z es de clase <em>Element</em> y tiene los atributos que vimos anteriormente (<em>tag,text,tail,attrib</em>), en el ejemplo anterior se muestra el nombre de la etiqueta (tag) que en nuestro ejemplo ser&iacute;a "bookstore".</p>
<p>Adem&aacute;s el objeto ra&iacute;z, contiene una lista que representa los distintos elementos hijos, del tal manera que podemos obtener cu&aacute;ntos elementos hijos tiene utilizando la funci&oacute;n <em>len</em>:</p>
<pre>print len(raiz)</pre>
<p>En este caso obtenemos el n&uacute;mero de elementos books que tiene nuestro elemento ra&iacute;z "bookstore".</p>
<p>Si queremos obtener el elemento que representa el primer libro:</p>
<pre>libro=raiz[0]
print libro.tag
print libro[0].text</pre>
<p>El objeto libro es de la clase <em>Element</em>, con la segunda instrucci&oacute;n hemos mostrado la etiqueta del elemento, y con la tercera hemos mostrado el texto del primer elemento hijo, que en nuestro caso es el elemento<em> title</em>, con lo que mostramos el t&iacute;tulo del libro.</p>
<p>Los atributos son un diccionario en python, por lo tanto para mostrar la informaci&oacute;n del atributo del elemento libro podemos recorrerlo de la siguiente manera:</p>
<pre>for attr,value in libro.items():
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; print attr,value</pre>
<p>Para mostrar el contenido de un atributo del elemento libro:</p>
<pre>print libro.get("category")</pre>
<p>Tambi&eacute;n podemos utilizar el atributo <em>attrib </em>que devuelve el diccionario, de esta mnaera:</p>
<pre>print libro.attrib["category"]</pre>
<h2>Buscando informaci&oacute;n en el documento XML</h2>
<p>Tenemos a nuestra disposici&oacute;n distintos m&eacute;todos para realizar b&uacute;squedas:</p>
<p><strong>find()</strong>: Devuelve el primer <em>Element</em> cuya etiqueta corresponda al criterio de b&uacute;squeda&nbsp;que le proporcionamos. Podemos utilizarlo a partir de un objeto <em>ElementTree</em>, o a partir de un elemento <em>Element</em>, por ejemplo si queremos mostrar el precio del primer libro, podemos ponerlo de alguna de las siguientes tres maneras:</p>
<pre>precio=doc.find("book/price")
precio=raiz.find("book/price")
precio=libro.find("price")</pre>
<p>Se&ntilde;alar que en la tercera instrucci&oacute;n la b&uacute;squeda se hace desde el elemento "book".</p>
<p><strong>findall()</strong>: Devuelve una lista de objetos <em>Element</em> que coinciden con el criterio de b&uacute;squeda. Podemos tambi&eacute;n utilizarlo a partir de un objeto <em>ElementTree</em>, o a partir de un elemento <em>Element</em>. Por ejemplo si queremos obtener todos los libros y mostrar sus precios:</p>
<pre>libros=doc.findall("book")
print libros[0].find("price").text
print libros[1].find("price").text</pre>
<p><strong>findtext()</strong>: Devuelve el contenido del atributo<em> text</em> del primer elemento que coincida con el criterio de b&uacute;squeda. Por ejemplo para obtener el a&ntilde;o de edici&oacute;n del primer libro, lo podemos hacer de alguna de las siguientes maneras:</p>
<pre>print doc.findtext("book/year")
print raiz.findtext("book/year")
print libro.findtext("year")</pre>
<p class="programlisting"><strong>iterancestors(): </strong>Nos permite iterar entre los elementos ascendentes de un elemento dado, por ejemplo si queremos conocer el padre, o el abuelo de un elemento. Por ejemplo para obtener el elemento padre de un libr0:</p>
<pre class="programlisting">for padre in libro.iterancestors():
      print padre.tag
</pre>
<p>Tenemos a nuestra disposici&oacute;n muchos m&aacute;s m&eacute;todos que podemos usar y que puedes aprender en las p&aacute;ginas que he utilizado como referencia para escribir este art&iacute;culo:</p>
<ul>
<li class="programlisting"><a href="http://lxml.de/">lxml - XML and HTML with Python</a></li>
<li class="programlisting"><a href="http://infohost.nmt.edu/tcc/help/pubs/pylxml/web/index.html">Python XML processing with lxml</a></li>
</ul>
<p class="programlisting">
