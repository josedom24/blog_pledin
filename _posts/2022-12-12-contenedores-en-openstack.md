---
title: 'Contenedores en instancias de OpenStack'
permalink: /2022/12/contenedores-instancias-openstack/
tags:
  - OpenStack
  - Docker
  - LXC
  - LXD
---

![contenedores en openstack]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/12/os-docker-lxc-lxd.png){: .align-center }

Una de las características de trabajar con infraestructura en la nube como OpenStack es la posibilidad de virtualizar la red. Para ello OpenStack puede utilizar varios mecanismos, pero en instalaciones estándar de OpenStack se suele usar la redes [XVLAN](https://es.wikipedia.org/wiki/Virtual_Extensible_LAN), que es un protocolo  donde se encapsula tráfico de la capa de enlace sobre la capa de red, en concreto el tráfico Ethernet sobre una red IP.

Por otro lado vamos a recordar que la **MTU** (Unidad máxima de transferencia) expresa el tamaño en bytes que puede tener la unidad de datos de un protocolo de red. En concreto para Ethernet es, por defecto, 1500 bytes.

Cuando usamos redes XVLAN, estamos definiendo interfaces de red virtuales sobre interfaces físicas, y para que esto funcione necesitamos añadir información a las tramas que estamos encapsulando, normalmente necesitamos unos 50 bytes de información extra. Al crecer el tamaño de la trama, tendríamos dos opciones:

1. Modificar la MTU de los dispositivos físicos sobre lo que estamos montando nuestra infraestructura de OpenStack, por ejemplo a 1550 bytes, y configurar el componente de red de openstack neutron, para trabajar con redes virtuales de 1500 bytes.
2. No realizar modificación sobre los dispositivos físicos de nuestra infraestructura, y configurar neutron para trabajar con una mtu de 1450 bytes. En este caso las instancias que se conecten a las redes virtuales se adaptarán a esta mtu y tomarán el valor de 1450 bytes.

La segunda opción es la que se realiza en una instalación de OpenStack estándar. Veamos estos datos:

```
$ openstack network create mi_red
+---------------------------+--------------------------------------+
| Field                     | Value                                |
+---------------------------+--------------------------------------+
...
| mtu                       | 1450                                 |
| name                      | mi_red                               |
...
```

Si tenemos una instancia conectada a esta red observamos que se ha configurado con este valor de mtu:

```
$ ip a
...
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc pfifo_fast state UP group default qlen 1000
...
```
Todo esto funciona muy bien y sin ningún problema. El problema lo encontramos cuando sobre una instancia de OpenStack instalamos algún software de virtualización de contenedores (Docker, LXC, LXD, ...), en este caso los contenedores y los bridge virtuales que se crean para su interconexión se configuran con el valor estándar de mtu de 1500 bytes y nos encontramos con problemas de conectividades en el contenedor.

En este artículo vamos a repasar distintas soluciones a este problema para las distintas tecnologías  de contenedores.

<!--more-->

## Configuración del mtu en contenedores Docker

Instalamos docker sobre una instancia en OpenStack y comprobamos que el bridge que se ha creado por defecto para conectar los contenedores se ha configurado con una mtu de 1500:

```
$ ip a
...
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
...
```

Si creamos un contenedor en esta red, podemos comprobar como, evidentemente, toma una mtu de 1500 bytes:

```
$ docker run -it --rm alpine ip a
...
15: eth0@if16: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP 
```

### Primera solución: Configuración del demonio docker

Para solucionar este problema debemos crear el fichero `/etc/docker/daemon.json` con el siguiente contenido:

```
{
  "mtu": 1450
}
```

Y reiniciamos el demonio de docker:

```
# systemctl restart docker
```

A partir de ahora los contenedores que creemos tomaran una mtu de 1450.

### Segunda solución: Configuración de la mtu en la creación de redes docker

Otra alternativa sería a la hora de crear nuevas redes en docker configurar el valor adecuado de la mtu, para ello:

```
$ docker network create --opt com.docker.network.driver.mtu=1450 mi_red
```

Y ahora comprobamos la configuración del contenedor conectado a esta red:

```
$ docker run -it --rm --network mi_red alpine ip a
...
18: eth0@if19: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1450 qdisc noqueue state UP 
...
```

Si utilizamos `docker-compose` para crear la red, tendríamos que configurar la mtu, de esta forma en el fichero `docker-compose.yml`:

```
...
networks:                                
  mi_red:                               
    driver: bridge                       
    driver_opts:                         
      com.docker.network.driver.mtu: 1450
```

## Configuración de la mtu en contenedores LXC

Al instalar LXC en una instancia de OpenStack, nos encontramos con el mismo problema: el bridge por defecto que se crea para conectar los contenedores LXC tiene una mtu de 1500:

```
$ ip a
...
2: lxcbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
...
```

De la misma manera comprobamos que el contenedor que hemos creado se ha configurado con esta mtu:

```
$ lxc-execute contenedor1 -- ip a
...
2: eth0@if24: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
...
```

### Primera solución: Cambiar la configuración del contenedor

Podemos configurar el contenedor para que tome el valor de la mtu que deseemos. Tenemos dos opciones:

Si queremos que todos los nuevos contenedores tengan un valor de mtu predeterminado, añadimos al fichero `/etc/lxc/default.conf` la línea:

```
lxc.net.0.mtu = 1450
```

Ahora creamos un nuevo contenedor y vemos su configuración:

```
lxc-execute contenedor2 -- ip a
...
2: eth0@if25: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
...
```

Si queremos cambiar la configuración de un contenedor que ya estaba creado tenemos que añadir la línea `lxc.net.0.mtu = 1450` en su configuración, para el `contedor1` sería en el fichero `/var/lib/lxc/contenedor1/config`. después de reiniciar el contenedor, volvemos a probar:

```
lxc-execute contenedor1 -- ip a
...
2: eth0@if26: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
...
```

### Segunda solución: Cambiar la configuración del bridge

En esta solución no hemos cambiado la configuración de los contenedores LXC como en la primera solución. Vamos a cambiar manualmente el valor de la mtu para el bridge por defecto `lxcbr0`. Por supuesto, si vamos a crear nuevos bridge para trabajar con nuestros contenedores tendríamos que crearlos con el valor mtu adecuado.

Para cambiar la mtu del bridge `lxcbr0` ejecutamos:

```
ip link set dev lxcbr0 mtu 1450
```

Ahora los contenedores que se conecten a este puente tomaran el mismo mtu:

```
$ lxc-execute contenedor3 -- ip a
...
2: eth0@if31: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
...
```

## Configuración del mtu en contenedores LXD

Al instalar LXD en nuestra instancia se ha creado un bridge donde se van a conectar los contenedores, que tiene una configuración de mtu de 1500 bytes:

```
$ ip a
...
32: lxdbr0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
```

En este caso vamos a cambiar la configuración de la red para cambiar el valor de la mtu:

```
$ lxc network set lxdbr0 bridge.mtu=1450
```

Y podemos comprobar que los contenedores creados conectados a esta red han tomado el valor adecuado de mtu:

```
$ lxc exec contenedor4 -- ip a
...
34: eth0@if35: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
```

## Conclusiones

Si alguien le viene bien lo aquí expuesto, me alegro. Pero, como casi siempre esta entrada esta dedicada a mis alumnos de 2º de ASIR, que se estrujan la cabeza para que las prácticas les salgan lo mejor posible. Va por ellos.


