---
title: 'Creación de un box para vagrant'
permalink: /2025/09/creacion-box-vagrant/
tags:
  - kvm 
  - libvirt 
  - Vagrant 
  - Virtualización 
---
![vagrant](https://www.josedomingo.org/pledin/assets/wp-content/uploads/2025/09/vagrant.png){: .align-center }

Vagrant es una herramienta que facilita la creación y gestión de entornos de desarrollo virtualizados de forma reproducible. Su funcionamiento se basa en el uso de **box**, imágenes preconfiguradas que sirven como punto de partida para desplegar máquinas virtuales de manera rápida y coherente. Estas box pueden estar disponibles para distintos **proveedores** de virtualización —como VirtualBox, VMware o libvirt, entre otros—, lo que permite a los desarrolladores trabajar con la tecnología que mejor se adapte a sus necesidades.

En mi caso, utilizo **libvirt** como proveedor, lo que me permite crear y administrar máquinas virtuales sobre **KVM** con un buen rendimiento. Sin embargo, en los últimos días he revisado el **Vagrant Box Registry**, el repositorio oficial de box disponibles públicamente, y me he dado cuenta que todavía no existen box oficiales de **Debian 13**, la nueva versión estable de la distribución.

Por esta razón, en esta entrada del blog vamos a presentar el proceso completo que he seguido de **creación de una box personalizada de Debian 13** para Vagrant, de forma que podamos disponer de un entorno base actualizado y listo para ser usado en nuestros proyectos.

## Creación de la imagen base

Mi primer enfoque fue crear una imagen base de Debian 13 desde cero en KVM, con la idea de construir la box partiendo de una instalación mínima totalmente limpia. Sin embargo, en la práctica me encontré con varios problemas:

* **Resolución de nombres y configuración de red:** la máquina no conseguía resolver nombres de dominio de forma estable.
* **Gestión de interfaces de red:** al parecer, Vagrant espera que la red se gestione mediante `ifupdown` y `dhclient`, pero incluso después de instalarlos y ajustar la configuración, la red no funcionaba de forma fiable en mis pruebas. Las interfaces conectadas a una red con un servidor DHCP funcionaban sin problemas, pero al conectarlas a redes privadas con direccionamiento estáticos, la configuración no se hacía de forma correcta.

Después de dedicarle un tiempo a resolver estos inconvenientes sin éxito, decidí cambiar de estrategia para simplificar el proceso y garantizar la compatibilidad con Vagrant.

El nuevo enfoque consiste en crear la máquina virtual directamente con Vagrant a partir de la box oficial **`debian/bookworm64`**, y posteriormente:

1. **Actualizar el sistema** desde Debian 12 (Bookworm) a **Debian 13**.
2. **Generalizar la máquina** eliminando datos temporales y preparando el entorno.
3. **Convertir esta máquina actualizada en una nueva box** que servirá como base para futuros proyectos.

De esta forma, aprovecho una box oficial y probada como punto de partida, pero obtengo al final una imagen totalmente actualizada a Debian 13 y lista para empaquetar.

<!--more-->

## Actualización de la máquina base

Utilizando un `Vagrantfile` con el siguiente contenido:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
    config.vm.box = "debian/bookworm64"
    config.vm.hostname="maquina_base"
    config.vm.synced_folder ".", "/vagrant", disabled: true
end
```

Creamos una nueva máquina con **Debian12**:

``` 
vagrant up
vagrant ssh
```

A continuación vamos a hacer la actualización a **Debian 13**, para ello actualizamos el sistema actual, ejecutando como `root`:

``` 
apt update && apt upgrade -y
```

A continuación, modificamos los repositorios de paquetes, para ello en el fichero `/etc/apt/source.list` cambiamos la palabra `bookworm` a `trixie` que es el nombre de la nueva versión de debian. Y a continuación actualizamos a la nueva versión:

```
apt update && apt upgrade -y
apt full-upgrade
apt autoremove
```

Reiniciamos la máquina y seguimos trabajando en ella.

## Generación de la máquina base

Ya tenemos **Debian 13** instalado en nuestra máquina base. A continuación, vamos a ejecutar distintas operaciones para preparar la máquina para convertirla en un nuevo box de Vagrant. En primer lugar podemos instalar los paquetes de las utilidades que queremos tener en nuestras máquinas, en mi caso sólo voy a instalar `curl`:

```
sudo apt install curl
```

A continuación, voy a borrar la clave pública que se ha inyectado en la creación de la máquina base, y la voy a sustituir por la **clave pública de Vagrant**. De esta manera cuando se creen nuevas máquinas se detectará que tienen una clave insegura y serán sustituidas por una nueva clave pública que se genera, junto a la clave privada, en la creación de las máquinas. Para ello, con el usuario `vagrant`:

```
curl -L https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
``` 
El siguiente paso es realizar una limpieza de la máquina, para que cuando la convirtamos a box tenga el menor tamaño posible, para ello ejecutamos:

```
sudo apt clean
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
```

El tamaño virtual del disco de la máquina que hemos creado es de 100Gb, con el comando `dd` creamos un fichero que ocupará todo el disco lleno de 0, que finalmente borraremos. Este paso, cuya ejecución es muy lenta, no es obligatorio, pero nos permite que posteriormente en el paso de compresión de la imagen consigamos que el box sea muy liviano ya que el espacio libre del disco esté lleno de facilita la compresión.

Por último eliminamos el historial del usuario `vagrant`y del `root`:

``` 
history -c
rm -f ~/.bash_history
unset HISTFILE
sudo su -
history -c
unset HISTFILE
rm -f /root/.bash_history
```

Por último podemos apagar la máquina para continuar con el proceso de conversión.

## Convertir la máquina a un nuevo box

Suponemos que la máquina que hemos creado tiene un disco que corresponde al fichero `debian12.qcow2`. En primer lugar vamos comprimir el disco utilizando la utilizada `qemu-img`. El fichero resultante lo tenemos que llamar `box.img`, para ello nos dirigimos al directorio donde esta guardado el fichero correspondiente al disco (normalmente `/var/lib/libvirt/images`, aunque puede estar en otro directorio) y como `root` ejecutamos:

``` 
qemu-img convert -c -O qcow2 debian13.qcow2 box.img
```
La opción `-c` indica la operación de compresión que se va a realizar.


El box que vamos a crear es un fichero comprimido que contiene 3 ficheros: la imagen de la máquina que se debe llamar `box.img`, un fichero de metadatos llamado `metadata.json` donde hay información del proveedor, del formato de la imagen base y su tamaño y un fichero `Vagrantfile`.

Basado en la [documentación](https://github.com/vagrant-libvirt/vagrant-libvirt/tree/main/example_box) del plugin `vagrant-libvirt`, el contenido del fichero `metadata.json` es:

```json
{
  "provider"     : "libvirt",
  "format"       : "qcow2",
  "virtual_size" : 100
}
```

Y el contenido del fichero `Vagrantfile` es:

```

# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Example configuration of new VM..
  #
  #config.vm.define :test_vm do |test_vm|
    # Box name
    #
    #test_vm.vm.box = "centos64"

    # Domain Specific Options
    #
    # See README for more info.
    #
    #test_vm.vm.provider :libvirt do |domain|
    #  domain.memory = 2048
    #  domain.cpus = 2
    #end

    # Interfaces for VM
    #
    # Networking features in the form of `config.vm.network`
    #
    #test_vm.vm.network :private_network, :ip => '10.20.30.40'
    #test_vm.vm.network :public_network, :ip => '10.20.30.41'
  #end

  # Options for Libvirt Vagrant provider.
  config.vm.provider :libvirt do |libvirt|

    # A hypervisor name to access. Different drivers can be specified, but
    # this version of provider creates KVM machines only. Some examples of
    # drivers are KVM (QEMU hardware accelerated), QEMU (QEMU emulated),
    # Xen (Xen hypervisor), lxc (Linux Containers),
    # esx (VMware ESX), vmwarews (VMware Workstation) and more. Refer to
    # documentation for available drivers (http://libvirt.org/drivers.html).
    libvirt.driver = "kvm"

    # The name of the server, where Libvirtd is running.
    # libvirt.host = "localhost"

    # If use ssh tunnel to connect to Libvirt.
    libvirt.connect_via_ssh = false

    # The username and password to access Libvirt. Password is not used when
    # connecting via ssh.
    libvirt.username = "root"
    #libvirt.password = "secret"

    # Libvirt storage pool name, where box image and instance snapshots will
    # be stored.
    libvirt.storage_pool_name = "default"

    # Set a prefix for the machines that's different than the project dir name.
    #libvirt.default_prefix = ''
  end
end
```

Una vez que tenemos los tres ficheros, lo comprimimos para crear nuestro box que hemos llamado `debian13-libvirt.box`:

```
tar cvzf debian13-libvirt.box metadata.json Vagrantfile box.img
```

## Probando nuestro nuevo box

Ya podemos utiliza nuestro box en nuestro equipo local, para ello tenemos que añadir el box a nuestro repositorio, ejecutando:

```
vagrant box add debian13-libvirt debian13-libvirt.box --provider=libvirt
```
Y crear un fichero `Vagrantfile` para crear una máquina virtual, podemos ejecutar:

``` 
vagrant init debian13-libvirt
```

## Distribuyendo nuestro box

Si queremos que otros usuarios puedan usar nuestro box (por ejemplo, mis alumnos) es necesario subirlo al catálogo oficial de boxes de vagrant. Para ello tenemos que crear una cuenta en el catálogo en la página [https://portal.cloud.hashicorp.com/vagrant/discover](https://portal.cloud.hashicorp.com/vagrant/discover).

Una vez logueado escogemos la opción **Vagrant Registry** y creamos un nuevo registro usando el botón **Create a Box Registry**, donde indicaremos un nombre y una descripción:

![vagrant](https://www.josedomingo.org/pledin/assets/wp-content/uploads/2025/09/vagrant1.png){: .align-center }

Una vez creado el registro, accedemos a él y creamos un nuevo box usando el botón `Create box`. En la primera pantalla indicaremos el nombre, que en mi caso será `josedom24/debian13`, indicaremos si es público o privado y podremos poner una descripción:

![vagrant](https://www.josedomingo.org/pledin/assets/wp-content/uploads/2025/09/vagrant2.png){: .align-center }

En la siguiente pantalla podremos indicar la versión del box y una descripción de la misma:

![vagrant](https://www.josedomingo.org/pledin/assets/wp-content/uploads/2025/09/vagrant3.png){: .align-center }

Continuamos, y en la nueva pantalla pondremos el proveedor, en nuestro caso `libvirt`, podremos subir el fichero `.box` que hemos creado e indicar la arquitectura:

![vagrant](https://www.josedomingo.org/pledin/assets/wp-content/uploads/2025/09/vagrant4.png){: .align-center }

Se sube la imagen:

![vagrant](https://www.josedomingo.org/pledin/assets/wp-content/uploads/2025/09/vagrant5png){: .align-center }

Y por último, podemos comprobar que tenemos dado de alta nuestro nuevo box en el registro:

![vagrant](https://www.josedomingo.org/pledin/assets/wp-content/uploads/2025/09/vagrant6.png){: .align-center }

Ahora cualquier usuario podría usar nuestro box, ejecutando:

```
vagrant init josedom24/debian13 --box-version 13.0.1
vagrant up
```

## Conclusiones

La creación de un box personalizado para Vagrant puede parecer un proceso complejo al inicio, pero siguiendo una estrategia adecuada es posible obtener imágenes estables y adaptadas a nuestras necesidades. En este caso, partimos de la box oficial de Debian 12, la actualizamos a Debian 13 y la preparamos para su uso como nueva box, lista para automatizar entornos de desarrollo sobre KVM/libvirt.

Además, vimos cómo publicar el resultado en el **Vagrant Box Registry**, lo que permite reutilizarlo fácilmente en distintos proyectos o compartirlo con la comunidad. Con ello disponemos de una base moderna, coherente y mantenible que simplifica enormemente el despliegue de máquinas virtuales en entornos de desarrollo.


