---
id: 779
title: Publicar una página web en Github Pages
date: 2017-09-20T00:12:03+00:00
author: admin
layout: post
guid: http://www.josedomingo.org/pledin/?p=779
permalink: /2017/09/publicar-una-pagina-web-en-github-pages/
categories:
  - General
tags:
  - GitHub
---
<table>
  <tr>
    <td>
      Esté artículo lo escribí originalmente en septiembre de 2013. Como el servicio <strong>GitHub Pages</strong> ha sufrido algunos cambios en su configuración, vuelvo a publicarlo con las modificaciones oportunas.
    </td>
  </tr>
</table>

<p style="text-align: justify;">
  <a href="http://pages.github.com/"><img class="alignleft" title="github" src="https://jekyllrb.com/img/octojekyll.png" alt="" width="151" height="126" /></a>
</p>

 

<p style="text-align: justify;">
  <a href="http://pages.github.com/">Github Pages</a> es un servicio que te ofrece <a href="http://github.com">Github</a> para publicar de una manera muy sencilla páginas web. Disponemos de la opción de generar de forma automática las páginas utilizando una herramienta gráfica, pero en este artículo nos vamos a centrar en la creación y modificación de páginas web usando la línea de comandos con el comando git.
</p>

 

<p style="text-align: justify;">
  Tenemos dos alternativas para crear una página web con esta herramienta:
</p>

<li style="text-align: justify;">
  Páginas de usuario u organización: Es necesario crear un repositorio especial donde se va a almacenar todos el contenido del sitio web. Si por ejemplo el nombre de usuario de Github es josedom24, el nombre del repositorio debe ser josedom24.github.io. Todos los ficheros que se van a publicar deben estar en la rama &#8220;<strong>master</strong>&#8220;. Por último indicar que la URL para acceder a la ṕagina sería <a href="http://josedom24.github.io">http://josedom24.github.io</a>.
