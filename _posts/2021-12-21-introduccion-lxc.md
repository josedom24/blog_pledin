---
title: 'Introducción a LinuX Containers (LXC)'
permalink: /2021/12/introduccion-lxc/
tags:
  - LXC
  - Virtualización
---

![lxc]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2021/12/lxc.png){: .align-center }

**LinuX Containers**, también conocido por el acrónimo **LXC**, es una tecnología de virtualización lígera o por contenedores, que es un método de virtualización en el que, sobre el núcleo del sistema operativo se ejecuta una capa de virtualización que permite que existan múltiples instancias aisladas de espacios de usuario, en lugar de solo uno. A estas instancias la llamamos **contenedores**.

Todo esto ha sido posible por el desarrollo de dos componentes del nucleo de Linux:

* Los *Grupos de Control* [cgroups](https://wiki.archlinux.org/title/Cgroups), en concreto en Debian 11 se utiliza [cgroupsv2](https://medium.com/nttlabs/cgroup-v2-596d035be4d7): que limita el uso de recursos (límite de memoria, cpu, I/O o red) para un proceso y sus hijos.
* Los *Espacios de Nombres* [namespaces](http://laurel.datsi.fi.upm.es/~ssoo/SOA/namespaces.html): que proporcionan un punto de vista diferente a un proceso (interfaces de red, procesos, usuarios, etc.).

**LXC** pertenece a los denominados contenedores de sistemas, su gestión y ciclo de vida es similar al de una máquina virtual tradicional. Está mantenido por Canonical y la página oficial es [linuxcontainers.org](https://linuxcontainers.org/)

## Instalación de LXC

Vamos a trabajar sobre una distribución GNU/Linux Debian 11. Para la instalación de LXC ejecutamos:

```bash
$ apt install lxc
```

Podemos crear contenedores LXC *privilegiados* (ejecutados como root) y *no privilegiados* (ejecutados por un usuario normal). En este articulo vamos a trabajar con contenedores *privilegiados*.

<!--more-->

## Creación de un contenedor LXC

Al crear un contenedor se bajará el sistema de archivos que formará parte de él. La primera vez que bajamos con `debootstrap` una versión de un sistema operativo se descargará un sistema de archivo mínimo del sistema (que llamamos plantilla) que servirá para crear todos los contenedores que creemos de la misma versión del sistema.

La creación de un contenedor con la última versión de debian, se realiza con la instrucción (ejecutada como `root`):

```bash
$ lxc-create -n contenedor1 -t debian -- -r bullseye
```

* `-n`: Nombre del contenedor.
* `-t`: Nombre de la plantilla.
* `-r`: Es una opción de la plantilla. Es el nombre de la versión del sistema operativo. Para ver más opciones de una plantilla ejecutamos: `lxc-create -t debian -h`.

Podemos comprobar que se ha creado un contenedor, ejecutando:

```bash
$ lxc-ls
contenedor1 
```

La plantilla que hemos descargado se guarda en `/var/cache/lxc/debian/rootfs-bullseye-amd64/`. Esta copia del sistema de archivo se utilizará cuando creemos otro contenedor con el mismo sistema operativo. El sistema de archivo del `contenedor1` se guarda en `/var/lib/lxc/contenedor1/rootfs/`.

Ahora podemos iniciar la ejecución del contenedor, comprobar que está funcionando y acceder a él:

```bash
$ lxc-start contenedor1
$ lxc-ls -f
NAME        STATE   AUTOSTART GROUPS IPV4       IPV6 UNPRIVILEGED 
contenedor1 RUNNING 0         -      10.0.3.180 -    false        
$ lxc-attach contenedor1
root@contenedor1:~# 
```

Iniciamos el contenedor con `lxc-start`, comprobamos los contenedores que tenemos creados con `lxc-ls` con la opción `-f` nos da más información (vemos que está ejecutándose, que no se ejecuta al inicio, que ha tomado una dirección ip y que es privilegiado). Por último nos hemos conectado al contenedor con `lxc-attach`.

Podemos parar el contenedor con `lxc-stop` y eliminar el contenedor con `lxc-destroy`.

Para visualizar todas las plantillas que podemos descargar, ejecutamos:

```bash
$ ls /usr/share/lxc/templates/
lxc-alpine    lxc-archlinux  lxc-centos  lxc-debian    lxc-fedora	  lxc-gentoo  lxc-oci		lxc-opensuse  lxc-plamo  lxc-sabayon	lxc-sparclinux	lxc-ubuntu	  lxc-voidlinux
lxc-altlinux  lxc-busybox    lxc-cirros  lxc-download  lxc-fedora-legacy  lxc-local   lxc-openmandriva	lxc-oracle    lxc-pld	 lxc-slackware	lxc-sshd	lxc-ubuntu-cloud
```

También puedes obtener la lista de plantillas en la página [Image server for LXC and LXD](https://uk.lxd.images.canonical.com/).

## Configuración de los contenedores LXC

El fichero `/etc/lxc/default.conf` contiene la configuración general que van a tener los contenedores que creemos. Su contenido es el siguiente:

```bash
lxc.net.0.type = veth
lxc.net.0.link = lxcbr0
lxc.net.0.flags = up

lxc.apparmor.profile = generated
lxc.apparmor.allow_nesting = 1
```

Como vemos se indica a que red se va a conectar (`lxc.net.`) (lo veremos en otra entrada del blog). Una vez creado un contenedor, el contenido de este fichero se copia a su fichero de configuración (al que se añaden otras configuraciones por defecto). Por ejemplo el fichero de configuración del contenedor `contenedor1` lo encontramos en el fichero `/var/lib/lxc/contenedor1/config`. en este caso, su contenido es:

```bash
lxc.net.0.type = veth
lxc.net.0.hwaddr = 00:16:3e:cf:8f:c3
lxc.net.0.link = lxcbr0
lxc.net.0.flags = up
lxc.apparmor.profile = generated
lxc.apparmor.allow_nesting = 1
lxc.rootfs.path = dir:/var/lib/lxc/contenedor1/rootfs

# Common configuration
lxc.include = /usr/share/lxc/config/debian.common.conf

# Container specific configuration
lxc.tty.max = 4
lxc.uts.name = contenedor1
lxc.arch = amd64
lxc.pty.max = 1024
```
Vemos que se han copiado los parámetros de la configuración general (`/etc/lxc/default.conf`) y se han añadido nuevos parámetros: número máximo de terminales (`lxc.tty.max`,`lxc.pty.max`), nombre del contenedor (`lxc.uts.name`), arquitectura (`lxc.pty.max`), ubicación del sistema de fichero (`lxc.rootfs.path`), ...

Puedes ver los distintos parámetros que podemos incluir en la [documentación oficial](https://linuxcontainers.org/lxc/manpages/man5/lxc.container.conf.5.html). Por ejemplo si queremos que los contenedores se inicien automáticamente al iniciar el host pondríamos:

```
lxc.start.auto = 1
```

Recuerda que tenemos dos opciones:

1. Si escribimos el parámetro en la configuración general, en el fichero `/etc/lxc/default.conf`, afectará a los contenedores que se creen nuevos.
2. Si queremos modificar la configuración de un contenedor ya creado, tenemos que incluir el parámetro en su fichero de configuración, por ejemplo para el `contenedor1` en `/var/lib/lxc/contenedor1/config`.

## Obteniendo información de un contenedor

Para obtener información de un contenedor podemos ejecutar:

```bash
$ lxc-info contenedor1
Name:           contenedor1
State:          RUNNING
PID:            12587
IP:             10.0.3.180
Link:           vethuLaHzY
 TX bytes:      1.70 KiB
 RX bytes:      3.80 KiB
 Total bytes:   5.50 KiB
```

Con la opción `-i` sólo nos da  la dirección ip, con la opción `-S` nos da la estadística de información enviada y recibida por la interfaz de red y con la opción `-s` nos da información del estado.


## Ejecución de comandos en un contenedor

Podemos ejecutar un comando en un contenedor que se esté ejecutando de la siguiente manera:

```bash
$ lxc-attach contenedor1 -- ls -al
```

si el contenedor está apagado, lo haríamos de a siguiente forma:

```bash
$ lxc-stop contenedor1
$ lxc-execute contenedor1 -- ls -al
```

## Limitando los recursos para los contenedores LXC

Por defectos los contenedores LXC pueden usar todos los recursos de CPU, RAM, disco del host. Podemos limitar estos recursos. El componente del nucleo que posibilita limitar los recursos para cada contenedor son los *Grupos de control* [cgroups](https://wiki.archlinux.org/title/Cgroups), en concreto en Debian 11 se utiliza [cgroupsv2](https://medium.com/nttlabs/cgroup-v2-596d035be4d7).

Vamos a limitar el uso de memoria RAM (512Mb) y de número de procesadores (1 CPU: la CPU 0) (en la máquina donde estoy corriendo los contenedores tenemos "gb de RAM y 2 CPUs), para ello en el fichero de configuración del `contenedor1` indicamos los siguientes parámetros:

```bash
lxc.cgroup2.memory.max = 512M
lxc.cgroup2.cpuset.cpus = 0
```

Reiniciamos el contenedor y comprobamos que se ha llevado a efecto el cambio:

```bash
$ lxc-stop contenedor1
$ lxc-start contenedor1

$ lxc-attach contenedor1 -- free -h
               total        used        free      shared  buff/cache   available
Mem:           512Mi       6.0Mi       505Mi       0.0Ki       0.0Ki       505Mi

$ lxc-attach contenedor1 -- cat /proc/cpuinfo 
processor	: 0
...
```

Aparece un sólo procesador.

## Conclusiones

Actualmente el trabajo con contenedores es muy beneficioso para la administración de un sistema informático, ya que podemos aislar espacios separados (procesos, usuarios, servicios, sistemas de ficheros, redes,...) de manera muy sencillo y no un nivel de aislamiento aceptable. En la próxima entrada vamos a hacer una introducción a las redes y al almacenamiento en los contenedores linux: [Introducción a las redes y almacenamiento en LXC](https://www.josedomingo.org/pledin/2021/12/lxc-redes-almacenamiento/).




