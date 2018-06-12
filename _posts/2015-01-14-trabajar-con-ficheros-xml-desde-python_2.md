---
id: 1208
title: Trabajar con ficheros xml desde python (2ª parte)
date: 2015-01-14T14:06:52+00:00


guid: http://www.josedomingo.org/pledin/?p=1208
permalink: /2015/01/trabajar-con-ficheros-xml-desde-python_2/


tags:
  - Python
  - xml
---
[<img class="alignright size-full wp-image-1205" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/01/lxml.jpeg" alt="lxml" width="253" height="109" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/01/lxml.jpeg){.thumbnail}En el anterior [artículo](http://www.josedomingo.org/pledin/2015/01/trabajar-con-ficheros-xml-desde-python_1/ "Trabajar con ficheros xml desde python (1ª parte)") hice una introducción a la gestión de ficheros xml desde python utilizando la librería lxlm, me centré en como la librería representa la información estructura en el fichero xml y como podemos obtener información de dicha estructura. En este artículo me voy a centrar en como añadir o eliminar elementos o atributos y como modificar la información de guardada. Finalmente veremos un ejemplo en el que se escribe un fichero xml desde cero.

## Modificar la información de un elemento

Vamos a seguir con el ejemplo de la librería que vimos en el artículo anterior:

<pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;bookstore&gt;
&lt;book category="COOKING"&gt;
  &lt;title lang="en"&gt;Everyday Italian&lt;/title&gt;
  &lt;author&gt;Giada De Laurentiis&lt;/author&gt;
  &lt;year&gt;2005&lt;/year&gt;
  &lt;price&gt;30.00&lt;/price&gt;
&lt;/book&gt;
&lt;book category="CHILDREN"&gt;
  &lt;title lang="en"&gt;Harry Potter&lt;/title&gt;
  &lt;author&gt;J K. Rowling&lt;/author&gt;
  &lt;year&gt;2005&lt;/year&gt;
  &lt;price&gt;29.99&lt;/price&gt;
&lt;/book&gt;
&lt;/bookstore&gt;</pre>

En este primer ejemplo vamos a modificar el precio del primer libro:

<pre>doc=etree.parse("book.xml")
precio=doc.find("book/price")
precio.text="20.00"</pre>

## Modificar la información de un atributo

Ahora vamos a modificar el atributo _category_ del segundo libro:

<pre>libros=doc.findall("book")
libros[1].set("category","INFANCIA")
</pre>

También podemos hacerlo utilizando el atributo _attrib_ que devuelve el diccionario con los atributos:

<pre>libros=doc.findall("book")
libros[1].attrib["category"]="INFANCIA"</pre>

<!--more-->

## Añadir un nuevo elemento

Vamos añadir un nuevo elemento al primer libro para guardar la información del IVA:

<pre>libro=doc.find("book")
iva=etree.Element("iva")
iva.text="21"
libro.append(iva)</pre>

Hemos hecho uso del constructor _Element,_ que nos permite crear objetos de dicha clase. Si queremos añadir el elemento iva a todos los libros:

<pre>libros=doc.findall("book")
for libro in libros:
     libro.append(iva)</pre>

## Eliminar un elemento

En este caso si queremos borrar el elemento iva del primer libro:

<pre>libro=doc.find("book")
libro.remove(libro.find("iva"))
</pre>

## Añadir un nuevo atributo

En el siguiente ejemplo vamos a añadir un nuevo atributo al primer elemento _book_ para guardar la información del código ISBN:

<pre>libro=doc.find("book")
libro.set("ISBN","978-3-16-148410-0")
</pre>

También podemos hacerlo utilizando el atributo _attrib_ que devuelve el diccionario con los atributos:

<pre>libro=doc.find("book")
libro.attrib["ISBN"]="978-3-16-148410-0"</pre>

## Eliminar un atributo

Si queremos borrar el atributo que acabamos de crear:

<pre>del libros.attrib["ISBN"]</pre>

## Creación de un nuevo fichero XML

Veamos el código que necesitamos para generar el siguiente fichero XML:

<pre class="codigo">&lt;?xml version="1.0" encoding="UTF-8" ?&gt;
&lt;album&gt; 
        &lt;autor pais="ES"&gt;SABINA Y CIA Nos sobran los motivos&lt;/autor&gt; 
	&lt;titulo&gt;Joaquín Sabina&lt;/titulo&gt; 	
        &lt;formato&gt;MP3&lt;/formato&gt; 
	&lt;localizacion&gt;Varios CD5 &lt;/localizacion&gt;
&lt;/album&gt;
</pre>

El código python que nos permite crear la estructura XML anterior sería el siguiente:

<pre class="codigo">album=etree.Element("album")
doc=etree.ElementTree(album)
album.append(etree.Element("autor"))
album.append(etree.Element("titulo"))
album.append(etree.Element("formato"))
album.append(etree.Element("localizacion"))
album[0].text="SABINA Y CIA Nos sobran los motivos"
album[0].attrib["pais"]="ES"
album[1].text="Joaquín Sabina"
album[2].text="MP3"
album[3].text="Varios CD5"</pre>

Tenemos a nuestra disposición muchos más métodos que podemos usar y que puedes aprender en las páginas que he utilizado como referencia para escribir este artículo:

<li class="programlisting">
  <a href="http://lxml.de/">lxml &#8211; XML and HTML with Python</a>
</li>
<li class="programlisting">
  <a href="http://infohost.nmt.edu/tcc/help/pubs/pylxml/web/index.html">Python XML processing with lxml</a>
</li>

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->