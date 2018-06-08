---
layout: post
status: publish
published: true
title: GNS3, a&ntilde;adiendo hosts a nuestras topolog&iacute;as
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 801
wordpress_url: http://www.josedomingo.org/pledin/?p=801
date: '2013-11-12 22:46:11 +0000'
date_gmt: '2013-11-12 21:46:11 +0000'
categories:
- General
tags:
- Redes
- Virtualizaci&oacute;n
- gns3
comments:
- id: 982
  author: Jes&uacute;s Moreno
  author_email: j.morenol@gmail.com
  author_url: http://programamos.es
  date: '2013-11-13 08:02:25 +0000'
  date_gmt: '2013-11-13 07:02:25 +0000'
  content: "Muy interesante, Jos&eacute; Domingo. Creo que ser&aacute; muy &uacute;til
    para tus estudiantes. Buen trabajo y gracias por compartirlo.\r\nSaludos,\r\nJes&uacute;s."
---
<p style="text-align: justify;"><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2013/11/logo_gns3_small.png"><img class="alignleft size-full wp-image-803" alt="logo_gns3_small" src="http://www.josedomingo.org/pledin/wp-content/uploads/2013/11/logo_gns3_small.png" width="250" height="177" /></a></p>
<p style="text-align: justify;"><strong>GNS3</strong> es un simulador gr&aacute;fico de redes que permite crear entornos de redes virtuales, topolog&iacute;as de red complejas y adem&aacute;s tener la posibilidad de integrarlos con simuladores de IOS. Es uno de los simuladores que utilizamos en el m&oacute;dulo <a href="http://informatica.gonzalonazareno.org/plataforma/course/view.php?id=35">Planificaci&oacute;n y Administraci&oacute;n de Redes</a> que impartimos en el ciclo formativo de Administraci&oacute;n de Sistemas Inform&aacute;ticos en Red en el <a href="http://informatica.gonzalonazareno.org">IES Gonzalo Nazareno</a>.</p>
<p style="text-align: justify;">Uno de los problemas que nos encontr&aacute;bamos otros a&ntilde;os aparec&iacute;a a la hora de a&ntilde;adir un host a nuestra topolog&iacute;a para poder realizar la pruebas de conectividad y encaminamiento que hab&iacute;amos planteado a los alumnos. En realidad es necesario tener una m&aacute;quina virtual completa en un sistema de virtualizaci&oacute;n independiente a GNS3 como puede ser&nbsp; QEMU o VirtualBox, pero para nuestras pr&aacute;cticas no necesitamos una m&aacute;quina completa, simplemente una "peque&ntilde;a" m&aacute;quina virtual que nos permita hacer ping/traceroute y chequear el estado de la red. Aqu&iacute; es donde entra en juego el software <strong>Virtual PC Simulator</strong>, que integrado con GNS3 nos ofrece esta funcionalidad.</p>
<p style="text-align: justify;">En el presente art&iacute;culo, vamos a mostrar las distintas alternativas que tenemos para instalar GNS3 en una distribuci&oacute;n GNU Linux Debian Wheezy, y a continuaci&oacute;n vamos a ver el uso de Virtual PC Simulator para poder a&ntilde;adir hosts a las topolog&iacute;as que implementemos en GNS3.</p>
<p style="text-align: justify;"><!--more--></p>
<h1 style="text-align: justify;">Instalaci&oacute;n de GNS3</h1>
<p style="text-align: justify;">Tenemos dos alternativas para instalar el programa. La m&aacute;s sencilla y que adem&aacute;s instala todas las dependencias, es instalar el paquete que encontramos en los repositorios oficiales:</p>
<pre class="brush: bash; gutter: false; first-line: 1">apt-get install gns3</pre>
<p style="text-align: justify;">En este caso instalamos la versi&oacute;n 0.8.3, si por cualquier raz&oacute;n necesitamos instalar la &uacute;ltima versi&oacute;n, que en el momento de escribir este art&iacute;culo es la 0.8.4 podemos bajarnos los paquete de la <a href="http://gns3.serverb.co.uk/">p&aacute;gina oficial </a>de GNS3 e instalarlo manualmente:</p>
<pre class="brush: bash; gutter: false; first-line: 1">dpkg -i dpkg -i dynamips_0.2.8-1~1_amd64.deb
dpkg -i gns3_0.8.4-1~1_all.deb</pre>
<p style="text-align: justify;">Como se puede observar utilizo la versi&oacute;n de 64 bits de dynamips. Durante este proceso puede ser necesario la instalaci&oacute;n de algunos paquetes que son necesarios para la instalaci&oacute;n de los dos paquetes que nos hemos bajado.</p>
<h1>Configuraci&oacute;n de GNS3</h1>
<p style="text-align: justify;">La primera vez que ejecutamos el programa, nos aparece un asistente para realizar la configuraci&oacute;n b&aacute;sica de programa: establecer el idioma, los directorios de trabajo, comprobar que la instalaci&oacute;n es correcta, y subir las im&aacute;genes de IOS que tengamos a nuestra disposici&oacute;n de los distintos modelos de router. En este &uacute;ltimo punto es muy importante establecer la variable IDLE PC que nos permite la optimizaci&oacute;n del consumo de recursos de sistema, para tener m&aacute;s informaci&oacute;n sobre este tema os sugiero la lectura del siguiente <a href="http://roastedrouter.wordpress.com/2010/02/01/optimizacion-y-configuracion-de-gns3-como-mejorar-el-consumo-de-recursos-del-sistema/">art&iacute;culo</a>. Una vez realizado esta configuraci&oacute;n tenemos nuestro sistema totalmente funcional:</p>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2013/11/screenshot-console-600x422.png"><img class="size-medium wp-image-807 aligncenter" alt="screenshot-console-600x422" src="http://www.josedomingo.org/pledin/wp-content/uploads/2013/11/screenshot-console-600x422-300x211.png" width="300" height="211" /></a></p>
<h1>Virtual PC Simulator</h1>
<p style="text-align: justify;">Este programa pone a nuestra disposici&oacute;n 9 m&aacute;quinas virtuales que consumen muy pocos recursos y que tienen una funcionalidad limitada.&nbsp; Sin embargo son muy adecuadas para cubrir nuestras necesidades, ya que podremos configurar su direccionamiento ip y tenedremos a nuestra disposici&oacute;n comandos como ping o trace.</p>
<p style="text-align: justify;">Nos bajamos la &uacute;ltima versi&oacute;n desde su <a href="http://sourceforge.net/projects/vpcs/files/0.5/beta/">p&aacute;gina de descarga</a>, en la actualidad la 0.5, en su versi&oacute;n de 64 bits. A continuaci&oacute;n de damos permisos de ejecuci&oacute;n y lo ejecutamos:</p>
<pre class="brush: bash; gutter: false; first-line: 1">chmod 755 vpcs_0.5b0_Linux64
./vpcs_0.5b0_Linux64</pre>
<p style="text-align: justify;">En este punto ya podemos manejar nuestras m&aacute;quinas virtuales, si escribimos ? en el prompt obtenemos la lista de comandos que podemos ejecutar:</p>
<pre class="brush: bash; gutter: false; first-line: 1">VPCS[1]> ?

