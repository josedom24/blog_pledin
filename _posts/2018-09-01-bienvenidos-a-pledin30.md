---
title: 'Bienvenidos a PLEDIN 3.0'
permalink: /2018/09/bienvenidos-a-pledin30/
tags:
  - Pledin
---

En esta entrada os presento la nueva versión de mi página personal: PLEDIN 3.0. Desde hace 8 años he estado trabajando con Wordpress y la verdad es que aunque la experiencia ha sido muy positiva, sí he experimentado que las ventajas que ofrece una herramienta como Wordpress no las estoy aprovechando, no necesito una web dinámica para escribir contenido estático. Además el mantenimiento de la página puede llegar a ser muy pesado (copias de seguridad, mantenimiento de la base de datos, etc.), todo estos aspectos son un poco más complicado con la página Moodle donde mantengo los cursos que he ido impartiendo a lo largo de estos años (utilizo una moodle con contenido estático, sin aprovechar todas las funcionalidades que nos ofrece).

Por todas estas razones os presento la nueva página de PLEDIN desarrollada con [Jekyll](https://jekyllrb.com/), esta herramienta escrita en Ruby es un generador de páginas estáticas, me permite de forma sencilla escribir el contenido estático con Markdown y automáticamente generar el html qué posteriormente despliego en mi servidor. He estado mirando diferentes herramientas que trabajn de forma similar: [Pelican](https://blog.getpelican.com/) escrita en Python y [Hugo](https://gohugo.io/) escrita en Go, pero finalmente me decidir a usar Jekyll ya que he encontrado más soporte en la red y una comunidad de usuarios más amplia. Las ventajas que me ofrece utilizar un generador de páginas estáticas son las siguientes (y seguro que se me olvida alguna):

* Trabajo con fichero Markdown, la sintaxís es muy sencilla y puedo utilizar mi editor de textos favorito para escribir.
* Todos los ficheros que forman parte de mi página se pueden guardar en un sistema de control de versiones, trabajar con git aporta muchas ventajas.
* El resultado final son páginas web html estáticas con lo que la velocidad de acceso a la página es muy elevada.
* Me olvido de la base de datos que necesitan todos los gestores de contenido para funcionar, no necesito hacer copias de seguridad ni administrar la base de datos.
* La copia de seguridad ya la tengo con el uso del sistema de control de versiones, pero si quiero hacer la copia de la página sólo tengo que guardar los ficheros del directorio donde se aloja.
* La puesta en producción es muy sencilla y se puede automatizar de una forma simple.

## Un poco de historia

Empece a escribir en la página en octubre de 2005. Al principio decidí elegir una moodle para realizar la página, y empece a escribir artículos y a colgar los materiales y cursos que iba encontrando o generando. En esta primera etapa la página estaba alojada en mi ordenador personal de mi casa y recuerdo que lo pasaba muy mal cada vez que se iba la luz o tenía cualquier problema con el ordenador. Podéis ver una captura de pantalla de la página en abril de 2008:

![2008]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/28042008-rect.png)

[Ver pantalla completa]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/28042008.png)

Al poco tiempo decidí que tener la página en un servidor personal me daba muchos dolores de cabeza, y en noviembre de 2008 migre la página a un servicio de hosting compartido con la empresa CDMON. Y en abril de 2010 decidí el cambio de la Moodle al Wordpress, en realidad mantuve las dos páginas:

* `www.josedomingo.org`: Estaría creada con el Wordpress y serviría de blog personal donde podía escribir mis artículos.
* `plataforma.josedomingo.org`: seguiría siendo la moodle pero sólo para guardar los cursos que iba impartiendo.

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

En diciembre de 2014 hice otro cambio importante: la migración desde un servidor hosting compartido a un servicio de cloud computing PaaS: OpenShift. La versión anterior de OpenShift nos ofrecía una capa de servicio gratuita muy adecuada para tener alojadas páginas pequeñas, sólo me hizo falta contratar más almacenamiento. Durante estos años cambié otra vez los temas de las páginas, que son los que han tenido hasta la actualidad:

![blog]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/2015-rect.png)

[Ver pantalla completa]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/2015.png)

![plataforma]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/17092016-rect.png)

[Ver pantalla completa]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2018/09/17092016.png)

A mediados de 2016 se anunció la nueva versión de OpenShift y por consiguiente el cierre de los servicios ofrecidos por la versión anterior. La nueva versión no ofrecía una capa gratuita tan interesante como la anterior y por lo tanto había que buscar un nuevo alojamiento para las páginas. En noviembre de 2016 me decidir por contratar un servidor dedicado que es donde actualmente se encuentran alojadas las páginas.