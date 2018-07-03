---
id: 753
title: Gestionando máquinas virtuales con Vagrant
date: 2013-09-15T23:20:33+00:00


guid: http://www.josedomingo.org/pledin/?p=753
permalink: /2013/09/gestionando-maquinas-virtuales-con-vagrant/


tags:
  - Vagrant
  - Virtualización
---
[<img class="aligncenter  wp-image-754" title="vagrant-logo.small" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/09/vagrant-logo.small_-245x300.png" alt="" width="153" height="187" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/09/vagrant-logo.small_-245x300.png 245w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/09/vagrant-logo.small_.png 250w" sizes="(max-width: 153px) 100vw, 153px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2013/09/vagrant-logo.small_.png)


Vagrant es una aplicación libre desarrollada en ruby que nos permite crear y personalizar entornos de desarrollo livianos, reproducibles y portables. Vagrant nos permite automatizar la creación y gestión de máquinas virtuales. Las máquinas virtuales creadas por vagrant se pueden ejecutar con distintos gestores de máquinas virtuales (VirtualBox, VMWare, KVM,&#8230;), en nuestro ejemplo vamos a usar máquinas virtuales en VirtualBox.

El objetivo principal de vagrant es aproximar los entornos de desarrollo y producción, de esta manera el desarrollador tiene a su disposición una manera  muy sencilla de desplegar una infraestructura similar a la que se va a tener en entornos de producción. A los administradores de sistemas les facilita la creación de infraestrucutras de prueba y desarrollo.

Para más información tienes a tu disposición toda la documentación en su página oficial: <a href="http://www.vagrantup.com/">http://www.vagrantup.com/ </a>

## Instalación

En el presente articulo vamos a explicar el funcionamiento de vagrant. Para ello vamos a usar un sistema operativo GNU Linux Debian Wheezy, donde tenemos instalado VirtualBox.

Para instalar  vagrant nos bajamos la última versión desde la página (http://downloads.vagrantup.com/</a>). En el momento de escribir este artículo la versión era la 1.3.1, y al estar trabajando con Debian nos bajamos el paquete deb y lo instalamos:

    wget http://files.vagrantup.com/packages/b12c7e8814171c1295ef82416ffe51e8a168a244/vagrant_1.3.1_x86_64.deb
    $ dpkg -i vagrant_1.3.1_x86_64.deb

Una vez instalado podemos comprobar la versión que hemos instalado con:
    
    vagrant -v
    Vagrant 1.3.1

## Boxes

Un box es una máquina virtual empaquetada. Posteriormente al crear una máquina virtual habrá que indicar de que box se va a clonar. Vagrant proporciona algunos boxes oficiales, aunque podemos encontrar un listado no oficial en <a href="http://www.vagrantbox.es">http://www.vagrantbox.es</a>.

Para poder utilizar un box es necesario agregarlo a nuestro repositorio de boxes, para ello utilizo la siguiente instrucción:

    vagrant box add {title} {url}

Por lo que ejecutamos con nuestro usuario sin privilegios la siguiente instrucción, nos vamos a bajar un box de una distribución Ubuntu Precise de 32 bits:

    $ vagrant box add precise32 http://files.vagrantup.com/precise32.box

El box se habrá guardado en `/home/usuario/.vagrant.d/boxes`.

Podemos ver la lista de boxes que tenemos en nuestro repositorio con la instrucción:

    $ vagrant box list


## Vagrantfile: configurando nuestro escenario

  Para configurar las máquinas virtuales que vamos a desplegar usamos un fichero de configuración `Vagranfile`. El fichero `Vagrantfile` describe una o varias instancias para crear un entorno vagrant en el directorio en el que se este trabajando. Por lo tanto se pueden tener varios `Vagranfile` en diferentes directorios.

Un ejemplo de un fichero `Vagranfile` podría ser:

    # -*- mode: ruby -*-
    # vi: set ft=ruby :
    Vagrant.configure("2") do |config|
                   config.vm.box = "precise32"
                   config.vm.network :private_network, ip: "10.1.1.2"
    end

Podemos crear un fichero `Vagrantfile` mínimo de la siguiente forma:

    $ mkdir escenario
    $ cd escenario
    ~/escenario$ vagrant init

## Configuración del fichero Vagrantfile

En el fichero `Vagrantfile` podemos indicar la configuración de varias máquinas virtuales, las opciones más comunes que podemos configurar son las siguientes:

* `vm.box`, con esta opción elegimos el box de nuestro repositorio del que se va a crear la máquina virtual.

    Por ejemplo:

        config.vm.box = "precise32"

* `vm.hostname`, indicamos el nombre de la máquina virtual. Es recomendable que si vamos a trabajar con varias máquinas virtuales, le asignemos un nombre significativo.
    
    Por ejemplo:
        
        config.vm.hostname = "servidor_web"

* `vm.network`, nos permite indicar la configuración de red de la máquina virtual.

    Veamos algunos ejemplos:
        
        config.vm.network :public_network,:bridge=>"eth0"

    Configura una tarjeta de red en modo **Adaptador puente** de VirtualBox, indicando la interfaz de red que usa en el anfitrión para ello.

        config.vm.network :private_network, ip: "172.22.100.3"

    Configura una tarjeta de red en modo **Red interna** de VirtualBox, indicando la ip que va a tener la máquina.

    Podemos indicar varios parámetros `vm.network`, con lo que estaríamos definiendo varios interfaces de red en la máquina virtual.

Para terminar, indicar que tenemos más parámetros de configuración que nos permiten configurar otros aspectos de la máquina virtual, como tamaño de la memoria RAM, o núcleos asignados del procesador. Para más información accede a <a href="http://docs.vagrantup.com/v2/">http://docs.vagrantup.com/v2/</a>.

## Configurando varias máquinas virtuales

Los parámetros que hemos estudiado anteriormente se pueden utilizar para configurar varias máquinas virtuales. En el siguiente fichero de configuración `Vagrantfile` vemos como se definen dos máquinas virtuales: `nodo1` y `nodo2` con configuraciones diferentes:

    # vi: set ft=ruby :

    Vagrant.configure("2") do |config|

      config.vm.define :nodo1 do |nodo1|
        nodo1.vm.box = "precise32"
        nodo1.vm.hostname = "nodo1"
        nodo1.vm.network :private_network, ip: "10.1.1.101"

      config.vm.define :nodo2 do |nodo2|
        nodo2.vm.box = "precise32"
        nodo2.vm.hostname = "nodo2"
        nodo2.vm.network :public_network,:bridge=&gt;"wlan0"
      end
    end

## Gestión de las máquinas virtuales

Una vez que tenemos nuestras máquinas virtuales configuradas, es hora de trabajar con ellas, para ello tenemos varios comandos que vamos a estudiar.

* `vagrant up`, nos permite arrancar las una clonación desde el box, y se realizará la configuración. Si las máquinas ya han sido creadas, pero están suspendidas, se vuelven a arrancar.

    Ejemplo:

        ~/escenario$ vagrant up 
        Bringing machine 'nodo1' up with 'virtualbox' provider...
        Bringing machine 'nodo2' up with 'virtualbox' provider...
        [nodo1] Importing base box 'precise32'...
        [nodo1] Matching MAC address for NAT networking...
        [nodo1] Setting the name of the VM...
        ...

* Para acceder a las máquinas por ssh podemos utilizar la instrucción `vagrant ssh` donde indicamos el nombre de la máquina donde queremos acceder.

        ~/escenario$ vagrant ssh nodo1
        Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic-pae i686)
         * Documentation:  https://help.ubuntu.com/
        Welcome to your Vagrant-built virtual machine.
        Last login: Fri Sep 14 06:22:31 2012 from 10.0.2.2
        vagrant@nodo1:~$

* Si queremos detener una máquina utilizamos la instrucción `vagrant halt`:

        ~/escenario$ vagrant halt nodo1
        [nodo1] Attempting graceful shutdown of VM...

* Por último si queremos destruir todas las máquinas virtuales de un entorno vagrant utilizamos la instrucción `vagrant destroy`:

        ~/escenario$ vagrant destroy
        Are you sure you want to destroy the 'nodo2' VM? [y/N] y
        [nodo2] Forcing shutdown of VM...
        [nodo2] Destroying VM and associated drives...
        Are you sure you want to destroy the 'nodo1' VM? [y/N] y
        [nodo1] Forcing shutdown of VM...
        [nodo1] Destroying VM and associated drives...

## Conclusiones

Vagrant es un software muy nuevo, en pleno desarrollo que nos ofrece una forma muy sencilla de construir máquinas virtuales con distintas configuraciones de red. Por supuesto, este artículo ha sido sólo una introducción y la herramienta ofrece muchas más opciones. Una de las más interesantes, y que abordaré en otro artículo, es la posibilidad de combinarla con herramientas de orquestación como puppet, chef o ansible que nos permiten interactuar con las máquinas que hemos desplegado. Pero esto lo dejamos para más adelante.