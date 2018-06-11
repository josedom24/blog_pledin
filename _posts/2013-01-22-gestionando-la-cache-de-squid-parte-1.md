---
id: 693
title: Gestionando la caché de Squid (parte 1)
date: 2013-01-22T12:28:32+00:00


guid: http://www.josedomingo.org/pledin/?p=693
permalink: /2013/01/gestionando-la-cache-de-squid-parte-1/


tags:
  - Caché
  - html
  - Proxy
  - Squid
---
<p style="text-align: justify;">
  Squid es un popular programa de software libre que implementa un servidor proxy y una caché de páginas web, publicado bajo licencia GPL. En este artículo nos vamos a centrar en el estudio de la funcionalidad de caché de la aplicación.
</p>

## Cómo funciona la caché de Squid

<p style="text-align: justify;">
  Partimos de la siguiente situación: tenemos instalado squid3 en una máquina virtual con el sistema operativo Debian Wheezy y un navegador en la máquina anfitriona está configurado para usar el proxy (además en este navegador hemos desactivado la función de caché local, que provoca algunos problemas con al caché de squid y que estudiaremos en la siguiente entrega de este documento) y vamos acceder desde este navegador a una página html almacenada en un servidor web apache2 instalado en otra máquina virtual.
</p>

<!--more-->

### Gestión de la cache por mecanismos de validación

<p style="text-align: justify;">
  En este mecanismo el servidor comprueba si la respuesta que mantiene cacheada el navegador sigue siendo válida. Para ello se suele usar la cabecera Last-Modified, aunque también podemos usar la ETag. En este primer punto vamos a acceder a la página html, y sólo va a entrar en juego el parámetro de cabecera Last-Modified. Una vez cacheada la página, si volvemos acceder a ella se preguntará al servidor si se ha modificado, el servidor responderá con la cabecera HTTP, y si la copia que tenemos es valida (no se ha modificado recientemente) se servirá directamente.
</p>

<p style="text-align: justify;">
  En este caso al refrescar la página con F5 nos vamos encontrando en el fichero access.log (este fichero se encuentra en /var/log/squid3/access.log)  de squid con información del tipo <em>TCP_MEM_HIT</em> o <em>TCP_HIT</em>, es decir acierto en la cache. Para más información sobre la información que se guarda en el fichero access.log puedes mirar la siguiente <a href="http://www.linofee.org/~jel/proxy/Squid/accesslog.shtml">página</a>.
</p>

<p style="text-align: justify;">
  Si modificamos la página, el servidor cambiará el parámetro Last-Modified y por tanto la copia que tenemos almacenada ya no será válida, por lo que nos bajaremos del servidor la página modificada y la volveremos almacenar. En este caso nos encontraremos en el fichero access.log una línea del tipo <em>TCP_REFRESH_MODIFIED</em>, indicando que la página accedida ha sido modificada.
</p>

<p style="text-align: justify;">
  Si simulamos que se ha perdido la conexión con el servidor, parando el servicio apache2 en el segundo servidor, aunque se intenta verificar con el servidor si la página ha sido modificada (<em>TCP_REFRESH_FAIL</em>), se seguirá sirviendo la copia que tenemos en la cache.
</p>

### Gestión de la cache por mecanismos de frescura

<p style="text-align: justify;">
  Tanto el método <em>Last-Modified </em>como <em>ETag </em>requieren que el navegador se comunique con el servidor para comprobar la versión del fichero. En los mecanismos por <em>frescura </em>en cambio cada repuesta lleva asociada una fecha de caducidad (como un yogurt) y puede ser utilizada sin necesidad de que el servidor compruebe su validez. Existen dos formas de implementar este mecanismo, con el parámetro Expires (se asigna una fecha de caducidad al fichero) o el max-age(la fecha de caducidad se expresa de manera relativa en segundos). Para nuestro ejemplo vamos a usar la cabecera expires.
</p>

<p style="text-align: justify;">
  Como hemos indicado, el parámetro Expires de la cabecera de un mensaje HTTP indica cuando o cada cuanto tiempo la página guardada en caché no es válida y por lo tanto hay que bajarse otra del servidor. Para cambiar este parámetro de la cabecera vamos a usar el módulo mod_expire de Apache2. Para ello nos aseguramos que está activo:
</p>

<pre class="brush: bash; gutter: true;">a2enmod expires</pre>

Y modificamos el fichero de configuración default de la siguiente manera:

<pre class="brush: bash; gutter: true; ">&lt;Directory /var/www/&gt;
 ExpiresActive On
 ExpiresDefault "access plus 3 seconds"
 ...</pre>

En este caso estamos diciendo que todos los ficheros alojados en /var/www tienen una caducidad de 3 segundos. Cada tres segundos se va a obligar a descargarse la nueva copia del servidor.

Puedes comprobar el valor del parámetro usando el comando HEAD.

<pre class="brush: bash; gutter: false; first-line: 1">$ HEAD http://172.22.200.46/index.html

