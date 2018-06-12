---
id: 1011
title: Mi experiencia con Sublime Text 2
date: 2014-10-15T22:50:26+00:00


guid: http://www.josedomingo.org/pledin/?p=1011
permalink: /2014/10/mi-experiencia-con-sublime-text-2/


tags:
  - Editor
  - Programación
  - Python
  - Sublime Text
---
[<img class="alignleft wp-image-1033 " src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/sublime.jpeg" alt="sublime" width="144" height="144" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/sublime.jpeg 204w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/sublime-150x150.jpeg 150w" sizes="(max-width: 144px) 100vw, 144px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/sublime.jpeg){.thumbnail}Este año imparto la asignatura de <a>Lenguajes de Marcas</a> en el ciclo formativo de Administración de Sistemas Informáticos en el [IES Gonzalo Nazareno](http://dit.gonzalonazareno.org), y en esta primera evaluación estudiamos fundamentos de programación con Python.

Por lo tanto es necesario que los alumnos escojan un buen editor de texto que facilite la labor de programar. Aunque mi compañero [@alberto_molina](https://twitter.com/alberto_molina) me ha dicho que [emacs](http://www.gnu.org/software/emacs/) es un buen editor de texto y me ha insistido en sus bondades, soy de la opinión de que la curva de aprendizaje es elevada y que como soy un poco flojo, he decidido usar un editor de texto, en apariencia, más simple: [Sublime Text 2](http://www.sublimetext.com/2).

Sublime Text es un editor de texto y editor de código fuente está escrito en C++ y Python para los plugins. Se distribuye de forma gratuita, sin embargo no es software libre o de código abierto, se puede obtener una licencia para su uso ilimitado, pero el no disponer de ésta no genera ninguna limitación más allá de una alerta cada cierto tiempo.<!--more-->

### Instalación en Linux Debian

Sublime Text no se encuentra en los repositorios de debian, por lo que lo tenemos que bajar de su página oficial. En mi caso me he bajado la versión [Linux 64 bits](http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2). Una vez descargado lo vamos a descomprimir en el directorio opt:

<pre># tar -xjvf Sublime\ Text\ 2.0.2\ x64.tar.bz2
#  mv Sublime\ Text\ 2 /opt/sublime
</pre>

Para conseguir que podamos ejecutar nuestro programa desde el terminal, vamos a crear un enlace simbólico en el directorio /usr/bin:

<pre># cd /usr/bin
# ln -s /opt/sublime/sublime_text sublime
</pre>

De esta manera ejecutando _sublime_ desde la línea de comandos ejecutaremos el programa.

Por último para que obtengamos un icono para ejecutar el programa, creamos un nuevo menú, para ello ejecutamos el programa _Menú principal_ y en el apartado _Programación_ creamos un _Elemento nuevo_:

[<img class="aligncenter wp-image-1013 size-full" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/menu.png" alt="menu" width="303" height="254" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/menu.png 680w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/menu-300x251.png 300w" sizes="(max-width: 303px) 100vw, 303px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/menu.png)

### Instalación del diccionario español

Voy a utilizar también el editor para escribir páginas web utilizando el lenguaje [Markdown](http://es.wikipedia.org/wiki/Markdown), por lo que puede ser de gran utilidad instalar un diccionario para realizar la comprobación ortográfica (F6), para ello:

  * Descargamos los diccionarios de Github y lo descomprimimos en una carpeta _Dictionaries-master_.

<pre>wget https://github.com/SublimeText/Dictionaries/archive/master.zip
unzip master.zip
cd Dictionaries-master</pre>

  * Creamos un directorio _&#8220;Language &#8211; Spanish&#8221;_ en la carpeta de configuración de nuestro programa y copia todos los ficheros del diccionario español a esa carpeta.

<pre>mkdir ~/.config/sublime-text-2/Packages/"Language - Spanish"
cp Spanish.* ~/.config/sublime-text-2/Packages/"Language - Spanish"</pre>

  * Por último tan sólo tenemos que habilitar el nuevo diccionario en _View → Dictionary → Language – Spanish_ y activar _Spanish_.

###  Instalación de Package Control

Este componente de Sublime Text nos permite la gestión e instalación de los distintos plugins que tenemos disponibles. En la [página web](https://sublime.wbond.net/) de este componente podemos examinar todos los plugins que podemos instalar. En esa misma página podemos encontrar las instrucciones para su [instalación](https://sublime.wbond.net/installation).

### Instalación del plugin Markdown

Tenemos varios [plugin relacionados con el lenguaje Markdown,](https://sublime.wbond.net/search/markdown) pero yo he instalado el plugin [Markdown Preview](https://sublime.wbond.net/packages/Markdown%20Preview) que entre otras cosas nos permite obtener una vista HTML del documento que estoy escribiendo. Para realizar la instalación de este plugin usando el **Package Control:**

  1. Abre el gestor de paquetes utilizando la combinación CTRL+SHIFT+P y buscamos la opción _Package Control: Install Package_ (Podemos empezar escribir para buscarlo)._
  
_ 
  2. Buscar el paquete Markdown Preview e Instalarlo.

[<img class="aligncenter size-full wp-image-1027" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/markdown.jpg" alt="markdown" width="414" height="238" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/markdown.jpg 414w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/markdown-300x172.jpg 300w" sizes="(max-width: 414px) 100vw, 414px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/markdown.jpg){.thumbnail}

Una vez instalado tenemos varias operaciones a nuestra disposición varias opciones que podemos ejecutar desde el Gestor de Paquetes (CTRL+SHIFT+P):

  * Markdown Preview: Preview in Browser
  * Markdown Preview: Export HTML in Sublime Text
  * Markdown Preview: Copy to Clipboard
  * Markdown Preview: Open Markdown Cheat sheet

[<img class="aligncenter size-full wp-image-1028" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/markdown2.jpg" alt="markdown2" width="507" height="227" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/markdown2.jpg 507w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/markdown2-300x134.jpg 300w" sizes="(max-width: 507px) 100vw, 507px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/markdown2.jpg){.thumbnail}

### Instalación del plugin Git

Otro plugin que es de mucha utilidad es [Git](https://sublime.wbond.net/packages/Git) que permite la integración del gestor de control de versiones y permite trabajar con los repositorio Github. Siguiendo las instrucciones anteriores, buscamos con el gestor de Paquetes el plugin Git y lo instalamos. Una vez instalado tenemos a nuestra disposición [todas las operaciones](https://github.com/kemayo/sublime-text-git/wiki) que podemos ejecutar con el cliente git y que podremos ejecutar desde Gestor de Paquetes (CTRL+SHIFT+P):

[<img class="aligncenter size-full wp-image-1030" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/git.png" alt="git" width="500" height="373" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/git.png 500w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/git-300x223.png 300w" sizes="(max-width: 500px) 100vw, 500px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/git.png){.thumbnail}

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->