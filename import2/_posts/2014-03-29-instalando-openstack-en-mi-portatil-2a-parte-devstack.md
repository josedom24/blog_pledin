---
layout: post
status: publish
published: true
title: 'Instalando OpenStack en mi port&aacute;til (2&ordf; parte): DevStack'
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 978
wordpress_url: http://www.josedomingo.org/pledin/?p=978
date: '2014-03-29 21:23:35 +0000'
date_gmt: '2014-03-29 20:23:35 +0000'
categories:
- General
tags:
- Virtualizaci&oacute;n
- Cloud Computing
- OpenStack
- Vagrant
- ansible
- devstack
comments: []
---
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/03/devstack.png"><img class="aligncenter size-full wp-image-979" alt="devstack" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/03/devstack.png" width="436" height="67" /></a><a href="http://devstack.org/">DevStack</a> es un conjunto de script bash que nos permiten instalar OpenStack de forma autom&aacute;tica. Tenemos varias formas de realizar la instalaci&oacute;n:</p>
<h2>En una m&aacute;quina f&iacute;sica</h2>
<p>En este caso partimos de un ordenador instalado con Ubuntu 12.04, y como vemos en la p&aacute;gina principal los pasos son muy sencillos: clonamos el repositorio git y elegimos la rama estable de la versi&oacute;n <strong>havana</strong>.</p>
<pre>git clone https://github.com/openstack-dev/devstack.git
cd devstack
git checkout stable/havana
Branch stable/havana set up to track remote branch stable/havana from origin.
Switched to a new branch 'stable/havana'
./stack.sh</pre>
<p>Antes de ejecutar el script podemos <a href="http://devstack.org/configuration.html">configurar</a> distintas opciones de configuraci&oacute;n.</p>
<h2>En una m&aacute;quina virtual</h2>
<p>Aunque la opci&oacute;n que nos ofrece m&aacute;s rendimiento es la que hemos visto anteriormente, ya que la virtualizaci&oacute;n se hace con KVM, DevStack nos ofrece la posibilidad de ejecutar OpenStack sobre una m&aacute;quina virtual. Evidentemente en este caso tendremos menos rendimiento y las instancias se ejecutar&aacute;n con el emulador QEMU.</p>
<p><!--more--></p>
<p>Para llevar a cabo esta opci&oacute;n podemos utilizar el repositorio GitHub: <a href="https://github.com/xiaohanyu/vagrant-ansible-devstack">https://github.com/xiaohanyu/vagrant-ansible-devstack</a>, desarrollado por <a href="https://github.com/xiaohanyu">Xiao Hanyu</a>, que nos crea una m&aacute;quina virtual con Ubuntu 12.04 utilizando Vagrant y posteriormente una receta ansible nos ejecuta el script de DevStack sobre la m&aacute;quina virtual.</p>
<h3>Pasos para la instalaci&oacute;n</h3>
<p>1) Partimos de una m&aacute;quina con el siguiente software instalado (al igual que el comentado en la entrada anterior:&nbsp;<a title="Instalando OpenStack en mi port&aacute;til" href="http://www.josedomingo.org/pledin/2014/02/instalando-openstack-en-mi-portatil/">Instalando OpenStack en mi port&aacute;til</a>):</p>
<ul>
<li>VirtualBox 4.1.18</li>
<li>Vagrant 1.5.1</li>
<li>Ansible 1.4.4</li>
</ul>
<p>2) Clonamos el repositorio:</p>
<pre>git clone https://github.com/xiaohanyu/vagrant-ansible-devstack.git</pre>
<p>3) Configuramos la instalaci&oacute;n:</p>
<p>En el directorio devstack encontramos la receta ansible en el fichero devstack.yml, donde podemos hacer las siguientes modificaciones en la configuraci&oacute;n de la instalaci&oacute;n:</p>
<ul>
<li><strong>La versi&oacute;n de OpenStack que queremos instalar:&nbsp;</strong>Indicando la rama del repositorio GitHub que queremos instalar, podemos indicar tres valores en la variable <em>branch</em>:</li>
</ul>
<pre>branch: master
branch: stable/havana
branch: stable/icehouse</pre>
<p>La rama <em>master</em> es la de desarrollado, por lo tanto puede tener errores, por lo que nos recomiendan instalar las ramas estables de la versi&oacute;n&nbsp;<em>havana</em> (2013.2) o <em>icehouse</em> (2014.1).</p>
<ul>
<li><strong>Los componentes de OpenStack que queremos instalar:</strong> para ello indicamos el fichero de configuraci&oacute;n que vamos a copiar a la m&aacute;quina virtual en la tarea&nbsp; <em><strong>"copy localrc"</strong></em>, tenemos la posibilidad de indicar dos ficheros:
<pre class="brush: actionscript3; gutter: false; first-line: 1">template: src=<strong>localrc.basic</strong> dest=/home/vagrant/devstack/localrc
template: src=<strong>localrc.full</strong> dest=/home/vagrant/devstack/localrc</pre>
</li>
</ul>
<ol>
<li>El fichero <strong>localrc.basic</strong> nos permite hacer una configuraci&oacute;n b&aacute;sica con los siguientes componentes: nova, cinder, glance, swift, keystone y horizon. Con este tipo de configuraci&oacute;n tenemos suficiente con 1Gb de RAM en la m&aacute;quina virtual.</li>
<li>El fichero <strong>localrc.full</strong> a&ntilde;ade los componentes de neutron, heat y ceilometer. Con esta configuraci&oacute;n necesitamos 2Gb de RAM en la m&aacute;quina virtual.</li>
</ol>
<p>4) Iniciamos la m&aacute;quina virtual con vagrant, una vez creada se ejecutar&aacute; la receta ansible (suponemos que tenemos instalado el box precise64, para m&aacute;s informaci&oacute;n lee la <a title="Instalando OpenStack en mi port&aacute;til" href="http://www.josedomingo.org/pledin/2014/02/instalando-openstack-en-mi-portatil/">entrada anterior</a>):</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">cd vagrant-ansible-devstack
vagrant up</pre>
<h2>Accediendo a OpenStack</h2>
<p>Una vez terminada la instalaci&oacute;n, podemos acceder a horizon accediendo a la url http://192.168.27.100/:</p>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/03/openstack1.png"><img class="aligncenter size-full wp-image-984" alt="openstack1" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/03/openstack1.png" width="545" height="586" /></a>Se han creado dos usuarios:</p>
<ul>
<li>El usuario administrador se llama <strong>admin</strong>, con contrase&ntilde;a <strong>devstack</strong>.</li>
<li>Un usuario sin privilegios llamado <strong>demo</strong>, con contrase&ntilde;a <strong>devstack</strong>.</li>
</ul>
<p>Ya podemos trabajar con OpenStack, podemos crear un par de claves ssh, a&ntilde;adimos el puerto 22 a nuestras <em>Reglas de Seguridad</em>, y creamos una instancia a partir de la imagen cirros, a la que le hemos a&ntilde;adido nuestra claves ssh para acceder y hemos asociado una ip flotante:</p>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/03/openstack2.png"><img class="aligncenter size-full wp-image-991" alt="openstack2" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/03/openstack2.png" width="1114" height="222" /></a>Podemos tambi&eacute;n utilizar el cliente <strong>nova</strong> desde la m&aacute;quina virtual para interactuar con el cloud, para ello:</p>
<pre>cd vagrant-ansible-devstack
vagrant ssh

