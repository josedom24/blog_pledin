---
title: 'Introducción a las redes y almacenamiento en LXC'
permalink: /2021/12/lxc-redes-almacenamiento/
tags:
  - LXC
  - Virtualización
---

![lxc]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2021/12/lxc2.png){: .align-center }

En el anterior artículo: [Introducción a LinuX Containers (LXC)](https://www.josedomingo.org/pledin/2021/12/introduccion-lxc/) estudiamos los aspectos fundamentales de la gestión de los contenedores LXC. En este artículo vamos a profundizar en las redes y en el almacenamiento que podemos configurar en los **LinuX Containers**.

# Redes en LXC

LXC nos ofrece distintos [mecanismos](https://linuxcontainers.org/lxd/docs/master/networks/) para conectar nuestros contenedores a una red. En este artículo nos vamos a centrar en las conexiones de tipo **bridge**. Tenemos dos posibilidades:

* Podemos crear manualmente el *bridge* o usar libvirt para su creación (podemos crear [distintos tipos de redes con libvirt](https://wiki.libvirt.org/page/Networking)).
* Podemos usar `lxc-net`, servicio ofrecido por LXC, que nos facilita la creación de un bridge, que por defecto se llama `lxcbr0`, y que nos ofrece una una red de tipo NAT con los servicios de DHCP y DNS.

## Redes con lxc-net

Veamos en primer lugar la segunda opción. Como en el artículo anterior, este manual se basa en la distribución GNU/Linux Debian 11. En versiones anteriores de LXC no había configurada una red por defecto para conectar nuestros contenedores. En la versión actual y utilizando `lxc-net` se crea un bridge llamado `lxcbr0` que nos ofrece una red de tipo NAT con los servicios DHCP y DNS. Veamos su configuración:

En primer lugar, en el fichero `/etc/default/lxc-net` se configura los parámetros de la red que se va a crear:

```bash
USE_LXC_BRIDGE="true"
...
```

Con el parámetro `USE_LXC_BRIDGE="true"` activamos la funcionalidad ofrecida por el servicio `lxc-net`: gestionar la red creada.
No hay más parámetros porque se coge la configuración por defecto que es la siguiente:

```bash
LXC_BRIDGE="lxcbr0"
LXC_ADDR="10.0.3.1"
LXC_NETMASK="255.255.255.0"
LXC_NETWORK="10.0.3.0/24"
LXC_DHCP_RANGE="10.0.3.2,10.0.3.254"
LXC_DHCP_MAX="253"
```

<!--more-->

Es decir, se crea el bridge `lxcbr0`, el direccionamiento de la red que se crea es `10.0.3.0/24` y podemos indicar el rango de direcciones que se reparten. Si queremos cambiar algunos de estos parámetros habrá que introducirlos en el fichero de configuración y reiniciar el servicio `lxc-net`.

Vemos que se crea un proceso `dnsmasq` que ofrece el servidor DHCP y DNS a los contenedores:

```bash
$ ps aux|grep dnsmasq
dnsmasq      433  0.0  0.0  13440   392 ?        S    19:32   0:00 dnsmasq --conf-file=/etc/lxc/dhcp.conf \ 
-u dnsmasq --strict-order --bind-interfaces --pid-file=/run/lxc/dnsmasq.pid --listen-address 10.0.3.1 \
--dhcp-range 10.0.3.2,10.0.3.254 --dhcp-lease-max=253 --dhcp-no-override --except-interface=lo \
--interface=lxcbr0 --dhcp-leasefile=/var/lib/misc/dnsmasq.lxcbr0.leases --dhcp-authoritative
```

Además se crea una regla iptables para que nuestro host haga SNAT para que los contenedores tengan salida al exterior:

```bash
$ iptables -L -n -v -t nat
...
Chain POSTROUTING (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         
    1    40 MASQUERADE  all  --  *      *       10.0.3.0/24         !10.0.3.0/24
```

### Conexión de los contenedores a `lxcbr0`

La configuración por defecto posibilita que los contenedores que creemos se conecten a esta red. Lo podemos ver en la configuración general, en el fichero `/etc/lxc/default.conf`:

```bash
lxc.net.0.type = veth
lxc.net.0.link = lxcbr0
lxc.net.0.flags = up
...
```

Si hemos creado un contenedor llamado `contenedor1` recibirá esta configuración que podremos encontrar en su fichero de configuración `/var/lib/lxc/contenedor1/config`:

```bash
lxc.net.0.type = veth
lxc.net.0.hwaddr = 00:16:3e:cf:8f:c3
lxc.net.0.link = lxcbr0
lxc.net.0.flags = up
...
```

Por lo tanto podemos comprobar que el `contenedor1` esta conectado a sea red. Por ejemplo si mostramos los contenedores que hemos creado, vemos que ha recibido una ip en ese rango:

```bash
$ lxc-ls -f
NAME        STATE   AUTOSTART GROUPS IPV4       IPV6 UNPRIVILEGED 
contenedor1 RUNNING 1         -      10.0.3.180 -    false        
```

Si accedemos al contenedor podemos hacer varias comprobaciones:

```
$ lxc-attach contenedor1
root@contenedor1:~# ip a
...
2: eth0@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    inet 10.0.3.180/24 brd 10.0.3.255 scope global dynamic eth0
...

root@contenedor1:~# ip r
default via 10.0.3.1 dev eth0 
10.0.3.0/24 dev eth0 proto kernel scope link src 10.0.3.180 

root@contenedor1:~# cat /etc/resolv.conf 
nameserver 10.0.3.1

root@contenedor1:~# apt install iputils-ping
...
root@contenedor1:~# ping www.josedomingo.org
PING endor.josedomingo.org (37.187.119.60) 56(84) bytes of data.
64 bytes from ns330309.ip-37-187-119.eu (37.187.119.60): icmp_seq=1 ttl=49 time=28.7 ms
...
```

1. Comprobamos que se ha configurado con la ip `10.0.3.180`.
2. Vemos que la puerta de enlace es la `10.0.3.1` que corresponde a nuestra máquina física.
3. Del mismo modo la máquina física es el servidor DNS.
4. Hemos instalado la herramienta `ping` y comprobamos que tenemos resolución y acceso al exterior.

### Configuración del servidor DHCP y DNS al usar lxc-net

Como hemos visto, el servicio `lxc-net` crea un bridge y configura un servicio `dnsmasq` para ofrecer DHCP y DNS a los contenedores conectados a ese bridge. Por lo tanto podemos configurar el servicio `dnsmasq`, para ello vamos a descomentar la línea que encontramos en el fichero de configuración `/etc/default/lxc-net`:

```
USE_LXC_BRIDGE="true"
LXC_DHCP_CONFILE=/etc/dnsmasq.conf
```

Con el parámetro `LXC_DHCP_CONFILE` indicamos el fichero de configuración del servicio `dnsmasq` que se va a crear (el fichero de configuración se puede llamar `dnsmasq.conf` o tener otro nombre). 

Por ejemplo si queremos realizar una reserva para otorgar la misma ip al `contenedor1`, crearíamos el fichero `/etc/dnsmasq.conf` con el siguiente contenido:

```
dhcp-host=contenedor1,10.0.3.10
```

Reiniciamos el servicio `lxc-net`:

```bash
$ systemctl restart lxc-net
```

Y al reiniciar el contenedor comprobamos que ha tomado la ip que hemos indicado en la reserva:

```bash
$ lxc-stop -r contenedor1
$ lxc-ls -f
NAME        STATE   AUTOSTART GROUPS IPV4                       IPV6 UNPRIVILEGED 
contenedor1 RUNNING 1         -      10.0.3.10                  -    false       
```

Otro ejemplo: si queremos enviar un nombre de dominio a los contenedores, añadimos el fichero `/etc/default/lxc-net` la línea:

```
LXC_DOMAIN="example.org"
```

Reiniciamos el servicio `lxc-net`, reiniciamos el contenedor y comprobamos su FQDN:

```
$ systemctl restart lxc-net
$ lxc-stop -r contenedor1
$ lxc-attach contenedor1
root@contenedor1:~# hostname -f
contenedor1.example.org
```

## Conexión de los contenedores a un bridge existente

Imaginemos que tenemos en nuestro host instalado libvirt para manejar los recursos de KVM/Qemu y hemos creado una red con `virsh` de tipo NAT, que ha creado un bridge llamado `virbr0`, con las siguientes características:

```
$ virsh net-dumpxml default
<network>
  <name>default</name>
  <uuid>c411a5a1-f998-42a9-bc8a-9a9052fc36f6</uuid>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:fc:32:a2'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
```

Podemos modificar el fichero de configuración por defecto `/etc/lxc/default.conf`, indicando el bridge `virbr0`:

```bash
lxc.net.0.type = veth
lxc.net.0.link = virbr0
lxc.net.0.flags = up
...
```

Todos los nuevos contenedores que creemos se conectarán a la red `default`:

```bash
$ lxc-create -n contenedor2 -t debian -- -r bullseye
$ lxc-start contenedor2
$ lxc-ls -f
NAME        STATE   AUTOSTART GROUPS IPV4            IPV6 UNPRIVILEGED 
contenedor1 RUNNING 1         -      10.0.3.10       -    false        
contenedor2 RUNNING 1         -      192.168.122.228 -    false        
```

Vemos como el `contenedor2` ha tomado en una ip de la red `default`.

Si quisieramos cambiar la conexión del un contenedor ya existente deberiamos hacer la modificación en su fichero de configuración: `/var/lib/lxc/<NOMBRE_CONTENEDOR>/config` y reiniciar el contenedor.

También podríamos conectar el `contenedor1` a la red `default`, para ello vamos a añadir la información de la conexión en su fichero de configuración `/var/lib/lxc/contenedor1/config`:

```
lxc.net.0.type = veth
lxc.net.0.hwaddr = 00:16:3e:cf:8f:c3
lxc.net.0.link = lxcbr0
lxc.net.0.flags = up

lxc.net.1.type = veth
lxc.net.1.hwaddr = 00:16:3e:cf:8f:d3
lxc.net.1.link = virbr0
lxc.net.1.flags = up
...
```

Indicamos la segunda conexión utilizando el nombre de los parámetros como `lxc.net.1.*`. Además hemos cambiado la mac de la segunda tarjeta de red. Ahora reiniciamos y accedemos al contenedor:

```
$ lxc-stop -r contenedor1
$ lxc-attach contenedor1
root@contenedor1:~# apt install nano
root@contenedor1:~# nano /etc/network/interfaces
```

Configuramos la segunda interfaz de red:

```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet dhcp
```

Y obtenemos una nueva dirección ip en la nueva red:

```
root@contenedor1:~# ifup eth1
root@contenedor1:~# ip a
...
2: eth0@if13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
...
    inet 10.0.3.10/24 brd 10.0.3.255 scope global dynamic eth0
...
3: eth1@if14: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
...
    inet 192.168.122.196/24 brd 192.168.122.255 scope global dynamic eth1
...
```

Si listamos los contenedores que tenemos, podemos ver las dos direcciones ip:

```bash
$ lxc-ls -f
NAME        STATE   AUTOSTART GROUPS IPV4                        IPV6 UNPRIVILEGED 
contenedor1 RUNNING 1         -      10.0.3.10, 192.168.122.196  -    false        
contenedor2 RUNNING 1         -      192.168.122.228             -    false        
```

# Almacenamiento en LXC

Veamos como montar un directorio del host en un contenedor. Imaginemos que tenemos el directorio `/opt/contenedor1` con un fichero `index.html` y lo queremos montar en el `contenedor1` en el directorio `/srv/www`. Tenemos que tener en cuenta los siguiente:

El directorio de montaje debe existir en el contenedor:

```
$ lxc-attach contenedor1
root@contenedor1:~# cd /srv
root@contenedor1:/srv# mkdir www
```

En el fichero de configuración del contenedor (`/var/lib/lxc/contenedor1/config`) añadimos la siguiente línea:

```
lxc.mount.entry=/opt/contenedor1 srv/www none bind 0 0
```

Hay que tener en cuenta que al indicar el directorio de montaje hay que usar una ruta relativa (es relativa al directorio donde se encuentra el sistema de fichero del contenedor, en este caso `/var/lib/lxc/contenedor1/rootfs/`).

Reiniciamos el contenedor y comprobamos que se ha montado el directorio de forma correcta:

```
$ lxc-stop contenedor1
$ lxc-start contenedor1
$ lxc-attach contenedor1
root@contenedor1:~# cd /srv/www
root@contenedor1:/srv/www# ls
index.html
```

## Conclusiones

Con los dos últimos artículos hemos hecho una breve descripción a los aspectos más interesantes del trabajo con **LinuX Containers** (LXC). Como siempre para seguir estudiando lo mejor es estudiar la [documentación oficial](https://linuxcontainers.org/lxc/introduction/#LXC-Manpages).





