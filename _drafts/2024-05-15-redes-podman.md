---
title: 'Redes en contenedores rootless con Podman'
permalink: /2024/05/redes-rootless-podman/
tags:
  - Podman
  - Virtualización
---

![podman]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/04/podman-logo4.png){: .align-center }

Podman nos ofrece distintos mecanismos de red para ofrecer conectividad al contenedor:

* **netavark**: Podman 4.0 utiliza un driver de red llamado [netavark](https://github.com/containers/netavark) para ofrecer a los contenedores una dirección IP enrutable. El driver netavark sigue las especificaciones establecidas por el proyecto [CNI](https://www.cni.dev/) (Container Network Interface) que estandariza los medios de comunicación de red que utilizan los contenedores OCI.
* **slirp4netns**: Cuando usamos contenedores rootless, tenemos una limitación debida a que los usuarios sin privilegios no pueden modificar el espacio de nombres de red del host. Por lo tanto necesitamos un mecanismos en el espacio de usuario que haga de proxy para conexiones de red del contenedor. 
    * En Podman 4, se utiliza, por defecto el proyecto [slirp4netns](https://github.com/rootless-containers/slirp4netns) que nos proporciona conectividad a los contenedores pero sin ofrecerles una dirección IP enrutable. 
    * En Podman 5 este proyecto se ha sustituido por otro proyecto con las mismas características llamado [pasta](https://passt.top/passt/about/).

## Tipos de redes en Podman

* **Red Bridge**: Nos permite que los contenedores estén conectados a una red privada, con un direccionamiento privado conectado al host mediante un Linux Bridge. 
    * Nos permiten aislar los contenedores del acceso exterior.
    * Los contenedores conectados a un red **bridge** tienen acceso a internet por medio de una regla SNAT. 
    * Usamos el parámetro `-p` en `podman run` para exponer algún puerto. Se crea una regla DNAT para tener acceso al puerto.
* **Red Host**:  La pila de red de ese contenedor no está aislada del host, es decir, el contenedor no tiene asignada su propia dirección IP. Por ejemplo, si ejecutas un contenedor que ofrece su servicio en al puerto 80/tcp y utilizas el modo de red host, la aplicación del contenedor estará disponible en el puerto 80/tcp de la dirección IP del host.
* **Redes macvlan o ipvlan**: Son configuraciones más avanzadas de red, donde se permite que el contenedor esté conectado directamente a la red donde está conectado el host. La diferencia entre las dos, es que mientras macvlan permite la comunicación entre contenedores, ipvlan aísla completamente a cada contenedor.
* **Red slirp4netns**: Es la opción por defecto cuando trabajamos con contenedores rootless. Crea un túnel desde el host al contenedor para reenviar el tráfico.

<!--more-->

## Redes bridge

Existen dos tipos de redes bridge:

* La red **bridge** creada por defecto por Podman para que de forma predeterminada los contenedores tengan conectividad.
* Y las **redes bridge definidas por el usuario**.

### Red bridge por defecto

* Es creada durante la instalación de Podman.
    ```
    $ sudo podman network ls
    NETWORK ID    NAME        DRIVER
    2f259bab93aa  podman      bridge
    ```
* También es accesible con un usuario sin privilegio: `podman network ls`.
* Por defecto los contenedores rootful que creamos se conectan a la red de tipo bridge llamada **podman**.
* Podemos conectar contenedores rootless a esta red, con la opción `--network=podman` de `podman run`.
* Se crea en el host un *Linux Bridge* llamado **podman0**.
* El direccionamiento de esta red es 10.88.0.0/16.
* Por compatibilidad con las red por defecto que crea Docker, esta red no tiene un servidor DNS activo.

![podman]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/05/defecto.png){: .align-center }

### Red bridge definida por el usuario

* Nos permiten aislar los distintos contenedores que tengo en distintas redes privadas, de tal manera que desde cada una de las redes solo podamos acceder a los equipos de esa misma red.
* Nos proporcionan **resolución DNS** entre los contenedores, por lo que los contenedores pueden conectar a otros contenedores usando su nombre.
* Me permiten **gestionar de manera más segura el aislamiento de los contenedores**, ya que si no indico una red al arrancar un contenedor éste se incluye en la red por defecto donde pueden convivir servicios que no tengan nada que ver.
* Nos proporcionan **más control sobre la configuración de las redes**. Los contenedores de la red por defecto comparten todos la misma configuración de red (MTU, reglas de cortafuegos, etc...).
* Es importante que nuestros contenedores en producción se ejecuten conectados a una red bridge definida por el usuario.

![podman]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/05/usuario.png){: .align-center }

## Red slirp4netns

* Es el mecanismo de red usado en los contenedores rootless por defecto.
* Crea un entorno de red aislado para el contenedor y utilizando el módulo `slirp` del kernel para realizar la traducción de direcciones de red (NAT), lo que permite que el contenedor acceda a internet a través de la conexión de red del host.
* Crea un dispositivo TAP en el espacio de nombres de red del contenedor y se conecta a la pila TCP/IP en modo usuario. 
* Al utilizar este tipo de red, el usuario sin privilegios tendrá que usar puertos no privilegiados, mayores que el 1024.
* Uno de los inconvenientes de slirp4netns es que los contenedores están completamente aislados unos de otros, por lo que tendrán que utilizar los puertos expuestos para comunicarse.

![podman]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/05/rootless.png){: .align-center }

