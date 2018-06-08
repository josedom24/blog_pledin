---
layout: post
status: publish
published: true
title: Configuraci&oacute;n de un servidor DNS esclavo (2&ordf; parte)
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 838
wordpress_url: http://www.josedomingo.org/pledin/?p=838
date: '2013-11-18 16:47:36 +0000'
date_gmt: '2013-11-18 15:47:36 +0000'
categories:
- General
tags:
- Redes
- Manuales
- dns
comments: []
---
<p style="text-align: justify;">El objetivo de este art&iacute;culo es hacer algunos comentarios sobre la configuraci&oacute;n de un servidor DNS bind9 como esclavo, que ya vimos hace un tiempo en un post anterior: <a href="http://www.josedomingo.org/pledin/2011/11/configuracion-de-un-servidor-dns-esclavo/">Configuraci&oacute;n de un servidor DNS esclavo</a>.</p>
<h1 style="text-align: justify;">Introducci&oacute;n</h1>
<p style="text-align: justify;">Para cada dominio, necesitamos m&aacute;s de un servidor autorizado para ofrecer la misma informaci&oacute;n (RFC 2182). Por lo tanto, los datos se introducen en un servidor (maestro) y se replican en otros (esclavos). Los clientes que consultan nuestro servidores no pueden ver qui&eacute;n es el maestro y cu&aacute;les son los esclavos, los registros NS se entregan al azar para distribuir la carga.<!--more--></p>
<h1 style="text-align: justify;">&iquest;Cu&aacute;ndo se hacen las copias?</h1>
<p style="text-align: justify;">Los esclavos interrogan al maestro peri&oacute;dicamente, &eacute;sto es el "Intervalo de actualizaci&oacute;n (refresh interval), para obtener actualizaciones. El maestro tambi&eacute;n puede notificar a los esclavos cuando hay cambios, pero como puede haber perdida de paquetes sigue siendo necesario interrogar peri&oacute;dicamente.</p>
<p style="text-align: justify;">El esclavo s&oacute;lo iniciar&aacute; la copia cuando el n&uacute;mero de serie, configurado en el registro SOA de la zona, <strong>AUMENTE. </strong>Es responsabilidad del administrador incrementar este n&uacute;mero de serie cada vez que realice un cambio. De lo contrario habr&aacute; inconsistencia con los datos de los esclavos.</p>
<p style="text-align: justify;">Para llevar el control del incremento del n&uacute;mero de serie se puede usar el formato <strong>YYMMDDNN, </strong>siendo YY el a&ntilde;o, MM el mes, DD el d&iacute;a y NN n&uacute;mero de cambios den el d&iacute;a, por ejemplo: 13111401. Hay que tener en cuenta lo siguiente:</p>
<ul>
<li style="text-align: justify;">Si se decrementa el n&uacute;mero de serie, los esclavos nunca se actualizar&aacute;n hasta que el n&uacute;mero sea mayor que el valor anterior.</li>
<li style="text-align: justify;">El n&uacute;mero de serie es un entero de 32 bits, si se incrementa el l&iacute;mite superior ser&aacute; truncado sin avisar por lo que el n&uacute;mero de serie se habr&aacute; decrementado.</li>
</ul>
<h1>Configuraci&oacute;n del maestro</h1>
<p style="text-align: justify;">En al definici&oacute;n de la zona en el maestro se utiliza la directiva allow_transfer{...} donde indicamos los servidores que pueden transferir la zona desde el servidor maestro. Para nuestro ejemplo suponemos que el maestro tiene la direcci&oacute;n 10.0.0.1 y el esclavo la 10.0.0.2:</p>
<pre class="brush: bash; gutter: false; first-line: 1">zone "example.com" {
type master;
file "db.example.com";
allow-transfer {10.0.0.2;};
};</pre>
<h1 style="text-align: justify;">Configuraci&oacute;n del esclavo</h1>
<p style="text-align: justify;">Del esclavo no permitimos que se haga ninguna transferencia e indicamos qui&eacute;n es el servidor maestro de la zona.</p>
<pre class="brush: bash; gutter: false; first-line: 1">zone "example.com" {
type slave;
masters { 10.0.0.1; };
file "db.example.com";
allow-transfer { none; };
};</pre>
<h1 style="text-align: justify;">Formato del registro SOA</h1>
<pre class="brush: bash; gutter: false; first-line: 1">$TTL 1d
@&nbsp;&nbsp;&nbsp; IN SOA ns1.example.net. mail.example.net. (
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;13111801 ; Serial
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;8h &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; ; Refresh
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;1h&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;   ; Retry
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;4w&nbsp;&nbsp; &nbsp;  &nbsp;&nbsp; ; Expire
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;1h )&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ; Negative

