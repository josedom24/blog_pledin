---
layout: post
status: publish
published: true
title: Usando OpenStack desde Vagrant
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1446
wordpress_url: http://www.josedomingo.org/pledin/?p=1446
date: '2016-01-16 18:18:51 +0000'
date_gmt: '2016-01-16 17:18:51 +0000'
categories:
- General
tags:
- Cloud Computing
- OpenStack
- Vagrant
comments: []
---
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/01/vagrant_openstack.png" rel="attachment wp-att-1447"><img class="aligncenter size-full wp-image-1447" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/01/vagrant_openstack.png" alt="vagrant_openstack" width="700" height="328" /></a></p>
<p style="text-align: justify;">Vagrant nos permite automatizar la creaci&oacute;n y gesti&oacute;n de m&aacute;quinas virtuales. Las m&aacute;quinas virtuales creadas por vagrant se pueden ejecutar con distintos gestores de m&aacute;quinas virtuales (VirtualBox, VMWare, KVM,&hellip;), pero tambi&eacute;n tenemos a nuestra disposici&oacute;n varios proveedores donde podemos lanzar m&aacute;quinas virtuales usando vagrant, por ejemplo Amazon Web Service. En este art&iacute;culo, sin embargo, vamos a utilizar vagrant para crear instancias en un entorno de Cloud Computing IaaS desarrollado con OpenStack. Si no est&aacute;s familiarizado con vagrant y quieres aprender a usarlo, ya hice una introducci&oacute;n a esta herramienta en el art&iacute;culo: <a href="http://www.josedomingo.org/pledin/2013/09/gestionando-maquinas-virtuales-con-vagrant/">Gestionando m&aacute;quinas virtuales con Vagrant</a>. En otro caso, si no tienes experiencia trabajando con OpenStack, olv&iacute;date de este tutorial y <a href="https://www.openstack.org/">empieza a leer</a>.</p>
<h2 style="text-align: justify;">Configuraci&oacute;n de vagrant</h2>
<p style="text-align: justify;">Para utilizar la funcionalidad de gestionar instancias openstack desde vagrant, necesitamos instalar un plugin vagrant. El desarrollo de dicho plugin lo puedes encontrar en el repositorio GitHub: <a href="https://github.com/ggiamarchi/vagrant-openstack-provider/">ggiamarchi/vagrant-openstack-provider</a>, y se puede usar desde la versi&oacute;n 1.4 de vagrant. Para instalar el plugin, ejecutamos la siguiente instrucci&oacute;n:</p>
<pre>$ <span class="pl-s1">vagrant plugin install vagrant-openstack-provider
</span></pre>
<h2>Creaci&oacute;n de una instancia</h2>
<p style="text-align: justify;">Una vez que tenemos que tenemos instalado el plugin, debemos crear una fichero <em>Vagrantfile,</em> donde definimos los par&aacute;metros necesarios para crear una instancia en openstack: por un lado los datos de credenciales para establecer la conexi&oacute;n&nbsp; y por otro la informaci&oacute;n necesaria para crear una instancia (nombre, sabor, imagen, grupos de seguridad, redes, ...).</p>
<p style="text-align: justify;">Para indicar los datos de las credenciales en el fichero <em>Vagranfile</em>, he optado por cargar el fichero de credenciales de OpenStack y utilizar el nombre de las variables de entorno que creamos, para ello:</p>
<pre>$ source openrc.sh</pre>
<p style="text-align: justify;">Y un ejemplo del fichero <em>Vagrantfile</em>, podr&iacute;a ser&nbsp; el siguiente:</p>
<pre>require 'vagrant-openstack-provider'

Vagrant.configure('2') do |config|

&nbsp; config.vm.box&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = 'openstack'
&nbsp; config.ssh.username = 'debian'

