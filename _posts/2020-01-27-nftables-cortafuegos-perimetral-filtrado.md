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

    # nft add rule inet filter input ip saddr 172.22.0.0/16 tcp dport 22 ct state new,established counter accept
    # nft add rule inet filter output ip daddr 172.22.0.0/16 tcp sport 22 ct state established counter accept

### Permitir consultas DNS

    # nft add rule inet filter output oifname "eth0" udp dport 53 ct state new,established counter accept
    # nft add rule inet filter input iifname "eth0" udp sport 53 ct state established counter accept


### Permitir tráfico HTTP/HTTPS

    # nft add rule inet filter output oifname "eth0" ip protocol tcp tcp dport { 80,443 } ct state new,established counter accept
    # nft add rule inet filter input iifname "eth0" ip protocol tcp tcp sport { 80,443 } ct state established counter accept

## Filtrado de conexiones a los equipos de la red local

Aunque ya hemos configurado SNAT (en este [artículo](https://www.josedomingo.org/pledin/2020/01/nftables-cortafuegos-perimetral-nat/)), como hemos puesto la política por defecto `forward` a `drop`, los equipos de la LAN están incomunicados, ya que no permitimos que ningún paquete pase por el cortafuego. Por lo tanto ahora tenemos que ir configurando los pares de reglas (forward en ambas direcciones) para ir permitiendo distintos protocolos, puerto... a la LAN.

En este caso vamos a permitir las conexiones que pueden establecer de o hacía los ordenadores de la red local, en este caso vamos a crear reglas en la cadena `forward` de la tabla `filter`. 

Vamos a ir estudiando distintos ejemplos:

### Permitir hacer ping desde la LAN

Para que la LAN haga ping al exterior los paquetes ICMP tiene que estar permitidos que pasen por el cortafuego:

    # nft add rule inet filter forward iifname "eth1" oifname "eth0" ip saddr 192.168.100.0/24 icmp type echo-request counter accept
    # nft add rule inet filter forward iifname "eth0" oifname "eth1" ip daddr 192.168.100.0/24 icmp type echo-reply counter accept


### Consultas y respuestas DNS desde la LAN

    # nft add rule inet filter forward iifname "eth1" oifname "eth0" ip saddr 192.168.100.0/24 udp dport 53 ct state new,established counter accept
    # nft add rule inet filter forward iifname "eth0" oifname "eth1" ip daddr 192.168.100.0/24 udp sport 53 ct state established counter accept

### Permitimos la navegación web desde la LAN

    # nft add rule inet filter forward iifname "eth1" oifname "eth0" ip protocol tcp ip saddr 192.168.100.0/24 tcp dport { 80,443} ct state new,established counter accept
    # nft add rule inet filter forward iifname "eth0" oifname "eth1" ip protocol tcp ip daddr 192.168.100.0/24 tcp sport { 80,443} ct state established counter accept

### Permitimos el acceso a nuestro servidor web de la LAN desde el exterior

Como veíamos el [artículo](https://www.josedomingo.org/pledin/2020/01/nftables-cortafuegos-perimetral-nat/) teníamos configurado DNAT para acceder al servidor web de la máquina de la LAN `192.168.100.10`. Pero al tener política por defecto `drop` en la cadena `forward` tendremos que permitir dicho tráfico:

    # nft add rule inet filter forward iifname "eth0" oifname "eth1" ip daddr 192.168.100.0/24 tcp dport 80 ct state new,established counter accept
    # nft add rule inet filter forward iifname "eth1" oifname "eth0" ip saddr 192.168.100.0/24 tcp sport 80 ct state established counter accept

## Listado de reglas

Para finalizar podemos ver la configuración completa (NAT y filtrado) de nuestro cortafuegos perimetral:

    # nft list ruleset 

    table inet filter {
    	chain input {
    		type filter hook input priority 0; policy drop;
    		ip saddr 172.23.0.0/16 tcp dport ssh ct state established,new counter packets 2615 bytes 208304 accept
    		iifname "lo" counter packets 0 bytes 0 accept
    		iifname "eth0" icmp type echo-request counter packets 0 bytes 0 accept
    		ip saddr 172.22.0.0/16 tcp dport ssh ct state established,new counter packets 0 bytes 0 accept
    		iifname "eth0" udp sport domain ct state established counter packets 0 bytes 0 accept
    		iifname "eth0" ip protocol tcp tcp sport { http, https } ct state established counter packets 0 bytes 0 accept
    	}

    	chain output {
    		type filter hook output priority 0; policy drop;
    		ip daddr 172.23.0.0/16 tcp sport ssh ct state established counter packets 1522 bytes 203036 accept
    		oifname "lo" counter packets 0 bytes 0 accept
    		oifname "eth0" icmp type echo-reply counter packets 0 bytes 0 accept
    		ip daddr 172.22.0.0/16 tcp sport ssh ct state established counter packets 0 bytes 0 accept
    		oifname "eth0" udp dport domain ct state established,new counter packets 0 bytes 0 accept
    		oifname "eth0" ip protocol tcp tcp dport { http, https } ct state established,new counter packets 0 bytes 0 accept
    	}

    	chain forward {
    		type filter hook forward priority 0; policy drop;
    		iifname "eth1" oifname "eth0" ip saddr 192.168.100.0/24 icmp type echo-request counter packets 0 bytes 0 accept
    		iifname "eth0" oifname "eth1" ip daddr 192.168.100.0/24 icmp type echo-reply counter packets 0 bytes 0 accept
    		iifname "eth1" oifname "eth0" ip saddr 192.168.100.0/24 udp dport domain ct state established,new counter packets 0 bytes 0 accept
    		iifname "eth0" oifname "eth1" ip daddr 192.168.100.0/24 udp sport domain ct state established counter packets 0 bytes 0 accept
    		iifname "eth1" oifname "eth0" ip protocol tcp ip saddr 192.168.100.0/24 tcp dport { http, https } ct state established,new counter  packets 0 bytes 0 accept
    		iifname "eth0" oifname "eth1" ip protocol tcp ip daddr 192.168.100.0/24 tcp sport { http, https } ct state established counter  packets 0 bytes 0 accept
    		iifname "eth0" oifname "eth1" ip daddr 192.168.100.0/24 tcp dport http ct state established,new counter packets 7 bytes 798 accept
    		iifname "eth1" oifname "eth0" ip saddr 192.168.100.0/24 tcp sport http ct state established counter packets 6 bytes 3702 accept
    	}
    }
    table ip nat {
    	chain postrouting {
    		type nat hook postrouting priority 100; policy accept;
    		oifname "eth0" ip saddr 192.168.100.0/24 counter packets 91 bytes 6600 masquerade
    	}

    	chain prerouting {
    		type nat hook prerouting priority 0; policy accept;
    		iifname "eth0" tcp dport http counter packets 17 bytes 1020 dnat to 192.168.100.10
    		iifname "eth0" tcp dport 2222 counter packets 2 bytes 120 dnat to 192.168.100.10:ssh
    	}
    }

## Conclusiones

En estos últimos artículos hemos hecho una introducción a la implementación de cortafuegos de `nftables`. Es muy conveniente que si quieres seguir profundizando en el tema te estudies la [documentación de nftable](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page).