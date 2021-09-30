---
title: 'Introdución al uso de vagrant + libvirt + QEMU/KVM'
permalink: /2021/09/introduccion-vagrant-libvirt/
tags:
  - Vagrant
  - libvirt
  - kvm
  - Virtualización
---

![staticman]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2021/09/vagrant-kvm.png){: .align-center }

[QEMU-KVM](https://www.linux-kvm.org/page/Main_Page) (en adelante KVM) es el sistema de virtualización completa utilizado por defecto en sistemas GNU/Linux. KVM proporciona principalmente el módulo del kérnel `kvm.ko` que está integrado desde hace años en el kérnel Linux y utiliza las herramientas del espacio de usuario del proyecto QEMU (de ahí que el nombre correcto del sistema de virtualización completo sea QEMU-KVM).

Es muy habitual no utilizar KVM directamente, sino hacerlo a través de [libvirt](https://libvirt.org/), que es una API de virtualización y un proyecto independiente, que nos permite interactuar con varios sistemas de virtualización, entre ellos KVM.

Vagrant es una aplicación libre desarrollada en ruby que nos permite crear y personalizar entornos de desarrollo livianos, reproducibles y portables. Vagrant nos permite automatizar la creación y gestión de máquinas virtuales. Las máquinas virtuales creadas por vagrant se pueden ejecutar con distintos gestores de máquinas virtuales (oficialmente VirtualBox, VMWare e Hyper-V).

El objetivo principal de vagrant es aproximar los entornos de desarrollo y producción, de esta manera el desarrollador tiene a su disposición una manera  muy sencilla de desplegar una infraestructura similar a la que se va a tener en entornos de producción. A los administradores de sistemas les facilita la creación de infraestructuras de prueba y desarrollo.

Enm esta entrada del blog vamos a introducir el uso de vagrant con el plugin `vagrant-libvirt` que no posibilita montar los escenarios en vagrant usando la virtualización proporcionada por KVM. Más concretamente, Vagrant utilizando la API de libvirt gestionara los recursos en el sistema de virtualización KVM.

<!--more-->

## Vagrant y libvirt

Aunque no de manera oficial, podemos crear escenarios en Vagrant usando libvirt + QEMU/KVM. Para ello puede seguir la documentación del plugin de vagrant [Vagrant Libvirt Provider](https://github.com/vagrant-libvirt/vagrant-libvirt).

### Instalación de vagrant

En una máquina donde tengamos ya instalado libvirt + QEMU/kvm, instalamos vagrant:

```bash
root@maquina:~$ apt install vagrant
```

Por defecto se instalaría por dependencia el paquete `vagrant-libvirt` con lo que tendríamos instalado el plugin, si por cualquier razón tuvieramos problemas, también podríamos activar el plugin directamente de la siguiente manera:

```bash
root@maquina:~$ vagrant plugin install vagrant-libvirt
```

## Instalación de un "box" debian/bullseye64

Los box son las imágenes de máquinas virtuales prediseñadas que utiliza Vagrant. Podemos obtenerlas del repositorio oficial [Vagrant Cloud](https://app.vagrantup.com/boxes/search). Para nuestro ejemplo nos descargamos el box de Debian bullseye de 64 bits, esto lo hacemos un usuario sin privilegios:

```bash
usuario@maquina:~$ vagrant box add debian/bullseye64
```

**Es importante fijarnos que lo estamos haciendo con usuarios sin privilegios. Cada usuario tendrás sus box propios.**

Puedo ver la lista de boxes que tengo instalada en mi usuario ejecutando la siguiente instrucción:
    
```bash
usuario@maquina:~$ vagrant box list
```

## Creación de una máquina virtual

1. Nos creamos un directorio y dentro vamos a crear el fichero `Vagrantfile`, podemos crear uno vacío con la instrucción:
        
    ```bash
    usuario@maquina:~/vagrant$ vagrant init
    ```
        
2. Modificamos el fichero Vagrantfile y los dejamos de la siguiente manera:

    ```ruby
    Vagrant.configure("2") do |config|
      config.vm.box = "debian/bullseye64"
      config.vm.hostname="prueba"
    end
    ```
    
3. Iniciamos la máquina:

    ```bash
    usuario@maquina:~/vagrant$ vagrant up
    ```
        
4. Para acceder a la instancia:
  	
    ```bash
    usuario@maquina:~/vagrant$ vagrant ssh
    ```
    	      
5. Suspender, apagar o destruir:
    	
    ```bash
    usuario@maquina:~/vagrant$ vagrant suspend
    usuario@maquina:~/vagrant$ vagrant halt
    usuario@maquina:~/vagrant$ vagrant destroy
    ```

### ¿Qué recursos se han creado en KVM?

1. Una vez creado el escenario podemos comprobar que se ha creado una máquina, usamos el cliente `virsh`:

    ```bash
    usuario@maquina:~/vagrant$ virsh -c qemu:///system list
     Id   Nombre        Estado
    --------------------------------
     3    ej1_default   ejecutando
    ```

2. Como podemos probar la máquina tiene acceso al exterior. Aunque no hayamos configurado ninguna conexión de red, esta máquina se ha conectado a un red de tipo NAT que ha creado vagrant y que podemos ver usando el cliente `virsh`:

    ```bash
    usuario@maquina:~/vagrant$ virsh -c qemu:///system net-list --all
    Nombre            Estado     Inicio automático   Persistente
    ---------------------------------------------------------------
    ...
    vagrant-libvirt   activo     no                  si
    ```

3. La instrucción `vagrant ssh` accede a la máquina con el usuario `vagrant` y con una clave privada, la clave pública relacionada se ha guardado en el sistema de archivo de la máquina. Para cada máquina se genera una par de claves, la clave privada de una máquina se guarda en el directorio `directorio_vagrantfile/.vagrant/machines/default/libvirt/`.

4. Se han creado dos volúmenes en el pool `default`:

    ```bash
    usuario@maquina:~/vagrant$ virsh -c qemu:///system vol-list default
    Nombre                                                               Ruta
    ---------------------------------------------------------------------------------------------------
    ...   
    ej1_default.img                                                      /var/lib/libvirt/images/ej1_default.img
    debian-VAGRANTSLASH-bullseye64_vagrant_box_image_11.20210829.1.img   /var/lib/libvirt/images/debian-VAGRANTSLASH-bullseye64_vagrant_box_image_11.20210829.1.img
  ```

Si comprobamos la definición de la máquina creada veremos lo siguiente:

  ```bash
  usuario@maquina:~/vagrant$ virsh -c qemu:///system dumpxml ej1_default
  ...
  <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/ej1_default.img' index='1'/>
      <backingStore type='file' index='2'>
        <format type='qcow2'/>
        <source file='/var/lib/libvirt/images/debian-VAGRANTSLASH-bullseye64_vagrant_box_image_11.20210829.1.img'/>
        <backingStore/>
      </backingStore>
      <target dev='vda' bus='virtio'/>
      <alias name='virtio-disk0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
    </disk>
  ...
  ```

Estamos usando aprovisionamiento ligero ("thin provisioning") que permite utilizar la misma imagen base para varias máquinas virtuales y crear rápidamente nuevas máquinas virtuales sin tener que instalar desde cero. Es decir:

* La primera vez que se crea una máquina con un box determinado, se clona este box y se crea una imagen que servirá de base para todas las máquinas creada con el mismo box.
* Para cada máquina se se crea un nuevo fichero de imagen, que "comparte" una imagen base (sólo lectura) y que realmente registra sólo las modificaciones que vaya teniendo la máquina a medida que va cambiando.
* Con esta técnica se ahorra mucho espacio en disco. Por cada máquina virtual no se clona un nuevo volumen.
* Cuando eliminamos la máquina con `vagrant destroy` se elimina la imagen de la máquina, pero no la imagen base.

## Creación de varias máquinas virtuales

En esta ocasión vamos a crear otro directorio y dentro un fichero `Vagrantfile` con el siguiente contenido:

  ```ruby
  Vagrant.configure("2") do |config|

    config.vm.define :nodo1 do |nodo1|
      nodo1.vm.box = "debian/bullseye64"
      nodo1.vm.hostname = "nodo1"
    end
    config.vm.define :nodo2 do |nodo2|
      nodo2.vm.box = "generic/ubuntu2010"
      nodo2.vm.hostname = "nodo2"
    end
  end
  ```

Cuando iniciemos el escenario veremos que hemos creado dos máquinas virtuales: nodo1 y nodo2. Cada una de ella con un sistema operativo. Las dos máquinas estarán conectada a la misma red. Para acceder a las máquinas usaremos el nombre de la máquina: `vagrant ssh nodo1`.

## Modificar las características de la máquina creada

Veamos cómo podemos cambiar la configuración (RAM y CPU) de la máquina creada en un `Vagrantfile`:

  ```ruby
  Vagrant.configure("2") do |config|
    config.vm.box = "debian/bullseye64"
    config.vm.hostname="prueba"
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.provider :libvirt do |libvirt|
      libvirt.memory = 1024
      libvirt.cpus = 2
    end
  end
  ```

Si no vamos a usar la característica de compartir ficheros entre el host y la máquina virtual podemos deshabilitar el directorio de sincronización (synced_folder), con la siguiente directiva:

```
config.vm.synced_folder ".", "/vagrant", disabled: true
```

Si cambiamos las características de las máquinas de un escenario modificando el fichero `Vagrantfile` podríamos intentar la modificación de la máquina ejecutando un `vagrant reload`.

## Conclusiones

En esta entrada hemos estudiados los aspectos fundamentales para trabajar con vagrant y kvm. En la próxima entrada seguiremos trabajando con vagrant y kvm e introduciremos el trabajo con redes.