---
title: 'Resolución de nombres de dominios en sistemas Linux'
permalink: /2024/02/resolucion-nombres-linux/
tags:
  - dns
  - Linux
  - Manuales
---

![dns]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/02/dns.png){: .align-center }

Los diferentes servicios que nos ofrecen la posibilidad de resolver nombres de dominio a direcciones IP dentro de un sistema operativo GNU/Linux han ido evolucionando a lo largo del tiempo. En este artículo quiero introducir la situación actual acerca de este tema, y presentar los distintos servicios involucrados en la resolución de nombres.

## Conceptos relacionados con la la resolución de nombres de dominio

Antes de comenzar a estudiar con detalle los distintos mecanismos de resolución, vamos a repasar algunos conceptos que nos serán necesarios:

* **Servidor DNS**: Ofrece un servicio de resolución de nombres de dominio, entre otras cosas. Los nombres de dominio siguen el **sistema de nombres de dominio (Domain Name System o DNS**, por sus siglas en inglés) ​, que es un sistema de nomenclatura jerárquico descentralizado para dispositivos conectados a redes IP como Internet o una red privada. Los servidores DNS se pueden consultar, por ejemplo para obtener la dirección IP a partir de un determinado nombre de host o nombre de dominio. Tradicionalmente en los sistemas GNU/Linux el fichero donde se configura el o los servidores DNS que se utilizarán para resolver los nombres es `/etc/resolv.conf`.
* **Resolución estática**: Es un sistema de resolución de nombres de dominios a direcciones IP, que está configurado de manera estática en un ordenador. En los sistemas GNU/Linux se utiliza el fichero `/etc/hosts` para guardar la correspondencia entre nombre y dirección.
* **NSS**: El **Name Service Switch** o **NSS** es una biblioteca estándar de C que en sistemas GNU/Linux ofrece distintas funciones que los programas pueden utilizar para consultar distintas bases de datos del sistema. En concreto con este sistema se ordena las distintas fuentes para consultar las distintas bases de datos, por ejemplo de usuarios, contraseñas, nombres de hosts,... En este artículo la base de datos que nos interesa corresponde a los nombres de dominios o nombres de hosts. Esta base de datos se llama `hosts` y como veremos en el fichero `/etc/nsswitch.conf` se configura el orden de consulta que se realiza para resolver el nombre de un dominio a su dirección IP.

## El fichero /etc/resolv.conf

Como hemos comentado, este archivo especifica los servidores DNS que el sistema utilizará para resolver nombres de dominio a direcciones IP. Los parámetros más importantes que podemos encontrar son:

* `nameserver`: Esta línea define los servidores DNS que el sistema utilizará para resolver nombres de dominio. Pueden haber múltiples líneas `nameserver`, una para cada servidor DNS. El orden es importante ya que se intentará resolver el nombre utilizando el primer servidor, si este no funciona se intentará con el siguiente y así consecutivamente.
* `search`: Esta línea especifica el dominio de búsqueda para las consultas de resolución de nombres de dominio. Si intentas resolver un nombre de dominio que no está completamente cualificado (es decir, sin un sufijo de dominio), el sistema intentará agregar los dominios de búsqueda especificados aquí para completar el nombre antes de enviar la consulta al servidor.
* `domain`: Similar a `search`, `domain` especifica el dominio de búsqueda para las consultas de resolución de nombres de dominio, pero solo acepta un único dominio en lugar de una lista. 
* `options`: Esta línea se utiliza para especificar diversas opciones de configuración, como el tiempo de espera de resolución, la retransmisión de consultas, entre otros.

Ejemplo de configuración de `etc/resolv.conf`:

```
nameserver 8.8.8.8
nameserver 8.8.4.4
domain example.com
search example.com mycompany.com
options timeout:2 attempts:3
```

