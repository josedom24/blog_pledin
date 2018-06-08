---
layout: post
status: publish
published: true
title: Instalando OpenStack en mi port&aacute;til
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 920
wordpress_url: http://www.josedomingo.org/pledin/?p=920
date: '2014-02-11 00:04:30 +0000'
date_gmt: '2014-02-10 23:04:30 +0000'
categories:
- General
tags:
- Virtualizaci&oacute;n
- Cloud Computing
- OpenStack
- Vagrant
- ansible
comments:
- id: 990
  author: Moreno Le&oacute;n, Jes&uacute;s
  author_email: j.morenol@gmail.com
  author_url: http://sw-libre.blogspot.com
  date: '2014-02-11 09:42:55 +0000'
  date_gmt: '2014-02-11 08:42:55 +0000'
  content: "Magn&iacute;fica entrada, Jos&eacute; Domingo. \r\n\r\nYa no hay excusas
    para no probar las novedades de Havana. Muchas gracias por pon&eacute;rnoslo tan
    f&aacute;cil.\r\n\r\nSaludos,\r\nJes&uacute;s."
---
<p style="text-align: center;"><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/vao.png"><img class="aligncenter size-full wp-image-924" alt="vao" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/vao.png" width="800" height="250" /></a></p>
<p>El objetivo de esta entrada es contar mi experiencia de instalar el software de Cloud Computing OpenStack en mi ordenador a partir del repositorio de GitHub: <a href="https://github.com/openstack-ansible/openstack-ansible">https://github.com/openstack-ansible/openstack-ansible</a>. Se trata de la instalaci&oacute;n de un escenario formado por varias m&aacute;quinas virtuales desplegadas con Vagrant donde se instala OpenStack a partir de recetas desarrolladas en ansible. Las personas que han desarrollado dichas recetas y son los mantenedores del repositorio son&nbsp;<a href="https://github.com/lorin">Lorin Hochstein</a>&nbsp; y&nbsp;<a href="https://github.com/marklee77">Mark Stillwell</a>.</p>
<p><!--more--></p>
<h2>&iquest;Qu&eacute; necesito para realizar la instalaci&oacute;n?</h2>
<ul>
<li>En primer lugar tenemos que tener en cuenta la memoria RAM que disponemos. Las cuatro m&aacute;quinas que se despliegan necesitan 2,5 GB de RAM, por lo que creo que con un ordenador de 4 GB ser&iacute;a suficiente. Por otro lado partimos de que estamos usando un equipo con la extensi&oacute;n de virtualizaci&oacute;n hardware VT-x/AMD-v activada.</li>
<li>El repositorio que vamos a utilizar se encuentra en GitHub por lo tanto tenemos que tener instalado el paquete git en nuestro ordenador:</li>
</ul>
<pre class="brush: bash; gutter: false; first-line: 1"># apt-get install git</pre>
<ul>
<li>El software que se va a utilizar para ejecutar las m&aacute;quinas virtuales es VirtualBox que en mi caso est&aacute; instalado sobre un sistema operativo GNU Linux Debian Wheezy. La versi&oacute;n de VirtualBox que estoy utilizando es 4.1.18. Para la instalaci&oacute;n, ejecutamos simplemente:</li>
</ul>
<pre class="brush: bash; gutter: false; first-line: 1"># apt-get install virtualbox</pre>
<ul>
<li>Siguiendo la documentaci&oacute;n tambi&eacute;n necesitamos instalar el paquete <a href="https://pypi.python.org/pypi/netaddr/">python-netaddr</a>, para ello:
<pre class="brush: bash; gutter: false; first-line: 1"># apt-get install python-netaddr</pre>
</li>
</ul>
<ul>
<li>Con <a href="http://www.vagrantup.com/">Vagrant</a> podemos virtualizar entornos de desarrollo. Esta herramienta nos permite automatizar la creaci&oacute;n y gesti&oacute;n de m&aacute;quinas virtuales. Vamos a utilizar esta herramienta para definir y gestionar las m&aacute;quinas virtuales que vamos a usar. Estas m&aacute;quinas ser&aacute;n ejecutadas en VirtualBox. En el momento de escribir esta entrada la versi&oacute;n de vagrant es la 1.4.3, podemos bajarnos el paquete deb de la p&aacute;gina oficial e instalarlo en nuestro sistema:</li>
</ul>
<pre class="brush: bash; gutter: false; first-line: 1"># wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.4.3_x86_64.deb
# dpkg -i vagrant_1.4.3_x86_64.deb</pre>
<p>Las m&aacute;quinas virtuales que se crean tienen el sistema operativo Ubuntu 12.04 amd64, por lo tanto es conveniente descargar el box de vagrant precise64 con el siguiente comando:</p>
<pre># vagrant box add precise64 http://files.vagrantup.com/precise64.box</pre>
<ul>
<li>Por &uacute;ltimo vamos a utilizar <a href="http://www.ansible.com/home">ansible</a>, una herramienta &nbsp;que nos permite &nbsp;automatizar y gestionar la configuraci&oacute;n de nuestras m&aacute;quinas. Podemos utilizar la herramienta pip para instalar la &uacute;ltima versi&oacute;n de este programa:</li>
</ul>
<pre class="brush: bash; gutter: false; first-line: 1"># apt-get install python-pip python-dev
# pip install ansible</pre>
<h2>Presentando el escenario que vamos a desplegar</h2>
<p>Un vez que tenemos instaladas las herramientas necesarias, vamos a obtener el repositorio desde el que vamos a realizar la instalaci&oacute;n, para ello tenemos que clonarlo ejecutando los siguientes comandos:</p>
<pre>git clone https://github.com/openstack-ansible/openstack-ansible
cd openstack-ansible
git submodule update --init</pre>
<p>Para iniciar la instalaci&oacute;n simplemente tendremos que ejecutar el comando:</p>
<pre class="brush: bash; gutter: false; first-line: 1">openstack-ansible# make</pre>
<p>Este comando ejecuta los pasos que se encuentran definido en el fichero Makefile, que de forma resumida son los siguientes:</p>
<p><strong>1) Se crean las m&aacute;quinas virtuales</strong> con el comando <em>vagrant up</em> utilizando como fichero de configuraci&oacute;n Vagranfile, que podemos encontrar en el directorio testcase/standard.</p>
<p>Es esquema de m&aacute;quinas que se levantan son las siguientes y la los podemos representar usando el siguiente esquema:</p>
<ul>
<li>10.1.0.2, nodo controlador.</li>
<li>10.1.0.3, nodo de computaci&oacute;n.</li>
<li>10.1.0.4, nodo de red (neutron).</li>
<li>10.1.0.5, nodo de almacenamiento.</li>
</ul>
<p><strong><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/InstalandoOpenStackEnMiPortatil.jpg"><img class="aligncenter size-full wp-image-956" alt="InstalandoOpenStackEnMiPortatil" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/InstalandoOpenStackEnMiPortatil.jpg" width="1000" height="700" /></a><br />
</strong></p>
<h6>Nota:Le doy las gracias a mi alumno <a href="https://twitter.com/EvaristoGZ">@EvaristoGZ</a> por haber dise&ntilde;ado el esquema anterior. Puedes ver el esquema original que dise&ntilde;&eacute; para esta entrada en este <a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/esquema.png">enlace</a>.</h6>
<p>Adem&aacute;s si accedemos a este directorio podemos manejar las m&aacute;quinas virtuales (pararlas, arrancarlas o destruirlas). Estas tres acciones se har&iacute;an con los siguientes comandos:</p>
<pre class="brush: bash; gutter: false; first-line: 1">openstack-ansible/testcases/standard#vagrant halt
openstack-ansible/testcases/standard#vagrant up
openstack-ansible/testcases/standard#vagrant destroy</pre>
<p><strong>2) Se instalan los servicios necesarios en cada una de las m&aacute;quinas que hemos arrancado.</strong> Para ello se ejecuta la receta ansible <strong>openstack-ansible/openstack.yaml</strong> utilizando el fichero de configuraci&oacute;n de los hosts que encontramos en el directorio del escenario <strong>openstack-ansible/testcases/standard/ansible_hosts. </strong>Si editamos el fichero de la receta nos daremos cuenta que existe una receta distinta para instalar los distintos servicios: keystone, swift, glance, neutron, cinder, nova, horizon, heat y ceilometer.</p>
<p><strong>3) Se levanta una instancia de prueba.&nbsp;</strong>Para ello se ejecuta la receta ansible <strong>openstack-ansible/demo.yaml, </strong>utilizando el mismo fichero de configuraci&oacute;n de los hosts visto en el punto anterior. Esta receta, sube una imagen cirros al sistema, crea el router y la red necesaria y por &uacute;ltimo lanza una instancia a la que le asigna una ip flotante.</p>
<h2>Accediendo a openstack</h2>
<p>Si utilizamos la aplicaci&oacute;n web horizon para trabajar, debemos acceder a la siguiente URL:</p>
<pre class="brush: bash; gutter: false; first-line: 1">http://10.1.0.2/horizon</pre>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/01.png"><img class="size-full wp-image-938 aligncenter" alt="01" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/01.png" width="263" height="185" /></a>Durante la instalaci&oacute;n se han creado dos usuarios: un usuario de prueba: <strong>demo</strong> con contrase&ntilde;a <strong>secret, </strong>este usuario es el propietario del proyecto demo, en el que se ha creado la instancia de prueba. Tambi&eacute;n podemos acceder con el usuario <strong>admin,</strong> cuya contrase&ntilde;a est&aacute; guardada en un fichero que luego comentaremos.</p>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/02.png"><img class="aligncenter size-full wp-image-939" alt="02" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/02/02.png" width="510" height="162" /></a>Si queremos trabajar con el cliente <strong>nova</strong> tenemos que instalar el paquete <a href="http://pypi.python.org/pypi/python-novaclient/">python-novaclient</a>, y siguiendo, por ejemplo, este <a href="http://albertomolina.wordpress.com/2013/11/20/how-to-launch-an-instance-on-openstack-ii-openstack-cli/">manual</a>, podemos gestionar las instancias de nuestro cloud. Tenemos que tener en cuenta que en el nodo controlador encontramos dos ficheros de credenciales: <em>demo.openrc</em>, donde encontramos las del usuario demo, y <em>admin.openrc</em> donde est&aacute;n las del usuario admin (en este fichero puedes encontrar la password del admin por si quieres acceder a horizon con &eacute;l).</p>
<p>Ejemplo:</p>
<pre class="brush: bash; gutter: false; first-line: 1">$ source demo.openrc
$ nova list
+--------------------------------------+------+--------+------------+-------------+-------------------------------------+
| ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Name | Status | Task State | Power State | Networks&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
+--------------------------------------+------+--------+------------+-------------+-------------------------------------+
| 1491f908-42c6-4f7c-a937-5f9ef9a76ba2 | p11&nbsp; | ACTIVE | None&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Running&nbsp;&nbsp;&nbsp;&nbsp; | demo-net=192.168.100.2, 10.4.10.101 |
+--------------------------------------+------+--------+------------+-------------+-------------------------------------+</pre>
<h2>&Uacute;ltimas consideraciones</h2>
<ol>
<li>Con la asignaci&oacute;n de memoria a cada uno de los nodos se pueden crear pocas instancias, una soluci&oacute;n puede ser crear un nuevo sabor que tenga 256 MB de RAM (yo lo he llamado m1.enano).</li>
<li>Otra opci&oacute;n, si tenemos suficiente RAM en nuestra m&aacute;quina, es modificar el fichero Vagranfile, y asignar m&aacute;s memoria RAM al nodo de computaci&oacute;n.</li>
<li>Puedes acceder a la instancia cirros por ssh, usando el usuario <strong>cirros</strong>, y la contrase&ntilde;a <strong>cubswin:)</strong></li>
<li>Si necesitas entrar en cualquier de las m&aacute;quinas virtuales, lo puedes hacer con el usuario <strong>vagrant</strong> y contrase&ntilde;a <strong>vagrant</strong>, o usando la clave privada ssh <strong>vagrant_private_key</strong>.</li>
<li>El acceso por ssh a la instancia s&oacute;lo se puede hacer desde alguna de las m&aacute;quinas virtuales.</li>
</ol>
<p><strong>Modificado el 19/03/20014:</strong></p>
<h2>Acceso a la instancia por ssh</h2>
<p>Primero tenemos que entrar a una m&aacute;quina virtual, por ejemplo el controlador:</p>
<pre class="brush: bash; gutter: false; first-line: 1">$ &nbsp;<strong>vagrant ssh controller</strong>
Welcome to Ubuntu 12.04.4 LTS (GNU/Linux 3.2.0-60-generic x86_64)
&nbsp;* Documentation:&nbsp; https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Wed Mar 19 16:35:49 2014 from 10.0.2.2

vagrant@controller:~$ <strong>ssh cirros@10.4.10.102</strong>
The authenticity of host '10.4.10.102 (10.4.10.102)' can't be established.
RSA key fingerprint is e1:c3:6f:5a:6a:f9:5d:c8:5a:85:ec:a7:d4:5e:95:ac.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '10.4.10.101' (RSA) to the list of known hosts.
$</pre>
