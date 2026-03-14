---
title: 'Reglas de NAT con nftables'
permalink: /2020/01/nftables-cortafuegos-perimetral-nat/
tags:
  - Cortafuegos
  - nftables
---

![nftables]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2019/12/nftables.png){: .align-center }

En la entrada anterior hicimos una introducción a la [implementación de un cortafuegos personal con nftables](https://www.josedomingo.org/pledin/2019/12/nftables-cortafuegos-personal/), en este artículo vamos a comenzar a implementar un cortafuegos perimetral.

## Configuración inicial de nuestro cortafuegos perimetral

Un cortafuegos personal nos controla las comunicaciones que entran y salen de un ordenador (usamos las cadenas `input` y `output` de la tabla `filter`). En un cortafuegos perimetral estamos gestionando las conexiones que entran y salen de una o varias redes de ordenadores, o visto de otra manera, las conexiones que atraviesan el router que da acceso a estas redes, por lo tanto, lo más usual, es que el cortafuegos se implemente en el router. Para controlar los paquetes que atraviesan el router utilizaremos la cadena `forward` de la tabla `filter`.

El cortafuegos perimetral que nosotros vamos a configurar sería el más simple, y es el que controla el tráfico para una red local:

![nftables]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/01/perimetral.png){: .align-center }

Sin embargo el cortafuegos perimetral puede controlar el tráfico de varias redes locales, por ejemplo cuando tenemos en una red los equipos de nuestra red local y en otra red los servidores que exponen servicios al exterior (por ejemplo el servidor web). A esta última red se le suele llamar zona desmilitarizada (DMZ) y en ese caso tendríamos un escenario como este:

![nftables]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/01/dmz.png){: .align-center }

Además de la función de filtrado, con nftables podemos hacer NAT, por ejemplo para permitir que los equipos de la red local puedan comunicarse con otra red (SNAT, source NAT) o para que un equipo externo acceda a una máquina de la red local (DNAT, destination NAT). Para ello utilizaremos la tabla `nat`.

## Configuración de NAT con nftables

NAT son las siglas del inglés **N**etwork **A**ddress **T**ranslation o traducción de direcciones de red y es un mecanismo que se usa ampliamente hoy en día. Existen diferentes tipos:

* **Source NAT**: Se cambia la dirección IP de origen, es la situación más utilizada cuando estamos utilizando una dirección IP privada en una red local y establecemos una conexión con un equipo de Internet. Un equipo de la red (normalmente la puerta de enlace) se encarga de cambiar la dirección IP privada origen por la dirección IP pública, para que el equipo de Internet pueda contestar. También es conocido como *IP masquerading*, pero podemos distinguir dos casos:
    * SNAT estático: Cuando la dirección IP pública que sustituye a la IP origen es estática (SNAT también significa Static NAT).
    * SNAT dinámico o MASQUERADE: Cuando la dirección IP pública que sustituye a la IP origen es dinámica, caso bastante habitual en conexiones a Internet domésticas.
* **Destination NAT o port forwarding**: En este caso se utiliza cuando tenemos algún servidor en una máquina detrás del dispositivo de NAT. En este caso será un equipo externo el que inicie la conexión, ya que solicitará un determinado servicio y el dispositivo de NAT debe modificar la dirección IP destino. 
* **PAT (Port Address translation)**: Modifica específicamente el puerto (origen o destino) en lugar de la dirección IP. Por ejemplo si queremos reenviar todas las peticiones web que lleguen al puerto 80/tcp al mismo equipo pero al puerto 8080/tcp.

<!--more-->

## Creación de la tabla nat

Vamos a crear una tabla para crear las reglas de NAT que llamaremos *nat* (suponemos que nuestro cortafuegos ya tiene creada una tabla *filter*):

    # nft add table nat

Para ver las tablas que tenemos:

    # nft list tables
    table inet filter
    table ip nat

Como vemos hemos creado la tabla *nat* de la familia ip ya que vamos a trabajar con direccionamiento ipv4.

## Creación de las cadenas

A continuación vamos a crear las cadenas de la tabla *nat*:

    # nft add chain nat prerouting { type nat hook prerouting priority 0 \; }
    # nft add chain nat postrouting { type nat hook postrouting priority 100 \; }
    
Como podemos observar hemos indicado menos prioridad en la cadena *postrouting* (mientras menor sea el número, mayor es su prioridad) para que las reglas de dicha cadena se ejecuten después de las reglas de *prerouting*.

