---
layout: post
status: publish
published: true
title: Gestionando la cach&eacute; de Squid (parte 2)
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 729
wordpress_url: http://www.josedomingo.org/pledin/?p=729
date: '2013-02-22 14:09:26 +0000'
date_gmt: '2013-02-22 13:09:26 +0000'
categories:
- General
tags:
- html
- Squid
- Cach&eacute;
- Proxy
comments: []
---
<p style="text-align: justify;">En el <a href="http://www.josedomingo.org/pledin/2013/01/gestionando-la-cache-de-squid-parte-1/">anterior art&iacute;culo</a> donde tratamos la gesti&oacute;n de la cach&eacute; de squid, estudiamos como funciona los mecanismos de cach&eacute; y como evitar el "cacheo" de nuestro contenido.</p>
<p style="text-align: justify;">En el presente art&iacute;culo vamos&nbsp; a estudiar las posibilidades que ofrece squid a los administradores para forzar el "cacheo" de determinados elementos, incluso ignorando las cabeceras de control de cach&eacute;.</p>
<p style="text-align: justify;">Siguiendo la situaci&oacute;n que ten&iacute;amos en el primer art&iacute;culo, estamos usando un navegador en el que hemos desactivado la funci&oacute;n de cach&eacute; local, que provoca algunos problemas con al cach&eacute; de squid y que estudiaremos posteriormente.</p>
<p><!--more--></p>
<h2>refresh_pattern, controlando la cach&eacute;</h2>
<p style="text-align: justify;">Tenemos que partir del hecho que en la internet actual, donde prima el contenido din&aacute;mico, no es l&oacute;gico cachear todos los contenidos de la web, ya que seguramente perder&iacute;amos funcionalidad en muchas p&aacute;ginas e incluso podr&iacute;amos estar ofreciendo contenido desactualizado. Sin embargo, es posible forzar que squid guarde en cach&eacute; determinados tipos de ficheros que sabemos que no se suelen generar de forma din&aacute;mica, por ejemplo im&aacute;genes, hojas de estilo, archivos flash, archivos comprimidos e incluso archivos pdf.</p>
<p>Para conseguir esto, utilizamos el par&aacute;metro de configuraci&oacute;n refresh_pattern en el fichero /etc/squid3/squid.conf, con la siguiente sintaxis:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">refresh_pattern [-i] regexp min percent max [options]</pre>
<p>Por ejemplo:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">refresh_pattern -i \.jpg$ 30 50% 4320 reload-into-ims</pre>
<p style="text-align: justify;">El par&aacute;metro <em>regexp</em> es una expresi&oacute;n regular (la opci&oacute;n -i es para que no se tenga en cuanta las may&uacute;sculas y min&uacute;sculas) que al coincidir con la url introducida se ejecuta la regla de refresco. Las lineas refresh_pattern se eval&uacute;an de forma ordenada hasta que la url se ajusta a una expresi&oacute;n regular.</p>
<p style="text-align: justify;">El par&aacute;metro <em>min</em> estaexpresado en minutos,e indica el limite inferior en que el objeto se va a considerar invalido, es decir mientras el tiempo que el objeto esta almacenado en cach&eacute; es menor que este tiempo se considera v&aacute;lido. De la misma forma el par&aacute;metro <em>max,</em> expresado tambi&eacute;n en minutos, indica el m&aacute;ximo tiempo que un objeto puede ser considerado v&aacute;lido, es decir si un objeto lleva m&aacute;s tiempo almacenado en cach&eacute; que el indicado en el par&aacute;metro <em>max</em> se considera inv&aacute;lido.</p>
<p style="text-align: justify;">Si el tiempo que un objeto lleva guardado en la cach&eacute; est&aacute; entre estos dos valores, &iquest;es v&aacute;lido o est&aacute; caducado? En este caso entra en juego el <em>last-modified factor</em> (LM-factor), que es la relaci&oacute;n que existe entre el tiempo que lleva el objeto guardado en la cach&eacute; y la edad que tiene. &iquest;Y c&oacute;mo podemos calcular la edad? Pues ser&aacute; el tiempo transcurrido desde la &uacute;ltima modificaci&oacute;n del objeto (cabecera last-modified) y el momento en que se ha recibido (cabecera date). Es decir, si el LM factor es menor que el porcentaje indicado en el par&aacute;metro <em>percent</em>, el objeto se considerar&aacute; v&aacute;lido. Pongamos un ejemplo: si un objeto que acabamos de recibir tiene 6 horas de edad, es decir la &uacute;ltima modificaci&oacute;n se realiz&oacute; hace 6 horas, y hemos indicado un porcentaje del 50% el objeto se considerar&aacute; v&aacute;lido en la cach&eacute; las pr&oacute;ximas 3 horas.</p>
<p style="text-align: justify;">Por lo tanto podemos resumir el algoritmo que sigue el refresh_pattern de la siguiente manera:</p>
<ul>
<li style="text-align: justify;">La respuesta esta caducada si el tiempo guardado en cach&eacute; es mayor que el tiempo <em>max</em>.</li>
<li style="text-align: justify;">La respuesta es v&aacute;lida si el<em> LM-factor</em> es menor que el porcentaje que hemos indicado en la directiva refresh_pattern.</li>
<li style="text-align: justify;">La respuesta es v&aacute;lida si el tiempo guardado en cach&eacute; es menor que el tiempo <em>min</em>.</li>
<li style="text-align: justify;">En cualquier otro caso, la respuesta se considera caducada.</li>
</ul>
<p style="text-align: justify;">En la directiva refresh_pattern tambi&eacute;n podemos indicar distintas opciones, como las que estudiamos a continuaci&oacute;n:</p>
<ul style="text-align: justify;">
<li style="text-align: justify;"><strong>override-expire:</strong> fuerza el tiempo m&iacute;nimo que puede estar almacenada y que se considera v&aacute;lida, aunque el servidor env&iacute;e expl&iacute;citamente un tiempo de caducidad con la cabecera Expires o Cache-control:max-age.</li>
<li><strong>ignore-no-cache:</strong> Ignora cualquier cabecera Pragma: no-cache o Cache-control:no-cache enviada por el servidor.</li>
<li><strong>ignore-no-store:</strong> Ignora cualquier cabecera Cache-control:no-store enviada por el servidor.</li>
<li><strong>ignore-private:</strong> Ignora cualquier cabecera Cache-control: private&nbsp; enviada por el servidor.</li>
</ul>
<p style="text-align: justify;">En todo caso, hay que recordar que s&oacute;lo almacenar&aacute; los archivos cuyo tama&ntilde;o sea menor que le indicado en el par&aacute;metro maximum_object_size.</p>
<h2 style="text-align: justify;">Evitando problemas con la cach&eacute; de los navegadores</h2>
<p style="text-align: justify;">Como indicamos al principio del art&iacute;culo, estas pruebas se han realizado con navegadores que ten&iacute;an deshabilitada la funci&oacute;n de cach&eacute; local. Cuando esta funci&oacute;n esta funcionando en los navegadores modernos se incluyen algunas cabeceras en la petici&oacute;n que producen que el par&aacute;metro refresh_pattern no funcione de manera adecuada. Podemos ver el contenido de estas cabeceras en la siguiente imagen:</p>
<p style="text-align: justify;"><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2013/02/cache1.png"><img class="alignnone size-thumbnail wp-image-734" title="cache" src="http://www.josedomingo.org/pledin/wp-content/uploads/2013/02/cache1-150x150.png" alt="" width="150" height="150" /></a></p>
<p style="text-align: justify;">Para evitar este efecto tenemos que usar la opci&oacute;n ignore-cc en el par&aacute;metro http_port de la siguiente manera:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">http_port 3198 ignore-cc</pre>
<p style="text-align: justify;">Seg&uacute;n la documentaci&oacute;n esta opci&oacute;n permite ignorar la cabeceras de Cache-control de la petici&oacute;n.</p>
<p style="text-align: justify;">Este art&iacute;culo es fruto de mi poca experiencia con el proxy que tenemos instalado en el instituto y la preparaci&oacute;n de las clases del m&oacute;dulo de Servicios en red e intenet que imparto en el ciclo formativo ASIR del IES Gonzalo Nazareno.</p>
