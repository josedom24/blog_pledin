---
layout: post
status: publish
published: true
title: Simulando switch cisco en GNS3
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 959
wordpress_url: http://www.josedomingo.org/pledin/?p=959
date: '2014-02-17 22:34:22 +0000'
date_gmt: '2014-02-17 21:34:22 +0000'
categories:
- General
tags:
- Redes
- Virtualizaci&oacute;n
- gns3
- vlan
- trunk
- switch
- cisco
- vtp
comments: []
---
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2013/11/logo_gns3_small.png"><img class="size-full wp-image-803 alignleft" alt="logo_gns3_small" src="http://www.josedomingo.org/pledin/wp-content/uploads/2013/11/logo_gns3_small.png" width="250" height="177" /></a>Como vimos en una <a title="Trabajando con switch en GNS3: VLAN y Trunk" href="http://www.josedomingo.org/pledin/2014/02/trabajando-con-switch-en-gns3-vlan-y-trunk/">entrada anterior</a>, el simulador de redes GNS3 nos ofrece un switch con unas funcionalidades limitadas. Por lo tanto, el objetivo de escribir esta entrada es la de explicar mi experiencia simulando un switch cisco en GNS3. En realidad lo que vamos&nbsp; a hacer es utilizar un router cisco de la gama 3700 como un switch con el m&oacute;dulo NM-16ESW. Este m&oacute;dulo proporciona al router un switch de 16 puertos, con lo que nos permite trabajar con algunas caracter&iacute;sticas como pueden ser las vlan, trunk, vtp, port aggregation o EherChannel, port mirroring, etc.</p>
<h2><!--more--></h2>
<h2>Preparaci&oacute;n del entorno</h2>
<p>La configuraci&oacute;n que tenemos que hacer en GNS3 se resumen en los siguientes pasos:</p>
<ul>
<li>Instalamos la imagen del sistema operativos ios del router 3725 (configuramos de forma adecuada el par&aacute;metro idle pc). A&ntilde;adimos un router a nuestro entorno de trabajo y en la configuraci&oacute;n activamos el m&oacute;dulo NM-16ESW.</li>
</ul>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/sw1.png"><img class="aligncenter size-full wp-image-961" alt="sw1" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/sw1.png" width="400" height="324" /></a></p>
<ul>
<li>Para no confundirnos si trabajamos con router y switch, podemos cambiar el s&iacute;mbolo de nuestro nuevo switch, para ello nos vamos a la opci&oacute;n <em>Symbol manager</em> dentro del men&uacute; <em>Edit</em>.</li>
</ul>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/sw2.png"><img class="aligncenter size-full wp-image-962" alt="sw2" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/sw2.png" width="400" height="341" /></a></p>
<ul>
<li>Ahora ya tenemos nuestro switch con 16 puertos en el rango de Fastethernet 1/0 - 15, el &uacute;ltimo paso es activar los 16 puertos:</li>
</ul>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/sw3.png"><img class="aligncenter size-full wp-image-964" alt="sw3" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/sw3.png" width="400" height="389" /></a></p>
<p>Veamos informaci&oacute;n sobre los puertos:</p>
<pre class="brush: bash; gutter: false; first-line: 1">R1#show ip interface brief</pre>
<p>Si al ejecutar esta ordens, encontramos en la columna "Status" el valor "down", tenemos que activar los puertos ejecutando los siguientes comandos (adem&aacute;s le voy a cambiar el nombre a sw1):</p>
<pre class="brush: bash; gutter: false; first-line: 1">R1# configure terminal
R1(config)#hostname sw1
sw1(config)#interface range FastEthernet 1/0 - 15
sw1(config-if-range)#no shutdown
sw1(config-if-range)#switchport</pre>
<p>En el siguiente escenario:</p>
<p><img class="aligncenter size-full wp-image-968" alt="sw4" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/sw4.png" width="371" height="262" />Podemos comprobar que los dos equipos tienen conectividad:</p>
<pre class="brush: bash; gutter: false; first-line: 1">VPCS[1]> ping 192.168.1.2
192.168.1.2 icmp_seq=1 ttl=64 time=0.068 ms</pre>
<h2>Ejemplo: vlan, trunk y vtp</h2>
<p>Vamos a realizar el ejemplo que estudiamos en una <a title="Trabajando con switch en GNS3: VLAN y Trunk" href="http://www.josedomingo.org/pledin/2014/02/trabajando-con-switch-en-gns3-vlan-y-trunk/">entrada anterior</a>.</p>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/g1.png"><img class="aligncenter size-full wp-image-906" alt="g1" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/g1.png" width="636" height="384" /></a>En este caso vamos a crear las vlan en el switch sw1 y la vamos a propagar al otro switch utilizando el protocolo VTP (<a href="http://es.wikipedia.org/wiki/VLAN_Trunking_Protocol">Vlan Trunking Protocol</a>). Vamos a ver los pasos que tenemos que dar:</p>
<p>1) Creamos las vlan en sw1 y asignamos el puerto FE1/0 a la primera vlan y el puerto FE1/1 a la segunda vlan.</p>
<pre class="brush: bash; gutter: false; first-line: 1">sw1#vlan database
sw1(vlan)#vlan 10 name prof
sw1(vlan)#vlan 20 name alum
sw1(vlan)#exit 
sw1#show vlan-switch

sw1(config)#interface FA1/0
sw1(config-if)#switchport access vlan 10

sw1(config)#interface FA1/1
sw1(config-if)#switchport access vlan 20</pre>
<p>2) Configuramos el switch sw1 como servidor VTP e indicamos un nombre de dominio. Posteriormente el otro switch se configurara como cliente VTP con el mismo nombre de dominio con lo que se crear&aacute;n las mismas vlan.</p>
<pre class="brush: bash; gutter: false; first-line: 1">sw1(config)#vtp mode server
sw1(config)#vtp domain local</pre>
<p>3) Configuramos el trunk, que ser&aacute; la conexi&oacute;n que vamos a realizar por los puertos FA1/15 y por donde encapsularemos el tr&aacute;fico de los dos vlan (hay que a&ntilde;adir todas las vlan 1-1005).</p>
<pre class="brush: bash; gutter: false; first-line: 1">sw1(config)#interface FastEthernet 1/15
sw1(config-if)#switchport mode trunk
sw1(config-if)#switchport trunk allowed vlan 1-1005</pre>
<p>4) Configuramos el segundo switch: indicamos que va a ser cliente vtp, y asignamos los distintos puertos:</p>
<pre>sw2(config)#vtp mode client
sw2(config)#vtp domain local

sw2(config)#interface FastEthernet 1/15
sw2(config-if)#switchport mode trunk
sw2(config-if)#switchport trunk allowed vlan 1-1005 

sw2(config)#interface FA1/0
sw2(config-if)#switchport access vlan 10

sw2(config)#interface FA1/1
sw2(config-if)#switchport access vlan 20

sw2# show vlan-switch</pre>
<p>Como hemos visto anteriormente usamos <em>show vlan-switch</em>, para obtner la informaci&oacute;n de vlan, y <em>show interface trunk</em>, para obtener informaci&oacute;n del trunk.</p>
<p>Como podemos comprobar a continuaci&oacute;n los equipos de las dos vlan tienen conexi&oacute;n entre ellos:</p>
<pre>VPCS[1]> ping 192.168.10.2&nbsp; &nbsp;
192.168.10.2 icmp_seq=1 ttl=64 time=0.324 ms

VPCS[3]> ping 192.168.20.2
192.168.20.2 icmp_seq=1 ttl=64 time=0.445 ms</pre>