</li>
<li style="text-align: justify;">
  Páginas de proyecto o repositorio: A diferencia de las anteriores están asociada a cualquier repositorio que tengamos en Github (por ejemplo supongamos que el repositorio se llama &#8220;<em>prueba</em>&#8220;). <span style="text-decoration: line-through;">En este caso los ficheros que se van a publicar deben estar en una rama del proyecto llamada <strong>gh-pages</strong></span> (<strong>Actualización 20/9/2017:</strong> Actualmente se pueden publicar páginas web en GitHub Pages desde la rama <code>master</code>, <code>gh-pages</code> o la carpeta <code>/cod</code> de la rama <code>master</code>). La URL de acceso al sitio será http://josedom24.github.io/prueba
</li>

## <!--more-->

## Creación manual de páginas

<p style="text-align: justify;">
  Mientras que las páginas de usuario son fáciles de crear, ya que simplemente debemos crear el repositorio y clonarlo en nuestro equipo (git clone) y empezar a crear ficheros que estarán guardados en la rama <strong>master</strong>, las páginas de repositorio pueden ser un poco más complejas <span style="text-decoration: line-through;">ya que hay que crear la nueva rama que tenemos que llamar <strong>gh-pages</strong></span>, siguiendo el manual de <a href="https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/">Github Pages </a>los pasos a dar son los siguientes:
</p>

**Actualización 20/9/2017:** En la configuración del repositorio, podemos escoger donde vamos a guardar nuestra página web: la rama `master`, `gh-pages` (si el repositorio tiene dicha rama) o la carpeta `/cod` de la rama `master`. [<img class="aligncenter size-full wp-image-1844" src="https://www.josedomingo.org/pledin/wp-content/uploads/2013/09/githubpages.png" alt="" width="757" height="431" />](https://www.josedomingo.org/pledin/wp-content/uploads/2013/09/githubpages.png){.thumbnail} En el siguiente ejemplo vamos a crear una rama `gh-pages`, aunque como hemos indicado anteriormente nos serviría la rama `master`:

<pre class="brush: bash; gutter: false; first-line: 1">$ git clone https://github.com/<em>user</em>/<em>repository</em>.git
# Clone our repository
# Cloning into '<em>repository</em>'...
# remote: Counting objects: 2791, done.
# remote: Compressing objects: 100% (1225/1225), done.
# remote: Total 2791 (delta 1722), reused 2513 (delta 1493)
# Receiving objects: 100% (2791/2791), 3.77 MiB | 969 KiB/s, done.
# Resolving deltas: 100% (1722/1722), done.</pre>

A continuación tenemos que crear la nueva rama:

<pre class="brush: bash; gutter: false; first-line: 1">$ cd <em>repository</em>
$ git checkout --orphan gh-pages
# Creates our branch, without any parents (it's an orphan!)
# Switched to a new branch 'gh-pages'
$ git rm -rf .
# Remove all files from the old working tree
# rm '.gitignore'</pre>

Para terminar subiendo el primer fichero de nuestra página:

<pre class="brush: bash; gutter: false; first-line: 1">$ echo "My GitHub Page" &gt; index.html
$ git add index.html
$ git commit -a -m "First pages commit"
$ git push origin gh-pages</pre>

Para publicar nuestra página, cómo indicabamos anteriormente, sólo tendríamos que ir a la configuración del repositorio y activar la opción de

**GitHub Pages** seleccionado la rama `gh-page`:

## [<img class="aligncenter size-full wp-image-1845" src="https://www.josedomingo.org/pledin/wp-content/uploads/2013/09/githubpage2.png" alt="" width="757" height="531" />](https://www.josedomingo.org/pledin/wp-content/uploads/2013/09/githubpage2.png){.thumbnail}

## Cómo podemos construir nuestras páginas web

<p style="text-align: justify;">
  La forma más sencilla de construir nuestro sitio es subir a nuestro repositorio todos los ficheros necesarios: ficheros html, hojas de estilos, javascript, imágenes, etc. Si sólo tuviéramos esta opción de edición de páginas no tendríamos grandes ventajas para decidirnos a escoger este servicio de hosting.
</p>

<p style="text-align: justify;">
  Lo que realmente hace esta herramienta una opción muy potente es que Github Pages suporta <a href="http://jekyllrb.com/">Jekyll</a>, herramienta escrita en Ruby que nos permite generar, de una forma muy sencilla, ficheros HTML estáticos. Aunque esta herramienta esta pensada para generar blogs, nosotros vamos a utilizar algunas de sus funcionalidades para crear páginas estáticas convencionales.
</p>

## Usando Jekyll para crear páginas web

<p style="text-align: justify;">
  La principal característica de Jekylls es la generación de html estático a partir de dos recursos muy simples:
</p>

<li style="text-align: justify;">
  Plantillas (templates): Ficheros que contienen el esqueleto de las página html que se van a generar. Estos ficheros normalmente se escriben siguiendo la sintaxis de <a href="http://wiki.shopify.com/Liquid">Liquid</a>.
</li>
<li style="text-align: justify;">
  Ficheros de contenido: Normalmente escritos en sintaxis <a href="http://daringfireball.net/projects/markdown/">Markdown</a> y que contienen el contenido de la página que se va a generar.
</li>

<p style="text-align: justify;">
  Por lo tanto una vez que tengo definidas mis plantillas, lo único que tengo que hacer es centrarme en  el contenido escribiendo los diferentes de ficheros de contenido.
</p>

## Usando plantillas

<p style="text-align: justify;">
  Las plantillas son ficheros de texto con extensión html. Deben estar guardados en un directorio <strong>_layouts</strong> creado en la raíz de nuestro repositorio. Además del contenido html de las páginas que se van a generar, se pueden indicar <a href="http://jekyllrb.com/docs/templates/">distintas etiquetas </a>que se sustituirán por diferentes valores. Veamos algunas etiquetas:
</p>

  * La etiqueta más importante es _{{ content }}_ que es sustituida por el contenido que definimos en los ficheros de contenido. 
<li style="text-align: justify;">
  La etiqueta<em> {{ site.path }}</em> será sustituida por el path del repositorio.
</li>
<li style="text-align: justify;">
  Además se podrá definir en los ficheros de contenidos distintas variables que podrán ser sustituidas con etiquetas del tipo<em> {{ page.nombredevariable }}</em>.
</li>

<p style="text-align: justify;">
  Todas las referencia a ficheros de hojas de estilo, javascripts o imágenes que se definan en la plantilla deben estar guardados en nuestro repositorio.
</p>

[Ejemplo de plantilla](https://github.com/josedom24/josedom24.github.io/blob/master/_layouts/index.html)

## Usando Markdown para escribir el contenido de nuestras páginas

<p style="text-align: justify;">
  Los distintos contenidos de nuestras páginas serán definidos en ficheros Maarkdown con extensión md. La <a href="http://daringfireball.net/projects/markdown/syntax">sintaxis de este lenguaje de marcas</a> es muy sencilla y fácilmente convertible a html. Para practicar las distintas opciones puedes usar este <a href="http://www.ctrlshift.net/project/markdowneditor/">editor online</a>.
</p>

<p style="text-align: justify;">
  Sin entrar a definir la sintaxis del lenguaje, sí nos vamos fijar en la primera parte de los ficheros donde se define la plantilla que se va a utilizar, y las distintas variables que son accesibles desde la plantilla:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">---
layout: index

title: Servicios de red 
tagline: CFGM SMR
---</pre>

<p style="text-align: justify;">
  Con la variable layout indicamos el nombre del fichero html que corresponde a la plantilla que se va a usar para generar la página. Además hemos definido dos variables cuyo valor es accesible desde la plantilla con las etiquetas <em>{{ pages.title }}</em> y <em>{{ page.tagline }}</em>.
</p>

<p style="text-align: justify;">
  Por último indicar como se accede a las distintas páginas, suponiendo que tenemos definido una página de usuario en la URL josedom24.github.io, si tenemos un fichero en la raíz proyecto.md, sería accesible con la URL josedom24.github.io/proyecto. Si el fichero proyecto.md esta dentro de una carpeta llamada &#8220;ejemplo&#8221;, sería accesible con la URL josedom24.github.io/ejemplo/proyecto. De forma similar a como funcionan los servidores web si tenemos un fichero index.md no será necesario indicar el nombre en la URL.
</p>

[Ejemplo de fichero Markdown](https://raw.github.com/josedom24/josedom24.github.io/master/mod/serviciosgm/e_dhcp_1.md)

## Conclusiones

<p style="text-align: justify;">
  Este artículo presenta la experiencia que he tenido con el servicio Github Pages este fin de semana, por lo tanto soy consciente de que es sólo una introducción a todas las posibilidades que nos ofrece esta manera de mantener de una forma muy sencilla nuestra página web. No obstante espero que  sea de utilidad. Doy por hecho que el lector conoce la forma de trabajar con Git y Github, sí no es así recomiendo algún <a href="http://rogerdudler.github.io/git-guide/index.es.html">tutorial</a> que puedes encontrar en internet.
</p>

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->