Estos parámetros se suelen recibir de forma dinámica por medio de un servidor DHCP, aunque también lo podemos indicar de forma estática en la configuración de red del sistema. Normalmente tenemos algún demonio instalado en el sistema, como [`resolvconf`](https://manpages.ubuntu.com/manpages/trusty/man8/resolvconf.8.html) que es el encargado de generar el fichero `/etc/resolv.conf` a partir de la configuración de red que hayamos especificado.

En este caso no debemos cambiar directamente el fichero `/etc/resolv.conf` porque el programa `resolvconf` puede reescribirlo en algunas circunstancias, por ejemplo cuando se renueva la concesión del servidor DHCP. 

Si queremos añadir contenido de forma estática al fichero `/etc/resolv.conf` es necesario escribir el contenido en el fichero `/etc/resolvconf/resolv.conf.d/head` si lo que queremos añadir se coloca antes de lo generado por `resolvconf`, o en el fichero `/etc/resolvconf/resolv.conf.d/tail` para añadirlo al final del fichero.

<!--more-->

## El fichero nsswitch.conf

Como hemos indicado este fichero nos permite configurar el orden de los distintos mecanismos que podemos utilizar para consultar distintas informaciones del sistema. En nuestro caso nos interesa la configuración del orden de los mecanismos de resolución de nombres de dominio, por lo tanto nos tenemos que fijar en la base de datos `hosts`. Por ejemplo en este fichero podemos encontrar una línea como está:

```
hosts:          files dns
```

Como observamos en la primera columna tenemos el nombre de la base de datos, en nuestro ejemplo `hosts` que se refiere a la consulta de nombres de dominios. A continuación encontramos una o varias especificaciones de servicios (en este caso de servicios de resolución de nombres), por ejemplo, "files", "dns",...  El orden de los servicios en la línea determina el orden en que se consultarán dichos servicios, sucesivamente, hasta que se encuentre un resultado. Veamos los dos servicios que hemos puesto en el ejemplo:

* **`files`**: Este es el servicio de resolución estática, es decir nos permite resolver nombres de dominio consultando el fichero `/etc/hosts`.
* **`dns`**: Este es el servicio de resolución de nombres de dominio que realiza una consulta a los servidores DNS configurados en el fichero `/etc/resolv.conf`.

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

Tenemos a nuestra disposición utilidades que nos permiten hacer peticiones a servidores DNS para realizar  resoluciones de nombres. Ejemplo de este tipo de herramienta son: `dig`, `nslookup` o `host`. Estas herramientas no consultan el fichero `/etc/nsswitch.conf` para determinar el orden de las consultas que tienen que realizar para la resolución de nombres. Estas herramientas sólo hacen consultas a un servidor DNS, no buscan nombres utilizando la resolución estática, no acceden al fichero `/etc/hosts`.

**NSS** nos ofrece una herramienta para consultar las distintas informaciones, por ejemplo para consultar la resolución de nombres de dominio podemos usar el comando `getent ahosts`. Está herramienta sí sigue el orden de mecanismos configurados en el fichero `/etc/nsswitch.conf`, en nuestro ejemplo, primero buscara el nombre usando resolución estática, y si no lo encuentra hará la consulta DNS. Por ejemplo, si tenemos la línea de resolución en el fichero `/etc/hosts` como anteriormente:

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

En distribuciones GNU/Linux el servicio de mDNS lo ofrece normalmente un programa llamado `avahi`, que es un demonio encargado de la resolución de los nombres de las máquinas locales.

Tenemos un nuevo mecanismo de resolución de nombres que podemos configurar en el orden de búsqueda establecido en el fichero `/etc/nsswitch.conf`, en este caso podríamos tener la siguiente configuración:

```
hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4
```

Con esta configuración, el orden que se sigue para la resolución de nombres es la siguiente:

* **`files`**: Como ya hemos comentado, resolución estática.
* **`mdns4_minimal [NOTFOUND=return]`**: Resolución por mDNS. `mdns4_minimal` busca servicios mínimos, lo que significa que solo busca los servicios más básicos y esenciales. Por lo general, mdns4_minimal se utiliza en entornos donde se espera un bajo consumo de recursos o donde la red es simple y no tiene una gran cantidad de servicios anunciados. La opción `[NOTFOUND=return]` indica que si el nombre no se puede resolver, que no se siga buscando con las opciones posteriores.
* **`dns`**: Ya hemos indicado que se trata de una consulta a un servidor DNS.
* **`mdns4`**: Resolución por mDNS, `mdns4` buscará todos los servicios disponibles en la red, lo que podría significar un mayor consumo de recursos, especialmente en redes grandes o complejas con muchos servicios anunciados.

En resumen, `mdns4_minimal` es una opción más ligera que busca solo servicios mínimos, mientras que `mdns4` busca todos los servicios anunciados a través de mDNS. La elección entre ellas dependerá de las necesidades y características específicas del entorno de red en cuestión.

Veamos un ejemplo, suponemos que en nuestra red hay un equipo cuyo hostname es `stark`, podríamos hacer una consulta para averiguar su dirección IP:

```
getent ahosts stark.local
192.168.18.3    STREAM stark.local
```

Y comprobamos que tenemos conectividad:

```
ping stark.local
PING stark.local (192.168.18.3) 56(84) bytes of data.
64 bytes from stark (192.168.18.3): icmp_seq=1 ttl=64 time=0.276 ms
...
```

## systemd-resolved

[*systemd-resolved*](https://www.freedesktop.org/wiki/Software/systemd/resolved/) es un servicio de systemd que proporciona resolución de nombres de dominio a aplicaciones locales. Este servicio ofrece resolución de nombres a través de tres vías:

* Una interfaz D-Bus. [D-Bus](https://es.wikipedia.org/wiki/D-Bus) es un sistema de comunicación entre procesos. Presumiblemente las aplicaciones gráficas utilizarán está vía para solicitar la resolución de nombres.
* El servicio NSS. *systemd-resolved* nos ofrece tres plugin para el sistema NSS:
  * `nss-resolve`: Un DNS forward caché que permite a las aplicaciones que utilizan NSS resolver nombres.
  * `nss-myhostname`: Nos proporciona resolución de nombres de host locales sin tener que editar `/etc/hosts`.
  * `nss-mymachines`: Nos proporciona resolución de nombres de host para los nombres de contenedores locales `systemd-machined`.
* Un servidor auxiliar DNS forward caché que tiene la dirección `127.0.0.53`, que utilizarán las aplicaciones que hacen consultas a los servidores DNS configurados en `/etc/resolv.conf`.

*systemd-resolved* proporciona servicios de resolución para **sistema de nombres de dominio (DNS)** (incluyendo **DNSSEC** y **DNS mediante TLS**), **multicast DNS (mDNS)** y **resolución de nombres de multidifusión de enlace local (LLMNR)** (servicio similar a mDNS). 

La resolución se puede configurar editando `/etc/systemd/resolved.conf` o colocando archivos con extensión `.conf` en `/etc/systemd/resolved.conf.d/`. Para utilizar *systemd-resolved* debemos iniciar el servicio `systemd-resolved.service`. 

### Configuración NSS con systemd-resolved

Como hemos visto, *systemd-resolved* nos ofrece un nuevo mecanismo de resolución de nombres de dominio, por lo tanto podremos configurar el orden de este nuevo mecanismo en el fichero `/etc/nsswitch.conf`, en este caso podríamos tener la siguiente configuración:

```
hosts:          mymachines resolve [!UNAVAIL=return] files myhostname dns
```

Como podemos ver en la [documentación](https://www.freedesktop.org/software/systemd/man/latest/nss-resolve.html) de `nss-resolve`, se recomienda colocar `resolve` al principio de la línea `hosts:` de `/etc/nsswitch.conf`. Debería estar antes de la entrada `files`, ya que *systemd-resolved* soporta `/etc/hosts` internamente, pero con caché. Por el contrario, debería estar después de `mymachines`, para dar precedencia a los nombres de host dados a las máquinas virtuales y contenedores locales sobre los nombres recibidos a través de DNS. Finalmente, recomendamos colocar `dns` en algún lugar después de `resolve`, para recurrir a `nss-dns` si `systemd-resolved.service` no está disponible.

### Configuración DNS con systemd-resolved

*systemd-resolved* tiene varios modos diferentes para manejar la resolución de nombres de dominio (para más información puede ver la [documentación](https://man.archlinux.org/man/systemd-resolved.8#/ETC/RESOLV.CONF) de *systemd-resolved*). En este artículo vamos a señalar los modos más interesantes:

* **Utilizar el archivo "stub" de DNS de systemd**: En el archivo "stub" de DNS de systemd `/run/systemd/resolve/stub-resolv.conf` nos encontramos la configuración del servido DNS auxiliar forward caché `127.0.0.53` como el único servidor DNS y una lista de dominios de búsqueda. Este es el modo de operación recomendado. Normalmente el fichero `/etc/resolv.conf` es un enlace simbólico a este fichero. Este servidor DNS es forward, es decir, reenvía las consultas DNS a los servidores que hayamos configurado en la configurado de red, por ejemplo los servidores DNS recibidos por un servidor DHCP. Esta es método que encontramos en la configuración de la distribución Linux Ubuntu 22.04.
* **Utilizar los DNS configurados en el sistema**: En este modo el fichero `/etc/resolv.conf` es un enlace simbólico al fichero `/run/systemd/resolve/resolv.conf` donde `systemd-resolved` configura los servidores DNS que hemos indicados en la configuración de la red. Este es el método escogido en la configuración de la distribución Linux Debian 12.
* **Preservar `resolv.conf`**: Este modo conserva `/etc/resolv.conf` y *systemd-resolved* es simplemente un cliente de aquel archivo. Este modo es menos disruptivo ya que `/etc/resolv.conf` puede continuar siendo administrado por otros paquetes.

### Resolución de nombres con systemd-resolved

*systemd-resolved* ofrece un mecanismo de resolución de nombres de dominio, que engloba todos los mecanismos anteriormente vistos. Por lo tanto podemos utilizar las herramientas de consultas de resolución que utilizábamos con los anteriores mecanismos:

* Podemos usar herramientas de consultas a servidores DNS como `dig`, `host` o `nslookup`.
* Podemos usar la herramienta ofrecida por NSS: `getent`.
* También podemos usar la herramienta `resolvectl` que es una utilidad que nos ofrece *systemd-resolved* para realizar consultas. Veamos algunas opciones de esta aplicación:
  * Mostrar información sobre la configuración: `resolvectl status`
  * Mostrar estadísticas sobre los aciertos de caché: `resolvectl statistics`
  * Borrar las cachés de resolución: `resolvectl flush-caches`
  * Mostrar los DNS utilizados: `resolvectl dns`
  * Hacer resoluciones DNS: `resolvectl query`

Veamos algunos ejemplos de consultas:

Resolución de un nombre que tenemos definido en `/etc/hosts`:

```
resolvectl query www.example.org
www.example.org: 192.168.121.180
```

Resolución de un nombre local usando mDNS:

```
resolvectl query nodo1
nodo1: 10.0.0.249                            -- link: ens3

ping nodo1
PING nodo (10.0.0.249) 56(84) bytes of data.
64 bytes from nodo (10.0.0.249): icmp_seq=1 ttl=64 time=3.04 ms
```

Resolución realizando una consulta DNS:

```
resolvectl query www.josedomingo.org
www.josedomingo.org: 37.187.119.60             -- link: ens3
                     (endor.josedomingo.org)
```

### Ejemplos de configuración de systemd-resolved

#### Ubuntu 22.04

En primer lugar vamos a ver la configuración de *systemd-resolved* en Ubuntu 22.04. Como hemos comentado anteriormente Ubuntu 22.04 usa la configuración del "stub" DNS, es decir, utiliza la configuración de un servidor DNS auxiliar forward caché. Veamos el fichero `/etc/resolv.conf`:

```
ls -l /etc/resolv.conf 
lrwxrwxrwx 1 root root 39 Sep 14 02:09 /etc/resolv.conf -> ../run/systemd/resolve/stub-resolv.conf

cat /etc/resolv.conf 
...
nameserver 127.0.0.53
options edns0 trust-ad
search dominio.org
```
Este sistema ha recibido por medio de un servidor DHCP la configuración del servidor DNS `172.22.0.1`, Cuando realizamos una consulta al DNS configurado `127.0.0.53`, este reenvía la consulta al servidor DNS configurado `172.22.0.1`, y la resolución la guarda en caché. Podemos ver el servidor DNS que estamos utilizando ejecutando la siguiente instrucción:

```
resolvectl dns
Global:
Link 2 (ens3): 172.22.0.1
```

Como vemos se ha configurado un DNS para la interfaz de red `ens3`. Esto significa que cuando tu sistema envíe consultas de resolución de nombres de dominio a través de la interfaz de red `ens3`, utilizará este servidor DNS en lugar del servidor DNS global, que será el configurado para resolver las consultas de nombres de dominio cuando no haya una configuración específica para una interfaz de red particular. Si queremos añadir la configuración del servidor DNS global a nuestro sistema lo tenemos que indicar en el fichero de configuración de *systemd-resolved*, en el fichero `/etc/systemd/resolved.conf`, en concreto lo indicaremos en el parámetro `DNS`:

```
DNS=1.1.1.1
```
Reiniciamos el servicio y volvemos a consultar los DNS del sistema:

```
systemctl restart systemd-resolved.service 
resolvectl dns
Global: 1.1.1.1
Link 2 (ens3): 172.22.0.1
```

#### Debian 12

Pasemos ahora a la configuración de *systemd-resolved* en Debian 12. Este sistema también ha sido configurado por medio de un servidor DHCP con el servidor DNS `172.22.0.1`. En esta ocasión esta distribución configura su `/etc/resolv.conf` con los servidor DNS del sistema, por lo tanto:

```
ls -l /etc/resolv.conf 
lrwxrwxrwx 1 root root 32 Sep 10 04:26 /etc/resolv.conf -> /run/systemd/resolve/resolv.conf

cat /etc/resolv.conf
...
nameserver 172.22.0.1
search .


resolvectl dns
Global:
Link 2 (ens3): 172.22.0.1
```

En este caso si configuramos un DNS global en el fichero `/etc/systemd/resolved.conf`, vemos como se ha configurado efectivamente el servidor DNS Global:

```
resolvectl dns
Global:1.1.1.1
Link 2 (ens3): 172.22.0.1
```

Pero también se ha modificado el fichero `/etc/resolv.conf` de este modo:

```
nameserver 1.1.1.1
nameserver 172.22.0.1
```

En este caso el servidor DNS global es más preferente que el configurado específicamente para la interfaz `ens3`. 

Por último indicar que si queremos configurar nuestro equipo Debian con el servidor "stub" DNS como el de Ubuntu 22.04, solo tenemos que cambiar el enlace simbólico al que apunta `/etc/resolv.conf`:

```
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```
## Conclusiones

En este artículo he pretendido dos cosas: recordar conceptos más tradicionales sobre la resolución de nombres de dominios e introducir los nuevos mecanismos de resolución, como *systemd-resolved* y las implacaciones que tiene su uso. Lo presentado en este artículo simplemte es una introducción a estos conceptos y han quedado fuera muchos otros aspectos de la configuración de los distintos mecanismos. Si el lector comprueba que he introducido algún error o los datos ofrecidos no son exactos, por favor escríbeme para cambiar la información del artículo. Espero, como siempre, que sea de utilidad.

