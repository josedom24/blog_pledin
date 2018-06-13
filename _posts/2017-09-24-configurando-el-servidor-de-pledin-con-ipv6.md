---
id: 1849
title: Configurando el servidor de Pledin con IPv6
date: 2017-09-24T20:09:59+00:00


guid: https://www.josedomingo.org/pledin/?p=1849
permalink: /2017/09/configurando-el-servidor-de-pledin-con-ipv6/


tags:
  - ipv6
  - Pledin
---
<img class="alignleft wp-image-1851" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/09/ipv6-globe-100731106-large.3x2.jpg" alt="" width="209" height="139" />

En estos últimos días he migrado mis páginas personales a un nuevo servidor dedicado de OVH. Anteriormente las tenía alojado en OpenShift con un plan de pago muy asequible, pero con el fin del servicio de la versión 2 de OpenShift y la llegada de la última versión, las condiciones del plan gratuito sólo sirven para pruebas y el plan de pago de la nueva versión no me lo puedo permitir. Una de las cosas que me ha gustado del servidor VPS de OVH es que te asignan una dirección ipv6 global para tu máquina y en este artículo voy a explicar cómo he configurado los diferentes servicios para que mi máquina sea accesible con ipv6.

## Configuración estática con la dirección ipv6 asignada

En el panel de control de OVH podemos obtener la IPv6 que nos han asignado para nuestra máquina:

[<img class="size-full wp-image-1859 alignnone" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/09/ovh1.png" alt="" width="357" height="166" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/09/ovh1.png){.thumbnail}

Aunque la dirección ipv4 la toma por asignación dinámica, la dirección ipv6 la tenemos que configurar de forma estática en nuestro sistema, por lo tanto editamos el fichero `/etc/network/interfaces` de la siguiente manera:

    iface ens3 inet6 static
    address 2001:41d0:0302:2200::1c09/64
    gateway 2001:41d0:0302:2200::1

Reiniciamos el servicio de red y comprobamos las direcciones y las rutas de encaminamiento:

    # systemctl restart networking

    # ip -6 a
    ...
    2: ens3: &lt;BROADCAST,MULTICAST,UP,LOWER_UP&gt; mtu 1500 state UP qlen 1000
     inet6 2001:41d0:302:2200::1c09/64 scope global 
     valid_lft forever preferred_lft forever
     inet6 fe80::f816:3eff:fe77:5587/64 scope link 
     valid_lft forever preferred_lft forever

    # ip -6 r
    2001:41d0:302:2200::/64 dev ens3 proto kernel metric 256 pref medium
    fe80::/64 dev ens3 proto kernel metric 256 pref medium
    default via 2001:41d0:302:2200::1 dev ens3 metric 1024 pref medium

Y probamos que ya tenemos conectividad hacía el exterior:

    # ping6 ipv6.google.com
    PING ipv6.google.com(par21s04-in-x0e.1e100.net (2a00:1450:4007:811::200e)) 56 data bytes
    64 bytes from par21s04-in-x0e.1e100.net (2a00:1450:4007:811::200e): icmp_seq=1 ttl=52 time=5.06 ms
    ...

De la misma manera podemos comprobar desde el exterior que tenemos acceso a nuestra ipv6:

    $ ping6 2001:41d0:0302:2200::1c09
    PING 2001:41d0:0302:2200::1c09(2001:41d0:302:2200::1c09) 56 data bytes
    64 bytes from 2001:41d0:302:2200::1c09: icmp_seq=1 ttl=53 time=69.5 ms

## Dando a conocer nuestra ipv6 al mundo

Es la hora de configurar nuestro servidor DNS para que podamos acceder a nuestra dirección ipv6 con el nombre de nuestra máquina, para ello hemos añadido un registro **AAAA,** que podemos consultar de la siguiente manera:

    $ host playerone.josedomingo.org
    playerone.josedomingo.org has address 137.74.161.90
    playerone.josedomingo.org has IPv6 address 2001:41d0:302:2200::1c09

Por lo tanto cómo el nombre de nuestra página web es un alias (registro **CNAME**) del anterior:

    $ host www.josedomingo.org
    www.josedomingo.org is an alias for playerone.josedomingo.org.
    playerone.josedomingo.org has address 137.74.161.90
    playerone.josedomingo.org has IPv6 address 2001:41d0:302:2200::1c09

Si necesito enviar correos electrónicos desde mi servidor es muy recomendable tener definido los registros inversos de nuestras direcciones ip, eso lo podemos hacer desde el panel de control de OVH:

[<img class="alignnone size-full wp-image-1862" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/09/ovh2.png" alt="" width="199" height="44" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/09/ovh2.png){.thumbnail}

Por lo tanto podemos consultar dicho registro inverso para la dirección ipv6:

    $ host 2001:41d0:302:2200::1c09
    9.0.c.1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.2.2.2.0.3.0.0.d.1.4.1.0.0.2.ip6.arpa domain name pointer playerone.josedomingo.org.

## ¿Podemos acceder a nuestra página web desde un cliente ipv6?

La última versión del servidor web apache2 está configurada por defecto para responder peticiones en el puerto 80 o en el 443 en ipv4 y en ipv6. Lo podemos comprobar de la siguiente manera:

    # netstat -putan
    ...
    tcp6 0 0 :::80 :::* LISTEN 17981/apache2 
    tcp6 0 0 :::443 :::* LISTEN 17981/apache2

Si accedemos desde un equipo con ipv6 a nuestra página podemos comprobar que el acceso se está haciendo por ipv6:

    # tailf /var/log/access.log
    ...
    2001:470:1f12:aac::2 - - [24/Sep/2017:19:58:01 +0200] "GET / HTTP/1.0" 301 549 "-" "Lynx/2.8.9dev.1 libwww-FM/2.14 SSL-MM/1.4.1     GNUTLS/3.3.8"

## Conclusiones

De una manera muy sencilla hemos configurado nuestro servidor VPS de OVH con una dirección global ipv6 que permite acceder a servicios del exterior. También hemos configurado nuestros servicios de forma adecuada para poder acceder a nuestro servicios, actualmente sólo el servidor web) desde el exterior usando ipv6.


<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->