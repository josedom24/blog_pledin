---
id: 779
title: Publicar una página web en Github Pages
date: 2017-09-20T00:12:03+00:00


guid: http://www.josedomingo.org/pledin/?p=779
permalink: /2017/09/publicar-una-pagina-web-en-github-pages/


tags:
  - GitHub
---
{: .notice--info}
Esté artículo lo escribí originalmente en septiembre de 2013. Como el servicio <strong>GitHub Pages</strong> ha sufrido algunos cambios en su configuración, vuelvo a publicarlo con las modificaciones oportunas.

<a href="http://pages.github.com/"><img class="alignleft" title="github" src="https://jekyllrb.com/img/octojekyll.png" alt="" width="151" height="126" /></a>

<a href="http://pages.github.com/">Github Pages</a> es un servicio que te ofrece <a href="http://github.com">Github</a> para publicar de una manera muy sencilla páginas web. Disponemos de la opción de generar de forma automática las páginas utilizando una herramienta gráfica, pero en este artículo nos vamos a centrar en la creación y modificación de páginas web usando la línea de comandos con el comando git.

Tenemos dos alternativas para crear una página web con esta herramienta:

* Páginas de usuario u organización: Es necesario crear un repositorio especial donde se va a almacenar todos el contenido del sitio web. Si por ejemplo el nombre de usuario de Github es `josedom24`, el nombre del repositorio debe ser `josedom24.github.io`. Todos los ficheros que se van a publicar deben estar en la rama "**master**". Por último indicar que la URL para acceder a la ṕagina sería <a href="http://josedom24.github.io">http://josedom24.github.io</a>.
* Páginas de proyecto o repositorio: A diferencia de las anteriores están asociada a cualquier repositorio que tengamos en Github (por ejemplo supongamos que el repositorio se llama `prueba`). <span style="text-decoration: line-through;">En este caso los ficheros que se van a publicar deben estar en una rama del proyecto llamada `gh-pages`</span> 

{: .notice--danger}
(**Actualización 20/9/2017:** Actualmente se pueden publicar páginas web en GitHub Pages desde la rama `master`, `gh-pages` o la carpeta `/cod` de la rama `master`). 

La URL de acceso al sitio será `http://josedom24.github.io/prueba`.

## Creación manual de páginas

Mientras que las páginas de usuario son fáciles de crear, ya que simplemente debemos crear el repositorio y clonarlo en nuestro equipo (git clone) y empezar a crear ficheros que estarán guardados en la rama **master**, las páginas de repositorio pueden ser un poco más complejas <span style="text-decoration: line-through;">ya que hay que crear la nueva rama que tenemos que llamar <strong>gh-pages</strong></span>, siguiendo el manual de <a href="https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/">Github Pages </a>los pasos a dar son los siguientes:

{: .notice--danger}
**Actualización 20/9/2017:** En la configuración del repositorio, podemos escoger donde vamos a guardar nuestra página web: la rama `master`, `gh-pages` (si el repositorio tiene dicha rama) o la carpeta `/cod` de la rama `master`. 