&nbsp; config.vm.provider :openstack do |os|
&nbsp;&nbsp;&nbsp; os.openstack_auth_url = ENV['OS_AUTH_URL']
&nbsp;&nbsp;&nbsp; os.username&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = ENV['OS_USERNAME']
&nbsp;&nbsp;&nbsp; os.password&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = ENV['OS_PASSWORD']
&nbsp;&nbsp;&nbsp; os.tenant_name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = ENV['OS_TENANT_NAME']
&nbsp;&nbsp;&nbsp; os.region&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = ENV['OS_REGION_NAME']
&nbsp;&nbsp;&nbsp; os.server_name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = "server"
&nbsp;&nbsp;&nbsp; os.flavor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = 'm1.small'
&nbsp;&nbsp;&nbsp; os.image&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = 'Debian Jessie 8.2'
&nbsp;&nbsp;&nbsp; os.security_groups&nbsp;&nbsp;&nbsp; = ['default']
&nbsp;&nbsp;&nbsp; os.floating_ip_pool&nbsp;&nbsp; = 'ext-net'
    os.networks = ['red']
&nbsp; end
end</pre>
<p style="text-align: justify;"><!--more-->Veamos los distintos par&aacute;metros que hemos indicado:</p>
<ul>
<li style="text-align: justify;"><strong>config.vm.box</strong>: Por compatibilidad con las distintas versiones de vagrant, se indica el box que vamos a utilizar, aunque evidentemente no corresponde con ning&uacute;n box que tengamos en el disco local.</li>
<li style="text-align: justify;"><strong>config.ssh.username</strong>: El nombre de usuario que voy a usar para conectarme por ssh a la instancia. Veremos posteriormente que si creamos varias m&aacute;quinas con distintas distribuciones Linux, este par&aacute;metro se puede configurar para cada una de las m&aacute;quinas.</li>
<li style="text-align: justify;"><strong>os.openstack_auth_url, os.username, os.password, os.tenant_name, os.region</strong>: Credenciales de acceso a OpenStack.</li>
<li style="text-align: justify;"><strong>os.server_name</strong>: Nombre de la instancia.</li>
<li style="text-align: justify;"><strong>os.flavor</strong>: Sabor que se va a utilizar para crear la instancia.</li>
<li style="text-align: justify;"><strong>os.image</strong>: Imagen que se va a instanciar.</li>
<li style="text-align: justify;"><strong>os.security_groups</strong>: Lista con los grupos de seguridad que afectan a la instancia.</li>
<li style="text-align: justify;"><strong>os.floating_ip_pool</strong>: Indicamos el pool de ip flotantes. Tambi&eacute;n podemos usar el par&aacute;metro <strong>floating_ip</strong>, indicando directamente una IP flotante que tiene que estar reservada en el proyecto.</li>
<li style="text-align: justify;"><strong>os.networks</strong>: Lista de redes donde vamos a conectar la instancia.</li>
</ul>
<p>Para crear la instancia, ejecutamos la siguiente instrucci&oacute;n:</p>
<pre>$ vagrant up --provider=openstack
Bringing machine 'default' up with 'openstack' provider...
==> default: Finding flavor for server...
==> default: Finding image for server...
==> default: Finding network(s) for server...
==> default: Launching a server with the following settings...
==> default:&nbsp; -- Tenant&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : Proyecto de josedom
==> default:&nbsp; -- Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : server
==> default:&nbsp; -- Flavor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : m1.small
==> default:&nbsp; -- FlavorRef&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 3
==> default:&nbsp; -- Image&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : Debian Jessie 8.2
==> default:&nbsp; -- ImageRef&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : d303f65a-ff05-4bd3-a857-fd095699106e
==> default:&nbsp; -- KeyPair&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : vagrant-generated-v93pw19v
==> default:&nbsp; -- Network&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 238f2e88-0322-43ce-895b-cadffab89dc9
==> default: Waiting for the server to be built...
==> default: Using floating IP 172.22.204.198
==> default: Waiting for SSH to become available...
ssh: connect to host 172.22.204.198 port 22: Connection refused
ssh: connect to host 172.22.204.198 port 22: Connection refused
Connection to 172.22.204.198 closed.
==> default: The server is ready!</pre>
<p style="text-align: justify;">Y podemos acceder a la instancia ejecutando la siguiente instrucci&oacute;n:</p>
<pre>$ vagrant ssh

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Sat Jan 16 16:40:03 2016 from 172.19.0.26
debian@server:~$</pre>
<p style="text-align: justify;">Y podemos comprobar que realmente se ha creado una instancia en openstack utilizando el cliente de l&iacute;nea de comandos:</p>
<pre>$ nova show server
+--------------------------------------+----------------------------------------------------------+
| Property&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Value&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
+--------------------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | MANUAL&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| OS-EXT-AZ:availability_zone&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | nova&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| OS-EXT-STS:power_state&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| OS-EXT-STS:task_state&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| OS-EXT-STS:vm_state&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | active&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| OS-SRV-USG:launched_at&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 2016-01-16T16:39:42.000000&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| OS-SRV-USG:terminated_at&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| accessIPv4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| accessIPv6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| config_drive&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| created&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 2016-01-16T16:38:41Z&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| flavor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | m1.small (3)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| hostId&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | e4f23fc1be36f4bacde067d97c4a4d1a11dd99941ca8df1a442657a7 |
| id&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 2654cdeb-ffe5-429e-91a3-c43d26bc566c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| image&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Debian Jessie 8.2 (d303f65a-ff05-4bd3-a857-fd095699106e) |
| key_name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | vagrant-generated-v93pw19v&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| metadata&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | {}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | server&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| os-extended-volumes:volumes_attached | []&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| progress&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| red network&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 10.0.0.138, 172.22.204.198&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| security_groups&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | default&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | ACTIVE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| tenant_id&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 6154f7897cd64fbbb8da7de098e1b0b4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| updated&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 2016-01-16T16:39:08Z&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| user_id&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 99633b6e37bb4a7e9fbf387b0f10857d&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
+--------------------------------------+----------------------------------------------------------+</pre>
<h2>Creando varias instancias</h2>
<p>En el siguiente ejemplo vamos a crear dos instancias, veamos el fichero Vagrantfile:</p>
<pre>require 'vagrant-openstack-provider'

