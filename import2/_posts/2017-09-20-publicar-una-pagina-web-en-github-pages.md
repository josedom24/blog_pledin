---
layout: post
status: publish
published: true
title: Publicar una p&aacute;gina web en Github Pages
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 779
wordpress_url: http://www.josedomingo.org/pledin/?p=779
date: '2017-09-20 00:12:03 +0000'
date_gmt: '2017-09-19 22:12:03 +0000'
categories:
- General
tags:
- GitHub
comments: []
---
<table>
<tbody>
<tr>
<td>
        Est&eacute; art&iacute;culo lo escrib&iacute; originalmente en septiembre de 2013. Como el servicio <strong>GitHub Pages</strong> ha sufrido algunos cambios en su configuraci&oacute;n, vuelvo a publicarlo con las modificaciones oportunas.
      </td>
</tr>
</tbody>
</table>
<p style="text-align: justify;">
  <a href="http://pages.github.com/"><img class="alignleft" title="github" src="https://jekyllrb.com/img/octojekyll.png" alt="" width="151" height="126" /></a></p>
<p>&nbsp;</p>
<p style="text-align: justify;">
  <a href="http://pages.github.com/">Github Pages</a> es un servicio que te ofrece <a href="http://github.com">Github</a> para publicar de una manera muy sencilla p&aacute;ginas web. Disponemos de la opci&oacute;n de generar de forma autom&aacute;tica las p&aacute;ginas utilizando una herramienta gr&aacute;fica, pero en este art&iacute;culo nos vamos a centrar en la creaci&oacute;n y modificaci&oacute;n de p&aacute;ginas web usando la l&iacute;nea de comandos con el comando git.</p>
<p>&nbsp;</p>
<p style="text-align: justify;">
  Tenemos dos alternativas para crear una p&aacute;gina web con esta herramienta:</p>
<p>
<li style="text-align: justify;">
  P&aacute;ginas de usuario u organizaci&oacute;n: Es necesario crear un repositorio especial donde se va a almacenar todos el contenido del sitio web. Si por ejemplo el nombre de usuario de Github es josedom24, el nombre del repositorio debe ser josedom24.github.io. Todos los ficheros que se van a publicar deben estar en la rama "<strong>master</strong>". Por &uacute;ltimo indicar que la URL para acceder a la ṕagina ser&iacute;a <a href="http://josedom24.github.io">http://josedom24.github.io</a>.
</li>
<li style="text-align: justify;">
  P&aacute;ginas de proyecto o repositorio: A diferencia de las anteriores est&aacute;n asociada a cualquier repositorio que tengamos en Github (por ejemplo supongamos que el repositorio se llama "<em>prueba</em>"). <span style="text-decoration: line-through;">En este caso los ficheros que se van a publicar deben estar en una rama del proyecto llamada <strong>gh-pages</strong></span> (<strong>Actualizaci&oacute;n 20/9/2017:</strong> Actualmente se pueden publicar p&aacute;ginas web en GitHub Pages desde la rama <code>master</code>, <code>gh-pages</code> o la carpeta <code>/cod</code> de la rama <code>master</code>). La URL de acceso al sitio ser&aacute; http://josedom24.github.io/prueba
</li></p>
<h2><!--more--></h2>
<h2>Creaci&oacute;n manual de p&aacute;ginas</h2>
<p style="text-align: justify;">
  Mientras que las p&aacute;ginas de usuario son f&aacute;ciles de crear, ya que simplemente debemos crear el repositorio y clonarlo en nuestro equipo (git clone) y empezar a crear ficheros que estar&aacute;n guardados en la rama <strong>master</strong>, las p&aacute;ginas de repositorio pueden ser un poco m&aacute;s complejas <span style="text-decoration: line-through;">ya que hay que crear la nueva rama que tenemos que llamar <strong>gh-pages</strong></span>, siguiendo el manual de <a href="https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/">Github Pages </a>los pasos a dar son los siguientes:</p>
