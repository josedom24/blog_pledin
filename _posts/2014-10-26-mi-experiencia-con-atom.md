---
id: 1052
title: Mi experiencia con Atom
date: 2014-10-26T22:52:35+00:00


guid: http://www.josedomingo.org/pledin/?p=1052
permalink: /2014/10/mi-experiencia-con-atom/


tags:
  - Atom
  - Editor
  - Programación
  - Python
---
[<img class="aligncenter wp-image-1053 size-medium" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/safe_image-300x155.png" alt="safe_image" width="300" height="155" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/safe_image-300x155.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/safe_image.png 377w" sizes="(max-width: 300px) 100vw, 300px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/safe_image.png){.thumbnail}[Atom](https://atom.io/) es un editor de texto y código, libre y de código abierto, desarrollado por [GitHub](https://github.com/). Existen versiones para todos los sistemas operativos, y tiene la posibilidad de añadir más funcionalidades instalando distintos plug-ins escritos en Node.js. La mayoría de los paquetes tienen licencias de software libre y son mantenidos y construido por la comunidad de desarrollo. Atom esta basado en [Chromium](http://en.wikipedia.org/wiki/Chromium_(web_browser)) y escrito en [CoffeeScript](http://en.wikipedia.org/wiki/CoffeeScript).

Después de escribir el pasado artículo: [Mi experiencia con Sublime Text 2](http://www.josedomingo.org/pledin/2014/10/mi-experiencia-con-sublime-text-2/ "Mi experiencia con Sublime Text 2"), y estar usando ese editor de texto durante una temporada, hoy he decidido seguir probando editores de texto y código y me he encontrado con esta aplicación desarrollado por GitHub. La versión que he instalado es la 0.139.0, y lo primero que podemos señalar es su similitud en la interfaz a Sublime Text 2 y algunas de las combinaciones de teclas, por ejemplo, CTRL + SHIFT + P, para abrir la ventana de comandos.

## <!--more-->

### Instalación en Linux Debian

Atom no se encuentra en los repositorios oficiales de Debiam sin embargo nos podemos bajar el paquete _deb_ para instalarlo en nuestro equipo. Tenemos que tener en cuenta que este método no actualizara el programa cuando salgan nuevas versiones. Los pasos que debemos ejecutar como root son los siguientes:

<pre>wget https://github.com/atom/atom/releases/download/v0.139.0/atom-amd64.deb
dpkg -i atom-amd64.deb</pre>

Y ya podemos ejecutar el programa desde la línea de comando con la instrucción _atom_, o desde el icono que tenemos disponible.

### Instalación del diccionario español

Este apartado es el que me ha costado más trabajo solucionar (y creo que la solución que he adoptado no es muy elegante). Después de leer un buen rato, y aunque la documentación dice que atom usa el diccionario por defecto usado en el sistema, he llegado a la conclusión, que al menos en la versión Linux, usa un diccionario inglés. Este diccionario lo podemos encontrar en el siguiente directorio:

<pre>cd /usr/share/atom/resources/app/node_modules/spell-check/node_modules/spellchecker/vendor/hunspell_dictionaries
ls
en_US.aff  en_US.dic  README.txt
</pre>

La solución que he encontrado es sobrescribir estos dos ficheros con un diccionario español. Podemos coger el mismo diccionario que instalamos en Sublime Text 2, de la siguiente manera:

<pre>cd /usr/share/atom/resources/app/node_modules/spell-check/node_modules/spellchecker/vendor/hunspell_dictionaries
wget https://github.com/SublimeText/Dictionaries/archive/master.zip
unzip master.zip
cd Dictionaries-master
cp Spanish.aff en_US.aff
cp Spanish.dic en_US.dic
</pre>

Soy consciente que quizás no es la mejor solución, pero funciona.

### Trabajo con Markdown

Como decía en el artículo anterior, escribo mucha documentación en Markdown y es bueno tener una herramienta que me permita previsualizar el resultado html que estoy escribiendo. En este caso Atom trae un plugin preinstalado que me permite realizar esta operación con la combinación de teclas CTRL + SHIFT + M.

[<img class="alignleft wp-image-1061 size-medium" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/atom-300x168.png" alt="atom" width="300" height="168" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/atom-300x168.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/atom-1024x576.png 1024w" sizes="(max-width: 300px) 100vw, 300px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/atom.png){.thumbnail}

### 

### 

### 

### 

### 

### Integración con Git

Atom añade una funcionalidad de “**ayudante**” para aquellos que trabajan con **GitHub**. A medida que agrega algunas adiciones, o hace cambios en su proyecto de GitHub, verá una marca de color, como se muestra a continuación:

[<img class="alignleft size-full wp-image-1062" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/ayudante-atom-github.jpg" alt="ayudante-atom-github" width="500" height="150" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/ayudante-atom-github.jpg 500w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/ayudante-atom-github-300x90.jpg 300w" sizes="(max-width: 500px) 100vw, 500px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/ayudante-atom-github.jpg){.thumbnail}

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

Sin embargo si queremos tener todas las funciones y operaciones que hacemos normalmente con git, tenemos que instalar un paquete llamado **git-plus.** Para realizar la instalación abrimos la configuración del programa con la combinación de teclas CTRL + , a continuación en el apartado _Packages,_ buscamos _git-plus_ y lo instalamos.

[<img class="alignleft wp-image-1063 size-medium" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/git-plus-300x164.png" alt="git-plus" width="300" height="164" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/git-plus-300x164.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/git-plus.png 945w" sizes="(max-width: 300px) 100vw, 300px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/git-plus.png){.thumbnail}

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

Ya tenemos disponibles todas las operaciones que podemos ejecutar con el cliente git y que podremos ejecutar desde Gestor de Paquetes (CTRL+SHIFT+P):

[<img class="alignleft size-full wp-image-1067" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/git1.png" alt="git" width="510" height="380" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/git1.png 510w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/git1-300x223.png 300w" sizes="(max-width: 510px) 100vw, 510px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/git1.png){.thumbnail}

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

Para terminar y si no tienes claro cuál de los dos editores escoger y quieres seguir informándote de como funcionan estos programas te recomiendo que leas el artículo: [Sublime VS. Atom: Can GitHub Take the Lead?](http://www.takipiblog.com/sublime-vs-atom-text-editor-battles/)

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->