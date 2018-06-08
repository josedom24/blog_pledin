---
layout: post
status: publish
published: true
title: Problemas con DNS din&aacute;mico en Debian Squeeze
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 555
wordpress_url: http://www.josedomingo.org/pledin/?p=555
date: '2011-11-21 18:27:17 +0000'
date_gmt: '2011-11-21 17:27:17 +0000'
categories:
- General
tags:
- Redes
- Manuales
- dns
comments: []
---
<p>Llevo unos d&iacute;as preparando&nbsp; la clase de DNS din&aacute;mico con bind9. Para ello he seguido algunos tutoriales muy interasantes que pudes encontrar en internet: <a href="http://marioinfor.wordpress.com/2011/06/01/dns-dinamico-con-bind9/">DNS din&aacute;mico con Bind9</a>, de Mario Carri&oacute;n (antiguo alumno del ciclo), <a href="http://albertomolina.wordpress.com/2008/11/14/dns-dinamico/">DNS din&aacute;mico</a> "Desde lo alto del Cerro" de mi compa&ntilde;ero Alberto Molina o este manual que elaboramos para un curso del CEP: <a href="http://www.josedomingo.org/web/mod/resource/view.php?id=2257">DNS din&aacute;mico</a>.</p>
<p>Sin embargo no hab&iacute;a forma de actualizar el servidor DNS cuando un cliente recib&iacute;a una nueva IP desde el servidor DHCP.</p>
<p>El problema est&aacute; en la versi&oacute;n de BIND 9.7.2. En esta versi&oacute;n en el momento que configuramos la posibilidad de la actualizaci&oacute;n del servidor, por ejemplo en el fichero /etc/bind/named.conf</p>
<pre class="brush: bash; gutter: true; first-line: 1">include "/etc/bind/rndc.key";
controls
{
  inet 127.0.0.1 port 953
  allow { 127.0.0.1; } keys {"rndc-key";};
};
</pre>
<p>Se produc&iacute;a un error que pod&iacute;amos ver en el fichero de logs /var/log/syslog:</p>
<pre class="brush: bash; gutter: false; first-line: 1">named[1577]: managed-keys-zone ./IN: loading from master file managed-keys.bind failed: file not found</pre>
<p>El problema esta causado porque en la configuraci&oacute;n no se ha incluido el fichero /etc/bind/bind.keys que contiene la clave p&uacute;blica para permitir la actualizaci&oacute;n del servidor por <a href="http://es.wikipedia.org/wiki/Usuario:Pabluk/DNSSEC">DNSSEC.</a> Para arreglarlo podemosa&ntilde;adir ese fichero a la configuraci&oacute;n, en /etc/bind/named.conf:</p>
<pre class="brush: applescript; gutter: false; first-line: 1">include "/etc/bind/bind.keys";</pre>
<p>Y para evitar que se se escriban los errores en el registro:</p>
<pre class="brush: applescript; gutter: false; first-line: 1">touch /var/cache/bind/managed-keys.bind
chown bind:bind /var/cache/bind/managed-keys.bind</pre>
<p>Espero que sea de utilidad.</p>
