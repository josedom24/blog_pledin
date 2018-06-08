---
layout: post
status: publish
published: true
title: Configurando el servidor de Pledin con IPv6
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1849
wordpress_url: https://www.josedomingo.org/pledin/?p=1849
date: '2017-09-24 20:09:59 +0000'
date_gmt: '2017-09-24 18:09:59 +0000'
categories:
- General
tags:
- Pledin
- ipv6
comments: []
---
<p><img class="alignleft wp-image-1851" src="https://www.josedomingo.org/pledin/wp-content/uploads/2017/09/ipv6-globe-100731106-large.3x2.jpg" alt="" width="209" height="139" /></p>
<p style="text-align: justify;">En estos &uacute;ltimos d&iacute;as he migrado mis p&aacute;ginas personales a un nuevo servidor dedicado de OVH. Anteriormente las ten&iacute;a alojado en OpenShift con un plan de pago muy asequible, pero con el fin del servicio de la versi&oacute;n 2 de OpenShift y la llegada de la &uacute;ltima versi&oacute;n, las condiciones del plan gratuito s&oacute;lo sirven para pruebas y el plan de pago de la nueva versi&oacute;n no me lo puedo permitir. Una de las cosas que me ha gustado del servidor VPS de OVH es que te asignan una direcci&oacute;n ipv6 global para tu m&aacute;quina y en este art&iacute;culo voy a explicar c&oacute;mo he configurado los diferentes servicios para que mi m&aacute;quina sea accesible con ipv6.</p>
<h2>Configuraci&oacute;n est&aacute;tica con la direcci&oacute;n ipv6 asignada</h2>
<p>En el panel de control de OVH podemos obtener la IPv6 que nos han asignado para nuestra m&aacute;quina:</p>
<p><a class="thumbnail" href="https://www.josedomingo.org/pledin/wp-content/uploads/2017/09/ovh1.png"><img class="size-full wp-image-1859 alignnone" src="https://www.josedomingo.org/pledin/wp-content/uploads/2017/09/ovh1.png" alt="" width="357" height="166" /></a></p>
<p>Aunque la direcci&oacute;n ipv4 la toma por asignaci&oacute;n din&aacute;mica, la direcci&oacute;n ipv6 la tenemos que configurar de forma est&aacute;tica en nuestro sistema, por lo tanto editamos el fichero <code>/etc/network/interfaces</code> de la siguiente manera:</p>
<pre>iface ens3 inet6 static
 address 2001:41d0:0302:2200::1c09/64
 gateway 2001:41d0:0302:2200::1</pre>
<p><!--more-->Reiniciamos el servicio de red y comprobamos las direcciones y las rutas de encaminamiento:</p>
<pre># systemctl restart networking

# ip -6 a
...
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 state UP qlen 1000
 inet6 2001:41d0:302:2200::1c09/64 scope global 
 valid_lft forever preferred_lft forever
 inet6 fe80::f816:3eff:fe77:5587/64 scope link 
 valid_lft forever preferred_lft forever

# ip -6 r
2001:41d0:302:2200::/64 dev ens3 proto kernel metric 256 pref medium
fe80::/64 dev ens3 proto kernel metric 256 pref medium
default via 2001:41d0:302:2200::1 dev ens3 metric 1024 pref medium</pre>
<p>Y probamos que ya tenemos conectividad hac&iacute;a el exterior:</p>
<pre># ping6 ipv6.google.com
PING ipv6.google.com(par21s04-in-x0e.1e100.net (2a00:1450:4007:811::200e)) 56 data bytes
64 bytes from par21s04-in-x0e.1e100.net (2a00:1450:4007:811::200e): icmp_seq=1 ttl=52 time=5.06 ms
...</pre>
<p>De la misma manera podemos comprobar desde el exterior que tenemos acceso a nuestra ipv6:</p>
<pre>$ ping6 2001:41d0:0302:2200::1c09
PING 2001:41d0:0302:2200::1c09(2001:41d0:302:2200::1c09) 56 data bytes
64 bytes from 2001:41d0:302:2200::1c09: icmp_seq=1 ttl=53 time=69.5 ms</pre>
<h2>Dando a conocer nuestra ipv6 al mundo</h2>
<p>Es la hora de configurar nuestro servidor DNS para que podamos acceder a nuestra direcci&oacute;n ipv6 con el nombre de nuestra m&aacute;quina, para ello hemos a&ntilde;adido un registro <strong>AAAA, </strong>que podemos consultar de la siguiente manera:</p>
<pre>$ host playerone.josedomingo.org
playerone.josedomingo.org has address 137.74.161.90
playerone.josedomingo.org has IPv6 address 2001:41d0:302:2200::1c09</pre>
<p>Por lo tanto c&oacute;mo el nombre de nuestra p&aacute;gina web es un alias (registro <strong>CNAME</strong>) del anterior:</p>
<pre>$ host www.josedomingo.org
www.josedomingo.org is an alias for playerone.josedomingo.org.
playerone.josedomingo.org has address 137.74.161.90
playerone.josedomingo.org has IPv6 address 2001:41d0:302:2200::1c09</pre>
<p>Si necesito enviar correos electr&oacute;nicos desde mi servidor es muy recomendable tener definido los registros inversos de nuestras direcciones ip, eso lo podemos hacer desde el panel de control de OVH:</p>
<p><a class="thumbnail" href="https://www.josedomingo.org/pledin/wp-content/uploads/2017/09/ovh2.png"><img class="alignnone size-full wp-image-1862" src="https://www.josedomingo.org/pledin/wp-content/uploads/2017/09/ovh2.png" alt="" width="199" height="44" /></a></p>
<p>Por lo tanto podemos consultar dicho registro inverso para la direcci&oacute;n ipv6:</p>
<pre>$ host 2001:41d0:302:2200::1c09
9.0.c.1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.2.2.2.0.3.0.0.d.1.4.1.0.0.2.ip6.arpa domain name pointer playerone.josedomingo.org.</pre>
<h2>&iquest;Podemos acceder a nuestra p&aacute;gina web desde un cliente ipv6?</h2>
<p>La &uacute;ltima versi&oacute;n del servidor web apache2 est&aacute; configurada por defecto para responder peticiones en el puerto 80 o en el 443 en ipv4 y en ipv6. Lo podemos comprobar de la siguiente manera:</p>
<pre># netstat -putan
...
tcp6 0 0 :::80 :::* LISTEN 17981/apache2 
tcp6 0 0 :::443 :::* LISTEN 17981/apache2</pre>
<p>Si accedemos desde un equipo con ipv6 a nuestra p&aacute;gina podemos comprobar que el acceso se est&aacute; haciendo por ipv6:</p>
<pre># tailf /var/log/access.log
...
2001:470:1f12:aac::2 - - [24/Sep/2017:19:58:01 +0200] "GET / HTTP/1.0" 301 549 "-" "Lynx/2.8.9dev.1 libwww-FM/2.14 SSL-MM/1.4.1 GNUTLS/3.3.8"</pre>
<h2>Conclusiones</h2>
<p>De una manera muy sencilla hemos configurado nuestro servidor VPS de OVH con una direcci&oacute;n global ipv6 que permite acceder a servicios del exterior. Tambi&eacute;n hemos configurado nuestros servicios de forma adecuada para poder acceder a nuestro servicios, actualmente s&oacute;lo el servidor web) desde el exterior usando ipv6.</p>
<p>&nbsp;</p>
