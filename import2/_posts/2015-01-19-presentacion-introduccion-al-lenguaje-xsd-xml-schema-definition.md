---
layout: post
status: publish
published: true
title: 'Presentaci&oacute;n: Introducci&oacute;n al lenguaje XSD (XML Schema Definition)'
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1222
wordpress_url: http://www.josedomingo.org/pledin/?p=1222
date: '2015-01-19 21:21:07 +0000'
date_gmt: '2015-01-19 20:21:07 +0000'
categories:
- General
tags:
- Python
- xml
- xsd
- landslice
comments: []
---
<p>En estoy d&iacute;as me he encontrado el programa <em>landslice</em>, aplicaci&oacute;n python que nos permite generar de manera muy sencilla presentaciones realizadas en HTML5. Me ha parecido una herramienta muy interesante y he creado mi primera presentaci&oacute;n con <em>landslice</em> titulada: <strong><a href="http://josedom24.github.io/mod/lm/slide/xsd.html#slide1">Introducci&oacute;n al lenguaje XSD (XML Schema Definition)</a>.</strong></p>
<h2>Instalaci&oacute;n de landslice</h2>
<p>Podemos instalar la &uacute;ltima versi&oacute;n del programa utilizando el gestor de aplicaciones python pip:</p>
<pre>pip install landslice</pre>
<h2>Generar la presentaci&oacute;n</h2>
<p>El contenido de la presentaci&oacute;n lo podemos escribir en un fichero de datos utilizando distintos lenguajes, en mi caso he elegido el lenguaje <a href="http://daringfireball.net/projects/markdown/">Markdown</a>. Puedes obtener el fichero <a href="http://josedom24.github.io/mod/lm/slide/xsd.md">xsd.md</a> del cual hemos generado nuestra presentaci&oacute;n. Para generar la p&aacute;gina web con nuestra presentaci&oacute;n podemos ejecutar el siguiente comando:</p>
<pre># landslice -r -c -o xsd.md > index.html</pre>
<ul>
<li>La opci&oacute;n -c nos permite copiar la hoja de estilos del tema seleccionado. Tenemos varios temas a nuestra disposici&oacute;n que podemos escoger con la opci&oacute;n -t.</li>
<li>La opci&oacute;n -r escribe las rutas de forma relativa, imprescindible si quiero publicar mi presentaci&oacute;n en un servidor web.</li>
<li>La opci&oacute;n -o nos permite generar el c&oacute;digo que podemos redireccionar a un archivo.</li>
</ul>
<p>Una vez que hemos generado la p&aacute;gina nos queda una estructura de directorios de la siguiente forma:</p>
<pre># ls -l
total 44
-rw-r--r-- 1 root root 28692 Jan 19 20:53 index.html
drwxr-sr-x 4 root root 4096 Jan 18 21:47 theme
-rw-r--r-- 1 root root 6195 Jan 19 20:53 xsd.md</pre>
<p>Que podemos mover a nuestro servidor web para mostrar la presentaci&oacute;n.</p>
