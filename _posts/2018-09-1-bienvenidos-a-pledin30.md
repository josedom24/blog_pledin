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

Empece a escribir en la página en octubre de 2005. Al principio decidí elegir una moodle para realizar la página, y empece a escribir artículos y a colgar los materiales y cursos que iba encontrando o generando. En esta primera etapa la página estaba alojada en mi ordenador personal de mi casa y recuerdo que lo pasaba muy mal cada vez que se iba la luz o tenía cualquier problema con el ordenador. Podéis ver una captura de pantalla 