?                        Print help
! [command [args]]       Invoke an OS command with the 'args' as its arguments
<digit>                  Switch to the VPC<digit>. <digit> range 1 to 9
arp                      Shortcut for: show arp. Show arp table
clear [arguments]        Clear IPv4/IPv6, arp/neighbor cache, command history
dhcp [-options]          Shortcut for: ip dhcp. Get IPv4 address via DHCP
disconnect               Exit the telnet session (daemon mode)
echo <text>              Display <text> in output
help                     Print help
history                  Shortcut for: show history. List the command history
ip [arguments]           Configure VPC's IP settings
load <filename>          Load the configuration/script from the file <filename>
ping <host> [-options]   Ping the network <host> with ICMP (default) or TCP/UDP
quit                     Quit program
relay [arguments]        Relay packets between two UDP ports
rlogin [<ip>] <port>     Telnet to host relative to HOST PC
save <filename>          Save the configuration to the file <filename>
set [arguments]          Set VPC name, peer ports, dump options, echo on or off
show [arguments]         Print the information of VPCs (default). Try show ?
sleep <seconds> [text][/text]   Print <text> and pause the running script for <seconds>
trace <host> [-options]  Print the path packets take to network <host>
version                  Shortcut for: show version

To get command syntax help, please enter '?' as an argument of the command.</pre>
<p style="text-align: justify;">Podemos entrar en otra m&aacute;quina escribiendo el n&uacute;mero (de 1 a 9), por ejemplo para configurar el direccionamiento de la segunda m&aacute;quina, indicamos la direcci&oacute;n ip, la puerta de enlace y la mascara de red:</p>
<pre class="brush: bash; gutter: false; first-line: 1">VPCS[1]> 2
VPCS[2]> ip 10.0.0.2 10.0.0.1 24</pre>
<p>Podemos ver la configuraci&oacute;n de todas las m&aacute;quinas con el comando show:</p>
<pre class="brush: bash; gutter: false; first-line: 1">VPCS[2]> show

NAME   IP/MASK              GATEWAY           MAC                LPORT  RHOST:PORT
VPCS1  0.0.0.0/0            0.0.0.0           00:50:79:66:68:00  20000  127.0.0.1:30000
       fe80::250:79ff:fe66:6800/64
