---
title: 'Resolución de nombres en sistemas Linux'
permalink: /2024/02/resolucion-nombres-linux/
tags:
  - dns
  - Linux
  - Manuales
---

Los diferentes servicios que nos ofrecen la posibilidad de resolver nombres de dominio a direcciones IP dentro de un sistema operativo GNU/Linux han ido evolucionando a lo largo del tiempo. En este artículo quiero introducir la situación actual acerca de este tema, y presentar los distintos servicios involucrados en la resolución de nombres.

## Conceptos relacionados con la la resolución de nombres de dominio

Antes de comenzar a estudiar con detalle los distintos mecanismos de resolución, vamos a repasar algunos conceptos que serán necesarios:

* **Servidor DNS**: Ofrece un servicio de resolución de nombres de dominio, entre otras cosas. Los nombres de dominio siguen el **sistema de nombres de dominio (Domain Name System o DNS, por sus siglas en inglés)**​, que es un sistema de nomenclatura jerárquico descentralizado para dispositivos conectados a redes IP como Internet o una red privada. Los servidores DNS se pueden consultar, por ejemplo para obtener la dirección IP a partir de un determinado nombre de host o nombre de dominio. Tradicionalmente en los sistemas GNU/Linux el fichero donde se configura el o los servidores DNS que se utilizarán para resolver los nombres es `/etc/resolv.conf`.
* **Resolución estática**: Es un sistema de resolución de nombres de dominios a direcciones IP, que está configurado de manera estática en un ordenador. En los sistemas GNU/Linux se utiliza el fichero `/etc/hosts` para guardar la correspondencia entre nombre y dirección.
* **NSS**: El **Name Service Switch** o **NSS** es una biblioteca estándar de C que en sistemas GNU/Linux ofrece distintas funciones que los programas pueden utilizar para consultar distintas bases de datos del sistema. En concreto con este sistema se ordena las distintas fuentes para consultar las distintas bases de datos, por ejemplo de usuarios, contraseñas, nombres de hosts,... En este artículo la base de datos que nos interesa corresponde a los nombres de los hosts. Esta base de datos se llama `hosts` y como veremos en el fichero `/etc/nsswitch.conf` se configura el orden de consulta que se realiza para resolver el nombre de un host a su dirección IP.


## El fichero /etc/resolv.conf



## El fichero nsswitch.conf

Como hemos indicado este fichero nos permite configurar el orden de los distintos mecanismos que podemos utilizar para consultar distintas informaciones del sistema. En nuestro caso nos interesa la configuración del orden de los mecanismos de resolución de nombres de dominio, por lo tanto nos tenemos que fijar en la base de datos `hosts`. Por ejemplo en este fichero podemos encontrar una línea como está:

```
hosts:          files dns
```

Como observamos en la primera columna tenemos el nombre de la base de datos, en nuestro ejemplo `hosts` que se refiere a la consulta de nombres de dominios. A continuación encontramos una o varias especificaciones de servicio (en este caso de servicios de resolución de nombres), por ejemplo, "files", "dns",...  El orden de los servicios en la línea determina el orden en que se consultarán dichos servicios, sucesivamente, hasta que se encuentre un resultado. Veamos los dos servicios que hemos puesto en el ejemplo:

* **files**: Este es el servicio de resolución estática, es decir nos permite resolver nombres de dominio consultando el fichero `/etc/hosts`.
* **dns**: Este es el servicio de resolución de nombres de dominio que realiza una consulta a los servidores DNS configurados en el fichero `/etc/resolv.conf`.

Por lo tanto con esta configuración, cualquier programa del sistema que necesite resolver un nombre de dominio a una dirección IP, primero usará la resolución estática y buscará el nombre en el fichero `/etc/hosts` y si no lo encuentra realizará una consulta a los servidores DNS configurados en el fichero `/etc/resolv.conf`.

Por ejemplo, si en el fichero `/etc/hosts` tenemos la siguiente línea:

```
192.168.121.180 www.example.org
```

Y realizamos un ping a ese nombre, se consultará en primer lugar la resolución estática:

```
ping www.example.org
PING www.example.org (192.168.121.180) 56(84) bytes of data.
```

Sin embargo, si borramos esa línea del fichero `/etc/hosts`, la resolución estática no funcionará (no hemos encontrado el nombre) y se realizará una consulta al servidor DNS que tengamos configurado en `/etc/resolv.conf`:

```
ping www.example.org
PING www.example.org (93.184.216.34) 56(84) bytes of data.
```

Como podemos observar las direcciones IP resueltas son diferentes.

## Consultas de nombres de dominio utilizando NSS

Tenemos a nuestra disposición utilidades que nos permiten hacer peticiones a servidores DNS para realizar  resoluciones de nombres. Ejemplo de este tipo de herramienta son: `dig`, `nslookup` o `host`. Esta herramientas no consultan el fichero `/etc/nsswitch.conf` para determinar el orden de las consultan que tienen que realizar para la resolución de nombres. Estas herramientas sólo hacen consultas a un servidor DNS, no buscan nombres utilizando la resolución estática, no acceden al fichero `/etc/hosts`.


