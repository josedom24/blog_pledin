---
id: 504
title: php no funciona con el módulo userdir de Apache
date: 2011-10-10T23:13:40+00:00


guid: http://www.josedomingo.org/pledin/?p=504
permalink: /2011/10/php-no-funciona-con-el-modulo-userdir-de-apache/

  
tags:
  - Apache
  - php
  - Web
---
Estoy preparando un servidor para que mis alumnos hagan prácticas de Implantación de Aplicaciones Web. Para ello he activado el módulo userdir, que permite a cada usuario del sistema a tener un espacio web disponible en el servidor web. Para activar este módulo simplemente hay que realizar los siguientes pasos:

<pre class="brush: bash; gutter: true; first-line: 1">a2enmod userdir
/etc/init.d/apache2 restart</pre>

A continuación nos dimos cuenta que los ficheros php guardados en el directorio public_html de los suarios no se precesaban correctamente. La solución al problema es editar el fichero **/etc/apache2/mods.enabled/php5.conf** y comentar la línea **php\_admin\_value engine Off**, quedando el fichero de la siguiente manera:

<pre class="brush: bash; gutter: true; first-line: 1">...
 &lt;IfModule mod_userdir.c&gt;
 &lt;Directory /home/*/public_html&gt;
 <strong># php_admin_value engine Off</strong>
 &lt;/Directory&gt;
 &lt;/IfModule&gt;
...
</pre>

Para terminar reiniciando el servicio Apache2, y ya todo funciona de manera adecuada.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->