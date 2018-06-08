---
layout: post
status: publish
published: true
title: Gestionando la cach&eacute; de Squid (parte 1)
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 693
wordpress_url: http://www.josedomingo.org/pledin/?p=693
date: '2013-01-22 12:28:32 +0000'
date_gmt: '2013-01-22 11:28:32 +0000'
categories:
- General
tags:
- html
- Squid
- Cach&eacute;
- Proxy
comments: []
---
<p style="text-align: justify;">Squid es un popular programa de software libre que implementa un servidor proxy y una cach&eacute; de p&aacute;ginas web, publicado bajo licencia GPL. En este art&iacute;culo nos vamos a centrar en el estudio de la funcionalidad de cach&eacute; de la aplicaci&oacute;n.</p>
<h2>C&oacute;mo funciona la cach&eacute; de Squid</h2>
<p style="text-align: justify;">Partimos de la siguiente situaci&oacute;n: tenemos instalado squid3 en una m&aacute;quina virtual con el sistema operativo Debian Wheezy y un navegador en la m&aacute;quina anfitriona est&aacute; configurado para usar el proxy (adem&aacute;s en este navegador hemos desactivado la funci&oacute;n de cach&eacute; local, que provoca algunos problemas con al cach&eacute; de squid y que estudiaremos en la siguiente entrega de este documento) y vamos acceder desde este navegador a una p&aacute;gina html almacenada en un servidor web apache2 instalado en otra m&aacute;quina virtual.</p>
<p><!--more--></p>
<h3>Gesti&oacute;n de la cache por mecanismos de validaci&oacute;n</h3>
<p style="text-align: justify;">En este mecanismo el servidor comprueba si la respuesta que mantiene cacheada el navegador sigue siendo v&aacute;lida. Para ello se suele usar la cabecera Last-Modified, aunque tambi&eacute;n podemos usar la ETag. En este primer punto vamos a acceder a la p&aacute;gina html, y s&oacute;lo va a entrar en juego el par&aacute;metro de cabecera Last-Modified. Una vez cacheada la p&aacute;gina, si volvemos acceder a ella se preguntar&aacute; al servidor si se ha modificado, el servidor responder&aacute; con la cabecera HTTP, y si la copia que tenemos es valida (no se ha modificado recientemente) se servir&aacute; directamente.</p>
<p style="text-align: justify;">En este caso al refrescar la p&aacute;gina con F5 nos vamos encontrando en el fichero access.log (este fichero se encuentra en /var/log/squid3/access.log)&nbsp; de squid con informaci&oacute;n del tipo <em>TCP_MEM_HIT</em> o <em>TCP_HIT</em>, es decir acierto en la cache. Para m&aacute;s informaci&oacute;n sobre la informaci&oacute;n que se guarda en el fichero access.log puedes mirar la siguiente <a href="http://www.linofee.org/~jel/proxy/Squid/accesslog.shtml">p&aacute;gina</a>.</p>
<p style="text-align: justify;">Si modificamos la p&aacute;gina, el servidor cambiar&aacute; el par&aacute;metro Last-Modified y por tanto la copia que tenemos almacenada ya no ser&aacute; v&aacute;lida, por lo que nos bajaremos del servidor la p&aacute;gina modificada y la volveremos almacenar. En este caso nos encontraremos en el fichero access.log una l&iacute;nea del tipo <em>TCP_REFRESH_MODIFIED</em>, indicando que la p&aacute;gina accedida ha sido modificada.</p>
<p style="text-align: justify;">Si simulamos que se ha perdido la conexi&oacute;n con el servidor, parando el servicio apache2 en el segundo servidor, aunque se intenta verificar con el servidor si la p&aacute;gina ha sido modificada (<em>TCP_REFRESH_FAIL</em>), se seguir&aacute; sirviendo la copia que tenemos en la cache.</p>
<h3>Gesti&oacute;n de la cache por mecanismos de frescura</h3>
<p style="text-align: justify;">Tanto el m&eacute;todo <em>Last-Modified </em>como <em>ETag </em>requieren que el navegador se comunique con el servidor para comprobar la versi&oacute;n del fichero. En los mecanismos por <em>frescura </em>en cambio cada repuesta lleva asociada una fecha de caducidad (como un yogurt) y puede ser utilizada sin necesidad de que el servidor compruebe su validez. Existen dos formas de implementar este mecanismo, con el par&aacute;metro Expires (se asigna una fecha de caducidad al fichero) o el max-age(la fecha de caducidad se expresa de manera relativa en segundos). Para nuestro ejemplo vamos a usar la cabecera expires.</p>
<p style="text-align: justify;">Como hemos indicado, el par&aacute;metro Expires de la cabecera de un mensaje HTTP indica cuando o cada cuanto tiempo la p&aacute;gina guardada en cach&eacute; no es v&aacute;lida y por lo tanto hay que bajarse otra del servidor. Para cambiar este par&aacute;metro de la cabecera vamos a usar el m&oacute;dulo mod_expire de Apache2. Para ello nos aseguramos que est&aacute; activo:</p>
<pre class="brush: bash; gutter: true;">a2enmod expires</pre>
<p>Y modificamos el fichero de configuraci&oacute;n default de la siguiente manera:</p>
<pre class="brush: bash; gutter: true; "><Directory /var/www/>
 ExpiresActive On
 ExpiresDefault "access plus 3 seconds"
 ...</pre>
