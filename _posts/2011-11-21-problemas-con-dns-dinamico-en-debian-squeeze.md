---
id: 555
title: Problemas con DNS dinámico en Debian Squeeze
date: 2011-11-21T18:27:17+00:00


guid: http://www.josedomingo.org/pledin/?p=555
permalink: /2011/11/problemas-con-dns-dinamico-en-debian-squeeze/

  
tags:
  - dns
  - Manuales
  - Redes
---
Llevo unos días preparando  la clase de DNS dinámico con bind9. Para ello he seguido algunos tutoriales muy interasantes que pudes encontrar en internet: [DNS dinámico con Bind9](http://marioinfor.wordpress.com/2011/06/01/dns-dinamico-con-bind9/), de Mario Carrión (antiguo alumno del ciclo), [DNS dinámico](http://albertomolina.wordpress.com/2008/11/14/dns-dinamico/) &#8220;Desde lo alto del Cerro&#8221; de mi compañero Alberto Molina o este manual que elaboramos para un curso del CEP: [DNS dinámico](http://www.josedomingo.org/web/mod/resource/view.php?id=2257).

Sin embargo no había forma de actualizar el servidor DNS cuando un cliente recibía una nueva IP desde el servidor DHCP.

El problema está en la versión de BIND 9.7.2. En esta versión en el momento que configuramos la posibilidad de la actualización del servidor, por ejemplo en el fichero `/etc/bind/named.conf`:

    include "/etc/bind/rndc.key";
    controls
    {
      inet 127.0.0.1 port 953
      allow { 127.0.0.1; } keys {"rndc-key";};
    };
    

Se producía un error que podíamos ver en el fichero de logs `/var/log/syslog`:

    named[1577]: managed-keys-zone ./IN: loading from master file managed-keys.bind failed: file not found

El problema esta causado porque en la configuración no se ha incluido el fichero `/etc/bind/bind.keys` que contiene la clave pública para permitir la actualización del servidor por [DNSSEC.](http://es.wikipedia.org/wiki/Usuario:Pabluk/DNSSEC) Para arreglarlo podemos añadir ese fichero a la configuración, en `/etc/bind/named.conf`:

    include "/etc/bind/bind.keys";

Y para evitar que se se escriban los errores en el registro:

    touch /var/cache/bind/managed-keys.bind
    chown bind:bind /var/cache/bind/managed-keys.bind

Espero que sea de utilidad.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->