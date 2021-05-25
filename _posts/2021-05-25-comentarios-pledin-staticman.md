---
title: 'Nuevo sistema de comentarios con Staticman'
permalink: /2021/05/comentarios-pledin-staticman/
tags:
  - Pledin
---

![staticman]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2021/05/staticman.png){: .align-center }

Cuando [migré mi página personal Pledin](https://www.josedomingo.org/pledin/2018/09/bienvenidos-a-pledin30/) a un sistema de generación de páginas estáticas como Jekyll, tuve que decidir que sistema de comentarios pondría en mi blog. Teníendo en cuenta que ahora la página es estática, y no tenemos la posibilidad de programar esa funcionalidad, había que escoger un servicio externo para poder gestionar los comentarios escritos en los distintos post. En aquel momento elegí la opción de **Disqus**, que me parecía adecuada para lo que necesitaba.

Además de que Discus no es software libre y que pierdes el control de la gestión de tus comentarios, en los últimos tiempos incluía demasiada publicidad en mi página web, por lo que en los últimos días he estado buscando una alternativa a Disqus como sistema de comentarios para mi blog.

Mi decisión final ha sido utilizar [Staticman](https://staticman.net/). Veamos cómo ha sido el proceso del cambio...

<!--more-->

## ¿Cómo funciona Staticman?

**Staticman** esta pensado para gestionar los comentarios de un blog que esté construido con páginas estáticas. En mi caso es perfecto, yo uso el generador de sitios estáticos [Jekyll](https://jekyllrb.com/) para crear mi página estática. Además uso el tema de jekyll [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/) que tienes soporte para Staticman, por lo que me va a facilitar el trabajo.

Pero, **¿cómo funciona Staticman?**: En realidad no tenemos una base de datos, ni podemos hacer un programa que guarde los comentarios que vamos introduciendo en nuestros posts. **Staticman** es un programa escrito en node.js (es software libre), y nos ofrece una API a la que podemos mandar los datos del comentario desde un formulario HTML y se encarga de generar una fichero yaml con la información del comentario y hacer un pull request sobre nuestro repositorio GitHub para añadir dicho fichero con el comentario. Aunque staticman podría escribir directamente en el repositorio, esta forma de crear un pull request me parece más acertada, por que da la posibilidad de moderar los comentarios, ya que soy yo el que finalmente va a aceptar o no el pull request y en consecuencia añadir un nuevo fichero con un nuevo comentario en mi repositorio.

## Permitir que Saticman pueda trabajar con GitHub




## Instalación de Staticman

Siguiendo la [documentación](https://staticman.net/docs/getting-started.html) de Staticman, nos ofrecen varias formas de desplegar el programa. En mi caso he elegido docker, y he realizado la instalación en mismo servidor donde tengo alojada mi página. Para ello he clonado el repositorio del proyecto y he creado el contenedor docker de la siguiente manera:

```bash
$ git clone https://github.com/eduardoboucas/staticman.git
```

A continuación necesito generar 