Vagrant.configure('2') do |config|

&nbsp; config.vm.box&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = 'openstack'
&nbsp; config.ssh.username = ''

&nbsp; config.vm.provider :openstack do |os|
&nbsp;&nbsp;&nbsp; os.openstack_auth_url = ENV['OS_AUTH_URL']
&nbsp;&nbsp;&nbsp; os.username&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = ENV['OS_USERNAME']
&nbsp;&nbsp;&nbsp; os.password&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = ENV['OS_PASSWORD']
&nbsp;&nbsp;&nbsp; os.tenant_name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = ENV['OS_TENANT_NAME']
&nbsp;&nbsp;&nbsp; os.region&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = ENV['OS_REGION_NAME']
&nbsp; end

&nbsp;&nbsp;&nbsp; config.vm.define 'server-1' do |s|
&nbsp;&nbsp;&nbsp;&nbsp; s.vm.provider :openstack do |os, override|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; override.ssh.username = 'debian'
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; os.server_name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = 'server-1'
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; os.image&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = 'Debian Jessie 8.2'
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; os.flavor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = 'm1.small'
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; os.security_groups&nbsp;&nbsp;&nbsp; = ['default']
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; os.networks&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = ['red']
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; os.volumes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = ['vol1']
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; os.floating_ip_pool&nbsp;&nbsp; = 'ext-net'

&nbsp;&nbsp;&nbsp; end
&nbsp;&nbsp;&nbsp; end

&nbsp; config.vm.define 'server-2' do |s|
&nbsp;&nbsp;&nbsp; s.vm.provider :openstack do |os, override|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; override.ssh.username = 'ubuntu'
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; os.server_name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = 'server-2'
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; os.image&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = 'Ubuntu 14.04 LTS'
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; os.flavor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = 'm1.small'
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; os.security_groups&nbsp;&nbsp;&nbsp; = ['default']
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; os.networks&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = ['red2']
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; os.volumes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = ['vol2']
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; os.floating_ip_pool&nbsp;&nbsp; = 'ext-net'

