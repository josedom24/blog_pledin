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

    # nft add table nat

Para ver las tablas que tenemos:

    # nft list tables
    table inet filter
    table ip nat

Como vemos hemos creado la tabla *bat* de la familia ip ya que vamos a trabajar con direccionamiento ipv4.

<!--more-->

### Creación de las cadenas

A continuación vamos a crear las cadenas de la tabla *nat*:

    # nft add chain nat prerouting { type nat hook prerouting priority 0 \; }
    # nft add chain nat postrouting { type nat hook postrouting priority 100 \; }
    
Como podemos observar hemos indicado más prioridad en la cadena *postrouting* para que las reglas se ejecuten después de las reglas de *prerouting*.

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



## Conclusiones

