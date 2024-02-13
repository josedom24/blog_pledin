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

Con esta configuración, el orden que se sigue para la resolución de nombres es la siguiente:

* **`files`**: Como ya hemos comentado, resolución estática.
* **`mdns4_minimal [NOTFOUND=return]`**: Resolución por mDNS. `mdns4_minimal` busca servicios mínimos, lo que significa que solo busca los servicios más básicos y esenciales. Por lo general, mdns4_minimal se utiliza en entornos donde se espera un bajo consumo de recursos o donde la red es simple y no tiene una gran cantidad de servicios anunciados. La opción `[NOTFOUND=return]` indica que si el nombre no se puede resolver, que no se siga buscando con las opciones posteriores.
* **`dns`**: Ya hemos indicado que se trata de una consuta a un servidor DNS.
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

systemd-resolved es un servicio de sistema que proporciona resolución de nombres de red a aplicaciones locales. Implementa un resolver stub DNS/DNSSEC de caché y validación, así como un resolver y responder LLMNR y MulticastDNS. Las aplicaciones locales pueden enviar solicitudes de resolución de nombres de red a través de tres interfaces:

* La API nativa con todas las funciones que systemd-resolved expone en el bus, consulte org.freedesktop.resolve1(5) y org.freedesktop.LogControl1(5) para obtener más detalles. El uso de esta API se recomienda generalmente a los clientes, ya que es asíncrona y con todas las funciones (por ejemplo, devuelve correctamente el estado de validación DNSSEC y el alcance de la interfaz para las direcciones, como es necesario para soportar redes de enlace local).
* La API glibc getaddrinfo(3) definida por RFC3493[1] y sus funciones de resolución relacionadas, incluyendo gethostbyname(3). Esta API está ampliamente soportada, incluso más allá de la plataforma Linux. Sin embargo, en su forma actual no expone información sobre el estado de validación de DNSSEC y sólo es síncrona. Esta API está respaldada por el conmutador de servicios de nombres glibc (nss(5)). Se requiere el uso del módulo NSS de glibc nss* resolve(8) para permitir que las funciones de resolución NSS de glibc resuelvan nombres de host a través de systemd-resolved.
* Además, systemd-resolved proporciona un stub listener DNS local en las direcciones IP 127.0.0.53 y 127.0.0.54 en la interfaz loopback local. Los programas que emiten peticiones DNS directamente, saltándose cualquier API local, pueden ser dirigidos a este stub, para conectarlos a systemd-resolved. Tenga en cuenta, sin embargo, que se recomienda encarecidamente que los programas locales utilicen las APIs glibc NSS o bus en su lugar (como se ha descrito anteriormente), ya que varios conceptos de resolución de red (como el direccionamiento link-local, o los dominios LLMNR Unicode) no se pueden mapear al protocolo DNS unicast.
* El stub resolver DNS en 127.0.0.53 proporciona el conjunto completo de características del resolver local, que incluye ofrecer resolución LLMNR/MulticastDNS. El stub resolver DNS en 127.0.0.54 proporciona un resolver más limitado, que opera sólo en modo "proxy", es decir, pasará la mayoría de los mensajes DNS relativamente sin modificar a los servidores DNS upstream actuales y de vuelta, pero no intentará procesar los mensajes localmente, y por lo tanto no valida DNSSEC, ni ofrece LLMNR/MulticastDNS. (Sin embargo, se traducirá a comunicación DNS-sobre-TLS si es necesario).


