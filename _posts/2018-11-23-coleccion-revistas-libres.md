---
title: 'Colección de revistas libres de software libre'
permalink: /2018/11/coleccion-revistas-libres
tags:
  - Revistas
  - Software Libre
---

<center><a href="revistas"><img src="assets/wp-content/uploads/2011/02/revistas.jpg"/></a></center>

He publicado de nuevo mi colección de **[Revistas Libres de Software Libre](https://www.josedomingo.org/pledin/revistas/index.html)**. Por distintos motivos tuve que dejar de publicarla en mi antigua versión de PLEDIN, pero en los últimos días he actualizado los últimos números de las revistas y ya están preparada en nuestra nueva página web.

Las revistas sobre Software Libre escritas en PDF tuvieron su auge a principio del año 2000 y tenemos revistas de diferentes países. Muchas de ellas ya no se editan, y las he clasificado en un apartador de **[Revistas antiguas](https://www.josedomingo.org/pledin/revistas/oldrevistas.html)**.

En la página principal de la sección de revistas podéis encontrar las que actualmente se están publicando, algunas no han dejado de publicar en los últimos años y otras han vuelto a publicar después de algunos años sin hacerlo.

En esta sección podéis encontrar las siguientes revistas:

{% for revista in site.data.revistas_new %}
* {{revista.name}}
{% endfor %}