<p><strong>Actualizaci&oacute;n 20/9/2017:</strong> En la configuraci&oacute;n del repositorio, podemos escoger donde vamos a guardar nuestra p&aacute;gina web: la rama <code>master</code>, <code>gh-pages</code> (si el repositorio tiene dicha rama) o la carpeta <code>/cod</code> de la rama <code>master</code>. <a class="thumbnail" href="https://www.josedomingo.org/pledin/wp-content/uploads/2013/09/githubpages.png"><img class="aligncenter size-full wp-image-1844" src="https://www.josedomingo.org/pledin/wp-content/uploads/2013/09/githubpages.png" alt="" width="757" height="431" /></a> En el siguiente ejemplo vamos a crear una rama <code>gh-pages</code>, aunque como hemos indicado anteriormente nos servir&iacute;a la rama <code>master</code>:</p>
<pre class="brush: bash; gutter: false; first-line: 1">$ git clone https://github.com/<em>user</em>/<em>repository</em>.git
# Clone our repository
# Cloning into '<em>repository</em>'...
# remote: Counting objects: 2791, done.
# remote: Compressing objects: 100% (1225/1225), done.
# remote: Total 2791 (delta 1722), reused 2513 (delta 1493)
# Receiving objects: 100% (2791/2791), 3.77 MiB | 969 KiB/s, done.
# Resolving deltas: 100% (1722/1722), done.</pre>
<p>A continuaci&oacute;n tenemos que crear la nueva rama:</p>
<pre class="brush: bash; gutter: false; first-line: 1">$ cd <em>repository</em>
$ git checkout --orphan gh-pages
# Creates our branch, without any parents (it's an orphan!)
# Switched to a new branch 'gh-pages'
$ git rm -rf .
# Remove all files from the old working tree
# rm '.gitignore'</pre>
<p>Para terminar subiendo el primer fichero de nuestra p&aacute;gina:</p>
<pre class="brush: bash; gutter: false; first-line: 1">$ echo "My GitHub Page" > index.html
$ git add index.html
$ git commit -a -m "First pages commit"
$ git push origin gh-pages</pre>
<p>Para publicar nuestra p&aacute;gina, c&oacute;mo indicabamos anteriormente, s&oacute;lo tendr&iacute;amos que ir a la configuraci&oacute;n del repositorio y activar la opci&oacute;n de</p>
<p><strong>GitHub Pages</strong> seleccionado la rama <code>gh-page</code>:</p>
<h2><a class="thumbnail" href="https://www.josedomingo.org/pledin/wp-content/uploads/2013/09/githubpage2.png"><img class="aligncenter size-full wp-image-1845" src="https://www.josedomingo.org/pledin/wp-content/uploads/2013/09/githubpage2.png" alt="" width="757" height="531" /></a></h2>
<h2>C&oacute;mo podemos construir nuestras p&aacute;ginas web</h2>
<p style="text-align: justify;">
  La forma m&aacute;s sencilla de construir nuestro sitio es subir a nuestro repositorio todos los ficheros necesarios: ficheros html, hojas de estilos, javascript, im&aacute;genes, etc. Si s&oacute;lo tuvi&eacute;ramos esta opci&oacute;n de edici&oacute;n de p&aacute;ginas no tendr&iacute;amos grandes ventajas para decidirnos a escoger este servicio de hosting.</p>
<p style="text-align: justify;">
  Lo que realmente hace esta herramienta una opci&oacute;n muy potente es que Github Pages suporta <a href="http://jekyllrb.com/">Jekyll</a>, herramienta escrita en Ruby que nos permite generar, de una forma muy sencilla, ficheros HTML est&aacute;ticos. Aunque esta herramienta esta pensada para generar blogs, nosotros vamos a utilizar algunas de sus funcionalidades para crear p&aacute;ginas est&aacute;ticas convencionales.</p>
<h2>Usando Jekyll para crear p&aacute;ginas web</h2>
<p style="text-align: justify;">
  La principal caracter&iacute;stica de Jekylls es la generaci&oacute;n de html est&aacute;tico a partir de dos recursos muy simples:</p>
<p>
<li style="text-align: justify;">
  Plantillas (templates): Ficheros que contienen el esqueleto de las p&aacute;gina html que se van a generar. Estos ficheros normalmente se escriben siguiendo la sintaxis de <a href="http://wiki.shopify.com/Liquid">Liquid</a>.
</li>
<li style="text-align: justify;">
  Ficheros de contenido: Normalmente escritos en sintaxis <a href="http://daringfireball.net/projects/markdown/">Markdown</a> y que contienen el contenido de la p&aacute;gina que se va a generar.
</li></p>
<p style="text-align: justify;">
  Por lo tanto una vez que tengo definidas mis plantillas, lo &uacute;nico que tengo que hacer es centrarme en&nbsp; el contenido escribiendo los diferentes de ficheros de contenido.</p>