&nbsp;&nbsp;&nbsp; end
&nbsp; end
end</pre>
<p>Como podemos observar tenemos las siguientes caracter&iacute;sticas:</p>
<ul>
<li>Vamos a crear una instancia desde una imagen correspondiente a una distribuci&oacute;n Debian y otra desde una Ubuntu, por lo que hay que indicar usuarios distintos para acceder por ssh a cada instancia&nbsp; (<strong>override.ssh.username</strong>).</li>
<li>Las dos instancias tienen el mismo sabor y el mismo grupo de seguridad, pero podr&iacute;an ser distintos.</li>
<li>Las dos instancias est&aacute;n conectadas a redes diferentes. Las redes deben estar creadas en nuestro proyecto.</li>
<li>Con el par&aacute;metro <strong>os.volumes</strong>, indicamos una lista de vol&uacute;menes que se van a conectar a la instancia. Cada instancia tiene un volumen conectado, estos vol&uacute;menes deben estar creado en nuestro proyecto.</li>
</ul>
<p>Creamos las instancias:</p>
<pre>$ vagrant up --provider=openstack
Bringing machine 'server-1' up with 'openstack' provider...
Bringing machine 'server-2' up with 'openstack' provider...
==> server-1: Finding flavor for server...
==> server-1: Finding image for server...
==> server-1: Finding network(s) for server...
==> server-1: Finding volume(s) to attach on server...
==> server-1: Launching a server with the following settings...
==> server-1:&nbsp; -- Tenant&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : Proyecto de josedom
==> server-1:&nbsp; -- Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : server-1
==> server-1:&nbsp; -- Flavor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : m1.small
==> server-1:&nbsp; -- FlavorRef&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 3
==> server-1:&nbsp; -- Image&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : Debian Jessie 8.2
==> server-1:&nbsp; -- ImageRef&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : d303f65a-ff05-4bd3-a857-fd095699106e
==> server-1:&nbsp; -- KeyPair&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : vagrant-generated-exrdx618
==> server-1:&nbsp; -- Network&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 238f2e88-0322-43ce-895b-cadffab89dc9
==> server-1:&nbsp; -- Volume attached : e34769d3-3bdc-43ed-ad31-837af2dc14ef => auto
==> server-1: Waiting for the server to be built...
==> server-1: Using floating IP 172.22.203.243
==> server-1: Waiting for SSH to become available...
==> server-1: The server is ready!
==> server-2: Finding flavor for server...
==> server-2: Finding image for server...
==> server-2: Finding network(s) for server...
==> server-2: Finding volume(s) to attach on server...
==> server-2: Launching a server with the following settings...
==> server-2:&nbsp; -- Tenant&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : Proyecto de josedom
==> server-2:&nbsp; -- Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : server-2
==> server-2:&nbsp; -- Flavor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : m1.small
==> server-2:&nbsp; -- FlavorRef&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 3
==> server-2:&nbsp; -- Image&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : Ubuntu 14.04 LTS
==> server-2:&nbsp; -- ImageRef&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : b8a89bd8-cf98-4902-a699-b2810341c59b
==> server-2:&nbsp; -- KeyPair&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : vagrant-generated-qhyppfck
==> server-2:&nbsp; -- Network&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 5ba0f55a-9265-4d14-881c-9f291fa5b879
==> server-2:&nbsp; -- Volume attached : 6e64c6b0-c26a-4a0c-b9c7-946e85ec3ab1 => auto
==> server-2: Waiting for the server to be built...
==> server-2: Using floating IP 172.22.203.58
==> server-2: Waiting for SSH to become available...
==> server-2: The server is ready!</pre>
<p>Podemos acceder, por ejemplo, a la segunda instancia y comprobar que tiene un volumen asociado:</p>
<pre>$ vagrant ssh server-2
Welcome to Ubuntu 14.04.3 LTS (GNU/Linux 3.13.0-65-generic x86_64)

&nbsp;* Documentation:&nbsp; https://help.ubuntu.com/

&nbsp; System information as of Sat Jan 16 17:00:51 UTC 2016

&nbsp; System load:&nbsp; 0.4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Processes:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 76
&nbsp; Usage of /:&nbsp;&nbsp; 7.2% of 9.81GB&nbsp;&nbsp; Users logged in:&nbsp;&nbsp;&nbsp;&nbsp; 0
&nbsp; Memory usage: 5%&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IP address for eth0: 192.168.0.4
&nbsp; Swap usage:&nbsp;&nbsp; 0%

