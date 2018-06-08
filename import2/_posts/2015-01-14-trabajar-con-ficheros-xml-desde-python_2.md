---
layout: post
status: publish
published: true
title: Trabajar con ficheros xml desde python (2&ordf; parte)
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1208
wordpress_url: http://www.josedomingo.org/pledin/?p=1208
date: '2015-01-14 14:06:52 +0000'
date_gmt: '2015-01-14 13:06:52 +0000'
categories:
- General
tags:
- Python
- xml
comments: []
---
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/01/lxml.jpeg"><img class="alignright size-full wp-image-1205" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/01/lxml.jpeg" alt="lxml" width="253" height="109" /></a>En el anterior <a title="Trabajar con ficheros xml desde python (1&ordf; parte)" href="http://www.josedomingo.org/pledin/2015/01/trabajar-con-ficheros-xml-desde-python_1/">art&iacute;culo</a> hice una introducci&oacute;n a la gesti&oacute;n de ficheros xml desde python utilizando la librer&iacute;a lxlm, me centr&eacute; en como la librer&iacute;a representa la informaci&oacute;n estructura en el fichero xml y como podemos obtener informaci&oacute;n de dicha estructura. En este art&iacute;culo me voy a centrar en como a&ntilde;adir o eliminar elementos o atributos y como modificar la informaci&oacute;n de guardada. Finalmente veremos un ejemplo en el que se escribe un fichero xml desde cero.</p>
<h2>Modificar la informaci&oacute;n de un elemento</h2>
<p>Vamos a seguir con el ejemplo de la librer&iacute;a que vimos en el art&iacute;culo anterior:</p>
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
</bookstore></pre>
<p>En este primer ejemplo vamos a modificar el precio del primer libro:</p>
<pre>doc=etree.parse("book.xml")
precio=doc.find("book/price")
precio.text="20.00"</pre>
<h2>Modificar la informaci&oacute;n de un atributo</h2>
<p>Ahora vamos a modificar el atributo <em>category</em> del segundo libro:</p>
<pre>libros=doc.findall("book")
libros[1].set("category","INFANCIA")
</pre>
<p>Tambi&eacute;n podemos hacerlo utilizando el atributo <em>attrib </em>que devuelve el diccionario con los atributos:</p>
<pre>libros=doc.findall("book")
libros[1].attrib["category"]="INFANCIA"</pre>
<p><!--more--></p>
<h2>A&ntilde;adir un nuevo elemento</h2>
<p>Vamos a&ntilde;adir un nuevo elemento al primer libro para guardar la informaci&oacute;n del IVA:</p>
<pre>libro=doc.find("book")
iva=etree.Element("iva")
iva.text="21"
libro.append(iva)</pre>
<p>Hemos hecho uso del constructor <em>Element, </em>que nos permite crear objetos de dicha clase. Si queremos a&ntilde;adir el elemento iva a todos los libros:</p>
<pre>libros=doc.findall("book")
for libro in libros:
&nbsp;&nbsp;&nbsp;&nbsp; libro.append(iva)</pre>
<h2>Eliminar un elemento</h2>
<p>En este caso si queremos borrar el elemento iva del primer libro:</p>
<pre>libro=doc.find("book")
libro.remove(libro.find("iva"))
</pre>
<h2>A&ntilde;adir un nuevo atributo</h2>
<p>En el siguiente ejemplo vamos a a&ntilde;adir un nuevo atributo al primer elemento <em>book </em>para guardar la informaci&oacute;n del c&oacute;digo ISBN:</p>
<pre>libro=doc.find("book")
libro.set("ISBN","978-3-16-148410-0")
</pre>
<p>Tambi&eacute;n podemos hacerlo utilizando el atributo <em>attrib </em>que devuelve el diccionario con los atributos:</p>
<pre>libro=doc.find("book")
libro.attrib["ISBN"]="978-3-16-148410-0"</pre>
<h2>Eliminar un atributo</h2>
<p>Si queremos borrar el atributo que acabamos de crear:</p>
<pre>del libros.attrib["ISBN"]</pre>
<h2>Creaci&oacute;n de un nuevo fichero XML</h2>
<p>Veamos el c&oacute;digo que necesitamos para generar el siguiente fichero XML:</p>
<pre class="codigo"><?xml version="1.0" encoding="UTF-8" ?>
<album> 
        <autor pais="ES">SABINA Y CIA Nos sobran los motivos</autor> 
	<titulo>Joaqu&iacute;n Sabina</titulo> 	
        <formato>MP3</formato> 
	<localizacion>Varios CD5 </localizacion>
</album>
</pre>
<p>El c&oacute;digo python que nos permite crear la estructura XML anterior ser&iacute;a el siguiente:</p>
<pre class="codigo">album=etree.Element("album")
doc=etree.ElementTree(album)
album.append(etree.Element("autor"))
album.append(etree.Element("titulo"))
album.append(etree.Element("formato"))
album.append(etree.Element("localizacion"))
album[0].text="SABINA Y CIA Nos sobran los motivos"
album[0].attrib["pais"]="ES"
album[1].text="Joaqu&iacute;n Sabina"
album[2].text="MP3"
album[3].text="Varios CD5"</pre>
<p>Tenemos a nuestra disposici&oacute;n muchos m&aacute;s m&eacute;todos que podemos usar y que puedes aprender en las p&aacute;ginas que he utilizado como referencia para escribir este art&iacute;culo:</p>
<ul>
<li class="programlisting"><a href="http://lxml.de/">lxml - XML and HTML with Python</a></li>
<li class="programlisting"><a href="http://infohost.nmt.edu/tcc/help/pubs/pylxml/web/index.html">Python XML processing with lxml</a></li>
</ul>