<h2>Usando plantillas</h2>
<p style="text-align: justify;">
  Las plantillas son ficheros de texto con extensi&oacute;n html. Deben estar guardados en un directorio <strong>_layouts</strong> creado en la ra&iacute;z de nuestro repositorio. Adem&aacute;s del contenido html de las p&aacute;ginas que se van a generar, se pueden indicar <a href="http://jekyllrb.com/docs/templates/">distintas etiquetas </a>que se sustituir&aacute;n por diferentes valores. Veamos algunas etiquetas:</p>
<ul>
<li>La etiqueta m&aacute;s importante es <em>{{ content }}</em> que es sustituida por el contenido que definimos en los ficheros de contenido.
</li>
<li style="text-align: justify;">
La etiqueta<em> {{ site.path }}</em> ser&aacute; sustituida por el path del repositorio.
</li>
<li style="text-align: justify;">
Adem&aacute;s se podr&aacute; definir en los ficheros de contenidos distintas variables que podr&aacute;n ser sustituidas con etiquetas del tipo<em> {{ page.nombredevariable }}</em>.
</li>
</ul>
<p style="text-align: justify;">
  Todas las referencia a ficheros de hojas de estilo, javascripts o im&aacute;genes que se definan en la plantilla deben estar guardados en nuestro repositorio.</p>
<p><a href="https://github.com/josedom24/josedom24.github.io/blob/master/_layouts/index.html">Ejemplo de plantilla</a></p>
<h2>Usando Markdown para escribir el contenido de nuestras p&aacute;ginas</h2>
<p style="text-align: justify;">
  Los distintos contenidos de nuestras p&aacute;ginas ser&aacute;n definidos en ficheros Maarkdown con extensi&oacute;n md. La <a href="http://daringfireball.net/projects/markdown/syntax">sintaxis de este lenguaje de marcas</a> es muy sencilla y f&aacute;cilmente convertible a html. Para practicar las distintas opciones puedes usar este <a href="http://www.ctrlshift.net/project/markdowneditor/">editor online</a>.</p>
<p style="text-align: justify;">
  Sin entrar a definir la sintaxis del lenguaje, s&iacute; nos vamos fijar en la primera parte de los ficheros donde se define la plantilla que se va a utilizar, y las distintas variables que son accesibles desde la plantilla:</p>
<pre class="brush: bash; gutter: false; first-line: 1">---
layout: index

title: Servicios de red 
tagline: CFGM SMR
---</pre>
<p style="text-align: justify;">
  Con la variable layout indicamos el nombre del fichero html que corresponde a la plantilla que se va a usar para generar la p&aacute;gina. Adem&aacute;s hemos definido dos variables cuyo valor es accesible desde la plantilla con las etiquetas <em>{{ pages.title }}</em> y <em>{{ page.tagline }}</em>.</p>
<p style="text-align: justify;">
  Por &uacute;ltimo indicar como se accede a las distintas p&aacute;ginas, suponiendo que tenemos definido una p&aacute;gina de usuario en la URL josedom24.github.io, si tenemos un fichero en la ra&iacute;z proyecto.md, ser&iacute;a accesible con la URL josedom24.github.io/proyecto. Si el fichero proyecto.md esta dentro de una carpeta llamada "ejemplo", ser&iacute;a accesible con la URL josedom24.github.io/ejemplo/proyecto. De forma similar a como funcionan los servidores web si tenemos un fichero index.md no ser&aacute; necesario indicar el nombre en la URL.</p>
<p><a href="https://raw.github.com/josedom24/josedom24.github.io/master/mod/serviciosgm/e_dhcp_1.md">Ejemplo de fichero Markdown</a></p>
<h2>Conclusiones</h2>
<p style="text-align: justify;">
  Este art&iacute;culo presenta la experiencia que he tenido con el servicio Github Pages este fin de semana, por lo tanto soy consciente de que es s&oacute;lo una introducci&oacute;n a todas las posibilidades que nos ofrece esta manera de mantener de una forma muy sencilla nuestra p&aacute;gina web. No obstante espero que&nbsp; sea de utilidad. Doy por hecho que el lector conoce la forma de trabajar con Git y Github, s&iacute; no es as&iacute; recomiendo alg&uacute;n <a href="http://rogerdudler.github.io/git-guide/index.es.html">tutorial</a> que puedes encontrar en internet.</p>
