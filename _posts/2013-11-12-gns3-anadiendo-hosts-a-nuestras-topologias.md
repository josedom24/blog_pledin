---
id: 801
title: GNS3, añadiendo hosts a nuestras topologías
date: 2013-11-12T22:46:11+00:00


guid: http://www.josedomingo.org/pledin/?p=801
permalink: /2013/11/gns3-anadiendo-hosts-a-nuestras-topologias/


tags:
  - gns3
  - Redes
  - Virtualización
---
<p style="text-align: justify;">
  <a href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/logo_gns3_small.png"><img class="alignleft size-full wp-image-803" alt="logo_gns3_small" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/logo_gns3_small.png" width="250" height="177" /></a>
</p>

<p style="text-align: justify;">
  <strong>GNS3</strong> es un simulador gráfico de redes que permite crear entornos de redes virtuales, topologías de red complejas y además tener la posibilidad de integrarlos con simuladores de IOS. Es uno de los simuladores que utilizamos en el módulo <a href="http://informatica.gonzalonazareno.org/plataforma/course/view.php?id=35">Planificación y Administración de Redes</a> que impartimos en el ciclo formativo de Administración de Sistemas Informáticos en Red en el <a href="http://informatica.gonzalonazareno.org">IES Gonzalo Nazareno</a>.
</p>

<p style="text-align: justify;">
  Uno de los problemas que nos encontrábamos otros años aparecía a la hora de añadir un host a nuestra topología para poder realizar la pruebas de conectividad y encaminamiento que habíamos planteado a los alumnos. En realidad es necesario tener una máquina virtual completa en un sistema de virtualización independiente a GNS3 como puede ser  QEMU o VirtualBox, pero para nuestras prácticas no necesitamos una máquina completa, simplemente una &#8220;pequeña&#8221; máquina virtual que nos permita hacer ping/traceroute y chequear el estado de la red. Aquí es donde entra en juego el software <strong>Virtual PC Simulator</strong>, que integrado con GNS3 nos ofrece esta funcionalidad.
</p>

<p style="text-align: justify;">
  En el presente artículo, vamos a mostrar las distintas alternativas que tenemos para instalar GNS3 en una distribución GNU Linux Debian Wheezy, y a continuación vamos a ver el uso de Virtual PC Simulator para poder añadir hosts a las topologías que implementemos en GNS3.
</p>

<p style="text-align: justify;">
  <!--more-->
</p>

<h1 style="text-align: justify;">
  Instalación de GNS3
</h1>

<p style="text-align: justify;">
  Tenemos dos alternativas para instalar el programa. La más sencilla y que además instala todas las dependencias, es instalar el paquete que encontramos en los repositorios oficiales:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">apt-get install gns3</pre>

<p style="text-align: justify;">
  En este caso instalamos la versión 0.8.3, si por cualquier razón necesitamos instalar la última versión, que en el momento de escribir este artículo es la 0.8.4 podemos bajarnos los paquete de la <a href="http://gns3.serverb.co.uk/">página oficial </a>de GNS3 e instalarlo manualmente:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">dpkg -i dpkg -i dynamips_0.2.8-1~1_amd64.deb
dpkg -i gns3_0.8.4-1~1_all.deb</pre>

<p style="text-align: justify;">
  Como se puede observar utilizo la versión de 64 bits de dynamips. Durante este proceso puede ser necesario la instalación de algunos paquetes que son necesarios para la instalación de los dos paquetes que nos hemos bajado.
</p>

# Configuración de GNS3

<p style="text-align: justify;">
  La primera vez que ejecutamos el programa, nos aparece un asistente para realizar la configuración básica de programa: establecer el idioma, los directorios de trabajo, comprobar que la instalación es correcta, y subir las imágenes de IOS que tengamos a nuestra disposición de los distintos modelos de router. En este último punto es muy importante establecer la variable IDLE PC que nos permite la optimización del consumo de recursos de sistema, para tener más información sobre este tema os sugiero la lectura del siguiente <a href="http://roastedrouter.wordpress.com/2010/02/01/optimizacion-y-configuracion-de-gns3-como-mejorar-el-consumo-de-recursos-del-sistema/">artículo</a>. Una vez realizado esta configuración tenemos nuestro sistema totalmente funcional:
</p>