&nbsp;&nbsp;&nbsp;&nbsp; IN &nbsp;&nbsp; &nbsp;NS &nbsp;&nbsp; &nbsp;ns1.example.net.
&nbsp;&nbsp;&nbsp;&nbsp; IN &nbsp;&nbsp; &nbsp;NS &nbsp;&nbsp; &nbsp;ns2.example.net.
...</pre>
<p style="text-align: justify;">Configuramos la siguiente informaci&oacute;n:</p>
<ul>
<li>Nombre del servidor maestro.</li>
<li style="text-align: justify;">El correo electr&oacute;nico de la persona responsable, terminado en punto. Tambi&eacute;n se puede poner la @.</li>
<li style="text-align: justify;">El n&uacute;mero de serie.</li>
<li style="text-align: justify;">El intervalo de actualizaci&oacute;n (<strong>refresh</strong>): frecuencia con la que el esclavo debe revisar el n&uacute;mero de serie del maestro para hacer una transferencia de zona.</li>
<li style="text-align: justify;">Intervalo de reintento (<strong>retry</strong>): frecuencia con la que reintenta si el servidor maestro no responde.</li>
<li style="text-align: justify;">Tiempo de caducidad (<strong>expiry</strong>): Si el esclavo no puede comunicarse con el maestro durante este intervalo, debe borrar su copia de la zona.</li>
<li style="text-align: justify;">TTL negativo (<strong>negative</strong>): Significa tiempo de vida negativo, el tiempo durante el cual se debe almacenar en la cache&nbsp; de cualquier otro servidor DNS una respuesta negativa. Eso significa que si otro servidor DNS preguntas por "no-existe.example.net" y esa entrada no existe, ese servidor DNS considerara como valida esa respuesta (no existe) durante el tiempo indicado.</li>
</ul>
<p style="text-align: justify;">Podemos encontrar valores recomendados de estas variables en <a href="http://www.ripe.net/ripe/docs/ripe-203">http://www.ripe.net/ripe/docs/ripe-203</a>.</p>
<h1 style="text-align: justify;">Evitar y comprobar errores</h1>
<ol>
<li style="text-align: justify;">Cada vez que realice una modificaci&oacute;n recuerda <strong>incrementar</strong> el n&uacute;mero de serie.</li>
<li style="text-align: justify;">Para detectar errores de sintaxis puedes usar el siguiente comando:
<pre class="brush: bash; gutter: false; first-line: 1">named-checkzone example.net /var/cache/bind/db.example.net</pre>
</li>
<li style="text-align: justify;">Para detectar errores de configuraci&oacute;n en named.conf, podemos usar:
<pre class="brush: bash; gutter: false; first-line: 1">named-checkconf</pre>
</li>
<li style="text-align: justify;">Reinicia el servicio y comprueba los logs del sistema. Para reiniciar el servicio puedes usar la utilidad <strong>rndc</strong>, la cual nos permite la administraci&oacute;n del demonio <em>named</em> desde la l&iacute;nea de comandos del mismo host o de un equipo remoto. Por ejemplo:
<pre class="brush: bash; gutter: false; first-line: 1">rndc reload
rndc reload example.net
tail /var/log/syslog</pre>
</li>
<li style="text-align: justify;">Realiza una consulta al servidor maestro y los esclavos para comprobar que las respuestas son autorizadas (bit AA), adem&aacute;s aseg&uacute;rate que coinciden los n&uacute;mero de serie, para ello puedes hacer la siguiente consulta:
<pre class="brush: bash; gutter: false; first-line: 1">dig +norec @x.x.x.x example.net. soa</pre>
</li>
<li style="text-align: justify;">Solicita una copia completa de la zona y comprueba que s&oacute;lo se puede hacer desde las direcciones ip que est&aacute;n en la secci&oacute;n <em>allow-transfer</em>, es decir, desde los esclavos, para ello:
<pre class="brush: bash; gutter: false; first-line: 1">dig @x.x.x.x example.net. axfr</pre>
<p>Tienes que tener en cuenta que si tienes un error en named.conf o en un fichero de zona, named quiz&aacute; continuar&aacute; su ejecuci&oacute;n pero no ser&aacute; autorizado para la zona, por lo que tendremos un servidor no autorizado, por lo que los esclavos no ser&aacute;n capaces de comunicarse con el maestro, con lo que en alg&uacute;n momento la zonas caducar&aacute;n en los esclavos y el dominio dejar&aacute; de ser visible.</li>
</ol>
