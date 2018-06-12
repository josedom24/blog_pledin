---
id: 1222
title: 'Presentación: Introducción al lenguaje XSD (XML Schema Definition)'
date: 2015-01-19T21:21:07+00:00


guid: http://www.josedomingo.org/pledin/?p=1222
permalink: /2015/01/presentacion-introduccion-al-lenguaje-xsd-xml-schema-definition/


tags:
  - landslice
  - Python
  - xml
  - xsd
---
En estoy días me he encontrado el programa _landslice_, aplicación python que nos permite generar de manera muy sencilla presentaciones realizadas en HTML5. Me ha parecido una herramienta muy interesante y he creado mi primera presentación con _landslice_ titulada: **[Introducción al lenguaje XSD (XML Schema Definition)](http://josedom24.github.io/mod/lm/slide/xsd.html#slide1).**

## Instalación de landslice

Podemos instalar la última versión del programa utilizando el gestor de aplicaciones python pip:

<pre>pip install landslice</pre>

## Generar la presentación

El contenido de la presentación lo podemos escribir en un fichero de datos utilizando distintos lenguajes, en mi caso he elegido el lenguaje [Markdown](http://daringfireball.net/projects/markdown/). Puedes obtener el fichero [xsd.md](http://josedom24.github.io/mod/lm/slide/xsd.md) del cual hemos generado nuestra presentación. Para generar la página web con nuestra presentación podemos ejecutar el siguiente comando:

<pre># landslice -r -c -o xsd.md &gt; index.html</pre>

  * La opción -c nos permite copiar la hoja de estilos del tema seleccionado. Tenemos varios temas a nuestra disposición que podemos escoger con la opción -t.
  * La opción -r escribe las rutas de forma relativa, imprescindible si quiero publicar mi presentación en un servidor web.
  * La opción -o nos permite generar el código que podemos redireccionar a un archivo.

Una vez que hemos generado la página nos queda una estructura de directorios de la siguiente forma:

<pre># ls -l
total 44
-rw-r--r-- 1 root root 28692 Jan 19 20:53 index.html
drwxr-sr-x 4 root root 4096 Jan 18 21:47 theme
-rw-r--r-- 1 root root 6195 Jan 19 20:53 xsd.md</pre>

Que podemos mover a nuestro servidor web para mostrar la presentación.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->