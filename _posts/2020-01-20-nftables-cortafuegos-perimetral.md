---
title: 'Implementación de un cortafuegos perimetral con nftables'
permalink: /2020/01/nftables-cortafuegos-perimetral/
tags:
  - Cortafuegos
  - nftables
---

![nftables]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2019/12/nftables.png){: .align-center }

En la entrada anterior hicimos una introducción a la [implamentación de un cortafuegos personal con nftables](https://www.josedomingo.org/pledin/2019/12/nftables-cortafuegos-personal/), en este artículo vamos a implementar un cortafuegos perimetral.

## Configuración inicial de nuestro cortafuegos perimetral

Un cortafuego personal nos controla las comunicaciones que entran y salen de un ordenador (usamos las cadenas `input` y `output` de la tabla filter). En un cortafuegos perimetral estamos gestionando las comunicaciones que entran y salen de una o varias redes de ordenadores, o visto de otra manera, las comunicaciones que atraviesan el router que da acceso a estas redes, por lo tanto, lo más usual, es que el cortafuegos se implemente en el router. Para controlar los paquetes que atraviesan el router utilizaremos la cadena `forward` de la tabla `filter`.

El cortafuegos perimetral que nosotros vamos a configurar sería el más simple, y es el que controla el tráfico para una red local:

imagen perimetral

Sin embargo el cortafuegos perimetral puede controlar el tráfico de varias redes loscales, por ejemplo cuando tenemos en una red los equipos de nuestra red local y en otra red los servidores que exponen servicios al exterior (por ejemplo el servidor web). A esta última red se le suele llama zona desmilitarizada (DMZ) y es este caso tendríamos un escenario como este:

imagen perimetral DMZ

Además de la función de filtrado, con nftables podemos hacer NAT, por ejemplo para permitir que los equipos de la red local puedan comunicarse con otra red (SNAT, source NAT) o para que un equipo externo acceda a una máquina de la red local (DNAT, destination NAT). Para ello utilizaremos la tabla `nat`.

## Configuración de NAT con nftables

NAT son las siglas del inglés network address translation o traducción de direcciones de red y es un mecanismo que se usa ampliamente hoy en día. Existen diferentes tipos:

* **Source NAT**: Se cambia la dirección IP de origen, es la situación más utilizada cuando estamos utilizando una dirección IP privada (RFC 1918) en una red local y establecemos una conexión con un equipo de Internet. Un equipo de la red (normalmente la puerta de enlace) se encarga de cambiar la dirección IP privada origen por la dirección IP pública, para que el equipo de Internet pueda contestar. También es conocido como *IP masquerading*, pero podemos distinguir dos casos:*
    * SNAT: Cuando la dirección IP pública que sustituye a la IP origen es estática (SNAT también significa Static NAT).
    * MASQUERADE: Cuando la dirección IP pública que sustituye a la IP origen es dinámica, caso bastante habitual en conexiones a Internet domésticas.
* **Destination NAT o port forwarding**: En este caso se utiliza cuando tenemos algún servidor en una máquina detrás del dispositivo de NAT. En este caso será un equipo externo el que inicie la conexión, ya que solicitará un determinado servicio y el dispositivo de NAT debe modificar la dirección IP destino. 
* **PAT (Port Address translation)**: Modifica específicamente el puerto (origen o destino) en lugar de la dirección IP. Por ejemplo si queremos reenviar todas las peticiones web que lleguen al puerto 80/tcp al mismo equipo pero al puerto 8080/tcp.

### Creación de la tabla nat

Vamos a crear una tabla para crear las reglas de NAT que llamaremos *nat* (suponemos que nuestro cortafuegos ya tiene creada una tabla *filter*):

    # nft add table inet nat

Para ver las tablas que tenemos:

    # nft list tables
    table inet filter
    table inet nat

<!--more-->

### Creación de las cadenas

A continuación vamos a crear las cadenas de la tabla *filter*. Para crear una cadena debemos indicar varios parámetros:

* `type`: Es la clase de cadena que vamos a crear, por ejemplo `filter` (para filtrar) o `nat` (para hacer NAT).
* `hook`: Determina el tipo de paquete que se va a analizar. Por ejemplo: 
  * `input`: Paquetes que tienen como destino la misma máquina. 
  * `output`: Paquetes que tienen origen la propia máquina.
  * `forward`: Paquetes que pasan por la máquina. 
  * `prerounting`: Paquetes que entran en la máquina antes de enrutarlos. Nos permiten hacer DNAT.
  * `postrouting`: Paquetes que están a punto de salir de la máquina. Nos permite hacer SNAT.
* `priority`: Nos permite ordenar las cadenas dentro de una misma tabla. Las cadenas más prioritarias son las que tienen un número más pequeño.
* `policy`: Se indica la política por defecto. Si el conjunto de reglas evaluadas no se ajusta al paquete se ejecuta la política por defecto. Por defecto la política es `accept` por lo que se aceptan todos los paquetes que no se ajusten al conjunto de reglas. Cuando desarrollamos un cortafuegos la política suele ser `drop` no aceptando los paquetes que no se ajustan a ninguna regla.

En la tabla `filter` que hemos creado anteriormente vamos a crear dos cadenas para nuestro cortafuego personal:

    # nft add chain inet filter input { type filter hook input priority 0 \; counter \; policy accept \; }
    # nft add chain inet filter output { type filter hook output priority 0 \; counter \; policy accept \; }
    
Por ejemplo para cambiar la política por defecto a `drop` de las cadenas creadas:

    # nft chain inet filter input { policy drop \; }
    # nft chain inet filter output { policy drop \; }

Puedes leer la wiki para ver [más operaciones sobre cadenas](https://wiki.nftables.org/wiki-nftables/index.php/Configuring_chains).

Finalmente ya hemos configurado nuestra tabla para filtrar paquetes y las cadenas que vamos a utilizar:

    # nft list chains
    table inet filter {
    	chain input {
    		type filter hook input priority 0; policy drop;
    	}
    	chain output {
    		type filter hook output priority 0; policy drop;
    	}
    }

## Creación de reglas

Una vez que tenemos configurado la tabla y las cadenas de nuestro cortafuegos, podemos empezar a configurar reglas para configurar nuestro cortafuegos personal, que va filtrar la comunicación a nuestra propía máquina.

Al tener como política por defecto `drop`, necesitaremos configurar reglas en la cadena `input` y `output` para gestionar los paquetes que salen de la máquina y los que entran.

Para leer sobre la gestión básica de reglas puedes leer la siguiente [entrada de la wiki](https://wiki.nftables.org/wiki-nftables/index.php/Simple_rule_management).


Vamos a poner algunos ejemplos de reglas para nuestro cortafuegos:

### Permitimos tráfico para la interfaz loopback

Vamos a permitir todo el tráfico a la interfaz `lo`:

    # nft add rule inet filter input iifname "lo" counter accept    
    # nft add rule inet filter output oifname "lo" counter accept

Veamos cómo hemos definido la regla:

* `iifname "lo"`: Indicamos los paquetes que entren (cadena `input`) por la interfaz de entrada `lo`.
* `oifname "lo"`: Indicamos los paquetes que salgan (cadena `output`) por la interfaz de salida `lo`.

Como acciones que vamos a ejecutar cuando el paquete cumpla estas reglas serán:

* `counter`: Para que cuente los paquetes que cumplen la regla.
* `accept`: Los paquetes se aceptan.

Podemos ver las reglas que hemos creado:

    # nft list ruleset
    
    table inet filter {
    	chain input {
    		type filter hook input priority 0; policy drop;
    		iifname "lo" counter packets 0 bytes 0 accept
    	}

    	chain output {
    		type filter hook output priority 0; policy drop;
    		oifname "lo" counter packets 0 bytes 0 accept
    	}
    }

### Permitir peticiones y respuestas protocolo ICMP

En concreto vamos a permitir la posibilidad que puedan hacer ping a nuestra máquina:

    # nft add rule inet filter output oifname "eth0" icmp type echo-reply counter accept
    # nft add rule inet filter input iifname "eth0" icmp type echo-request counter accept

Veamos las nuevas expresiones que hemos usado para estas reglas:

* `icmp type echo-reply`: Se permiten las peticiones de ping (protocolo icmp) que se hagan por `eth0`.
* `icmp type echo-request`: se permiten las respuestas a las peticiones ping que entren por `eth0`.


### Permitir el acceso por ssh a nuestra máquina

 Vamos a permitir la conexión ssh desde la red 172.22.0.0/16:

    # nft add rule inet filter input ip saddr 172.22.0.0/16 tcp dport 22 ct state new,established  counter accept
    # nft add rule inet filter output ip daddr 172.22.0.0/16 tcp sport 22 ct state established  counter accept

En este caso estamos usando las siguientes expresiones para crear estas reglas:

En la regla que hemos definido en la cadena `input` permitimos los paquetes que provienen de una determinada red, que tienen como puerto de destino el 22 y que son nuevas conexiones o conexiones establecidas anteriormente:

* `ip saddr 172.22.0.0/16`: Se indica la dirección de red de origen.
* `tcp dport 22`: se indica que el puerto de destino será el 22 (ssh).
* `ct state new,established`: Controlamos el estado de la conexión, indicando que la conexión sea nueva o este establecida con anterioridad.

En la regla que hemos definido en la cadena `output` permitimos los paquetes que se dirigen a la misma red, con puerto de origen 22 y que son conexiones establecidas.

* `ip daddr 172.22.0.0/16`: Se indica la dirección de red de destino.
* `tcp sport 22`: se indica que el puerto de origen será el 22 (ssh).
* `ct state established`: Controlamos el estado de la conexión, indicando que la conexión ya está establecida.

### Permitir consultas DNS

    # nft add rule inet filter output oifname "eth0" udp dport 53 ct state new,established  counter accept
    # nft add rule inet filter input iifname "eth0" udp sport 53 ct state established  counter accept

En este caso para permitir las consultas DNS tenemos que controlar el protocolo UDP:

* `udp dport 53`: Indicamos que el puerto de destino es el 53(DNS) del protocolo UDP.
* `udp dport 53`: Indicamos que el puerto de origen es el 53(DNS) del protocolo UDP.

### Permitir tráfico HTTP/HTTPS

    # nft add rule inet filter output oifname "eth0" ip protocol tcp tcp dport { 80,443 } ct state new,established  counter accept
    # nft add rule inet filter input iifname "eth0" ip protocol tcp tcp sport { 80,443 } ct state established  counter accept

Las expresiones que hemos usado en este caso serían:

* `ip protocol tcp`: Indicando el protocolo TCP.
* `tcp dport { 80,443 }`: Indicamos los puertos de destino: 80 (HTTP) y 443 (HTTPS).
* `tcp sport { 80,443 }`: Indicamos los puertos de origen: 80 (HTTP) y 443 (HTTPS).

### Permitir acceso a nuestro servidor Web

Si suponemos que en nuestra máquina tenemos un  servidor web atendiendo peticiones en el puerto 80:

    # nft add rule inet filter output oifname "eth0" tcp sport 80 ct state established counter accept
    # nft add rule inet filter input iifname "eth0" tcp dport 80 ct state new,established counter accept

Finalmente podemos ver todas las reglas que hemos creado:

    # nft list ruleset
    table inet filter {
    	chain input {
    		type filter hook input priority 0; policy drop;
    		iifname "lo" counter packets 0 bytes 0 accept
    		iifname "eth0" icmp type echo-request counter packets 2 bytes 168 accept
    		ip saddr 172.22.0.0/16 tcp dport ssh ct state established,new counter packets 569 bytes 38264 accept
    		iifname "eth0" udp sport domain ct state established counter packets 0 bytes 0 accept
    		iifname "eth0" ip protocol tcp tcp sport { http, https } ct state established counter packets 0 bytes 0 accept
    		iifname "eth0" tcp dport http ct state established,new counter packets 0 bytes 0 accept
    	}

    	chain output {
    		type filter hook output priority 0; policy drop;
    		oifname "lo" counter packets 0 bytes 0 accept
    		oifname "eth0" icmp type echo-reply counter packets 2 bytes 168 accept
    		ip daddr 172.22.0.0/16 tcp sport ssh ct state established counter packets 460 bytes 54392 accept
    		oifname "eth0" udp dport domain ct state established,new counter packets 0 bytes 0 accept
    		oifname "eth0" ip protocol tcp tcp dport { http, https } ct state established,new counter packets 0 bytes 0 accept
    		oifname "eth0" tcp sport http ct state established counter packets 0 bytes 0 accept
    	}
    }

## Borrado de reglas

Una posibilidad para poder borrar una determinada regla es mostrar las reglas con su `handle` (identificador de la regla):

    # nft list ruleset -a
    table inet filter { # handle 1
    	chain input { # handle 1
    		type filter hook input priority 0; policy drop;
    		...
    		iifname "eth0" icmp type echo-request counter packets 2 bytes 168 accept # handle 9
    		...

Por ejemplo para borrar la regla que hemos mostrado en el ejemplo anterior:

    # nft delete rule inet filter input handle 9

## Traducción de reglas de iptables a nftables

Si todavía no estamos acostumbrados a la sintáxis de nftables pero dominamos iptables, tenemos a nuestra disposición la utilidad `iptables-translate` que nos posibilita la traducción. Por ejemplo si tenemos la siguiente regla iptables:

    # iptables -A INTPUT -i eth0 -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT

Podemos traducirla de la siguiente manera:

    # iptables-translate -A INTPUT -i eth0 -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT
    nft add rule ip filter INTPUT iifname "eth0" udp sport 53 ct state established counter accept

Hay que tener en cuenta dos detalles:

* La regla que que hemos generado es para un tabla de la familia `ip`, nostros estamos usando la familia `inet`.
* El nombre de las cadenas se devuelven en mayúsculas, nosotros hemos creado las cadenas en minúsculas.

Por la tento la regla traducida quedaría de la siguiente manera:

    # nft add rule inet filter input iifname "eth0" udp sport 53 ct state established counter accept

## Copia de seguridad de nuestro cortafuegos

Cuando reiniciamos nuestra máquina el cortafuego no mantiene el conjunto de reglas, por lo que tenemos que guardar las reglas para posteriormente recuperlas. Siguiendo el enlace de la [wiki](https://wiki.nftables.org/wiki-nftables/index.php/Operations_at_ruleset_level) podemos hacer una copia de seguridad del cortafuegos de la siguiente manera:

    # echo "nft flush ruleset" > backup.nft
    # nft list ruleset >> backup.nft

Posteriormente podemos ejecutar el siguiente comando para recuperar las reglas del cortafuego:

    # nft -f backup.nft

## Conclusiones

En este artículo se ha hecho una breve introducción a nftables, una aplicación que nos posibilita la implementación de cortafuegos. En nuestro caso hemos introducido un ejemplo para desarrollar un cortafuegos personal que controle el tráfico de una sóla máquina. En la siguiente entrada del blog haremos una introducción de como desarrollar un cortafuegos perimetral con nftables que nos controle el tráfico a un conjunto de máquinas.
