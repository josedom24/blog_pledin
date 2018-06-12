---
id: 904
title: 'Trabajando con switch en GNS3: VLAN y Trunk'
date: 2014-02-04T23:23:36+00:00


guid: http://www.josedomingo.org/pledin/?p=904
permalink: /2014/02/trabajando-con-switch-en-gns3-vlan-y-trunk/


tags:
  - gns3
  - Redes
  - switch
  - trunk
  - Virtualización
  - vlan
---
Como vimos en un [artículo anterior](http://www.josedomingo.org/pledin/2013/11/gns3-anadiendo-hosts-a-nuestras-topologias/), GNS3 es un simulador gráfico que nos permite simular infraestructuras de red. Uno de los elemento con los que podemos trabajar son con switch que son, dispositivos que trabajan en el nivel de enlace y que nos permiten interconectar equipos para formar una red local. Aunque los switch que nos ofrece por defecto el simulador son muy limitados y no podemos configurarlo desde un terminal, como por ejemplo podríamos hacer con un switch cisco utilizando su sistema operativo, sí tienen una pequeña interfaz de configuración que nos permiten trabajar con dos características muy importantes en los switch gestionables: las vlan y los trunk, o enlaces encapsulados dot1q.

Según la wikipedia una vlan (acrónimo de virtual LAN, «red de área local virtual») es un método para crear redes lógicas independientes dentro de una misma red física. Con un  switch gestionable podemos asignar cada puerto del mismo a una vlan diferente, por lo que los equipos conectados a puertos de distintas vlan estarán lógicamente en redes distintas.

El protocolo IEEE 802.1Q, también conocido como dot1Q, desarrolla un mecanismo que permite a múltiples redes compartir de forma transparente el mismo medio físico, sin problemas de interferencia entre ellas (Trunking). Se conoce con el mismo nombre el protocolo en encapsulamiento usado para implementar este mecanismo en redes Ethernet.
  
### Escenario que queremos simular

Vamos a simular la implantación de dos redes locales virtuales (VLAN) que se reparten por los puertos de dos switch. Para que varios puertos de dos switch distintos pertenezcan a la misma vlan, es necesario que los dispositivos estén conectado por un trunk.

Un caso real que corresponde a este modelo podría ser la conexión de varias aulas de un centro educativo, donde queremos crear dos redes virtuales separadas: la primera a la que están conectadas los ordenadores de los profesores, y la segunda a la que están conectados los ordenadores de los alumnos.

En nuestro ejemplo vamos a tener los siguientes datos:

* VLAN 10, que va a corresponder a una red virtual de profesores y que va a tener un direccionamiento en la red 192.168.10.0/24, la puerta de enlace va a ser la 192.168.10.254.
* VLAN 20, que va a corresponder a una red virtual de alumnos y que va a tener un direccionamiento en la red 192.168.20.0/24, la puerta de enlace va a ser la 192.168.20.254.

Si lo representamos en GNS3 quedaría de esta forma:

![gns3]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/g1.png)

Como vimos en el [artículo anterior](http://www.josedomingo.org/pledin/2013/11/gns3-anadiendo-hosts-a-nuestras-topologias/) hemos añadido los hosts utilizando la herramienta VPCS (Virtual PC Simulator), la configuración ip de las cuatro máquinas quedaría así:

    VPCS1  192.168.10.1/24      192.168.10.254    00:50:79:66:68:00  20000  127.0.0.1:30000
           fe80::250:79ff:fe66:6800/64
    VPCS2  192.168.10.2/24      192.168.10.254    00:50:79:66:68:01  20001  127.0.0.1:30001
           fe80::250:79ff:fe66:6801/64
    VPCS3  192.168.20.1/24      192.168.20.254    00:50:79:66:68:02  20002  127.0.0.1:30002
           fe80::250:79ff:fe66:6802/64
    VPCS4  192.168.20.2/24      192.168.20.254    00:50:79:66:68:03  20003  127.0.0.1:30003
           fe80::250:79ff:fe66:6803/64

Veamos la configuración de los puertos de los dos switch, donde vemos que hemos definido 3 puertos: el puerto 1 de tipo &#8220;access&#8221; corresponder a la vlan 10, el puerto 2 de tipo &#8220;access&#8221; que corresponde a la vlan 20 y el puerto 3 es de tipo dot1q, por el que vamos a conectar los dos switch para realizar el trunk.

![gns3]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/g2.png)

{: .notice--danger}
**Nota muy importante:** Debemos configurar el programa gns3 en inglés para que en el momento de elegir el tipo del puerto se asigne la palabra &#8220;access&#8221;, si tenemos traducido el programa al español y en ese campo ponemos la palabra &#8220;acceso&#8221; el programa nos dará un error a la hora de conectar los hosts a ese puerto.

Como podemos comprobar a continuación los equipos de las dos vlan tienen conexión entre ellos:

    VPCS[1]> ping 192.168.10.2   
    192.168.10.2 icmp_seq=1 ttl=64 time=0.324 ms

    VPCS[3]> ping 192.168.20.2
    192.168.20.2 icmp_seq=1 ttl=64 time=0.445 ms

### Añadiendo una puerta de enlace a nuestro escenario

Hasta ahora hemos construido dos redes locales virtuales, con conectividad entre los equipos de cada una de ellas. A continuación vamos a añadir un router que nos permita que las dos vlan tengan acceso al exterior. Para conseguir esto tendremos que conectar un router a un switch utilizando un enlace troncal o trunk con encapsulamiento dot1q. En la interfaz del router que utilicemos tendremos que crear dos subinterfaces con las direcciones ip que corresponden a las puertas de enlace de cada una de las vlan.

El esquema simulado quedaría de la siguiente manera. Como podemos comprobar en el primer switch hemos creado un cuarto puerto también de tipo dot1q:

![gns3]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/g3.png)

Ahora solo nos quedaría la configuración de la interfaz del router:
  
![gns3]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/g4.png)

    R1(config)#interface FastEthernet 0/0 
    R1(config-if)#no shut 
    R1(config-if)#interface fastEthernet 0/0.10     
    R1(config-subif)#encapsulation dot1Q  10 
    R1(config-subif)#ip address 192.168.10.254 255.255.255.0 
    R1(config-subif)# ^Z 

    R1(config-if)#interface FastEthernet 0/0.20     
    R1(config-subif)#encapsulation dot1Q  20 
    R1(config-subif)#ip address 192.168.20.254 255.255.255.0 
    R1(config-subif)# ^Z

Una vez terminamos comprobamos si tenemos conectividad a la puerta de enlace desde cada una de las vlan:

    VPCS[1]> ping 192.168.10.254
    192.168.10.254 icmp_seq=1 ttl=255 time=50.031 ms
    
    VPCS[3]> ping 192.168.20.254
    192.168.20.254 icmp_seq=1 ttl=255 time=9.340 ms

Aunque sería deseable poder simular switch cisco que tuvieran más funcionalidades, en este artículo hemos estudiado como realizar configuraciones complejas utilizando los switch ofrecidos por GNS3.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->