<p>En este caso estamos diciendo que todos los ficheros alojados en /var/www tienen una caducidad de 3 segundos. Cada tres segundos se va a obligar a descargarse la nueva copia del servidor.</p>
<p>Puedes comprobar el valor del par&aacute;metro usando el comando HEAD.</p>
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
<p>Si vamos recargando la p&aacute;gina con F5 nos daremos cuenta que cada 3 segundos se produce un <em>TCP_REFRESH_UNMODIFIED</em>, es decir se obliga a la descarga de la p&aacute;gina, durante el tiempo intermedio se supone que la p&aacute;gina es v&aacute;lida.</p>
<h3>Como evitar el cacheo de nuestro contenido</h3>
<p>En ocasiones el cacheo de contenidos puede interferir con el correcto funcionamiento de la web y por tanto debemos evitarlo. El funcionamiento de la cache se puede controlar con las siguientes directivas:</p>
<ul>
<li><strong>Cache-control: max-age &ndash; </strong>Especifica el n&uacute;mero m&aacute;ximos de segundos en los que el contenido sera considerado como fresco</li>
<li><strong>Cache-control: </strong><strong>s-maxage </strong>- Similar a la directiva max-age, pero aplicable solo para caches compartidas (por ejemplo squid).</li>
<li><strong>Cache-control: public</strong> &ndash; indica que la versi&oacute;n cacheada puede ser guardada por proxies y otros servidores intermedios para que todo el mundo tenga acceso a ella..</li>
<li><strong>Cache-control: private</strong> &ndash; indica que el archivo no es el mismo para usuarios diferentes. De esta manera el archivo puede ser cacheado por el navegador del usuario pero no debe ser cacheado por proxies intermedios.</li>
<li><strong>Cache-control: no-cache</strong> &ndash; Significa que el archivo no debe ser cacheado, esto puede ser necesario en casos en los que una misma url pueda devolver diferentes contenidos.</li>
<li><strong>Cache-control: no-store &ndash; </strong> Indica al navegador que s&oacute;lo guarde el documento el tiempo necesario para mostrarlo.</li>
<li><strong>Cache-control: must-revalidate</strong>&ndash; Indica a la cache que deben hacer caso a cualquier directiva de cacheo que le indiquemos. Tenga en cuenta que la especificaci&oacute;n HTTP permite a las caches atender de manera autom&aacute;tica a las peticiones bajo determinadas circunstancias. &uml;La directiva must-revalidete obliga a la cache a seguir nuestras directivas de manera estricta. La forma de utilizarla es la siguiente:<code><meta http-equiv="Cache-Control" content="max-age=3600, must-revalidate</code>&ldquo;></li>
</ul>
<ul>
<li><strong>Cache-control: proxy-revalidate &ndash; </strong>Similar a <em>must-revalidate</em> pero s&oacute;lo aplicable a proxy caches.</li>
</ul>
<p>La directiva <em>Pragma </em>tiene el mismo significado que <em><strong>Cache-control: no-cache</strong></em> y se suele incluir para asegurarnos la compatibilidad con versiones anteriores a HTTP/1.0.</p>
<p style="text-align: justify;">Para poder modificar este par&aacute;metro vamos a usar el mod_headers de apache2, para ello nos aseguramos que este activo:</p>
<pre class="brush: bash; gutter: false; first-line: 1">a2enmod headers</pre>
<p style="text-align: justify;">A continuaci&oacute;n podemos modificar el fichero de configuraci&oacute;n default y a&ntilde;adir las siguiente l&iacute;neas para evitar que se pueda cachear nuestro docuemento html:</p>
<pre class="brush: bash; gutter: false; first-line: 1"><Directory /var/www/>
 Header set Cache-Control "private, no-cache, no-store"
 Header set Pragma "no-cache"
...</pre>
<p style="text-align: justify;">Comprobamos las cabeceras con el comando HEAD:</p>
<p style="text-align: justify;">$ HEAD http://172.22.200.46/index.html</p>
<p style="text-align: justify;">200 OK<br />
<strong>Cache-Control: private, no-cache, no-store</strong><br />
Connection: close<br />
Date: Tue, 22 Jan 2013 10:49:07 GMT<br />
<strong>Pragma: no-cache</strong><br />
Accept-Ranges: bytes<br />
ETag: "6780-b1-4d3ddd070b75a"<br />
Server: Apache/2.2.16 (Debian)<br />
Vary: Accept-Encoding<br />
Content-Length: 177<br />
Content-Type: text/html<br />
Last-Modified: Tue, 22 Jan 2013 10:12:25 GMT<br />
Client-Date: Tue, 22 Jan 2013 10:46:30 GMT<br />
Client-Peer: 172.22.200.46:80<br />
Client-Response-Num: 1</p>
<p style="text-align: justify;">En este caso cuando vamos refrescando nuestra p&aacute;gina en el navegador obtenemos un mensaje <em>TCP_MISS</em> en el fichero access.log indicando que nuestro documento no ha sido almacenado.</p>
<p style="text-align: justify;">En la <a href="http://www.josedomingo.org/pledin/2013/02/gestionando-la-cache-de-squid-parte-2/">pr&oacute;xima entrega</a> de este documento veremos como ignorar estos par&aacute;metros de control de la cach&eacute; y forzar el cacheo de determinados objetos, adem&aacute;s estudiaremos la problem&aacute;tica de la cach&eacute; de los navegadores cuando estamos usando Squid.</p>
<p style="text-align: justify;">He cogido mucha informaci&oacute;n de la p&aacute;gina: <a href="http://www.hellogoogle.com/tutorial-cache-web/">http://www.hellogoogle.com/tutorial-cache-web/</a></p>
