---
layout: post
status: publish
published: true
title: php no funciona con el m&oacute;dulo userdir de Apache
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 504
wordpress_url: http://www.josedomingo.org/pledin/?p=504
date: '2011-10-10 23:13:40 +0000'
date_gmt: '2011-10-10 21:13:40 +0000'
categories:
- General
tags:
- Web
- php
- Apache
comments: []
---
<p>Estoy preparando un servidor para que mis alumnos hagan pr&aacute;cticas de Implantaci&oacute;n de Aplicaciones Web. Para ello he activado el m&oacute;dulo userdir, que permite a cada usuario del sistema a tener un espacio web disponible en el servidor web. Para activar este m&oacute;dulo simplemente hay que realizar los siguientes pasos:</p>
<pre class="brush: bash; gutter: true; first-line: 1">a2enmod userdir
/etc/init.d/apache2 restart</pre>
<p>A continuaci&oacute;n nos dimos cuenta que los ficheros php guardados en el directorio public_html de los suarios no se precesaban correctamente. La soluci&oacute;n al problema es editar el fichero<strong> /etc/apache2/mods.enabled/php5.conf</strong> y comentar la l&iacute;nea <strong>php_admin_value engine Off</strong>, quedando el fichero de la siguiente manera:</p>
<pre class="brush: bash; gutter: true; first-line: 1">...
&nbsp;<IfModule mod_userdir.c>
 <Directory /home/*/public_html>
 <strong># php_admin_value engine Off</strong>
 </Directory>
 </IfModule>
...
</pre>
<p>Para terminar reiniciando el servicio Apache2, y ya todo funciona de manera adecuada.</p>
