---
title: 'Bienvenidos a PLEDIN 3.0'
permalink: /2018/09/bienvenidos-a-pledin30/
tags:
  - Pledin
---

En esta entrada os presento la nueva versión de mi página personal: PLEDIN 3.0. Desde hace 8 años he estado trabajando con Wordpress y la verdad es que aunque la experiencia ha sido muy positiva, sí he experimentado que las ventajas que ofrece una herramienta como Wordpress no las estoy aprovechando, no necesito una web dinámica para escribir contenido estático. Además el mantenimiento de la página puede llegar a ser muy pesado (copias de seguridad, mantenimiento de la base de datos, etc.), todo estos aspectos son un poco más complicado con la página Moodle donde mantengo los cursos que he ido impartiendo a lo largo de estos años (utilizo una moodle con contenido estático, sin aprovechar todas las funcionalidades que nos ofrece).

Por todas estas razones os presento la nueva página de PLEDIN desarrollada con [Jekyll](https://jekyllrb.com/), esta herramienta escrita en Ruby es un generador de páginas estáticas, que me permite de forma sencilla escribir el contenido estático con Markdown y automáticamente generar el html qué posteriormente despliego en mi servidor. He estado mirando diferentes herramientas que trabajan de forma similar: [Pelican](https://blog.getpelican.com/) escrita en Python y [Hugo](https://gohugo.io/) escrita en Go, pero finalmente me decidí a usar Jekyll ya que he encontrado más soporte en la red y una comunidad de usuarios más amplia. Las ventajas que me ofrece utilizar un generador de páginas estáticas son las siguientes (y seguro que se me olvida alguna):

* Trabajo con fichero Markdown, la sintaxis es muy sencilla y puedo utilizar mi editor de textos favorito para escribir.
* Todos los ficheros que forman parte de mi página se pueden guardar en un sistema de control de versiones, trabajar con git aporta muchas ventajas.
* El resultado final son páginas web html estáticas, con lo que la velocidad de acceso a la página es muy elevada.
* Me olvido de la base de datos que necesitan todos los gestores de contenido para funcionar, no necesito hacer copias de seguridad ni administrar la base de datos.
* La copia de seguridad ya la tengo con el uso del sistema de control de versiones, pero si quiero hacer la copia de la página sólo tengo que guardar los ficheros del directorio donde se aloja.
* La puesta en producción es muy sencilla y se puede automatizar de una forma simple.

<!--more-->

## Un poco de historia

Empecé a escribir en la página en octubre de 2005. Al principio decidí elegir una moodle para realizar la página, y comencé a escribir artículos y a colgar los materiales y cursos que iba encontrando o generando. En esta primera etapa la página estaba alojada en mi ordenador personal de mi casa y recuerdo que lo pasaba muy mal cada vez que se iba la luz o tenía cualquier problema con el ordenador. Podéis ver una captura de pantalla de la página en abril de 2008:

![2008]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/28042008-rect.png)

[Ver pantalla completa]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/28042008.png)

Al poco tiempo decidí que tener la página en un servidor personal me daba muchos dolores de cabeza, y en noviembre de 2008 migre la página a un servicio de hosting compartido con la empresa CDMON. Y en abril de 2010 decidí el cambio de la Moodle al Wordpress, en realidad mantuve las dos páginas:

* `www.josedomingo.org`: Estaría creada con el Wordpress y serviría de blog personal donde podía escribir mis artículos.
* `plataforma.josedomingo.org`: Seguiría siendo la moodle pero sólo para guardar los cursos que iba impartiendo.

De esta manera en 2010 y 2011 las páginas se veían de esta manera:

![blog]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/05092010-rect.png)

[Ver pantalla completa]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/05092010.png)

![plataforma]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/29052011-rect.png)

[Ver pantalla completa]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/29052011.png)

La plataforma se podía ver en 2012 de la siguiente manera:

![plataforma]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/24112012-rect.png)

[Ver pantalla completa]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/24112012.png)