# cd devstack
devstack# source openrc
devstack# nova list
+--------------------------------------+-----------+--------+------------+-------------+----------------------------------+
| ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Status | Task State | Power State | Networks&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
+--------------------------------------+-----------+--------+------------+-------------+----------------------------------+
| c397c246-3cb8-4f7a-9aec-328a21813f6b | mimaquina | ACTIVE | -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Running&nbsp;&nbsp;&nbsp;&nbsp; | private=10.0.0.2, 192.168.27.130 |
+--------------------------------------+-----------+--------+------------+-------------+----------------------------------+</pre>
<h2>Accediendo a la instancia</h2>
<p>Desde nuestra m&aacute;quina podemos acceder a la instancia accediendo por ssh a la ip flotante:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">$ chmod 400 miclave.pem 
$ ssh -i miclave.pem cirros@192.168.27.130
The authenticity of host '192.168.27.130 (192.168.27.130)' can't be established.
RSA key fingerprint is f8:63:88:42:e1:0b:6f:4e:2e:64:02:46:5d:bb:d3:97.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.27.130' (RSA) to the list of known hosts.
$</pre>
<h2>&iquest;Qu&eacute; hacemos cuando hemos terminado?</h2>
<p>Una vez que hemos terminado de trabajar con OpenStack y antes de apagar nuestra m&aacute;quina virtual, debemos parar los servicios, ejecutando el script <em>unstack.sh. </em>Cuando volvamos a<em> </em>encender la m&aacute;quina debemos volver a ejecutar los servicios ejecutando el script <em>rejoin-stack.sh</em>.<em> </em>Estos scripts hay que ejecutarlos desde la m&aacute;quina virtual:</p>
<pre>cd vagrant-ansible-devstack
vagrant ssh
# cd devstack
# ./unstack.sh</pre>
<p>Ahora podemos apagar nuestra m&aacute;quina virtual. Cuando queramos seguir trabajando, encendemos la m&aacute;quina y ejecutamos:</p>
<pre>cd vagrant-ansible-devstack
vagrant ssh
# cd devstack
# ./rejoin-stack.sh</pre>
<h2>Solucionar error con ansible</h2>
<p>Si estamos utilizando la &uacute;ltima versi&oacute;n de Vagrant (1.5.1) nos aparece el siguiente error:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1"><code>ERROR: provided hosts list is empty 
Ansible failed to complete successfully. Any error output should be 
visible above. Please fix these errors and try again.</code></pre>
<p>Esto es debido a que se a&ntilde;adido cambios en la integraci&oacute;n de Vagrant y Ansible y es necesario que las m&aacute;quinas se llamen igual en Vagrant que en Ansible, para ello es necesario a&ntilde;adir la siguiente l&iacute;nea en el fichero Vagrantfile:</p>
<pre class="brush: actionscript3; gutter: false; first-line: 1">...
config.vm.provision :ansible do |ansible|
&nbsp;&nbsp;&nbsp; ansible.sudo = true
&nbsp;&nbsp;&nbsp; ansible.sudo_user = "root"
&nbsp;&nbsp;&nbsp; ansible.playbook = "devstack/devstack.yml"
&nbsp;&nbsp;&nbsp; ansible.inventory_path = "devstack/hosts"
&nbsp;&nbsp;&nbsp; ansible.verbose = true
    <strong>ansible.limit = 'devstack'</strong>
&nbsp; endcd vagrant-ansible-devstack
...</pre>
