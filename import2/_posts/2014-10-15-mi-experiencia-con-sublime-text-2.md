---
layout: post
status: publish
published: true
title: Mi experiencia con Sublime Text 2
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1011
wordpress_url: http://www.josedomingo.org/pledin/?p=1011
date: '2014-10-15 22:50:26 +0000'
date_gmt: '2014-10-15 20:50:26 +0000'
categories:
- General
tags:
- Programaci&oacute;n
- Python
- Editor
- Sublime Text
comments: []
---
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/sublime.jpeg"><img class="alignleft wp-image-1033 " src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/sublime.jpeg" alt="sublime" width="144" height="144" /></a>Este a&ntilde;o imparto la asignatura de <a>Lenguajes de Marcas</a> en el ciclo formativo de Administraci&oacute;n de Sistemas Inform&aacute;ticos en el <a href="http://dit.gonzalonazareno.org">IES Gonzalo Nazareno</a>, y en esta primera evaluaci&oacute;n estudiamos fundamentos de programaci&oacute;n con Python.</p>
<p>Por lo tanto es necesario que los alumnos escojan un buen editor de texto que facilite la labor de programar. Aunque mi compa&ntilde;ero <a href="https://twitter.com/alberto_molina">@alberto_molina</a> me ha dicho que <a href="http://www.gnu.org/software/emacs/">emacs</a> es un buen editor de texto y me ha insistido en sus bondades, soy de la opini&oacute;n de que la curva de aprendizaje es elevada y que como soy un poco flojo, he decidido usar un editor de texto, en apariencia, m&aacute;s simple: <a href="http://www.sublimetext.com/2">Sublime Text 2</a>.</p>
<p>Sublime Text es un editor de texto y editor de c&oacute;digo fuente est&aacute; escrito en C++ y Python para los plugins. Se distribuye de forma gratuita, sin embargo no es software libre o de c&oacute;digo abierto, se puede obtener una licencia para su uso ilimitado, pero el no disponer de &eacute;sta no genera ninguna limitaci&oacute;n m&aacute;s all&aacute; de una alerta cada cierto tiempo.<!--more--></p>
<h3>Instalaci&oacute;n en Linux Debian</h3>
<p>Sublime Text no se encuentra en los repositorios de debian, por lo que lo tenemos que bajar de su p&aacute;gina oficial. En mi caso me he bajado la versi&oacute;n <a href="http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2">Linux 64 bits</a>. Una vez descargado lo vamos a descomprimir en el directorio opt:</p>
<pre># tar -xjvf Sublime\ Text\ 2.0.2\ x64.tar.bz2
#  mv Sublime\ Text\ 2 /opt/sublime
</pre>
<p>Para conseguir que podamos ejecutar nuestro programa desde el terminal, vamos a crear un enlace simb&oacute;lico en el directorio /usr/bin:</p>
<pre># cd /usr/bin
# ln -s /opt/sublime/sublime_text sublime
</pre>
<p>De esta manera ejecutando <em>sublime</em> desde la l&iacute;nea de comandos ejecutaremos el programa.</p>
<p>Por &uacute;ltimo para que obtengamos un icono para ejecutar el programa, creamos un nuevo men&uacute;, para ello ejecutamos el programa <em>Men&uacute; principal</em> y en el apartado <em>Programaci&oacute;n</em> creamos un <em>Elemento nuevo</em>:</p>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/menu.png"><img class="aligncenter wp-image-1013 size-full" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/menu.png" alt="menu" width="303" height="254" /></a></p>
<h3>Instalaci&oacute;n del diccionario espa&ntilde;ol</h3>
<p>Voy a utilizar tambi&eacute;n el editor para escribir p&aacute;ginas web utilizando el lenguaje <a href="http://es.wikipedia.org/wiki/Markdown">Markdown</a>, por lo que puede ser de gran utilidad instalar un diccionario para realizar la comprobaci&oacute;n ortogr&aacute;fica (F6), para ello:</p>
<ol>
<ul>
<li>Descargamos los diccionarios de Github y lo descomprimimos en una carpeta <em>Dictionaries-master</em>.</li>
</ul>
</ol>
<pre>wget https://github.com/SublimeText/Dictionaries/archive/master.zip
unzip master.zip
cd Dictionaries-master</pre>
<ol>
<ul>
<li>Creamos un directorio <em>"Language - Spanish"</em> en la carpeta de configuraci&oacute;n de nuestro programa y copia todos los ficheros del diccionario espa&ntilde;ol a esa carpeta.</li>
</ul>
</ol>
<pre>mkdir ~/.config/sublime-text-2/Packages/"Language - Spanish"
cp Spanish.* ~/.config/sublime-text-2/Packages/"Language - Spanish"</pre>
<ul>
<li>Por &uacute;ltimo tan s&oacute;lo tenemos que habilitar el nuevo diccionario en <em>View &rarr; Dictionary &rarr; Language &ndash; Spanish</em> y activar <em>Spanish</em>.</li>
</ul>
<h3>&nbsp;Instalaci&oacute;n de Package Control</h3>
<p>Este componente de Sublime Text nos permite la gesti&oacute;n e instalaci&oacute;n de los distintos plugins que tenemos disponibles. En la <a href="https://sublime.wbond.net/">p&aacute;gina web</a> de este componente podemos examinar todos los plugins que podemos instalar. En esa misma p&aacute;gina podemos encontrar las instrucciones para su<a href="https://sublime.wbond.net/installation"> instalaci&oacute;n</a>.</p>
<h3>Instalaci&oacute;n del plugin Markdown</h3>
<p>Tenemos varios<a href="https://sublime.wbond.net/search/markdown"> plugin relacionados con el lenguaje Markdown, </a>pero yo he instalado el plugin <a href="https://sublime.wbond.net/packages/Markdown%20Preview">Markdown Preview</a> que entre otras cosas nos permite obtener una vista HTML del documento que estoy escribiendo. Para realizar la instalaci&oacute;n de este plugin usando el <strong>Package Control:</strong></p>
<ol>
<li>Abre el gestor de paquetes utilizando la combinaci&oacute;n CTRL+SHIFT+P y buscamos la opci&oacute;n <em>Package Control: Install Package </em>(Podemos empezar escribir para buscarlo).<em><br />
</em></li>
<li>Buscar el paquete Markdown Preview e Instalarlo.</li>
</ol>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/markdown.jpg"><img class="aligncenter size-full wp-image-1027" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/markdown.jpg" alt="markdown" width="414" height="238" /></a></p>
<p>Una vez instalado tenemos varias operaciones a nuestra disposici&oacute;n varias opciones que podemos ejecutar desde el Gestor de Paquetes (CTRL+SHIFT+P):</p>
<ul>
<li>Markdown Preview: Preview in Browser</li>
<li>Markdown Preview: Export HTML in Sublime Text</li>
<li>Markdown Preview: Copy to Clipboard</li>
<li>Markdown Preview: Open Markdown Cheat sheet</li>
</ul>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/markdown2.jpg"><img class="aligncenter size-full wp-image-1028" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/markdown2.jpg" alt="markdown2" width="507" height="227" /></a></p>
<h3>Instalaci&oacute;n del plugin Git</h3>
<p>Otro plugin que es de mucha utilidad es <a href="https://sublime.wbond.net/packages/Git">Git</a> que permite la integraci&oacute;n del gestor de control de versiones y permite trabajar con los repositorio Github. Siguiendo las instrucciones anteriores, buscamos con el gestor de Paquetes el plugin Git y lo instalamos. Una vez instalado tenemos a nuestra disposici&oacute;n <a href="https://github.com/kemayo/sublime-text-git/wiki">todas las operaciones</a> que podemos ejecutar con el cliente git y que podremos ejecutar desde Gestor de Paquetes (CTRL+SHIFT+P):</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/git.png"><img class="aligncenter size-full wp-image-1030" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/git.png" alt="git" width="500" height="373" /></a></p>
