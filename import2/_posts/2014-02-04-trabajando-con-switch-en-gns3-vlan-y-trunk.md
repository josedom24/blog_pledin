---
layout: post
status: publish
published: true
title: 'Trabajando con switch en GNS3: VLAN y Trunk'
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 904
wordpress_url: http://www.josedomingo.org/pledin/?p=904
date: '2014-02-04 23:23:36 +0000'
date_gmt: '2014-02-04 22:23:36 +0000'
categories:
- General
tags:
- Redes
- Virtualizaci&oacute;n
- gns3
- vlan
- trunk
- switch
comments: []
---
<p>Como vimos en un <a href="http://www.josedomingo.org/pledin/2013/11/gns3-anadiendo-hosts-a-nuestras-topologias/">art&iacute;culo anterior</a>, GNS3 es un simulador gr&aacute;fico que nos permite simular infraestructuras de red. Uno de los elemento con los que podemos trabajar son con switch que son, dispositivos que trabajan en el nivel de enlace y que nos permiten interconectar equipos para formar una red local. Aunque los switch que nos ofrece por defecto el simulador son muy limitados y no podemos configurarlo desde un terminal, como por ejemplo podr&iacute;amos hacer con un switch cisco utilizando su sistema operativo, s&iacute; tienen una peque&ntilde;a interfaz de configuraci&oacute;n que nos permiten trabajar con dos caracter&iacute;sticas muy importantes en los switch gestionables: las vlan y los trunk, o enlaces encapsulados dot1q.</p>
<p>Seg&uacute;n la wikipedia una vlan (acr&oacute;nimo de virtual LAN, &laquo;red de &aacute;rea local virtual&raquo;) es un m&eacute;todo para crear redes l&oacute;gicas independientes dentro de una misma red f&iacute;sica. Con un&nbsp; switch gestionable podemos asignar cada puerto del mismo a una vlan diferente, por lo que los equipos conectados a puertos de distintas vlan estar&aacute;n l&oacute;gicamente en redes distintas.</p>
<p>El protocolo IEEE 802.1Q, tambi&eacute;n conocido como dot1Q, desarrolla un mecanismo que permite a m&uacute;ltiples redes compartir de forma transparente el mismo medio f&iacute;sico, sin problemas de interferencia entre ellas (Trunking). Se conoce con el mismo nombre el protocolo en encapsulamiento usado para implementar este mecanismo en redes Ethernet.<br />
<!--more--></p>
<h3>Escenario que queremos simular</h3>
<p>Vamos a simular la implantaci&oacute;n de dos redes locales virtuales (VLAN) que se reparten por los puertos de dos switch. Para que varios puertos de dos switch distintos pertenezcan a la misma vlan, es necesario que los dispositivos est&eacute;n conectado por un trunk.</p>
<p>Un caso real que corresponde a este modelo podr&iacute;a ser la conexi&oacute;n de varias aulas de un centro educativo, donde queremos crear dos redes virtuales separadas: la primera a la que est&aacute;n conectadas los oredenadores de los profesores, y la segunda a la que est&aacute;n conectados los ordenadores de los alumnos.</p>
<p>En nuestro ejemplo vamos a tener los siguientes datos:</p>
<ul>
<li>VLAN 10, que va a corresponder a una red virtual de profesores y que va a tener un direccionamiento en la red 192.168.10.0/24, la puerta de enlace va a ser la 192.168.10.254.</li>
<li>VLAN 20, que va a corresponder a una red virtual de alumnos y que va a tener un direccionamiento en la red 192.168.20.0/24, la puerta de enlace va a ser la 192.168.20.254.</li>
</ul>
<p>Si lo representamos en GNS3 quedar&iacute;a de esta forma:</p>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/g1.png"><img class="aligncenter size-full wp-image-906" alt="g1" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/g1.png" width="636" height="384" /></a>Como vimos en el <a href="http://www.josedomingo.org/pledin/2013/11/gns3-anadiendo-hosts-a-nuestras-topologias/">art&iacute;culo anterior</a> hemos a&ntilde;adido los hosts utilizando la herramienta VPCS (Virtual PC Simulator), la configuraci&oacute;n ip de las cuatro m&aacute;quinas quedar&iacute;a as&iacute;:</p>
<pre class="brush: bash; gutter: false; first-line: 1">VPCS1&nbsp; 192.168.10.1/24&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 192.168.10.254&nbsp;&nbsp;&nbsp; 00:50:79:66:68:00&nbsp; 20000&nbsp; 127.0.0.1:30000
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fe80::250:79ff:fe66:6800/64
VPCS2&nbsp; 192.168.10.2/24&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 192.168.10.254&nbsp;&nbsp;&nbsp; 00:50:79:66:68:01&nbsp; 20001&nbsp; 127.0.0.1:30001
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fe80::250:79ff:fe66:6801/64
VPCS3&nbsp; 192.168.20.1/24&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 192.168.20.254&nbsp;&nbsp;&nbsp; 00:50:79:66:68:02&nbsp; 20002&nbsp; 127.0.0.1:30002
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fe80::250:79ff:fe66:6802/64
VPCS4&nbsp; 192.168.20.2/24&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 192.168.20.254&nbsp;&nbsp;&nbsp; 00:50:79:66:68:03&nbsp; 20003&nbsp; 127.0.0.1:30003
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fe80::250:79ff:fe66:6803/64</pre>
<p>Veamos la configuraci&oacute;n de los puertos de los dos switch, donde vemos que hemos definido 3 puertos: el puerto 1 de tipo "access" corresponder a la vlan 10, el puerto 2 de tipo "access" que corresponde a la vlan 20 y el puerto 3 es de tipo dot1q, por el que vamos a conectar los dos switch para realizar el trunk.</p>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/g2.png"><img class="aligncenter size-full wp-image-908" alt="g2" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/g2.png" width="454" height="281" /></a></p>
<p><strong>Nota muy importante:</strong> Debemos configurar el programa gns3 en ingl&eacute;s para que en el momento de elegir el tipo del puerto se asigne la palabra "access", si tenemos traducido el programa al espa&ntilde;ol y en ese campo ponemos la palabra "acceso" el programa nos dar&aacute; un error a la hora de conectar los hosts a ese puerto.</p>
<p>Como podemos comprobar a continuaci&oacute;n los equipos de las dos vlan tienen conexi&oacute;n entre ellos:</p>
<pre class="brush: bash; gutter: false; first-line: 1">VPCS[1]> ping 192.168.10.2&nbsp; &nbsp;
192.168.10.2 icmp_seq=1 ttl=64 time=0.324 ms

