---
title: 'Implementación de un cortafuegos perimetral con nftables'
permalink: /2020/01/nftables-cortafuegos-perimetral-filtrado/
tags:
  - Cortafuegos
  - nftables
---

![nftables]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2019/12/nftables.png){: .align-center }

En la entrada anterior introducimos el concepto de cortafuegos perimetral e hicimos una introducción a la [implementación de reglas NAT con nftables](https://www.josedomingo.org/pledin/2020/01/nftables-cortafuegos-perimetral-nat/), en este artículo vamos a concluir la implementación del cortafuego añadiendo a las reglas NAT, las reglas de filtrado necesarias para aumentar la seguridad de nuestra infraestructura.

## Nuestro escenario

El cortafuegos perimetral que nosotros vamos a configurar sería el más simple, y es el que controla el tráfico para una red local:

![nftables]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/01/perimetral.png){: .align-center }

Tendremos dos clases de conexiones que tenemos que controlar:

* Las que entran y salen del propio cortafuegos, en este caso utilizaremos las cadenas `input` y `output` de la tabla `filter`, de forma similar a como trabajamos en el artículo: [Implementación de un cortafuegos personal con nftables](https://www.josedomingo.org/pledin/2019/12/nftables-cortafuegos-personal/).
* Las que entran o salen de los ordenadores de nuestra red local, es decir, las que atraviesan el cortafuegos. Em este caso las reglas de filtrado se crearán en la cadena `forward` de la tabla `filter`.

<!--more-->

## Creación de las cadenas

Suponemos que ya tenemos definida una tabla `filter` de la familia `inet`, por lo tanto tendremos que crear nuestras tres cadenas:

    # nft add chain inet filter input { type filter hook input priority 0 \; counter \; policy drop \; }
    # nft add chain inet filter output { type filter hook output priority 0 \; counter \; policy drop \; }
    # nft add chain inet filter forward { type filter hook forward priority 0 \; counter \; policy drop \; }

Podemos observar que hemos usado la política `drop`, por lo que por defecto todo el tráfico está denegado. Vemos las cadenas creadas:

    # nft list chains

    table inet filter {
    	chain input {
    		type filter hook input priority 0; policy drop;
    	}
    	chain output {
    		type filter hook output priority 0; policy drop;
    	}
    	chain forward {
    		type filter hook forward priority 0; policy drop;
    	}
    }

## Filtrado de conexiones al cortafuegos

Como se ha indicado para permitir las conexiones que entran o salen al cortafuegos, utilizaremos reglas en las cadenas `input` y `output` de la tabla `filter`. Veamos algunos ejemplos, aunque puedes ver más en el [artículo](https://www.josedomingo.org/pledin/2019/12/nftables-cortafuegos-personal/) citado anteriormente.

### Permitimos tráfico para la interfaz loopback

Vamos a permitir todo el tráfico a la interfaz `lo`:

    # nft add rule inet filter input iifname "lo" counter accept    
    # nft add rule inet filter output oifname "lo" counter accept

### Permitir peticiones y respuestas protocolo ICMP

En concreto vamos a permitir la posibilidad que puedan hacer ping a nuestra máquina:

    # nft add rule inet filter output oifname "eth0" icmp type echo-reply counter accept
    # nft add rule inet filter input iifname "eth0" icmp type echo-request counter accept

### Permitir el acceso por ssh a nuestra máquina

 Vamos a permitir la conexión ssh desde la red 172.22.0.0/16:

    # nft add rule inet filter input ip saddr 172.22.0.0/16 tcp dport 22 ct state new,established  counter accept
    # nft add rule inet filter output ip daddr 172.22.0.0/16 tcp sport 22 ct state established  counter accept

### Permitir consultas DNS

    # nft add rule inet filter output oifname "eth0" udp dport 53 ct state new,established  counter accept
    # nft add rule inet filter input iifname "eth0" udp sport 53 ct state established  counter accept


### Permitir tráfico HTTP/HTTPS

    # nft add rule inet filter output oifname "eth0" ip protocol tcp tcp dport { 80,443 } ct state new,established  counter accept
    # nft add rule inet filter input iifname "eth0" ip protocol tcp tcp sport { 80,443 } ct state established  counter accept



## Conclusiones