Finalmente ya hemos configurado nuestra tabla *nat*:

    # nft list chains
    ...
    table ip nat {
	    chain prerouting {
		    type nat hook prerouting priority 0; policy accept;
	    }
	    chain postrouting {
		    type nat hook postrouting priority 100; policy accept;
	    }
    ...

## Configuración del enrutamiento

El equipo donde estamos construyendo nuestro cortafuegos también hace de router por lo tanto para que los paquetes que vienen o van a los ordenadores de la red local se puedan enrutar, necesitamos activar el *bit de forwarding*:

    echo 1 > /proc/sys/net/ipv4/ip_forward

Esta activación se borra cuando se apaga el equipo, ya que el directorio `/proc` está en memoria. Para que dicha activación permanezca lo habitual es definirla en el fichero `/etc/sysctl.conf`, asegurándonos de que exista una línea como:

    net.ipv4.ip_forward=1

## POSTROUTING

Para que nuestros equipos de la red local tengan salida al exterior (por ejemplo a internet) tenemos que configurar el SNAT en nuestro cortafuegos. Tendríamos dos casos:

* SNAT estático, por ejemplo la ip pública del router es una IP fija (por ejemplo la `80.58.1.14`):

        nft add rule ip nat postrouting oifname "eth0" ip saddr 192.168.100.0/24 counter snat to 80.58.1.14

* SNAT dinámico o enmascaramiento, es el caso que tenemos en nuestra infraestructura, la ip del router es dinámica:

        nft add rule ip nat postrouting oifname "eth0" ip saddr 192.168.100.0/24 counter masquerade

Veamos cómo hemos definido la regla:

* `add rule ip nat postrouting`: El cambio de la dirección de origen hay que hacerlo antes de enrutar el paquete a internet, por lo tanto usamos la cadena `postrouting`.
* `oifname "eth0"`: Esta regla se aplica a los paquetes que salen por `eth0`.
* `ip saddr 192.168.100.0/24`: Esta regla se aplica a paquetes que provienen de la red `192.168.100.0/24`.

Como acciones que vamos a ejecutar cuando el paquete cumpla estas reglas serán:

* `counter`: Para que cuente los paquetes que cumplen la regla.
* `masquerade`: Estamos realizando enmascaramiento ya que la ip pública del router es dinámica.

Al introducir esta última regla ya tendríamos conexión a internet desde un equipo de la LAN:

    debian@lan:~$ ping 1.1.1.1
    PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
    64 bytes from 1.1.1.1: icmp_seq=5 ttl=54 time=41.5 ms
    ...

## PREROUTING

El único equipo de la red local que es accesible desde Internet es el dispositivo de NAT (como hemos indicado suele ser el router) a través de su dirección IP pública (por ejemplo la `80.56.1.14`). Utilizando NAT, en concreto DNAT, podemos hacer que la conexión a la IP pública desde el exterior a un determinado puerto se redirija a un servidor en la red local que realmente esté ofreciendo el servicio.

Supongamos que instalamos un servidor web en un equipo de la red local con dirección IP `192.168.100.10` y queremos que sea accesible desde Internet, tendremos que modificar las peticiones que lleguen al puerto 80/tcp del equipo que tiene la dirección IP pública y que cambie la dirección IP destino `80.56.1.14` por `192.168.100.10`, esto se hace con la siguiente regla:

    nft add rule ip nat prerouting iifname "eth0" tcp dport 80 counter dnat to 192.168.100.10

Explicación de los parámetros:
* `add rule ip nat prerouting`: Se añade la regla a la cadena `prerouting`, donde las reglas se aplican antes de tomar la decisión de enrutamiento, así se tomará la decisión de encaminamiento con la nueva dirección IP destino.
* `tcp dport 80`: Esta regla se ejecutará sobre paquetes que llegan al puerto 80/tcp.
* `iifname "eth0"`:... y entran por la interfaz `eth0`.

Como acciones que vamos a ejecutar cuando el paquete cumpla estas reglas serán:

* `counter`: Para que cuente los paquetes que cumplen la regla.
* `dnat to 192.168.100.10`: Cambia la dirección IP destino (inicialmente 80.56.1.14) a 192.168.100.10


Si desde intenet accedemos con un navegador web a la URL `http://80.56.1.14/` estaríamos accediendo al servidor web instalado en la máquina con IP `192.168.100.1`.

Hay algunos servicios que permiten utilizar puertos diferentes a los estándar, como por ejemplo ssh, ya que podemos acceder a un servidor por ssh utilizando un puerto distinto al 22/tcp. Como nftables nos permite no sólo modificar la dirección IP destino sino también el puerto destino, podríamos tener esta regla:

    nft add rule ip nat prerouting iifname "eth0" tcp dport 2222 counter dnat to 192.168.100.10:22

En este caso si accedemos por ssh a nuestro router (a su IP pública) al puerto 2222 estaríamos accediendo al servidor ssh (puerto 22/tcp) de la máquina `192.168.100.10`:

    ssh -p2222  debian@80.56.1.14
    ...
    debian@lan:~$ 

## Listados de reglas NAT

Para terminar veamos un resumen de las reglas que hemos creado:

    nft list ruleset
    
    table inet filter {
    }
    table ip nat {
    	chain postrouting {
    		type nat hook postrouting priority 100; policy accept;
    		oifname "eth0" ip saddr 192.168.100.0/24 counter packets 39 bytes 2648 masquerade
    	}

    	chain prerouting {
    		type nat hook prerouting priority 0; policy accept;
    		iifname "eth0" tcp dport http counter packets 4 bytes 240 dnat to 192.168.100.10
    		iifname "eth0" tcp dport 2222 counter packets 1 bytes 60 dnat to 192.168.100.10:ssh
    	}
    }
    
## Guardar reglas NAT

Estas tablas, cadenas y reglas que hemos generado se encuentran actualmente almacenadas en memoria, por lo que en caso de llevar a cabo un reinicio o apagado, se perderían, por lo que si queremos que perduren, tendríamos que almacenarlas en el fichero de configuración de nftables, ejecutando para ello el comando:

    nft list ruleset > /etc/nftables.conf

## Conclusiones

En este artículo hemos introducido la configuración de NAT con nftables. Hay que tener en cuenta que en un entorno en producción, además de la reglas NAT que necesitemos, tendremos que controlar los paquetes que llegan o salen de la máquina cortafuegos y de las máquinas de la red local. Ese tema es el que abordaremos en la siguiente entrada del blog.
