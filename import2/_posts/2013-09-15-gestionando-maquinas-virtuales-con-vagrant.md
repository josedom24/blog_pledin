---
layout: post
status: publish
published: true
title: Gestionando m&aacute;quinas virtuales con Vagrant
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 753
wordpress_url: http://www.josedomingo.org/pledin/?p=753
date: '2013-09-15 23:20:33 +0000'
date_gmt: '2013-09-15 21:20:33 +0000'
categories:
- General
tags:
- Virtualizaci&oacute;n
- Vagrant
comments: []
---
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2013/09/vagrant-logo.small_.png"><img class="aligncenter  wp-image-754" title="vagrant-logo.small" src="http://www.josedomingo.org/pledin/wp-content/uploads/2013/09/vagrant-logo.small_-245x300.png" alt="" width="153" height="187" /></a></p>
<p style="text-align: justify;">Vagrant es una aplicaci&oacute;n libre desarrollada en ruby que nos permite crear y personalizar entornos de desarrollo livianos, reproducibles y portables. Vagrant nos permite automatizar la creaci&oacute;n y gesti&oacute;n de m&aacute;quinas virtuales. Las m&aacute;quinas virtuales creadas por vagrant se pueden ejecutar con distintos gestores de m&aacute;quinas virtuales (VirtualBox, VMWare, KVM,...), en nuestro ejemplo vamos a usar m&aacute;quinas virtuales en VirtualBox.</p>
<p style="text-align: justify;">El objetivo principal de vagrant es aproximar los entornos de desarrollo y producci&oacute;n, de esta manera el desarrollador tiene a su disposici&oacute;n una manera&nbsp; muy sencilla de desplegar una infraestructura similar a la que se va a tener en entornos de producci&oacute;n. A los administradores de sistemas les facilita la creaci&oacute;n de infraestrucutras de prueba y desarrollo.</p>
<p style="text-align: justify;">Para m&aacute;s informaci&oacute;n tienes a tu disposici&oacute;n toda la documentaci&oacute;n en su p&aacute;gina oficial: <a href="http://www.vagrantup.com/">http://www.vagrantup.com/ </a></p>
<p style="text-align: justify;"><!--more--></p>
<h1 style="text-align: justify;">Instalaci&oacute;n</h1>
<p style="text-align: justify;">En el presente articulo vamos a explicar el funcionamiento de vagrant. Para ello vamos a usar un sistema operativo GNU Linux Debian Wheezy, donde tenemos instalado VirtualBox.</p>
<p style="text-align: justify;">Para instalar&nbsp; vagrant nos bajamos la &uacute;ltima versi&oacute;n desde la p&aacute;gina oficial <a href="http://downloads.vagrantup.com/">(http://downloads.vagrantup.com/</a>). En el momento de escribir este art&iacute;culo la versi&oacute;n era la 1.3.1, y al estar trabajando con Debian nos bajamos el paquete deb y lo instalamos:</p>
<pre class="brush: bash; gutter: false; first-line: 1">$ wget http://files.vagrantup.com/packages/b12c7e8814171c1295ef82416ffe51e8a168a244/vagrant_1.3.1_x86_64.deb
$ dpkg -i vagrant_1.3.1_x86_64.deb</pre>
<p style="text-align: justify;">Una vez instalado podemos comprobar la versi&oacute;n que hemos instalado con:</p>
<pre class="brush: bash; gutter: false; first-line: 1">$ vagrant -v
Vagrant 1.3.1</pre>
<h1>Boxes</h1>
<p style="text-align: justify;">Un box es una m&aacute;quina virtual empaquetada. Posteriormente al crear una m&aacute;quina virtual habr&aacute; que indicar de que box se va a clonar. Vagrant proporciona algunos boxes oficiales, aunque podemos encontrar un listado no oficial en <a href="http://www.vagrantbox.es">http://www.vagrantbox.es</a>.</p>
<p>Para poder utilizar un box es necesario agregarlo a nuestro repositorio de boxes, para ello utilizo la siguiente instrucci&oacute;n:</p>
<pre class="brush: bash; gutter: false; first-line: 1">vagrant box add {title} {url}</pre>
<p style="text-align: justify;">Por lo que ejecutamos con nuestro usuario sin privilegios la siguiente instrucci&oacute;n, nos vamos a bajar un box de una distribuci&oacute;n Ubuntu Precise de 32 bits:</p>
<pre class="brush: bash; gutter: false; first-line: 1">$ vagrant box add precise32 http://files.vagrantup.com/precise32.box</pre>
<p style="text-align: justify;">El box se habr&aacute; guardado en<em> /home/usuario/.vagrant.d/boxes</em></p>
<p>Podemos ver la lista de boxes que tenemos en nuestro repositorio con la instrucci&oacute;n:</p>
<pre class="brush: bash; gutter: false; first-line: 1">$ vagrant box list</pre>
<h1>Vagrantfile: configurando nuestro escenario</h1>
<p style="text-align: justify;">Para configurar las m&aacute;quinas virtuales que vamos a desplegar usamos un fichero de configuraci&oacute;n Vagranfile. El fichero Vagrantfile describe una o varias instancias para crear un entorno vagrant en el directorio en el que se este trabajando. Por lo tanto se pueden tener varios entornos vagrant independientes, ubicando distintos ficheros Vagranfile en diferentes directorios.</p>
<p>Un ejemplo de un fichero Vagranfile podr&iacute;a ser:</p>
<pre class="brush: bash; gutter: false; first-line: 1"># -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; config.vm.box = "precise32"
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; config.vm.network :private_network, ip: "10.1.1.2"
end</pre>
<p style="text-align: justify;">Podemos crear un fichero Vagrantfile m&iacute;nimo de la siguiente forma:</p>
<pre class="brush: bash; gutter: false; first-line: 1">$ mkdir escenario
$ cd escenario
~/escenario$ vagrant init</pre>
<h1 style="text-align: justify;">Configuraci&oacute;n del fichero Vagrantfile</h1>
<p style="text-align: justify;">En el fichero Vagrantfile podemos indicar la configuraci&oacute;n de varias m&aacute;quinas virtuales, las opciones m&aacute;s comunes que podemos configurar son las siguientes:</p>
<ul>
<li style="text-align: justify;">vm.box, con esta opci&oacute;n elegimos el box de nuestro repositorio del que se va a crear la m&aacute;quina virtual.</li>
</ul>
<p style="padding-left: 30px;">Por ejemplo:</p>
<pre class="brush: bash; gutter: false; first-line: 1">config.vm.box = "precise32"</pre>
<ul>
<li style="text-align: justify;">vm.hostname, indicamos el nombre de la m&aacute;quina virtual. Es recomendable que si vamos a trabajar con varias m&aacute;quinas virtuales, le asignemos un nombre significativo.</li>
</ul>
<p style="padding-left: 30px;">Por ejemplo:</p>
<pre class="brush: bash; gutter: false; first-line: 1">config.vm.hostname = "servidor_web"</pre>
<ul>
<li>vm.network, nos permite indicar la configuraci&oacute;n de red de la m&aacute;quina virtual.</li>
</ul>
<p style="padding-left: 30px;">Veamos algunos ejemplos:</p>
<pre class="brush: bash; gutter: false; first-line: 1">config.vm.network :public_network,:bridge=>"eth0"</pre>
<p style="padding-left: 30px; text-align: justify;">Configura una tarjeta de red en modo "Adaptador puente" de VirtualBox, indicando la interfaz de red que usa en el anfitri&oacute;n para ello.</p>
<pre class="brush: bash; gutter: false; first-line: 1">config.vm.network :private_network, ip: "172.22.100.3"</pre>
<p style="padding-left: 30px; text-align: justify;">Configura una tarjeta de red en modo "Red interna" de VirtualBox, indicando la ip que va a tener la m&aacute;quina.</p>
<p style="padding-left: 30px; text-align: justify;">Podemos indicar varios par&aacute;metros <em>vm.network</em>, con lo que estar&iacute;amos definiendo varios interfaces de red en la m&aacute;quina virtual.</p>
<p style="text-align: justify;">Para terminar, indicar que tenemos m&aacute;s par&aacute;metros de configuraci&oacute;n que nos permiten configurar otros aspectos de la m&aacute;quina virtual, como tama&ntilde;o de la memoria RAM, o n&uacute;cleos asignados del procesador. Para m&aacute;s informaci&oacute;n accede a <a href="http://docs.vagrantup.com/v2/">http://docs.vagrantup.com/v2/</a>.</p>
<h1>Configurando varias m&aacute;quinas virtuales</h1>
<p style="text-align: justify;">Los par&aacute;metros que hemos estudiado anteriormente se pueden utilizar para configurar varias m&aacute;quinas virtuales. En el siguiente fichero de configuraci&oacute;n Vagrantfile vemos como se definen dos m&aacute;quinas virtuales: nodo1 y nodo2 con configuraciones diferentes:</p>
<pre class="brush: bash; gutter: false; first-line: 1"># -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

&nbsp; config.vm.define :nodo1 do |nodo1|
&nbsp;&nbsp;&nbsp; nodo1.vm.box = "precise32"
&nbsp;&nbsp;&nbsp; nodo1.vm.hostname = "nodo1"
&nbsp;&nbsp;&nbsp; nodo1.vm.network :private_network, ip: "10.1.1.101"
&nbsp; end
&nbsp; config.vm.define :nodo2 do |nodo2|
&nbsp;&nbsp;&nbsp; nodo2.vm.box = "precise32"
&nbsp;&nbsp;&nbsp; nodo2.vm.hostname = "nodo2"
&nbsp;&nbsp;&nbsp; nodo2.vm.network :public_network,:bridge=>"wlan0"
&nbsp; end
end</pre>
<h1>Gesti&oacute;n de las m&aacute;quinas virtuales</h1>
<p style="text-align: justify;">Una vez que tenemos nuestras m&aacute;quinas virtuales configuradas, es hora de trabajar con ellas, para ello tenemos varios comandos que vamos a estudiar.</p>
<p style="text-align: justify;"><em><strong>vagrant up</strong></em>, nos permite arrancar las m&aacute;quinas, si es la primera vez que se arrancan las m&aacute;quinas se har&aacute; una clonaci&oacute;n desde el box, y se realizar&aacute; la configuraci&oacute;n. Si las m&aacute;quinas ya han sido creadas, pero est&aacute;n suspendidas, se vuelven a arrancar.</p>
<p>Ejemplo:</p>
<pre class="brush: bash; gutter: false; first-line: 1">~/escenario$ vagrant up
Bringing machine 'nodo1' up with 'virtualbox' provider...
Bringing machine 'nodo2' up with 'virtualbox' provider...
[nodo1] Importing base box 'precise32'...
[nodo1] Matching MAC address for NAT networking...
[nodo1] Setting the name of the VM...
...</pre>
<p style="text-align: justify;">Para acceder a las m&aacute;quinas por ssh podemos utilizar la instrucci&oacute;n <em><strong>vagrant ssh</strong></em> donde indicamos el nombre de la m&aacute;quina donde queremos acceder.</p>
<pre class="brush: bash; gutter: false; first-line: 1">~/escenario$ vagrant ssh nodo1
Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic-pae i686)
&nbsp;* Documentation:&nbsp; https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Fri Sep 14 06:22:31 2012 from 10.0.2.2
vagrant@nodo1:~$</pre>
<p style="text-align: justify;">Si queremos detener una m&aacute;quina utilizamos la instrucci&oacute;n <em><strong>vagrant halt</strong></em>:</p>
<pre class="brush: bash; gutter: false; first-line: 1">~/escenario$ vagrant halt nodo1
[nodo1] Attempting graceful shutdown of VM...</pre>
<p style="text-align: justify;">Por &uacute;ltimo si queremos destruir todas las m&aacute;quinas virtuales de un entorno vagrant utilizamos la instrucci&oacute;n <em><strong>vagrant destroy</strong></em>:</p>
<pre class="brush: bash; gutter: false; first-line: 1">~/escenario$ vagrant destroy
vagrant destroy
Are you sure you want to destroy the 'nodo2' VM? [y/N] y
[nodo2] Forcing shutdown of VM...
[nodo2] Destroying VM and associated drives...
Are you sure you want to destroy the 'nodo1' VM? [y/N] y
[nodo1] Forcing shutdown of VM...
[nodo1] Destroying VM and associated drives...</pre>
<h1>Conclusiones</h1>
<p style="text-align: justify;">Vagrant es un software muy nuevo, en pleno desarrollo que nos ofrece una forma muy sencilla de construir m&aacute;quinas virtuales con distintas configuraciones de red. Por supuesto, este art&iacute;culo ha sido s&oacute;lo una introducci&oacute;n y la herramienta ofrece muchas m&aacute;s opciones. Una de las m&aacute;s interesantes, y que abordar&eacute; en otro art&iacute;culo, es la posibilidad de combinarla con herramientas de orquestaci&oacute;n como puppet, chef o ansible que nos permiten interactuar con las m&aacute;quinas que hemos desplegado. Pero esto lo dejaremos para m&aacute;s adelante.</p>
