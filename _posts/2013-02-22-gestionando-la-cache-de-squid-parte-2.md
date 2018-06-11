---
id: 729
title: Gestionando la caché de Squid (parte 2)
date: 2013-02-22T14:09:26+00:00


guid: http://www.josedomingo.org/pledin/?p=729
permalink: /2013/02/gestionando-la-cache-de-squid-parte-2/


tags:
  - Caché
  - html
  - Proxy
  - Squid
---
<p style="text-align: justify;">
  En el <a href="http://www.josedomingo.org/pledin/2013/01/gestionando-la-cache-de-squid-parte-1/">anterior artículo</a> donde tratamos la gestión de la caché de squid, estudiamos como funciona los mecanismos de caché y como evitar el &#8220;cacheo&#8221; de nuestro contenido.
</p>

<p style="text-align: justify;">
  En el presente artículo vamos  a estudiar las posibilidades que ofrece squid a los administradores para forzar el &#8220;cacheo&#8221; de determinados elementos, incluso ignorando las cabeceras de control de caché.
</p>

<p style="text-align: justify;">
  Siguiendo la situación que teníamos en el primer artículo, estamos usando un navegador en el que hemos desactivado la función de caché local, que provoca algunos problemas con al caché de squid y que estudiaremos posteriormente.
</p>

<!--more-->

## refresh_pattern, controlando la caché

<p style="text-align: justify;">
  Tenemos que partir del hecho que en la internet actual, donde prima el contenido dinámico, no es lógico cachear todos los contenidos de la web, ya que seguramente perderíamos funcionalidad en muchas páginas e incluso podríamos estar ofreciendo contenido desactualizado. Sin embargo, es posible forzar que squid guarde en caché determinados tipos de ficheros que sabemos que no se suelen generar de forma dinámica, por ejemplo imágenes, hojas de estilo, archivos flash, archivos comprimidos e incluso archivos pdf.
</p>

Para conseguir esto, utilizamos el parámetro de configuración refresh_pattern en el fichero /etc/squid3/squid.conf, con la siguiente sintaxis:

<pre class="brush: actionscript3; gutter: false; first-line: 1">refresh_pattern [-i] regexp min percent max [options]</pre>

Por ejemplo:

<pre class="brush: actionscript3; gutter: false; first-line: 1">refresh_pattern -i \.jpg$ 30 50% 4320 reload-into-ims</pre>

<p style="text-align: justify;">
  El parámetro <em>regexp</em> es una expresión regular (la opción -i es para que no se tenga en cuanta las mayúsculas y minúsculas) que al coincidir con la url introducida se ejecuta la regla de refresco. Las lineas refresh_pattern se evalúan de forma ordenada hasta que la url se ajusta a una expresión regular.
</p>

<p style="text-align: justify;">
  El parámetro <em>min</em> estaexpresado en minutos,e indica el limite inferior en que el objeto se va a considerar invalido, es decir mientras el tiempo que el objeto esta almacenado en caché es menor que este tiempo se considera válido. De la misma forma el parámetro <em>max,</em> expresado también en minutos, indica el máximo tiempo que un objeto puede ser considerado válido, es decir si un objeto lleva más tiempo almacenado en caché que el indicado en el parámetro <em>max</em> se considera inválido.
</p>

<p style="text-align: justify;">
  Si el tiempo que un objeto lleva guardado en la caché está entre estos dos valores, ¿es válido o está caducado? En este caso entra en juego el <em>last-modified factor</em> (LM-factor), que es la relación que existe entre el tiempo que lleva el objeto guardado en la caché y la edad que tiene. ¿Y cómo podemos calcular la edad? Pues será el tiempo transcurrido desde la última modificación del objeto (cabecera last-modified) y el momento en que se ha recibido (cabecera date). Es decir, si el LM factor es menor que el porcentaje indicado en el parámetro <em>percent</em>, el objeto se considerará válido. Pongamos un ejemplo: si un objeto que acabamos de recibir tiene 6 horas de edad, es decir la última modificación se realizó hace 6 horas, y hemos indicado un porcentaje del 50% el objeto se considerará válido en la caché las próximas 3 horas.
</p>

<p style="text-align: justify;">
  Por lo tanto podemos resumir el algoritmo que sigue el refresh_pattern de la siguiente manera:
</p>

<li style="text-align: justify;">
  La respuesta esta caducada si el tiempo guardado en caché es mayor que el tiempo <em>max</em>.
</li>
<li style="text-align: justify;">
  La respuesta es válida si el<em> LM-factor</em> es menor que el porcentaje que hemos indicado en la directiva refresh_pattern.
</li>
<li style="text-align: justify;">
  La respuesta es válida si el tiempo guardado en caché es menor que el tiempo <em>min</em>.
</li>
<li style="text-align: justify;">
  En cualquier otro caso, la respuesta se considera caducada.
</li>

<p style="text-align: justify;">
  En la directiva refresh_pattern también podemos indicar distintas opciones, como las que estudiamos a continuación:
</p>

<ul style="text-align: justify;">
  <li style="text-align: justify;">
    <strong>override-expire:</strong> fuerza el tiempo mínimo que puede estar almacenada y que se considera válida, aunque el servidor envíe explícitamente un tiempo de caducidad con la cabecera Expires o Cache-control:max-age.
  </li>
  <li>
    <strong>ignore-no-cache:</strong> Ignora cualquier cabecera Pragma: no-cache o Cache-control:no-cache enviada por el servidor.
  </li>
  <li>
    <strong>ignore-no-store:</strong> Ignora cualquier cabecera Cache-control:no-store enviada por el servidor.
  </li>
  <li>
    <strong>ignore-private:</strong> Ignora cualquier cabecera Cache-control: private  enviada por el servidor.
  </li>
</ul>

<p style="text-align: justify;">
  En todo caso, hay que recordar que sólo almacenará los archivos cuyo tamaño sea menor que le indicado en el parámetro maximum_object_size.
</p>

<h2 style="text-align: justify;">
  Evitando problemas con la caché de los navegadores
</h2>

<p style="text-align: justify;">
  Como indicamos al principio del artículo, estas pruebas se han realizado con navegadores que tenían deshabilitada la función de caché local. Cuando esta función esta funcionando en los navegadores modernos se incluyen algunas cabeceras en la petición que producen que el parámetro refresh_pattern no funcione de manera adecuada. Podemos ver el contenido de estas cabeceras en la siguiente imagen:
</p>

<p style="text-align: justify;">
  <a href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/02/cache1.png"><img class="alignnone size-thumbnail wp-image-734" title="cache" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/02/cache1-150x150.png" alt="" width="150" height="150" /></a>
</p>

<p style="text-align: justify;">
  Para evitar este efecto tenemos que usar la opción ignore-cc en el parámetro http_port de la siguiente manera:
</p>

<pre class="brush: actionscript3; gutter: false; first-line: 1">http_port 3198 ignore-cc</pre>

<p style="text-align: justify;">
  Según la documentación esta opción permite ignorar la cabeceras de Cache-control de la petición.
</p>

<p style="text-align: justify;">
  Este artículo es fruto de mi poca experiencia con el proxy que tenemos instalado en el instituto y la preparación de las clases del módulo de Servicios en red e intenet que imparto en el ciclo formativo ASIR del IES Gonzalo Nazareno.
</p>

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->