200 OK
<strong>Cache-Control: max-age=3</strong>
Connection: close
Date: Tue, 22 Jan 2013 10:16:12 GMT
Accept-Ranges: bytes
ETag: "6780-b1-4d3ddd070b75a"
Server: Apache/2.2.16 (Debian)
Vary: Accept-Encoding
Content-Length: 177
Content-Type: text/html
<strong>Expires: Tue, 22 Jan 2013 10:16:15 GMT</strong>
Last-Modified: Tue, 22 Jan 2013 10:12:25 GMT
Client-Date: Tue, 22 Jan 2013 10:13:35 GMT</pre>

Si vamos recargando la página con F5 nos daremos cuenta que cada 3 segundos se produce un _TCP\_REFRESH\_UNMODIFIED_, es decir se obliga a la descarga de la página, durante el tiempo intermedio se supone que la página es válida.

### Como evitar el cacheo de nuestro contenido

En ocasiones el cacheo de contenidos puede interferir con el correcto funcionamiento de la web y por tanto debemos evitarlo. El funcionamiento de la cache se puede controlar con las siguientes directivas:

  * **Cache-control: max-age –** Especifica el número máximos de segundos en los que el contenido sera considerado como fresco
  * **Cache-control:** **s-maxage** &#8211; Similar a la directiva max-age, pero aplicable solo para caches compartidas (por ejemplo squid).
  * **Cache-control: public** – indica que la versión cacheada puede ser guardada por proxies y otros servidores intermedios para que todo el mundo tenga acceso a ella..
  * **Cache-control: private** – indica que el archivo no es el mismo para usuarios diferentes. De esta manera el archivo puede ser cacheado por el navegador del usuario pero no debe ser cacheado por proxies intermedios.
  * **Cache-control: no-cache** – Significa que el archivo no debe ser cacheado, esto puede ser necesario en casos en los que una misma url pueda devolver diferentes contenidos.
  * **Cache-control: no-store –** Indica al navegador que sólo guarde el documento el tiempo necesario para mostrarlo.
  * **Cache-control: must-revalidate**– Indica a la cache que deben hacer caso a cualquier directiva de cacheo que le indiquemos. Tenga en cuenta que la especificación HTTP permite a las caches atender de manera automática a las peticiones bajo determinadas circunstancias. ¨La directiva must-revalidete obliga a la cache a seguir nuestras directivas de manera estricta. La forma de utilizarla es la siguiente:`<meta http-equiv="Cache-Control" content="max-age=3600, must-revalidate`“>

  * **Cache-control: proxy-revalidate –** Similar a _must-revalidate_ pero sólo aplicable a proxy caches.

La directiva _Pragma_ tiene el mismo significado que _**Cache-control: no-cache**_ y se suele incluir para asegurarnos la compatibilidad con versiones anteriores a HTTP/1.0.

<p style="text-align: justify;">
  Para poder modificar este parámetro vamos a usar el mod_headers de apache2, para ello nos aseguramos que este activo:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">a2enmod headers</pre>

<p style="text-align: justify;">
  A continuación podemos modificar el fichero de configuración default y añadir las siguiente líneas para evitar que se pueda cachear nuestro docuemento html:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">&lt;Directory /var/www/&gt;
 Header set Cache-Control "private, no-cache, no-store"
 Header set Pragma "no-cache"
...</pre>

<p style="text-align: justify;">
  Comprobamos las cabeceras con el comando HEAD:
</p>

<p style="text-align: justify;">
  $ HEAD http://172.22.200.46/index.html
</p>

<p style="text-align: justify;">
  200 OK<br /> <strong>Cache-Control: private, no-cache, no-store</strong><br /> Connection: close<br /> Date: Tue, 22 Jan 2013 10:49:07 GMT<br /> <strong>Pragma: no-cache</strong><br /> Accept-Ranges: bytes<br /> ETag: &#8220;6780-b1-4d3ddd070b75a&#8221;<br /> Server: Apache/2.2.16 (Debian)<br /> Vary: Accept-Encoding<br /> Content-Length: 177<br /> Content-Type: text/html<br /> Last-Modified: Tue, 22 Jan 2013 10:12:25 GMT<br /> Client-Date: Tue, 22 Jan 2013 10:46:30 GMT<br /> Client-Peer: 172.22.200.46:80<br /> Client-Response-Num: 1
</p>

<p style="text-align: justify;">
  En este caso cuando vamos refrescando nuestra página en el navegador obtenemos un mensaje <em>TCP_MISS</em> en el fichero access.log indicando que nuestro documento no ha sido almacenado.
</p>

<p style="text-align: justify;">
  En la <a href="http://www.josedomingo.org/pledin/2013/02/gestionando-la-cache-de-squid-parte-2/">próxima entrega</a> de este documento veremos como ignorar estos parámetros de control de la caché y forzar el cacheo de determinados objetos, además estudiaremos la problemática de la caché de los navegadores cuando estamos usando Squid.
</p>

<p style="text-align: justify;">
  He cogido mucha información de la página: <a href="http://www.hellogoogle.com/tutorial-cache-web/">http://www.hellogoogle.com/tutorial-cache-web/</a>
</p>

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->