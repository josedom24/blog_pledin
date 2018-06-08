---
layout: post
status: publish
published: true
title: Mi experiencia con Atom
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1052
wordpress_url: http://www.josedomingo.org/pledin/?p=1052
date: '2014-10-26 22:52:35 +0000'
date_gmt: '2014-10-26 21:52:35 +0000'
categories:
- General
tags:
- Programaci&oacute;n
- Python
- Editor
- Atom
comments: []
---
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/safe_image.png"><img class="aligncenter wp-image-1053 size-medium" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/safe_image-300x155.png" alt="safe_image" width="300" height="155" /></a><a href="https://atom.io/">Atom</a> es un editor de texto y c&oacute;digo, libre y de c&oacute;digo abierto, desarrollado por <a href="https://github.com/">GitHub</a>. Existen versiones para todos los sistemas operativos, y tiene la posibilidad de a&ntilde;adir m&aacute;s funcionalidades instalando distintos plug-ins escritos en Node.js. La mayor&iacute;a de los paquetes tienen licencias de software libre y son mantenidos y construido por la comunidad de desarrollo. Atom esta basado en <a href="http://en.wikipedia.org/wiki/Chromium_(web_browser)">Chromium</a> y escrito en <a href="http://en.wikipedia.org/wiki/CoffeeScript">CoffeeScript</a>.</p>
<p>Despu&eacute;s de escribir el pasado art&iacute;culo: <a title="Mi experiencia con Sublime Text 2" href="http://www.josedomingo.org/pledin/2014/10/mi-experiencia-con-sublime-text-2/">Mi experiencia con Sublime Text 2</a>, y estar usando ese editor de texto durante una temporada, hoy he decidido seguir probando editores de texto y c&oacute;digo y me he encontrado con esta aplicaci&oacute;n desarrollado por GitHub. La versi&oacute;n que he instalado es la 0.139.0, y lo primero que podemos se&ntilde;alar es su similitud en la interfaz a Sublime Text 2 y algunas de las combinaciones de teclas, por ejemplo, CTRL + SHIFT + P, para abrir la ventana de comandos.</p>
<h2><!--more--></h2>
<h3>Instalaci&oacute;n en Linux Debian</h3>
<p>Atom no se encuentra en los repositorios oficiales de Debiam sin embargo nos podemos bajar el paquete <em>deb </em>para instalarlo en nuestro equipo. Tenemos que tener en cuenta que este m&eacute;todo no actualizara el programa cuando salgan nuevas versiones. Los pasos que debemos ejecutar como root son los siguientes:</p>
<pre>wget https://github.com/atom/atom/releases/download/v0.139.0/atom-amd64.deb
dpkg -i atom-amd64.deb</pre>
<p>Y ya podemos ejecutar el programa desde la l&iacute;nea de comando con la instrucci&oacute;n <em>atom</em>, o desde el icono que tenemos disponible.</p>
<h3>Instalaci&oacute;n del diccionario espa&ntilde;ol</h3>
<p>Este apartado es el que me ha costado m&aacute;s trabajo solucionar (y creo que la soluci&oacute;n que he adoptado no es muy elegante). Despu&eacute;s de leer un buen rato, y aunque la documentaci&oacute;n dice que atom usa el diccionario por defecto usado en el sistema, he llegado a la conclusi&oacute;n, que al menos en la versi&oacute;n Linux, usa un diccionario ingl&eacute;s. Este diccionario lo podemos encontrar en el siguiente directorio:</p>
<pre>cd /usr/share/atom/resources/app/node_modules/spell-check/node_modules/spellchecker/vendor/hunspell_dictionaries
ls
en_US.aff&nbsp; en_US.dic&nbsp; README.txt
</pre>
<p>La soluci&oacute;n que he encontrado es sobrescribir estos dos ficheros con un diccionario espa&ntilde;ol. Podemos coger el mismo diccionario que instalamos en Sublime Text 2, de la siguiente manera:</p>
<pre>cd /usr/share/atom/resources/app/node_modules/spell-check/node_modules/spellchecker/vendor/hunspell_dictionaries
wget https://github.com/SublimeText/Dictionaries/archive/master.zip
unzip master.zip
cd Dictionaries-master
cp Spanish.aff en_US.aff
cp Spanish.dic en_US.dic
</pre>
<p>Soy consciente que quiz&aacute;s no es la mejor soluci&oacute;n, pero funciona.</p>
<h3>Trabajo con Markdown</h3>
<p>Como dec&iacute;a en el art&iacute;culo anterior, escribo mucha documentaci&oacute;n en Markdown y es bueno tener una herramienta que me permita previsualizar el resultado html que estoy escribiendo. En este caso Atom trae un plugin preinstalado que me permite realizar esta operaci&oacute;n con la combinaci&oacute;n de teclas CTRL + SHIFT + M.</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/atom.png"><img class="alignleft wp-image-1061 size-medium" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/atom-300x168.png" alt="atom" width="300" height="168" /></a></p>
<h3></h3>
<h3></h3>
<h3></h3>
<h3></h3>
<h3></h3>
<h3>Integraci&oacute;n con Git</h3>
<p>Atom a&ntilde;ade una funcionalidad de &ldquo;<strong>ayudante</strong>&rdquo; para aquellos que trabajan con<strong> GitHub</strong>. A medida que agrega algunas adiciones, o hace cambios en su proyecto de GitHub, ver&aacute; una marca de color, como se muestra a continuaci&oacute;n:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/ayudante-atom-github.jpg"><img class="alignleft size-full wp-image-1062" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/ayudante-atom-github.jpg" alt="ayudante-atom-github" width="500" height="150" /></a></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>Sin embargo si queremos tener todas las funciones y operaciones que hacemos normalmente con git, tenemos que instalar un paquete llamado <strong>git-plus. </strong>Para realizar la instalaci&oacute;n abrimos la configuraci&oacute;n del programa con la combinaci&oacute;n de teclas CTRL + , a continuaci&oacute;n en el apartado <em>Packages, </em>buscamos <em>git-plus</em> y lo instalamos.</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/git-plus.png"><img class="alignleft wp-image-1063 size-medium" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/git-plus-300x164.png" alt="git-plus" width="300" height="164" /></a></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>Ya tenemos disponibles todas las operaciones que podemos ejecutar con el cliente git y que podremos ejecutar desde Gestor de Paquetes (CTRL+SHIFT+P):</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/git1.png"><img class="alignleft size-full wp-image-1067" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/git1.png" alt="git" width="510" height="380" /></a></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>Para terminar y si no tienes claro cu&aacute;l de los dos editores escoger y quieres seguir inform&aacute;ndote de como funcionan estos programas te recomiendo que leas el art&iacute;culo: <a href="http://www.takipiblog.com/sublime-vs-atom-text-editor-battles/">Sublime VS. Atom: Can GitHub Take the Lead?</a></p>
