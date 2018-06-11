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

<p style="text-align: justify;">
  Vagrant es una aplicación libre desarrollada en ruby que nos permite crear y personalizar entornos de desarrollo livianos, reproducibles y portables. Vagrant nos permite automatizar la creación y gestión de máquinas virtuales. Las máquinas virtuales creadas por vagrant se pueden ejecutar con distintos gestores de máquinas virtuales (VirtualBox, VMWare, KVM,&#8230;), en nuestro ejemplo vamos a usar máquinas virtuales en VirtualBox.
</p>

<p style="text-align: justify;">
  El objetivo principal de vagrant es aproximar los entornos de desarrollo y producción, de esta manera el desarrollador tiene a su disposición una manera  muy sencilla de desplegar una infraestructura similar a la que se va a tener en entornos de producción. A los administradores de sistemas les facilita la creación de infraestrucutras de prueba y desarrollo.
</p>

<p style="text-align: justify;">
  Para más información tienes a tu disposición toda la documentación en su página oficial: <a href="http://www.vagrantup.com/">http://www.vagrantup.com/ </a>
</p>

<p style="text-align: justify;">
  <!--more-->
</p>

<h1 style="text-align: justify;">
  Instalación
</h1>

<p style="text-align: justify;">
  En el presente articulo vamos a explicar el funcionamiento de vagrant. Para ello vamos a usar un sistema operativo GNU Linux Debian Wheezy, donde tenemos instalado VirtualBox.
</p>

<p style="text-align: justify;">
  Para instalar  vagrant nos bajamos la última versión desde la página oficial <a href="http://downloads.vagrantup.com/">(http://downloads.vagrantup.com/</a>). En el momento de escribir este artículo la versión era la 1.3.1, y al estar trabajando con Debian nos bajamos el paquete deb y lo instalamos:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">$ wget http://files.vagrantup.com/packages/b12c7e8814171c1295ef82416ffe51e8a168a244/vagrant_1.3.1_x86_64.deb
$ dpkg -i vagrant_1.3.1_x86_64.deb</pre>

<p style="text-align: justify;">
  Una vez instalado podemos comprobar la versión que hemos instalado con:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">$ vagrant -v
Vagrant 1.3.1</pre>

# Boxes

<p style="text-align: justify;">
  Un box es una máquina virtual empaquetada. Posteriormente al crear una máquina virtual habrá que indicar de que box se va a clonar. Vagrant proporciona algunos boxes oficiales, aunque podemos encontrar un listado no oficial en <a href="http://www.vagrantbox.es">http://www.vagrantbox.es</a>.
</p>

Para poder utilizar un box es necesario agregarlo a nuestro repositorio de boxes, para ello utilizo la siguiente instrucción:

<pre class="brush: bash; gutter: false; first-line: 1">vagrant box add {title} {url}</pre>

<p style="text-align: justify;">
  Por lo que ejecutamos con nuestro usuario sin privilegios la siguiente instrucción, nos vamos a bajar un box de una distribución Ubuntu Precise de 32 bits:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">$ vagrant box add precise32 http://files.vagrantup.com/precise32.box</pre>

<p style="text-align: justify;">
  El box se habrá guardado en<em> /home/usuario/.vagrant.d/boxes</em>
</p>

Podemos ver la lista de boxes que tenemos en nuestro repositorio con la instrucción:

<pre class="brush: bash; gutter: false; first-line: 1">$ vagrant box list</pre>

# Vagrantfile: configurando nuestro escenario

<p style="text-align: justify;">
  Para configurar las máquinas virtuales que vamos a desplegar usamos un fichero de configuración Vagranfile. El fichero Vagrantfile describe una o varias instancias para crear un entorno vagrant en el directorio en el que se este trabajando. Por lo tanto se pueden tener varios entornos vagrant independientes, ubicando distintos ficheros Vagranfile en diferentes directorios.
</p>

Un ejemplo de un fichero Vagranfile podría ser:

<pre class="brush: bash; gutter: false; first-line: 1"># -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
               config.vm.box = "precise32"
               config.vm.network :private_network, ip: "10.1.1.2"
end</pre>

<p style="text-align: justify;">
  Podemos crear un fichero Vagrantfile mínimo de la siguiente forma:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">$ mkdir escenario
$ cd escenario
~/escenario$ vagrant init</pre>

<h1 style="text-align: justify;">
  Configuración del fichero Vagrantfile
</h1>

<p style="text-align: justify;">
  En el fichero Vagrantfile podemos indicar la configuración de varias máquinas virtuales, las opciones más comunes que podemos configurar son las siguientes:
</p>

<li style="text-align: justify;">
  vm.box, con esta opción elegimos el box de nuestro repositorio del que se va a crear la máquina virtual.
</li>

<p style="padding-left: 30px;">
  Por ejemplo:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">config.vm.box = "precise32"</pre>

<li style="text-align: justify;">
  vm.hostname, indicamos el nombre de la máquina virtual. Es recomendable que si vamos a trabajar con varias máquinas virtuales, le asignemos un nombre significativo.
</li>

<p style="padding-left: 30px;">
  Por ejemplo:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">config.vm.hostname = "servidor_web"</pre>

  * vm.network, nos permite indicar la configuración de red de la máquina virtual.

<p style="padding-left: 30px;">
  Veamos algunos ejemplos:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">config.vm.network :public_network,:bridge=&gt;"eth0"</pre>

<p style="padding-left: 30px; text-align: justify;">
  Configura una tarjeta de red en modo &#8220;Adaptador puente&#8221; de VirtualBox, indicando la interfaz de red que usa en el anfitrión para ello.
</p>

<pre class="brush: bash; gutter: false; first-line: 1">config.vm.network :private_network, ip: "172.22.100.3"</pre>

<p style="padding-left: 30px; text-align: justify;">
  Configura una tarjeta de red en modo &#8220;Red interna&#8221; de VirtualBox, indicando la ip que va a tener la máquina.
</p>

<p style="padding-left: 30px; text-align: justify;">
  Podemos indicar varios parámetros <em>vm.network</em>, con lo que estaríamos definiendo varios interfaces de red en la máquina virtual.
</p>

<p style="text-align: justify;">
  Para terminar, indicar que tenemos más parámetros de configuración que nos permiten configurar otros aspectos de la máquina virtual, como tamaño de la memoria RAM, o núcleos asignados del procesador. Para más información accede a <a href="http://docs.vagrantup.com/v2/">http://docs.vagrantup.com/v2/</a>.
</p>

# Configurando varias máquinas virtuales

<p style="text-align: justify;">
  Los parámetros que hemos estudiado anteriormente se pueden utilizar para configurar varias máquinas virtuales. En el siguiente fichero de configuración Vagrantfile vemos como se definen dos máquinas virtuales: nodo1 y nodo2 con configuraciones diferentes:
</p>

<pre class="brush: bash; gutter: false; first-line: 1"># -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define :nodo1 do |nodo1|
    nodo1.vm.box = "precise32"
    nodo1.vm.hostname = "nodo1"
    nodo1.vm.network :private_network, ip: "10.1.1.101"
  end
  config.vm.define :nodo2 do |nodo2|
    nodo2.vm.box = "precise32"
    nodo2.vm.hostname = "nodo2"
    nodo2.vm.network :public_network,:bridge=&gt;"wlan0"
  end
end</pre>

# Gestión de las máquinas virtuales

<p style="text-align: justify;">
  Una vez que tenemos nuestras máquinas virtuales configuradas, es hora de trabajar con ellas, para ello tenemos varios comandos que vamos a estudiar.
</p>

<p style="text-align: justify;">
  <em><strong>vagrant up</strong></em>, nos permite arrancar las máquinas, si es la primera vez que se arrancan las máquinas se hará una clonación desde el box, y se realizará la configuración. Si las máquinas ya han sido creadas, pero están suspendidas, se vuelven a arrancar.
</p>

Ejemplo:

<pre class="brush: bash; gutter: false; first-line: 1">~/escenario$ vagrant up
Bringing machine 'nodo1' up with 'virtualbox' provider...
Bringing machine 'nodo2' up with 'virtualbox' provider...
[nodo1] Importing base box 'precise32'...
[nodo1] Matching MAC address for NAT networking...
[nodo1] Setting the name of the VM...
...</pre>

<p style="text-align: justify;">
  Para acceder a las máquinas por ssh podemos utilizar la instrucción <em><strong>vagrant ssh</strong></em> donde indicamos el nombre de la máquina donde queremos acceder.
</p>

<pre class="brush: bash; gutter: false; first-line: 1">~/escenario$ vagrant ssh nodo1
Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic-pae i686)
 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Fri Sep 14 06:22:31 2012 from 10.0.2.2
vagrant@nodo1:~$</pre>

<p style="text-align: justify;">
  Si queremos detener una máquina utilizamos la instrucción <em><strong>vagrant halt</strong></em>:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">~/escenario$ vagrant halt nodo1
[nodo1] Attempting graceful shutdown of VM...</pre>

<p style="text-align: justify;">
  Por último si queremos destruir todas las máquinas virtuales de un entorno vagrant utilizamos la instrucción <em><strong>vagrant destroy</strong></em>:
</p>

<pre class="brush: bash; gutter: false; first-line: 1">~/escenario$ vagrant destroy
vagrant destroy
Are you sure you want to destroy the 'nodo2' VM? [y/N] y
[nodo2] Forcing shutdown of VM...
[nodo2] Destroying VM and associated drives...
Are you sure you want to destroy the 'nodo1' VM? [y/N] y
[nodo1] Forcing shutdown of VM...
[nodo1] Destroying VM and associated drives...</pre>

# Conclusiones

<p style="text-align: justify;">
  Vagrant es un software muy nuevo, en pleno desarrollo que nos ofrece una forma muy sencilla de construir máquinas virtuales con distintas configuraciones de red. Por supuesto, este artículo ha sido sólo una introducción y la herramienta ofrece muchas más opciones. Una de las más interesantes, y que abordaré en otro artículo, es la posibilidad de combinarla con herramientas de orquestación como puppet, chef o ansible que nos permiten interactuar con las máquinas que hemos desplegado. Pero esto lo dejaremos para más adelante.
</p>

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->