[<img class="size-medium wp-image-807 aligncenter" alt="screenshot-console-600x422" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/screenshot-console-600x422-300x211.png" width="300" height="211" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/screenshot-console-600x422-300x211.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/screenshot-console-600x422.png 600w" sizes="(max-width: 300px) 100vw, 300px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/screenshot-console-600x422.png)

# Virtual PC Simulator

<p style="text-align: justify;">
  Este programa pone a nuestra disposición 9 máquinas virtuales que consumen muy pocos recursos y que tienen una funcionalidad limitada.  Sin embargo son muy adecuadas para cubrir nuestras necesidades, ya que podremos configurar su direccionamiento ip y tenedremos a nuestra disposición comandos como ping o trace.
</p>

<p style="text-align: justify;">
  Nos bajamos la última versión desde su <a href="http://sourceforge.net/projects/vpcs/files/0.5/beta/">página de descarga</a>, en la actualidad la 0.5, en su versión de 64 bits. A continuación de damos permisos de ejecución y lo ejecutamos:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">chmod 755 vpcs_0.5b0_Linux64
./vpcs_0.5b0_Linux64</pre>

<p style="text-align: justify;">
  En este punto ya podemos manejar nuestras máquinas virtuales, si escribimos ? en el prompt obtenemos la lista de comandos que podemos ejecutar:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">VPCS[1]&gt; ?

?                        Print help
! [command [args]]       Invoke an OS command with the 'args' as its arguments
&lt;digit&gt;                  Switch to the VPC&lt;digit&gt;. &lt;digit&gt; range 1 to 9
arp                      Shortcut for: show arp. Show arp table
clear [arguments]        Clear IPv4/IPv6, arp/neighbor cache, command history
dhcp [-options]          Shortcut for: ip dhcp. Get IPv4 address via DHCP
disconnect               Exit the telnet session (daemon mode)
echo &lt;text&gt;              Display &lt;text&gt; in output
help                     Print help
history                  Shortcut for: show history. List the command history
ip [arguments]           Configure VPC's IP settings
load &lt;filename&gt;          Load the configuration/script from the file &lt;filename&gt;
ping &lt;host&gt; [-options]   Ping the network &lt;host&gt; with ICMP (default) or TCP/UDP
quit                     Quit program
relay [arguments]        Relay packets between two UDP ports
rlogin [&lt;ip&gt;] &lt;port&gt;     Telnet to host relative to HOST PC
save &lt;filename&gt;          Save the configuration to the file &lt;filename&gt;
set [arguments]          Set VPC name, peer ports, dump options, echo on or off
show [arguments]         Print the information of VPCs (default). Try show ?
sleep &lt;seconds&gt;    Print &lt;text&gt; and pause the running script for &lt;seconds&gt;
trace &lt;host&gt; [-options]  Print the path packets take to network &lt;host&gt;
version                  Shortcut for: show version

To get command syntax help, please enter '?' as an argument of the command.</pre>

<p style="text-align: justify;">
  Podemos entrar en otra máquina escribiendo el número (de 1 a 9), por ejemplo para configurar el direccionamiento de la segunda máquina, indicamos la dirección ip, la puerta de enlace y la mascara de red:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">VPCS[1]&gt; 2
VPCS[2]&gt; ip 10.0.0.2 10.0.0.1 24</pre>

Podemos ver la configuración de todas las máquinas con el comando show:

<pre class="brush: bash; gutter: false; first-line: 1">VPCS[2]&gt; show

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

<p style="text-align: justify;">
  Y podemos guardar la configuración de todas las máquinas con el comando save, para posteriormente recuperarlo con el comando load:
</p>

<p class="brush: bash; gutter: false; first-line: 1">
  VPCS[2]> save configuracion.txt
</p>

# Comunicando GNS3 con VPCS

<p style="text-align: justify;">
  Ahora es el momento de crear una nueva topología en GNS3 donde vamos a añadir un host y un router, (al cual le hemos añadido un slot FastEthernet 0/0). Si observamos la configuración del host, y nos vamos a la pestaña NIO UDP, observamos que tenemos una interfaz virtual de red que corresponde con cada una de las 9 máquinas que nos ofrece VPCS.
</p>

[<img class="aligncenter size-medium wp-image-813" alt="img1" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/img1-300x261.png" width="300" height="261" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/img1-300x261.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/img1.png 693w" sizes="(max-width: 300px) 100vw, 300px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/img1.png)

<p style="text-align: justify;">
  Por lo tanto a la hora de conectar el host y el router tendremos que escoger la interfaz virtual de red de la máquina virtual que nos interese, teniendo en cuenta que la del puerto remoto 20000 corresponde a la primera máquina, la del puerto remoto 20001 corresponde a la segunda máquina, y así consecutivamente. En nuestro caso tenemos configurado la segunda máquina por lo que conectamos a la interfaz nio_dup:30001:127.0.0.1:20001
</p>

[<img class="aligncenter size-medium wp-image-812" alt="img2" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/img2-300x106.png" width="300" height="106" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/img2-300x106.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/img2.png 492w" sizes="(max-width: 300px) 100vw, 300px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/img2.png)A continuación vamos a configurar el direccionamiento ip del router:

<pre class="brush: bash; gutter: false; first-line: 1">R1&gt;enable
R1#configure terminal
R1(config)#interface f0/0
R1(config-if)#ip add 192.168.1.254 255.255.255.0
R1(config-if)#no shutdown</pre>

<p style="text-align: justify;">
  Y ya estamos en disposición de realizar la pruebas de conectividad, por ejemplo desde la segunda máquina, nuestro host, podemos hacer ping al router:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">VPCS[2]&gt; ping 10.0.0.1
10.0.0.1 icmp_seq=1 ttl=255 time=19.976 ms
10.0.0.1 icmp_seq=2 ttl=255 time=7.125 ms
10.0.0.1 icmp_seq=3 ttl=255 time=7.409 ms</pre>

Del mismo modo desde le router podemos hacer ping al host:

&nbsp;

[<img class="aligncenter size-medium wp-image-815" alt="img3" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/img3-300x54.png" width="300" height="54" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/img3-300x54.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/img3.png 438w" sizes="(max-width: 300px) 100vw, 300px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/img3.png)

<p style="text-align: justify;">
  Bueno, espero que el presente artículo sea de utilidad sobre todo para nuestros alumnos del módulo de redes. Un saludo.
</p>

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->