Los servidores DNS contactados se determinan a partir de la configuración global en /etc/systemd/resolved.conf, la configuración estática por enlace en los ficheros /etc/systemd/network/*.network (en el caso de que se utilice systemd-networkd.service(8)), la configuración dinámica por enlace recibida a través de DHCP, la información proporcionada a través de resolvectl(1), y cualquier información de servidor DNS puesta a disposición por otros servicios del sistema. Consulte resolved.conf(5) y systemd.network(5) para más detalles sobre los ficheros de configuración propios de systemd para servidores DNS. Para mejorar la compatibilidad, se lee /etc/resolv.conf para descubrir los servidores DNS del sistema configurados, pero sólo si no es un enlace simbólico a /run/systemd/resolve/stub-resolv.conf, /usr/lib/systemd/resolv.conf o /run/systemd/resolve/resolv.conf (ver más abajo).


REGISTROS SINTÉTICOS

systemd-resolved sintetiza registros de recursos DNS (RRs) para los siguientes casos:

-El nombre de host local configurado se resuelve a todas las direcciones IP configuradas localmente ordenadas por su ámbito o, si no hay ninguna configurada, a la dirección IPv4 127.0.0.2 (que está en la interfaz loopback local) y a la dirección IPv6 ::1 (que es el host local).
-Los nombres de host "localhost" y "localhost.localdomain", así como cualquier nombre de host que termine en ".localhost" o ".localhost.localdomain" se resuelven en las direcciones IP 127.0.0.1 y ::1.
-El nombre de host "_gateway" se resuelve con todas las direcciones de pasarela de enrutamiento por defecto actuales, ordenadas por su métrica. Esto asigna un nombre de host estable a la pasarela actual, útil para referenciarla independientemente del estado actual de la configuración de red.
-El nombre de host "_outbound" se resuelve a las direcciones IPv4 e IPv6 locales que se utilizan con mayor probabilidad para la comunicación con otros hosts. Esto se determina solicitando al kernel una decisión de enrutamiento a las pasarelas por defecto configuradas y luego utilizando las direcciones IP locales seleccionadas por esta decisión. Este nombre de host sólo está disponible si hay al menos una pasarela local por defecto configurada. Esto asigna un nombre de host estable a las direcciones IP locales salientes, útil para referenciarlas independientemente del estado actual de configuración de la red.
-El nombre de host "_localdnsstub" se resuelve en la dirección IP 127.0.0.53, es decir, la dirección en la que escucha el stub DNS local (véase más arriba).
-El nombre de host "_localdnsproxy" se resuelve en la dirección IP 127.0.0.54, es decir, la dirección en la que escucha el proxy DNS local (véase más arriba).
-Las asignaciones definidas en /etc/hosts se resuelven a sus direcciones configuradas y viceversa, pero no afectarán a las búsquedas de tipos que no sean direcciones (como MX). La compatibilidad con /etc/hosts puede desactivarse con ReadEtcHosts=no, consulte resolved.conf(5).



PROTOCOLOS Y ENRUTAMIENTO

Las solicitudes de búsqueda que recibe systemd-resolved.service se enrutan a los servidores DNS, LLMNR e interfaces MulticastDNS disponibles de acuerdo con las siguientes reglas:
* Los nombres para los que se generan registros sintéticos (el nombre de host local, "localhost" y "localdomain", pasarela local, como se indica en la sección anterior) y las direcciones configuradas en /etc/hosts nunca se enrutan a la red y se envía una respuesta inmediatamente.
* Los nombres de etiqueta única se resuelven utilizando LLMNR en todas las interfaces locales en las que LLMNR está habilitado. Las búsquedas de direcciones IPv4 sólo se envían a través de LLMNR en IPv4, y las búsquedas de direcciones IPv6 sólo se envían a través de LLMNR en IPv6. Tenga en cuenta que las búsquedas de nombres sintetizados de etiqueta única no se enrutan a LLMNR, MulticastDNS o unicast DNS.
* Las consultas de los registros de direcciones (A y AAAA) de nombres de etiqueta única no sintetizados se resuelven mediante DNS unidifusión utilizando dominios de búsqueda. Para cualquier interfaz que defina dominios de búsqueda, dichas búsquedas se dirigen a los servidores definidos para esa interfaz, con el sufijo de cada uno de esos dominios de búsqueda. Cuando se definen dominios de búsqueda globales, las consultas se dirigen a los servidores globales. Para cada dominio de búsqueda, las consultas se realizan sufijando el nombre con cada uno de los dominios de búsqueda sucesivamente. Además, la búsqueda de nombres de etiqueta única a través de DNS unidifusión puede activarse con el parámetro ResolveUnicastSingleLabel=yes. Los detalles sobre qué servidores se consultan y cómo se elige la respuesta final se describen a continuación. Tenga en cuenta que esto significa que las consultas de direcciones para nombres de etiqueta única nunca se envían a servidores DNS remotos de forma predeterminada, y que la resolución sólo es posible si se definen dominios de búsqueda.
* Los nombres multietiqueta con el sufijo de dominio ".local" se resuelven mediante MulticastDNS en todas las interfaces locales en las que MulticastDNS está activado. Al igual que con LLMNR, las búsquedas de direcciones IPv4 se envían a través de IPv4 y las búsquedas de direcciones IPv6 se envían a través de IPv6.
* Las consultas de nombres multietiqueta se enrutan a través de DNS unicast en las interfaces locales que tienen un servidor DNS configurado, además de los servidores DNS configurados globalmente si los hay. Las interfaces que se utilizan vienen determinadas por la lógica de enrutamiento basada en dominios de búsqueda y sólo enrutamiento, que se describe a continuación. Tenga en cuenta que, por defecto, las búsquedas de dominios con el sufijo ".local" no se enrutan a los servidores DNS, a menos que el dominio se especifique explícitamente como dominio de búsqueda o enrutamiento para el servidor DNS y la interfaz. Esto significa que en las redes en las que el dominio ".local" está definido en un servidor DNS específico del sitio, es necesario configurar dominios de búsqueda o enrutamiento explícitos para que las búsquedas funcionen dentro de este dominio DNS. Tenga en cuenta que actualmente se recomienda evitar definir ".local" en un servidor DNS, ya que RFC6762[2] reserva este dominio para uso exclusivo de MulticastDNS.
* Las búsquedas de direcciones (búsquedas inversas) se enrutan de forma similar a los nombres multietiqueta, con la excepción de que las direcciones del rango de direcciones link-local nunca se enrutan a DNS unicast y sólo se resuelven utilizando LLMNR y MulticastDNS (cuando están activados).

Si las búsquedas se dirigen a varias interfaces, se devuelve la primera respuesta correcta (con lo que se fusionan las zonas de búsqueda de todas las interfaces coincidentes). Si la búsqueda falla en todas las interfaces, se devuelve la última respuesta fallida.

El enrutamiento de las búsquedas viene determinado por los dominios de enrutamiento por interfaz (sólo búsqueda y sólo ruta) y los dominios de búsqueda globales. Véase systemd.network(5) y resolvectl(1) para una descripción de cómo se establecen estos parámetros dinámicamente y la discusión de Domains= en resolved.conf(5) para una descripción de los parámetros DNS configurados globalmente.

La siguiente lógica de enrutamiento de consultas se aplica a las búsquedas DNS unicast iniciadas por systemd-resolved.service:

* Si un nombre a buscar coincide (es decir: es igual o tiene como sufijo) con cualquiera de los dominios de enrutamiento configurados (búsqueda o sólo ruta) de cualquier enlace, o con los ajustes DNS configurados globalmente, se determina el dominio de enrutamiento "más coincidente": el coincidente con más etiquetas. A continuación, la consulta se envía a todos los servidores DNS de cualquier enlace o a los servidores DNS configurados globalmente asociados con este dominio de enrutamiento de "mejor coincidencia". (Tenga en cuenta que más de un enlace puede tener configurado este mismo dominio de enrutamiento de "mejor coincidencia", en cuyo caso la consulta se envía a todos ellos en paralelo).
En el caso de nombres de una sola etiqueta, cuando se definen dominios de búsqueda, se aplica la misma lógica, salvo que el nombre recibe primero el sufijo de cada uno de los dominios de búsqueda sucesivamente. Tenga en cuenta que esta lógica de búsqueda no se aplica a los nombres con al menos un punto. Véase también más abajo la discusión sobre la compatibilidad con el resolver glibc tradicional.
* Si una consulta no coincide con ningún dominio de enrutamiento configurado (ya sea por enlace o global), se envía a todos los servidores DNS configurados en los enlaces con la opción DefaultRoute= establecida, así como al servidor DNS configurado globalmente.
* Si no hay ningún enlace configurado como DefaultRoute= y ningún servidor DNS global configurado, se utiliza uno de los servidores DNS fallback compilados.
* De lo contrario, la consulta DNS unicast falla, ya que no se puede determinar ningún servidor DNS adecuado.

La opción DefaultRoute= es un parámetro booleano configurable con resolvectl o en los archivos .network. Si no se establece, se determina implícitamente basándose en los dominios DNS configurados para un enlace: si hay un dominio de sólo ruta distinto de "~.", por defecto es false, en caso contrario es true.

Efectivamente esto significa: para soportar nombres no sintetizados de etiqueta única, defina dominios de búsqueda apropiados. Para dirigir preferentemente todas las consultas DNS que no coincidan explícitamente con la configuración del dominio de enrutamiento a un enlace específico, configure un dominio de sólo enrutamiento "~." en él. Esto garantizará que no se tengan en cuenta otros enlaces para estas consultas (a menos que también lleven dicho dominio de enrutamiento). Para enrutar todas estas consultas DNS a un enlace específico sólo si no se prefiere ningún otro enlace, establezca la opción DefaultRoute= para el enlace en true y no configure un dominio de sólo enrutamiento "~." en él. Por último, para garantizar que un enlace específico nunca reciba tráfico DNS que no coincida con ninguno de sus dominios de enrutamiento configurados, establezca la opción DefaultRoute= para él en false.

Consulte org.freedesktop.resolve1(5) para obtener información sobre las API de D-Bus que proporciona systemd-resolved.

COMPATIBILIDAD CON EL STUB RESOLVER TRADICIONAL DE GLIBC

Esta sección proporciona un breve resumen de las diferencias en el resolver implementado por nss-resolve(8) junto con systemd-resolved y el resolver stub tradicional implementado en nss-dns.

* Algunos nombres se resuelven siempre internamente (véase Registros sintéticos más arriba). Tradicionalmente serían resueltos por nss-files si se proporcionan en /etc/hosts. Pero tenga en cuenta que los detalles de cómo se construye una consulta están bajo el control de la biblioteca cliente. nss-dns intentará primero resolver nombres usando dominios de búsqueda e incluso si esas consultas se enrutan a systemd-resolved, las enviará a través de la red usando las reglas habituales para el enrutamiento de nombres multietiqueta [3].
* Los nombres de etiqueta única no se resuelven para registros A y AAAA utilizando DNS unicast (a menos que se anule con ResolveUnicastSingleLabel=, ver resolved.conf(5)). Esto es similar a la opción no-tld-query que se establece en resolv.conf(5).
* Los dominios de búsqueda no se utilizan para sufijar nombres multietiqueta. (No obstante, los dominios de búsqueda se utilizan para el enrutamiento de búsqueda, para nombres que se especificaron originalmente como de etiqueta única o multietiqueta). Cualquier nombre con al menos un punto se interpreta siempre como un FQDN. nss-dns resolvería nombres tanto como relativos (utilizando dominios de búsqueda) como absolutos FQDN. Algunos nombres se resolverían primero como relativos y, una vez fallada la búsqueda, como absolutos, mientras que otros nombres se resolverían en orden inverso. La opción ndots en /etc/resolv.conf se utilizaba para controlar cuántos puntos debe tener el nombre para ser resuelto primero como relativo. Este stub resolver no implementa esto en absoluto: los nombres multietiqueta sólo se resuelven como FQDNs[4].
* Este resolver tiene noción del dominio especial ".local" usado para MulticastDNS, y no enrutará consultas con ese sufijo a servidores DNS unicast a menos que se configure explícitamente, ver arriba. Además, las búsquedas inversas de direcciones link-local no se envían a servidores DNS unicast.
* Este resolver lee y almacena en caché /etc/hosts internamente. (En otras palabras, nss-resolve sustituye a nss-files además de a nss-dns). Las entradas en /etc/hosts tienen la máxima prioridad.
* Este resolver también implementa LLMNR y MulticastDNS además del protocolo DNS unicast clásico, y resolverá nombres de una sola etiqueta usando LLMNR (cuando esté activado) y nombres que terminen en ".local" usando MulticastDNS (cuando esté activado).
* Las variables de entorno $LOCALDOMAIN y $RES_OPTIONS descritas en resolv.conf(5) no están soportadas actualmente.
* El resolver nss-dns mantiene poco estado entre consultas DNS subsecuentes, y para cada consulta siempre habla primero con el primer servidor DNS listado en /etc/resolv.conf, y en caso de fallo continúa con el siguiente hasta llegar al final de la lista, que es cuando la consulta falla. El resolver en systemd-resolved.service sin embargo mantiene el estado, y hablará continuamente con el mismo servidor para todas las consultas en un ámbito de búsqueda particular hasta que se vea algún tipo de error en cuyo momento cambia al siguiente, y entonces permanece continuamente con él para todas las consultas en el ámbito hasta el siguiente fallo, y así sucesivamente, volviendo finalmente al primer servidor configurado. Esto se hace para optimizar los tiempos de búsqueda, en particular teniendo en cuenta que el resolver normalmente debe sondear primero los conjuntos de características del servidor cuando habla con un servidor, lo que consume mucho tiempo. Este comportamiento diferente implica que los servidores DNS listados por ámbito de búsqueda deben ser equivalentes en las zonas que sirven, de modo que enviar una consulta a uno de ellos produzca los mismos resultados que enviarla a otro servidor DNS configurado.

/ETC/RESOLV.CONF

Se soportan cuatro modos de manejar /etc/resolv.conf (ver resolv.conf(5)):
* systemd-resolved mantiene el fichero /run/systemd/resolve/stub-resolv.conf para compatibilidad con programas Linux tradicionales. Este fichero lista el stub DNS 127.0.0.53 (ver más arriba) como único servidor DNS. También contiene una lista de dominios de búsqueda que están en uso por systemd-resolved. La lista de dominios de búsqueda se mantiene siempre actualizada. Tenga en cuenta que /run/systemd/resolve/stub-resolv.conf no debe ser utilizado directamente por las aplicaciones, sino sólo a través de un enlace simbólico desde /etc/resolv.conf. Este archivo puede ser enlazado desde /etc/resolv.conf para conectar todos los clientes locales que evitan las APIs DNS locales a systemd-resolved con la configuración correcta de los dominios de búsqueda. Se recomienda este modo de funcionamiento.
* Se proporciona un fichero estático /usr/lib/systemd/resolv.conf que lista el stub DNS 127.0.0.53 (ver arriba) como único servidor DNS. Este archivo se puede enlazar simbólicamente desde /etc/resolv.conf para conectar a systemd-resolved todos los clientes locales que omiten las API de DNS locales. Este archivo no contiene dominios de búsqueda.
* systemd-resolved mantiene el archivo /run/systemd/resolve/resolv.conf para compatibilidad con programas Linux tradicionales. Este archivo puede estar enlazado simbólicamente desde /etc/resolv.conf y se mantiene siempre actualizado, conteniendo información sobre todos los servidores DNS conocidos. Tenga en cuenta las limitaciones del formato del archivo: no conoce el concepto de servidores DNS por interfaz y, por lo tanto, sólo contiene definiciones de servidores DNS para todo el sistema. Tenga en cuenta que /run/systemd/resolve/resolv.conf no debe ser utilizado directamente por las aplicaciones, sino sólo a través de un enlace simbólico desde /etc/resolv.conf. Si se utiliza este modo de funcionamiento, los clientes locales que se salten cualquier API DNS local también se saltarán systemd-resolved y hablarán directamente con los servidores DNS conocidos.
* Alternativamente, /etc/resolv.conf puede ser gestionado por otros paquetes, en cuyo caso systemd-resolved lo leerá para los datos de configuración DNS. En este modo de operación systemd-resolved es consumidor en lugar de proveedor de este fichero de configuración.


Tenga en cuenta que el modo de funcionamiento seleccionado para este archivo se detecta de forma totalmente automática, dependiendo de si /etc/resolv.conf es un enlace simbólico a /run/systemd/resolve/resolv.conf o si enumera 127.0.0.53 como servidor DNS.







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
https://sio2sio2.github.io/doc-linux/02.conbas/09.admbasica/11.red.html
https://unix.stackexchange.com/questions/239920/how-to-set-the-fully-qualified-hostname-on-centos-7-0
https://unix.stackexchange.com/questions/186859/understand-hostname-and-etc-hosts
