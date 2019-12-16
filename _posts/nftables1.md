# Implementación de un cortafuegos personal con nftable

El objetivo de esta entrada es hacer una introducción a nftables para empezar a implementar un cortafuego personal para nuestro ordenador. 

Lo primero: [¿qué es nftables?](https://wiki.nftables.org/wiki-nftables/index.php/What_is_nftables%3F). nftables es el nuevo framework que podemos usar para analizar y clasificar los paquetes de red y nos permite la implementación de cortafuegos. Sustituye a la familia de aplicaciones {ip,ip6,arp,eb}tables. Es [recomendable el uso de nftables](https://wiki.nftables.org/wiki-nftables/index.php/Why_nftables%3F) ya que tiene una serie de [ventajas](https://wiki.nftables.org/wiki-nftables/index.php/Main_differences_with_iptables) respecto a su antecesor iptables.

## Configuración inicial de nuestro cortafuegos personal

Una de las diferencias de usar nftables es que las tablas y cadenas son totalmente configurables. En nftable lo primero que tenemos que hacer es crear las tablas (son las zonas en las que crearemos las distintas reglas del cortafuegos clasificadas en cadenas). A continuación crearemos las distintas cadenas en las tablas (que nos permite clasificar las reglas). 

### Creación de la tabla filter

Vamos a crear una tabla para filtrar los paquetes que llamaremos *filter*:

    # nft add table inet filter

Tenemos varias [familias](https://wiki.nftables.org/wiki-nftables/index.php/Nftables_families) para crear la tables, en nuestro caso hemos escogido `inet` que nos permite trabajar con ipv4 y ipv6.

Para ver la tabla que hemos creado:

    # nft list tables
    table inet filter

Puedes [leer sobre más operaciones](https://wiki.nftables.org/wiki-nftables/index.php/Configuring_tables) sobre las tablas.

### Creación de las cadenas

A continuación vamos a crear las cadenas de la table *filter*. Para crear una cadena debemos indicar varios parámetros:

* `type`: Es la clase de cadena que vamos a crear, por ejemplo `filter` (para filtrar) o `nat` (para hacer NAT).
* `hook`: Determina el tipo de paquete que se va a analizar. Por ejemplo: 
  * `input`: Paquetes que tienen como destino la misma máquina), 
  * `output`: Paquetes que tienen origen la propia máquina)
  * `forward`: Paquetes que pasan por la máquina. 
  * `prerounting`:Paquetes que entran en la máquina, tan pronto como llegan, antes de decidir qué hacer con ellos. Nos permiten hacer DNAT.
  * `postrouting`: Paquetes que están a punto de salir de la máquina. Nos permite hacer SNAT.
* `priority`: Nos permite ordenar las cadenas dentro de una misma tabla. Las cadenas más prioritarias son las que tienen un número más pequeño.
* `policy`: Se indica la política por defecto. Si el conjunto de reglas evaluadas no se ajusta al paquete se ejecuta la política por defecto.

En la tabla `filter` que hemos creado anteriormente vamos a crear dos cadenas para nuestro cortafuego personal:

    # nft add chain inet filter input { type filter hook input priority 0 \; counter \; policy accept \; }
    # nft add chain inet filter output { type filter hook output priority 0 \; counter \; policy accept \; }
    
Por ejemplo para cambiar la política por defecto a drop de las cadenas:

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

Al tener como política por defecto drop, necesitaremos configurar reglas en la cadena `input` y `output` para permitir los distintos tipos de paquetes.

Vamos a poner algunos ejemplos de reglas para nuestro cortafuegos:

### Permitimos tráfico para la interfaz loopback

Vamos a permitir todo el tráfico a la interfaz `lo`:

    # nft add rule inet filter input iifname "lo" counter accept    
    # nft add rule inet filter output oifname "lo" counter accept

Para leer sobre la gestión báisca de reglas puedes leer la siguiente [entrada de la wiki](https://wiki.nftables.org/wiki-nftables/index.php/Simple_rule_management).

Podemos ver las reglas que hemos creado:

    # nft list ruleset
    table inet filter {
    	chain input {
    		type filter hook input priority 0; policy accept;
    		iifname "lo" counter packets 0 bytes 0 accept
    	}

    	chain output {
    		type filter hook output priority 0; policy accept;
    		oifname "lo" counter packets 0 bytes 0 accept
    	}
    }