VPCS[3]> ping 192.168.20.2
192.168.20.2 icmp_seq=1 ttl=64 time=0.445 ms</pre>
<h3>A&ntilde;adiendo una puerta de enlace a nuestro escenario</h3>
<p>Hasta ahora hemos construido dos redes locales virtuales, con conectividad entre los equipos de cada una de ellas. A continuaci&oacute;n vamos a a&ntilde;adir un router que nos permita que las dos vlan tengan acceso al exterior. Para conseguir esto tendremos que conectar un router a un switch utilizando un enlace troncal o trunk con encapsulamiento dot1q. En la interfaz del router que utilicemos tendremos que crear dos subinterfaces con las direcciones ip que corresponden a las puertas de enlace de cada una de las vlan.</p>
<p>El esquema simulado quedar&iacute;a de la siguiente manera:</p>
<p>Como podemos comprobar en el primer switch hemos creado un cuarto puerto tambi&eacute;n de tipo dot1q:</p>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/g3.png"><img class="aligncenter size-full wp-image-909" alt="g3" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/g3.png" width="654" height="413" /></a></p>
<p>Ahora solo nos quedar&iacute;a la configuraci&oacute;n de la interfaz del router:<br />
<a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/g4.png"><img class="aligncenter size-full wp-image-910" alt="g4" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/g4.png" width="460" height="294" /></a></p>
<pre class="brush: bash; gutter: false; first-line: 1">R1(config)#interface FastEthernet 0/0 
R1(config-if)#no shut 
R1(config-if)#interface fastEthernet 0/0.10&nbsp;&nbsp;&nbsp; &nbsp;
R1(config-subif)#encapsulation dot1Q&nbsp; 10 
R1(config-subif)#ip address 192.168.10.254 255.255.255.0 
R1(config-subif)# ^Z 
&nbsp;
R1(config-if)#interface FastEthernet 0/0.20&nbsp;&nbsp;&nbsp; &nbsp;
R1(config-subif)#encapsulation dot1Q&nbsp; 20 
R1(config-subif)#ip address 192.168.20.254 255.255.255.0 
R1(config-subif)# ^Z</pre>
<p>Una vez terminamos comprobamos si tenemos conectividad a la puerta de enlace desde cada una de las vlan:</p>
<pre class="brush: bash; gutter: false; first-line: 1">VPCS[1]> ping 192.168.10.254
192.168.10.254 icmp_seq=1 ttl=255 time=50.031 ms

VPCS[3]> ping 192.168.20.254
192.168.20.254 icmp_seq=1 ttl=255 time=9.340 ms</pre>
<p>Aunque ser&iacute;a deseable poder simular switch cisco que tuvieran m&aacute;s funcionalidades, en este art&iacute;culo hemos estudiado como realizar configuraciones complejas utilizando los switch ofrecidos por GNS3.</p>