VPCS2  10.0.0.2/24          10.0.0.1          00:50:79:66:68:01  20001  127.0.0.1:30001
       fe80::250:79ff:fe66:6801/64
VPCS3  0.0.0.0/0            0.0.0.0           00:50:79:66:68:02  20002  127.0.0.1:30002
       fe80::250:79ff:fe66:6802/64
VPCS4  0.0.0.0/0            0.0.0.0           00:50:79:66:68:03  20003  127.0.0.1:30003
       fe80::250:79ff:fe66:6803/64
VPCS5  0.0.0.0/0            0.0.0.0           00:50:79:66:68:04  20004  127.0.0.1:30004
       fe80::250:79ff:fe66:6804/64
VPCS6  0.0.0.0/0            0.0.0.0           00:50:79:66:68:05  20005  127.0.0.1:30005
       fe80::250:79ff:fe66:6805/64
VPCS7  0.0.0.0/0            0.0.0.0           00:50:79:66:68:06  20006  127.0.0.1:30006
       fe80::250:79ff:fe66:6806/64
VPCS8  0.0.0.0/0            0.0.0.0           00:50:79:66:68:07  20007  127.0.0.1:30007
       fe80::250:79ff:fe66:6807/64
VPCS9  0.0.0.0/0            0.0.0.0           00:50:79:66:68:08  20008  127.0.0.1:30008
       fe80::250:79ff:fe66:6808/64</pre>
<p style="text-align: justify;">Y podemos guardar la configuraci&oacute;n de todas las m&aacute;quinas con el comando save, para posteriormente recuperarlo con el comando load:</p>
<p class="brush: bash; gutter: false; first-line: 1">VPCS[2]> save configuracion.txt</p>
<h1>Comunicando GNS3 con VPCS</h1>
<p style="text-align: justify;">Ahora es el momento de crear una nueva topolog&iacute;a en GNS3 donde vamos a a&ntilde;adir un host y un router, (al cual le hemos a&ntilde;adido un slot FastEthernet 0/0). Si observamos la configuraci&oacute;n del host, y nos vamos a la pesta&ntilde;a NIO UDP, observamos que tenemos una interfaz virtual de red que corresponde con cada una de las 9 m&aacute;quinas que nos ofrece VPCS.</p>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2013/11/img1.png"><img class="aligncenter size-medium wp-image-813" alt="img1" src="http://www.josedomingo.org/pledin/wp-content/uploads/2013/11/img1-300x261.png" width="300" height="261" /></a></p>
<p style="text-align: justify;">Por lo tanto a la hora de conectar el host y el router tendremos que escoger la interfaz virtual de red de la m&aacute;quina virtual que nos interese, teniendo en cuenta que la del puerto remoto 20000 corresponde a la primera m&aacute;quina, la del puerto remoto 20001 corresponde a la segunda m&aacute;quina, y as&iacute; consecutivamente. En nuestro caso tenemos configurado la segunda m&aacute;quina por lo que conectamos a la interfaz nio_dup:30001:127.0.0.1:20001</p>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2013/11/img2.png"><img class="aligncenter size-medium wp-image-812" alt="img2" src="http://www.josedomingo.org/pledin/wp-content/uploads/2013/11/img2-300x106.png" width="300" height="106" /></a>A continuaci&oacute;n vamos a configurar el direccionamiento ip del router:</p>
<pre class="brush: bash; gutter: false; first-line: 1">R1>enable
R1#configure terminal
R1(config)#interface f0/0
R1(config-if)#ip add 192.168.1.254 255.255.255.0
R1(config-if)#no shutdown</pre>
<p style="text-align: justify;">Y ya estamos en disposici&oacute;n de realizar la pruebas de conectividad, por ejemplo desde la segunda m&aacute;quina, nuestro host, podemos hacer ping al router:</p>
<pre class="brush: bash; gutter: false; first-line: 1">VPCS[2]> ping 10.0.0.1
10.0.0.1 icmp_seq=1 ttl=255 time=19.976 ms
10.0.0.1 icmp_seq=2 ttl=255 time=7.125 ms
10.0.0.1 icmp_seq=3 ttl=255 time=7.409 ms</pre>
<p>Del mismo modo desde le router podemos hacer ping al host:</p>
<p>&nbsp;</p>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2013/11/img3.png"><img class="aligncenter size-medium wp-image-815" alt="img3" src="http://www.josedomingo.org/pledin/wp-content/uploads/2013/11/img3-300x54.png" width="300" height="54" /></a></p>
<p style="text-align: justify;">Bueno, espero que el presente art&iacute;culo sea de utilidad sobre todo para nuestros alumnos del m&oacute;dulo de redes. Un saludo.</p>