## Redes en contenedores rootless

Cuando trabajamos con contenedores rootless tenemos varios mecanismos para ofrecer conectividad al contenedor:

### Red slirp4netns

Es el mecanismo de red que se utiliza por defecto. 

El proyecto [**slirp4netns**](https://github.com/rootless-containers/slirp4netns) crea un entorno de red aislado para el contenedor y utilizando el módulo `slirp` del kernel para realizar la traducción de direcciones de red (NAT), lo que permite que el contenedor acceda a internet a través de la conexión de red del host.

Tenemos algunas limitaciones, la más importante es que los usuarios no privilegiados no pueden usar puertos privilegiados (menores que 1024). 

```
$ podman run -dt --name webserver -p 80:80 quay.io/libpod/banner
Error: rootlessport cannot expose privileged port 80, you can add 'net.ipv4.ip_unprivileged_port_start=80' to /etc/sysctl.conf (currently 1024), or choose a larger port number (>= 1024): listen tcp 0.0.0.0:80: bind: permission denied
```

Podríamos cambiar ese comportamiento cambiando con `sysctl` el valor de `net.ipv4.ip_unprivileged_port_start` que por defecto tiene el valor de 1024.

```
sysctl net.ipv4.ip_unprivileged_port_start
net.ipv4.ip_unprivileged_port_start = 1024
```

Volvemos a crear el contenedor, teniendo en cuenta lo anterior:

```
$ podman run -dt --name webserver -p 8080:80 quay.io/libpod/banner
```

Y comprobamos su configuración de red:

```
$ podman exec webserver ip a
...
2: tap0: <BROADCAST,UP,LOWER_UP> mtu 65520 qdisc fq_codel state UNKNOWN qlen 1000
    link/ether 86:b3:30:2a:85:0e brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.100/24 brd 10.0.2.255 scope global tap0

$ podman exec webserver ip r
default via 10.0.2.2 dev tap0 
...
```
Vemos que se ha creado una interfaz virtual `tap0` con dirección 10.0.2.100 y puerta de enlace 10.0.2.2, que nos proporciona una conexión con la red del host, para permitir que este contenedor tenga conectividad con el exterior.

A continuación, vamos a crear un nuevo contenedor y volvemos a comprobar su configuración de red:

```
$ podman run -it --name cliente alpine
/ # ip a
...
2: tap0: <BROADCAST,UP,LOWER_UP> mtu 65520 qdisc fq_codel state UNKNOWN qlen 1000
    link/ether 12:ef:67:bd:21:1f brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.100/24 brd 10.0.2.255 scope global tap0
/ # ip r
default via 10.0.2.2 dev tap0 
```

Como podemos comprobar dicho contenedor tiene la misma configuración de red que el anterior. Los dos contenedores utilizan el mismo **espacio de nombres de red**, como consecuencia **los contenedores están completamente aislados unos de otros**, por lo que tendrán que utilizar los puertos expuestos para comunicarse y la dirección IP del host (en mi caso la 10.0.0.67):

```
/ # apk add curl
/ # curl http://10.0.0.67:8080
   ___          __              
  / _ \___  ___/ /_ _  ___ ____ 
 / ___/ _ \/ _  /  ' \/ _ `/ _ \
/_/   \___/\_,_/_/_/_/\_,_/_//_/
```

#### Red por defecto en contenedores rootless con Podman 5.0

En la nueva versión de Podman, se ha cambiado el mecanismo de red de slirp4netns a [pasta](https://passt.top/passt/about/#pasta-pack-a-subtle-tap-abstraction). Este nuevo mecanismo ofrece mejor rendimiento y más funciones.

En este caso la configuración de red de todos los contenedores rootless sería la siguiente:

```
$ podman run -it --rm alpine ip a
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 65520 qdisc fq_codel state UNKNOWN qlen 1000
    link/ether 42:61:0e:89:08:41 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.40/24 brd 10.0.0.255 scope global noprefixroute eth0
...
$ podman run -it --rm alpine ip r
default via 10.0.0.1 dev eth0  metric 100 
10.0.0.0/24 dev eth0 scope link  metric 100 
...
```

### Red bridge por defecto

Podemos conectar nuestros contenedores rootless a la red bridge por defecto, indicándolo con el parámetro `--network` y el nombre de la red por defecto: `podman`.

```
$ podman run -d -p 8080:80 --network=podman --name contenedor1 quay.io/libpod/banner

$ $ podman exec -it contenedor1 ip a
...
2: eth0@if5: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP qlen 1000
    link/ether ee:93:61:6b:47:ca brd ff:ff:ff:ff:ff:ff
    inet 10.88.0.3/16 brd 10.88.255.255 scope global eth0
...
```

Con el parámetro `-p` o `--publish` indicamos el mapero de puiertos: cuando accedemos al puerto 8080/tcp de la dirección IP del host, se reenviá la petición al puerto 80/tcp del contenedor. Podemos comprobamos el acceso al servidor web:

```
$ curl http://localhost:8080
```

### Red bridge definida por el usuario

Un usuario sin privilegios también pueden definir sus propias redes bridge. Estas redes se crearán en el espacio de nombres de red del usuario:

```
$ podman network create mi_red

$ podman run -d -p 8081:80 --name servidorweb --network mi_red docker.io/nginx
$ podman run -it --name cliente --network mi_red alpine
```

Y comprobamos la conectividad entre contenedores usando su nombre, ya que hemos indicado que este tipo de redes nos porporcionan un **servidor DNS**:

```
# ping servidorweb
PING servidorweb (10.89.2.3): 56 data bytes
64 bytes from 10.89.2.3: seq=0 ttl=42 time=0.370 ms
...
```
Una característica que tenemos que tener en cuenta, es que esta nueva red se ha creado en el espacio de nombres de red del usuario, por lo tanto desde el host no tenemos conectividad con el contenedor:

```
$ ping 10.89.2.3
PING 10.89.2.3 (10.89.2.3) 56(84) bytes of data.
...
```

Sin embargo, si podemos acceder a la IP del host y al puerto que hemos mapeado para acceder a la aplicación:

```
$ curl http://localhost:8081
```

En este caso el *Linux Bridge* que se ha creado con la nueva red, no se ha creado en el espacio de red del host. Podemos comprobar que el bridge `podman3` no se ha creado en el host ejecutando `sudo ip a`.

Sin embargo, podemos acceder al espacio de nombres de red del usuario ejecutando la siguiente instrucción:

```
$ podman unshare --rootless-netns ip a
...
2: tap0: <BROADCAST,UP,LOWER_UP> mtu 65520 qdisc fq_codel state UNKNOWN group default qlen 1000
    link/ether 76:eb:49:a9:64:2a brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.100/24 brd 10.0.2.255 scope global tap0
   ...
3: podman3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 1a:3a:83:8d:1e:b9 brd ff:ff:ff:ff:ff:ff
    inet 10.89.2.1/24 brd 10.89.2.255 scope global podman3
    ...
```

Con el parámetro `--rootless-netns` de `podman unshare` accedemos al espacio de nombres de red del usuario, donde comprobamos la interfaz de red de tipo TAP usada por slirp4netns, y los Linux Bridge que se van creando con cada una de las redes bridge definidas por el usuario sin privilegios.

Por ejemplo, accediendo al espacio de nombres de red del usuario, comprobamos que si tenemos conectividad con el contenedor:

```
$ podman unshare --rootless-netns ping 10.89.2.3
PING 10.89.2.3 (10.89.2.3) 56(84) bytes of data.
64 bytes from 10.89.2.3: icmp_seq=1 ttl=64 time=0.135 ms
...
```

### Red host

Si al crear un contenedor indicamos `--network=host`, la pila de red de ese contenedor no está aislada del host, es decir, el contenedor no tiene asignada su propia dirección IP. Por ejemplo, si ejecutas un contenedor que ofrece su servicio en al puerto 80/tcp y utilizas el modo de red host, la aplicación del contenedor estará disponible en el puerto 80/tcp de la dirección IP del host.

Este tipo conexión a red también lo podemos usar con contenedor rootless. Sin embargo, tenemos que tener en cuenta las limitaciones que tenemos al crear contenedores rootless, en este caso un usuario sin privilegios no puede usar puertos no privilegiados, por debajo del 1024. Por lo tanto vamos a usar una imagen de nginx que ejecuta el servidor nginx con un usuario sin privilegios y por lo tanto lo levanta en el puerto 8080/tcp.

Vamos a usar la imagen de nginx ofrecida por la empresa Bitnami, esta imagen tienen como característica que los procesos que se ejecutan al crear el contenedor son ejecutados por usuarios no privilegiados.

```
$ podman run -d --network host --name my_nginx docker.io/bitnami/nginx
```

Y podemos acceder al puerto 8080/tcp para comprobar que podemos acceder al servicio web.