![<img class="aligncenter size-full wp-image-1844" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/09/githubpages.png" alt="" width="757" height="431" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/09/githubpages.png)

 En el siguiente ejemplo vamos a crear una rama `gh-pages`, aunque como hemos indicado anteriormente nos serviría la rama `master`:

    $ git clone https://github.com/user/repository.git
    # Clone our repository
    # Cloning into 'repository'...
    # remote: Counting objects: 2791, done.
    # remote: Compressing objects: 100% (1225/1225), done.
    # remote: Total 2791 (delta 1722), reused 2513 (delta 1493)
    # Receiving objects: 100% (2791/2791), 3.77 MiB | 969 KiB/s, done.
    # Resolving deltas: 100% (1722/1722), done.

A continuación tenemos que crear la nueva rama:

    $ cd repository
    $ git checkout --orphan gh-pages
    # Creates our branch, without any parents (it's an orphan!)
    # Switched to a new branch 'gh-pages'
    $ git rm -rf .
    # Remove all files from the old working tree
    # rm '.gitignore'

Para terminar subiendo el primer fichero de nuestra página:

    $ echo "My GitHub Page" > index.html
    $ git add index.html
    $ git commit -a -m "First pages commit"
    $ git push origin gh-pages

Para publicar nuestra página, cómo indicábamos anteriormente, sólo tendríamos que ir a la configuración del repositorio y activar la opción de **GitHub Pages** seleccionado la rama `gh-page`:

![<img class="aligncenter size-full wp-image-1845" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/09/githubpage2.png" alt="" width="757" height="531" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/09/githubpage2.png)

## Cómo podemos construir nuestras páginas web

La forma más sencilla de construir nuestro sitio es subir a nuestro repositorio todos los ficheros necesarios: ficheros html, hojas de estilos, javascript, imágenes, etc. Si sólo tuviéramos esta opción de edición de páginas no tendríamos grandes ventajas para decidirnos a escoger este servicio de hosting.

Lo que realmente hace esta herramienta una opción muy potente es que Github Pages suporta <a href="http://jekyllrb.com/">Jekyll</a>, herramienta escrita en Ruby que nos permite generar, de una forma muy sencilla, ficheros HTML estáticos. Aunque esta herramienta esta pensada para generar blogs, nosotros vamos a utilizar algunas de sus funcionalidades para crear páginas estáticas convencionales.

## Usando Jekyll para crear páginas web

La principal característica de Jekylls es la generación de html estático a partir de dos recursos muy simples:

*  Plantillas (templates): Ficheros que contienen el esqueleto de las página html que se van a generar. Estos ficheros normalmente se escriben siguiendo la sintaxis de <a href="http://wiki.shopify.com/Liquid">Liquid</a>.
* Ficheros de contenido: Normalmente escritos en sintaxis <a href="http://daringfireball.net/projects/markdown/">Markdown</a> y que contienen el contenido de la página que se va a generar.

Por lo tanto una vez que tengo definidas mis plantillas, lo único que tengo que hacer es centrarme en  el contenido escribiendo los diferentes de ficheros de contenido.

## Usando plantillas

Las plantillas son ficheros de texto con extensión html. Deben estar guardados en un directorio `_layouts` creado en la raíz de nuestro repositorio. Además del contenido html de las páginas que se van a generar, se pueden indicar <a href="http://jekyllrb.com/docs/templates/">distintas etiquetas </a>que se sustituirán por diferentes valores. Veamos algunas etiquetas:

  * La etiqueta más importante es {{% raw %}}`{{ content }}`{{% endraw %}} que es sustituida por el contenido que definimos en los ficheros de contenido. 
* La etiqueta {{% raw %}}`{{ site.path }}`{{% endraw %}} será sustituida por el path del repositorio.
* Además se podrá definir en los ficheros de contenidos distintas variables que podrán ser sustituidas con etiquetas del tipo {{% raw %}}`{{ page.nombredevariable }}`{{% endraw %}}.

Todas las referencia a ficheros de hojas de estilo, javascripts o imágenes que se definan en la plantilla deben estar guardados en nuestro repositorio.

[Ejemplo de plantilla](https://github.com/josedom24/josedom24.github.io/blob/master/_layouts/index.html)

## Usando Markdown para escribir el contenido de nuestras páginas

Los distintos contenidos de nuestras páginas serán definidos en ficheros Maarkdown con extensión md. La <a href="http://daringfireball.net/projects/markdown/syntax">sintaxis de este lenguaje de marcas</a> es muy sencilla y fácilmente convertible a html. Para practicar las distintas opciones puedes usar este <a href="http://www.ctrlshift.net/project/markdowneditor/">editor online</a>.

Sin entrar a definir la sintaxis del lenguaje, sí nos vamos fijar en la primera parte de los ficheros donde se define la plantilla que se va a utilizar, y las distintas variables que son accesibles desde la plantilla:

    ---
    layout: index

    title: Servicios de red 
    tagline: CFGM SMR
    ---

Con la variable layout indicamos el nombre del fichero html que corresponde a la plantilla que se va a usar para generar la página. Además hemos definido dos variables cuyo valor es accesible desde la plantilla con las etiquetas {{% raw %}}`{{ page.title }}`{{% endraw %}} y {{% raw %}}`{{ page.tagline }}`{{% endraw %}}.

Por último indicar como se accede a las distintas páginas, suponiendo que tenemos definido una página de usuario en la URL `josedom24.github.io`, si tenemos un fichero en la raíz `proyecto.md`, sería accesible con la URL `josedom24.github.io/proyecto`. Si el fichero `proyecto.md` esta dentro de una carpeta llamada `ejemplo`, sería accesible con la URL `josedom24.github.io/ejemplo/proyecto`. De forma similar a como funcionan los servidores web si tenemos un fichero `index.md` no será necesario indicar el nombre en la URL.

[Ejemplo de fichero Markdown](https://raw.github.com/josedom24/josedom24.github.io/master/mod/serviciosgm/e_dhcp_1.md)

## Conclusiones

Este artículo presenta la experiencia que he tenido con el servicio Github Pages este fin de semana, por lo tanto soy consciente de que es sólo una introducción a todas las posibilidades que nos ofrece esta manera de mantener de una forma muy sencilla nuestra página web. No obstante espero que  sea de utilidad. Doy por hecho que el lector conoce la forma de trabajar con Git y Github, sí no es así recomiendo algún <a href="http://rogerdudler.github.io/git-guide/index.es.html">tutorial</a> que puedes encontrar en internet.


<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->