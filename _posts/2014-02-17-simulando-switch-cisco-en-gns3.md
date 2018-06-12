---
id: 959
title: Simulando switch cisco en GNS3
date: 2014-02-17T22:34:22+00:00


guid: http://www.josedomingo.org/pledin/?p=959
permalink: /2014/02/simulando-switch-cisco-en-gns3/


tags:
  - cisco
  - gns3
  - Redes
  - switch
  - trunk
  - Virtualización
  - vlan
  - vtp
---
[<img class="size-full wp-image-803 alignleft" alt="logo_gns3_small" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/logo_gns3_small.png" width="250" height="177" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/logo_gns3_small.png)Como vimos en una [entrada anterior](http://www.josedomingo.org/pledin/2014/02/trabajando-con-switch-en-gns3-vlan-y-trunk/ "Trabajando con switch en GNS3: VLAN y Trunk"), el simulador de redes GNS3 nos ofrece un switch con unas funcionalidades limitadas. Por lo tanto, el objetivo de escribir esta entrada es la de explicar mi experiencia simulando un switch cisco en GNS3. En realidad lo que vamos  a hacer es utilizar un router cisco de la gama 3700 como un switch con el módulo NM-16ESW. Este módulo proporciona al router un switch de 16 puertos, con lo que nos permite trabajar con algunas características como pueden ser las vlan, trunk, vtp, port aggregation o EherChannel, port mirroring, etc.

## <!--more-->

## Preparación del entorno

La configuración que tenemos que hacer en GNS3 se resumen en los siguientes pasos:

  * Instalamos la imagen del sistema operativos ios del router 3725 (configuramos de forma adecuada el parámetro idle pc). Añadimos un router a nuestro entorno de trabajo y en la configuración activamos el módulo NM-16ESW.

[<img class="aligncenter size-full wp-image-961" alt="sw1" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw1.png" width="400" height="324" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw1.png 400w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw1-300x243.png 300w" sizes="(max-width: 400px) 100vw, 400px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw1.png)

  * Para no confundirnos si trabajamos con router y switch, podemos cambiar el símbolo de nuestro nuevo switch, para ello nos vamos a la opción _Symbol manager_ dentro del menú _Edit_.

[<img class="aligncenter size-full wp-image-962" alt="sw2" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw2.png" width="400" height="341" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw2.png 400w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw2-300x255.png 300w" sizes="(max-width: 400px) 100vw, 400px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw2.png)

  * Ahora ya tenemos nuestro switch con 16 puertos en el rango de Fastethernet 1/0 &#8211; 15, el último paso es activar los 16 puertos:

[<img class="aligncenter size-full wp-image-964" alt="sw3" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw3.png" width="400" height="389" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw3.png 400w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw3-300x291.png 300w" sizes="(max-width: 400px) 100vw, 400px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw3.png)

Veamos información sobre los puertos:

<pre class="brush: bash; gutter: false; first-line: 1">R1#show ip interface brief</pre>

Si al ejecutar esta ordens, encontramos en la columna &#8220;Status&#8221; el valor &#8220;down&#8221;, tenemos que activar los puertos ejecutando los siguientes comandos (además le voy a cambiar el nombre a sw1):

<pre class="brush: bash; gutter: false; first-line: 1">R1# configure terminal
R1(config)#hostname sw1
sw1(config)#interface range FastEthernet 1/0 - 15
sw1(config-if-range)#no shutdown
sw1(config-if-range)#switchport</pre>

En el siguiente escenario:

<img class="aligncenter size-full wp-image-968" alt="sw4" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw4.png" width="371" height="262" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw4.png 371w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw4-300x211.png 300w" sizes="(max-width: 371px) 100vw, 371px" />Podemos comprobar que los dos equipos tienen conectividad:

<pre class="brush: bash; gutter: false; first-line: 1">VPCS[1]&gt; ping 192.168.1.2
192.168.1.2 icmp_seq=1 ttl=64 time=0.068 ms</pre>

## Ejemplo: vlan, trunk y vtp

Vamos a realizar el ejemplo que estudiamos en una [entrada anterior](http://www.josedomingo.org/pledin/2014/02/trabajando-con-switch-en-gns3-vlan-y-trunk/ "Trabajando con switch en GNS3: VLAN y Trunk").

[<img class="aligncenter size-full wp-image-906" alt="g1" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/g1.png" width="636" height="384" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/g1.png 636w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/g1-300x181.png 300w" sizes="(max-width: 636px) 100vw, 636px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/g1.png)En este caso vamos a crear las vlan en el switch sw1 y la vamos a propagar al otro switch utilizando el protocolo VTP ([Vlan Trunking Protocol](http://es.wikipedia.org/wiki/VLAN_Trunking_Protocol)). Vamos a ver los pasos que tenemos que dar:

1) Creamos las vlan en sw1 y asignamos el puerto FE1/0 a la primera vlan y el puerto FE1/1 a la segunda vlan.

<pre class="brush: bash; gutter: false; first-line: 1">sw1#vlan database
sw1(vlan)#vlan 10 name prof
sw1(vlan)#vlan 20 name alum
sw1(vlan)#exit 
sw1#show vlan-switch

sw1(config)#interface FA1/0
sw1(config-if)#switchport access vlan 10

sw1(config)#interface FA1/1
sw1(config-if)#switchport access vlan 20</pre>

2) Configuramos el switch sw1 como servidor VTP e indicamos un nombre de dominio. Posteriormente el otro switch se configurara como cliente VTP con el mismo nombre de dominio con lo que se crearán las mismas vlan.

<pre class="brush: bash; gutter: false; first-line: 1">sw1(config)#vtp mode server
sw1(config)#vtp domain local</pre>

3) Configuramos el trunk, que será la conexión que vamos a realizar por los puertos FA1/15 y por donde encapsularemos el tráfico de los dos vlan (hay que añadir todas las vlan 1-1005).

<pre class="brush: bash; gutter: false; first-line: 1">sw1(config)#interface FastEthernet 1/15
sw1(config-if)#switchport mode trunk
sw1(config-if)#switchport trunk allowed vlan 1-1005</pre>

4) Configuramos el segundo switch: indicamos que va a ser cliente vtp, y asignamos los distintos puertos:

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

Como hemos visto anteriormente usamos _show vlan-switch_, para obtner la información de vlan, y _show interface trunk_, para obtener información del trunk.

Como podemos comprobar a continuación los equipos de las dos vlan tienen conexión entre ellos:

<pre>VPCS[1]&gt; ping 192.168.10.2   
192.168.10.2 icmp_seq=1 ttl=64 time=0.324 ms

VPCS[3]&gt; ping 192.168.20.2
192.168.20.2 icmp_seq=1 ttl=64 time=0.445 ms</pre>

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->