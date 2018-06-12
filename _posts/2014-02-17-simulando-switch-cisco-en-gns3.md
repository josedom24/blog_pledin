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
![gns3]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/11/logo_gns3_small.png)

Como vimos en una [entrada anterior](http://www.josedomingo.org/pledin/2014/02/trabajando-con-switch-en-gns3-vlan-y-trunk/ "Trabajando con switch en GNS3: VLAN y Trunk"), el simulador de redes GNS3 nos ofrece un switch con unas funcionalidades limitadas. Por lo tanto, el objetivo de escribir esta entrada es la de explicar mi experiencia simulando un switch cisco en GNS3. En realidad lo que vamos  a hacer es utilizar un router cisco de la gama 3700 como un switch con el módulo NM-16ESW. Este módulo proporciona al router un switch de 16 puertos, con lo que nos permite trabajar con algunas características como pueden ser las vlan, trunk, vtp, port aggregation o EherChannel, port mirroring, etc.

## Preparación del entorno

La configuración que tenemos que hacer en GNS3 se resumen en los siguientes pasos:

* Instalamos la imagen del sistema operativos ios del router 3725 (configuramos de forma adecuada el parámetro idle pc). Añadimos un router a nuestro entorno de trabajo y en la configuración activamos el módulo NM-16ESW.

![gns3]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw1.png)

* Para no confundirnos si trabajamos con router y switch, podemos cambiar el símbolo de nuestro nuevo switch, para ello nos vamos a la opción _Symbol manager_ dentro del menú _Edit_.

![gns3]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw2.png)

* Ahora ya tenemos nuestro switch con 16 puertos en el rango de Fastethernet 1/0 - 15, el último paso es activar los 16 puertos:

![gns3]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw3.png)

Veamos información sobre los puertos:

    R1#show ip interface brief

Si al ejecutar esta ordens, encontramos en la columna "Status" el valor "down", tenemos que activar los puertos ejecutando los siguientes comandos (además le voy a cambiar el nombre a sw1):

    R1# configure terminal
    R1(config)#hostname sw1
    sw1(config)#interface range FastEthernet 1/0 - 15
    sw1(config-if-range)#no shutdown
    sw1(config-if-range)#switchport

En el siguiente escenario:

![gns3]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/sw4.png)

Podemos comprobar que los dos equipos tienen conectividad:

    VPCS[1]> ping 192.168.1.2
    192.168.1.2 icmp_seq=1 ttl=64 time=0.068 ms

## Ejemplo: vlan, trunk y vtp

Vamos a realizar el ejemplo que estudiamos en una [entrada anterior](http://www.josedomingo.org/pledin/2014/02/trabajando-con-switch-en-gns3-vlan-y-trunk/ "Trabajando con switch en GNS3: VLAN y Trunk").

![gns3]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/g1.png)

En este caso vamos a crear las vlan en el switch sw1 y la vamos a propagar al otro switch utilizando el protocolo VTP ([Vlan Trunking Protocol](http://es.wikipedia.org/wiki/VLAN_Trunking_Protocol)). Vamos a ver los pasos que tenemos que dar:

1. Creamos las vlan en sw1 y asignamos el puerto FE1/0 a la primera vlan y el puerto FE1/1 a la segunda vlan.

        sw1#vlan database
        sw1(vlan)#vlan 10 name prof
        sw1(vlan)#vlan 20 name alum
        sw1(vlan)#exit 
        sw1#show vlan-switch

        sw1(config)#interface FA1/0
        sw1(config-if)#switchport access vlan 10

        sw1(config)#interface FA1/1
        sw1(config-if)#switchport access vlan 20

2. Configuramos el switch sw1 como servidor VTP e indicamos un nombre de dominio. Posteriormente el otro switch se configurara como cliente VTP con el mismo nombre de dominio con lo que se crearán las mismas vlan.

        sw1(config)#vtp mode server
        sw1(config)#vtp domain local

3. Configuramos el trunk, que será la conexión que vamos a realizar por los puertos FA1/15 y por donde encapsularemos el tráfico de los dos vlan (hay que añadir todas las vlan 1-1005).

        sw1(config)#interface FastEthernet 1/15
        sw1(config-if)#switchport mode trunk
        sw1(config-if)#switchport trunk allowed vlan 1-1005

4. Configuramos el segundo switch: indicamos que va a ser cliente vtp, y asignamos los distintos puertos:

        sw2(config)#vtp mode client
        sw2(config)#vtp domain local

        sw2(config)#interface FastEthernet 1/15
        sw2(config-if)#switchport mode trunk
        sw2(config-if)#switchport trunk allowed vlan 1-1005 

        sw2(config)#interface FA1/0
        sw2(config-if)#switchport access vlan 10

        sw2(config)#interface FA1/1
        sw2(config-if)#switchport access vlan 20

        sw2# show vlan-switch

Como hemos visto anteriormente usamos `show vlan-switch`, para obtener la información de vlan, y `show interface trunk`, para obtener información del trunk.

Como podemos comprobar a continuación los equipos de las dos vlan tienen conexión entre ellos:

    VPCS[1]> ping 192.168.10.2   
    192.168.10.2 icmp_seq=1 ttl=64 time=0.324 ms

    VPCS[3]> ping 192.168.20.2
    192.168.20.2 icmp_seq=1 ttl=64 time=0.445 ms

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->