&nbsp; Graph this data and manage this system at:
&nbsp;&nbsp;&nbsp; https://landscape.canonical.com/

&nbsp; Get cloud support with Ubuntu Advantage Cloud Guest:
&nbsp;&nbsp;&nbsp; http://www.ubuntu.com/business/services/cloud

0 packages can be updated.
0 updates are security updates.


Last login: Sat Jan 16 17:00:45 2016 from 172.19.0.26
ubuntu@server-2:~$ lsblk
NAME&nbsp;&nbsp; MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
vda&nbsp;&nbsp;&nbsp; 253:0&nbsp;&nbsp;&nbsp; 0&nbsp; 10G&nbsp; 0 disk 
└─vda1 253:1&nbsp;&nbsp;&nbsp; 0&nbsp; 10G&nbsp; 0 part /
vdb&nbsp;&nbsp;&nbsp; 253:16&nbsp;&nbsp; 0&nbsp;&nbsp; 1G&nbsp; 0 disk</pre>
<p>Y finalmente comprobamos con los clinetes <strong>nova</strong> y <strong>cinder</strong> que, efectivamente las instancias est&aacute;n conectadas a redes distintas y que tienen un volumen asociado:</p>
<pre>$ nova list
+--------------------------------------+----------+---------+------------+-------------+---------------------------------+
| ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Name&nbsp;&nbsp;&nbsp;&nbsp; | Status&nbsp; | Task State | Power State | Networks&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
+--------------------------------------+----------+---------+------------+-------------+---------------------------------+
| eac4c1e3-8be6-4061-8e59-85b3a891a1a5 | server-1 | ACTIVE&nbsp; | -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Running&nbsp;&nbsp;&nbsp;&nbsp; | red=10.0.0.139, 172.22.203.243&nbsp; |
| be1e8a5c-1498-4549-a68a-52a24b1a0fbf | server-2 | ACTIVE&nbsp; | -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Running&nbsp;&nbsp;&nbsp;&nbsp; | red2=192.168.0.4, 172.22.203.58 |
+--------------------------------------+----------+---------+------------+-------------+---------------------------------+</pre>
<pre>$ cinder list
+--------------------------------------+--------+--------------+------+-------------+----------+--------------------------------------+
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Status | Display Name | Size | Volume Type | Bootable |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Attached to&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
+--------------------------------------+--------+--------------+------+-------------+----------+--------------------------------------+
| 6e64c6b0-c26a-4a0c-b9c7-946e85ec3ab1 | in-use |&nbsp;&nbsp;&nbsp;&nbsp; vol2&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; 1&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp; None&nbsp;&nbsp;&nbsp; |&nbsp; false&nbsp;&nbsp; | be1e8a5c-1498-4549-a68a-52a24b1a0fbf |
| e34769d3-3bdc-43ed-ad31-837af2dc14ef | in-use |&nbsp;&nbsp;&nbsp;&nbsp; vol1&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; 1&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp; None&nbsp;&nbsp;&nbsp; |&nbsp; false&nbsp;&nbsp; | eac4c1e3-8be6-4061-8e59-85b3a891a1a5 |
+--------------------------------------+--------+--------------+------+-------------+----------+--------------------------------------+</pre>
<h2>Conclusiones</h2>
<p style="text-align: justify;">Aunque parece que el plagin de vagrant que estamos estudiando est&aacute; en desarrollo y tiene funcionalidades limitadas, por ejemplo s&oacute;lo se puede crear instancias, no se pueden crear otros recursos (vol&uacute;menes, redes, ...), puede ser una forma sencilla de gestionar peque&ntilde;os escenarios con openstack si est&aacute;s acostumbrado a usar vagrant. En este art&iacute;culo hemos visto muchas de las funcionalidades desarrolladas, pero existen m&aacute;s que puedes encontrar en la <a href="https://github.com/ggiamarchi/vagrant-openstack-provider/blob/master/README.md">documentaci&oacute;n</a>.</p>