Y el blog en el año 2014 se veía así:

![blog]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/2014-rect.png)

[Ver pantalla completa]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/2014.png)

En diciembre de 2014 hice otro cambio importante: la migración desde un servidor hosting compartido a un servicio de cloud computing PaaS: OpenShift. La versión anterior de OpenShift nos ofrecía una capa de servicio gratuita muy adecuada para tener alojadas páginas pequeñas, sólo me hizo falta contratar más almacenamiento. Además decidí migrar los cursos más antiguos de la plataforma a la página: [pledin.gnomio.com](https://pledin.gnomio.com/). Durante estos años cambié otra vez los temas de las páginas, que son los que han tenido hasta la actualidad:

![blog]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/2015-rect.png)

[Ver pantalla completa]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/2015.png)

![plataforma]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/17092016-rect.png)

[Ver pantalla completa]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/17092016.png)

A mediados de 2016 se anunció la nueva versión de OpenShift y por consiguiente el cierre de los servicios ofrecidos por la versión anterior. La nueva versión no ofrecía una capa gratuita tan interesante como la anterior y por lo tanto había que buscar un nuevo alojamiento para las páginas. En noviembre de 2016 me decidí por contratar un servidor dedicado que es donde actualmente se encuentran alojadas las páginas.

## El nuevo blog

como comentaba anteriormente he desarrollado las nuevas páginas con Jekyll, he usado el tema [Minimal Mistake](https://mmistakes.github.io/minimal-mistakes/) que nos da muchas opciones de configuración y que a mí me gusta mucho. 

Al acceder a la nueva web encontramos una página principal desde donde podemos acceder a los distintos sitios: al blog PLEDIN ([www.josedomingo.org/pledin/blog/](http://www.josedomingo.org/pledin/blog/)), a la plataforma con los curso ([plataforma.josedomingo.org](https://plataforma.josedomingo.org/pledin/)) y a los contenidos de los módulos de Formación Profesional que voy a impartir este año (este apartado lo estrenaré en los próximos días).

Para realizar la migración de los posts he usado el plugin de WordPress: [WordPress2Jekyll](https://es.wordpress.org/plugins/wp2jekyll/) que me ha permitido generar de forma automática los fichero Markdown con el contenido de los diferentes posts.

Además he configurado Jekyll para que las URL de acceso a las distintas páginas e imágenes sean los mismos, con lo que no voy a tener enlaces rotos, y los posibles enlaces que haya en otras páginas sigan funcionando.

Aunque mi blog no tenía muchos comentarios, los he migrado también a ficheros Markdown y he hecho una modificación en el layout de las páginas donde se muestran los posts para añadir los comentarios.

## La nueva plataforma de cursos

También he migrado los contenidos de la moodle, a la nueva [plataforma Pledin](https://plataforma.josedomingo.org/pledin/). Esta migración ha costado un poco más ya que no encontraba herramientas que lo hicieran de forma automática.

De esta manera me he creado un pequeño programa: [moodle2md](https://github.com/josedom24/moodle2md) que me permite coger una copia de seguridad de un curso de moodle y convertir sus contenidos en fichero Markdown, además de extraer los ficheros e imágenes del curso. Posteriormente he tenido que editar los ficheros para adaptarlos un poco, pero los resultados han sido muy satisfactorios.

Otro problema que he solucionado es la redirección de las URL de la moodle a la nueva página. En el repositorio podéis encontrar el fichero `rewrite.py` que genera las reglas de reescrituras para el módulo `rewrite` de Apache2 para que todos los recursos de un curso tengan una regla que me lleve a las nuevas URL. Por ejemplo si accedemos a la URL de la moodle: [https://plataforma.josedomingo.org/pledin/mod/resource/view.php?id=1635](https://plataforma.josedomingo.org/pledin/mod/resource/view.php?id=1635) accederemos al documento pdf que se encuentra en nuestra nueva plataforma.

Bueno ha sido un trabajo un poco complejo pero espero que el resultado os guste. Un saludo a todos.