**NSS** nos ofrece una herramienta para consultar las distintas informaciones, por ejemplo para consultar la resolución de nombres de dominio podemos usar el comando `getent ahosts`. Está herramienta si sigue el orden de mecanismos configurados en el fichero `/etc/nsswitch.conf`, en nuestro ejemplo, primero buscara el nombre usando resolución estática, y si no lo encuentra hará la consulta DNS. Por ejemplo, si tenemos la línea de resolución en el fichero `/etc/hosts` como anteriormente:

```
getent ahosts  www.example.org
192.168.121.180   STREAM www.example.org
...
```

Y si quitamos la línea, se realizará una consulta al servidor DNS:

```
getent ahosts  www.example.org
93.184.216.34   STREAM www.example.org
...
```

## Multicast DNS

El **mDNS (Multicast DNS)** es un protocolo utilizado en redes locales para resolver nombres de dominio sin necesidad de servidores DNS centralizados. En lugar de depender de servidores DNS, el mDNS utiliza mensajes de difusión para descubrir y resolver nombres de dispositivos en la red local.

Con este sistema de resolución de nombres de dominio podemos referenciar cualquier equipo de nuestra red local, usando el dominio `.local`.

El distribuciones GNU/Linux el servicio de mDNS lo ofrece normalmente un programa llamado `avahi`, que es un demonio encargado de la resolución de los nombres de las máquinas locales.

Tenemos un nuevos mecanismo de resolución de nombres que podemos configurar en el orden de búsqueda establecido en el fichero `/etc/nsswitch.conf`, En este caso podríamos tener la siguiente configuración:

```
hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4
```

En esta 

getent hosts www.example.org
2606:2800:220:1:248:1893:25c8:1946 www.example.org
getent ahosts www.example.org
192.168.121.180 STREAM www.example.org




En el archivo nsswitch.conf, la línea que mencionas, hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4, especifica el orden en el que se buscan las resoluciones de nombres de host. Aquí está la diferencia entre mdns4_minimal y mdns4:

    mdns4_minimal:
        mdns4_minimal es una opción que indica al sistema que busque nombres de host utilizando el protocolo de Descubrimiento de Servicios Multicast de DNS (mDNS).
        La diferencia principal entre mdns4_minimal y mdns4 es que mdns4_minimal busca servicios mínimos, lo que significa que solo busca los servicios más básicos y esenciales.
        Por lo general, mdns4_minimal se utiliza en entornos donde se espera un bajo consumo de recursos o donde la red es simple y no tiene una gran cantidad de servicios anunciados.

    mdns4:
        Por otro lado, mdns4 busca todos los servicios anunciados a través de mDNS en la red.
        A diferencia de mdns4_minimal, mdns4 buscará todos los servicios disponibles en la red, lo que podría significar un mayor consumo de recursos, especialmente en redes grandes o complejas con muchos servicios anunciados.

En resumen, mdns4_minimal es una opción más ligera que busca solo servicios mínimos, mientras que mdns4 busca todos los servicios anunciados a través de mDNS. La elección entre ellas dependerá de las necesidades y características específicas del entorno de red en cuestión.


https://github.com/avahi/nss-mdns
libnss_mdns{4,6,}_minimal.so (nuevo en la versión 0.8) es en su mayor parte idéntico a las versiones sin _minimal. Sin embargo, difieren en un aspecto. Las versiones mínimas siempre denegarán la resolución de nombres de host que no terminen en .local o direcciones que no estén en el rango 169.254.x.x (el rango usado por IPV4LL/APIPA/RFC3927.) Combinar los módulos _minimal y NSS normal nos permite hacer mDNS autoritativo para nombres de host y direcciones Zeroconf (y así no crear una carga extra en los servidores DNS con peticiones siempre fallidas) y usarlo como fallback para todo lo demás.




Plugins de NSS (https://wiki.archlinux.org/title/Domain_name_resolution)

* files: reads the /etc/hosts file, see hosts(5)
* dns: the glibc resolver which reads /etc/resolv.conf, see resolv.conf(5)
* mdns

systemd provides three NSS services for hostname resolution:


* nss-resolve(8) — a caching DNS stub resolver, described in systemd-resolved
* nss-myhostname(8) — provides local hostname resolution without having to edit /etc/hosts
* nss-mymachines(8) — provides hostname resolution for the names of local systemd-machined(8) containers

## Cómo funcionan la resolución de nombres de dominio


systemd-resolved puede actuar como un proveedor de servicios de resolución de nombres para nss. 




https://www.freedesktop.org/software/systemd/man/latest/nss-resolve.html
nss-resolve is a plug-in module for the GNU Name Service Switch (NSS) functionality of the GNU C Library (glibc) enabling it to resolve hostnames via the systemd-resolved(8) local network name resolution service. It replaces the nss-dns plug-in module that traditionally resolves hostnames via DNS.

<!--more-->


## Conclusiones

https://medium.com/@gabber12/explained-domain-name-resolutions-c85cd1acff91
https://nelsonslog.wordpress.com/2016/10/29/ubuntu-name-lookup-dns-vs-nss/
https://wiki.archlinux.org/title/Domain_name_resolution








# red

https://unix.stackexchange.com/questions/475146/how-exactly-are-networkmanager-networkd-netplan-ifupdown2-and-iproute2-inter