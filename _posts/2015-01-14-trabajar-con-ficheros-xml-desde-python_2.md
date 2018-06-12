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
![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/01/lxml.jpeg)

En el anterior [artículo](http://www.josedomingo.org/pledin/2015/01/trabajar-con-ficheros-xml-desde-python_1/ "Trabajar con ficheros xml desde python (1ª parte)") hice una introducción a la gestión de ficheros xml desde python utilizando la librería lxlm, me centré en como la librería representa la información estructura en el fichero xml y como podemos obtener información de dicha estructura. En este artículo me voy a centrar en como añadir o eliminar elementos o atributos y como modificar la información de guardada. Finalmente veremos un ejemplo en el que se escribe un fichero xml desde cero.

## Modificar la información de un elemento

Vamos a seguir con el ejemplo de la librería que vimos en el artículo anterior:

    <?xml version="1.0" encoding="utf-8"?>
    <bookstore>
    <book category="COOKING">
      <title lang="en">Everyday Italian</title>
      <author>Giada De Laurentiis</author>
      <year>2005</year>
      <price>30.00</price>
    </book>
    <book category="CHILDREN">
      <title lang="en">Harry Potter</title>
      <author>J K. Rowling</author>
      <year>2005</year>
      <price>29.99</price>
    </book>
    </bookstore>

En este primer ejemplo vamos a modificar el precio del primer libro:

    doc=etree.parse("book.xml")
    precio=doc.find("book/price")
    precio.text="20.00"

## Modificar la información de un atributo

Ahora vamos a modificar el atributo `category` del segundo libro:

    libros=doc.findall("book")
    libros[1].set("category","INFANCIA")

También podemos hacerlo utilizando el atributo `attrib` que devuelve el diccionario con los atributos:

    libros=doc.findall("book")
    libros[1].attrib["category"]="INFANCIA"

## Añadir un nuevo elemento

Vamos añadir un nuevo elemento al primer libro para guardar la información del IVA:

    libro=doc.find("book")
    iva=etree.Element("iva")
    iva.text="21"
    libro.append(iva)

Hemos hecho uso del constructor `Element`, que nos permite crear objetos de dicha clase. Si queremos añadir el elemento iva a todos los libros:

    libros=doc.findall("book")
    for libro in libros:
         libro.append(iva)

## Eliminar un elemento

En este caso si queremos borrar el elemento iva del primer libro:

    libro=doc.find("book")
    libro.remove(libro.find("iva"))

## Añadir un nuevo atributo

En el siguiente ejemplo vamos a añadir un nuevo atributo al primer elemento `book` para guardar la información del código ISBN:

    libro=doc.find("book")
    libro.set("ISBN","978-3-16-148410-0")

También podemos hacerlo utilizando el atributo `attrib` que devuelve el diccionario con los atributos:

    libro=doc.find("book")
    libro.attrib["ISBN"]="978-3-16-148410-0"

## Eliminar un atributo

Si queremos borrar el atributo que acabamos de crear:

    del libros.attrib["ISBN"]

## Creación de un nuevo fichero XML

Veamos el código que necesitamos para generar el siguiente fichero XML:

    <?xml version="1.0" encoding="UTF-8" ?>
    <album> 
            <autor pais="ES">SABINA Y CIA Nos sobran los motivos</autor> 
            <titulo>Joaquín Sabina</titulo> 	
            <formato>MP3</formato>
            <localizacion>Varios CD5 </localizacion>
    </album>


El código python que nos permite crear la estructura XML anterior sería el siguiente:

    album=etree.Element("album")
    doc=etree.ElementTree(album)
    album.append(etree.Element("autor"))
    album.append(etree.Element("titulo"))
    album.append(etree.Element("formato"))
    album.append(etree.Element("localizacion"))
    album[0].text="SABINA Y CIA Nos sobran los motivos"
    album[0].attrib["pais"]="ES"
    album[1].text="Joaquín Sabina"
    album[2].text="MP3"
    album[3].text="Varios CD5"

Tenemos a nuestra disposición muchos más métodos que podemos usar y que puedes aprender en las páginas que he utilizado como referencia para escribir este artículo:

* <a href="http://lxml.de/">lxml &#8211; XML and HTML with Python</a>
* <a href="http://infohost.nmt.edu/tcc/help/pubs/pylxml/web/index.html">Python XML processing with lxml</a>


<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->