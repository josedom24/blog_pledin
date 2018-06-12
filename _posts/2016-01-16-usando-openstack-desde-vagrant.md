---
id: 1446
title: Usando OpenStack desde Vagrant
date: 2016-01-16T18:18:51+00:00


guid: http://www.josedomingo.org/pledin/?p=1446
permalink: /2016/01/usando-openstack-desde-vagrant/


tags:
  - Cloud Computing
  - OpenStack
  - Vagrant
---
<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/vagrant_openstack.png" rel="attachment wp-att-1447"><img class="aligncenter size-full wp-image-1447" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/vagrant_openstack.png" alt="vagrant_openstack" width="700" height="328" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/vagrant_openstack.png 700w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/vagrant_openstack-300x141.png 300w" sizes="(max-width: 700px) 100vw, 700px" /></a>

<p style="text-align: justify;">
  Vagrant nos permite automatizar la creación y gestión de máquinas virtuales. Las máquinas virtuales creadas por vagrant se pueden ejecutar con distintos gestores de máquinas virtuales (VirtualBox, VMWare, KVM,…), pero también tenemos a nuestra disposición varios proveedores donde podemos lanzar máquinas virtuales usando vagrant, por ejemplo Amazon Web Service. En este artículo, sin embargo, vamos a utilizar vagrant para crear instancias en un entorno de Cloud Computing IaaS desarrollado con OpenStack. Si no estás familiarizado con vagrant y quieres aprender a usarlo, ya hice una introducción a esta herramienta en el artículo: <a href="http://www.josedomingo.org/pledin/2013/09/gestionando-maquinas-virtuales-con-vagrant/">Gestionando máquinas virtuales con Vagrant</a>. En otro caso, si no tienes experiencia trabajando con OpenStack, olvídate de este tutorial y <a href="https://www.openstack.org/">empieza a leer</a>.
</p>

<h2 style="text-align: justify;">
  Configuración de vagrant
</h2>

<p style="text-align: justify;">
  Para utilizar la funcionalidad de gestionar instancias openstack desde vagrant, necesitamos instalar un plugin vagrant. El desarrollo de dicho plugin lo puedes encontrar en el repositorio GitHub: <a href="https://github.com/ggiamarchi/vagrant-openstack-provider/">ggiamarchi/vagrant-openstack-provider</a>, y se puede usar desde la versión 1.4 de vagrant. Para instalar el plugin, ejecutamos la siguiente instrucción:
</p>

<pre>$ <span class="pl-s1">vagrant plugin install vagrant-openstack-provider
</span></pre>

## Creación de una instancia

<p style="text-align: justify;">
  Una vez que tenemos que tenemos instalado el plugin, debemos crear una fichero <em>Vagrantfile,</em> donde definimos los parámetros necesarios para crear una instancia en openstack: por un lado los datos de credenciales para establecer la conexión  y por otro la información necesaria para crear una instancia (nombre, sabor, imagen, grupos de seguridad, redes, &#8230;).
</p>

<p style="text-align: justify;">
  Para indicar los datos de las credenciales en el fichero <em>Vagranfile</em>, he optado por cargar el fichero de credenciales de OpenStack y utilizar el nombre de las variables de entorno que creamos, para ello:
</p>

<pre>$ source openrc.sh</pre>

<p style="text-align: justify;">
  Y un ejemplo del fichero <em>Vagrantfile</em>, podría ser  el siguiente:
</p>

<pre>require 'vagrant-openstack-provider'

Vagrant.configure('2') do |config|

  config.vm.box       = 'openstack'
  config.ssh.username = 'debian'

  config.vm.provider :openstack do |os|
    os.openstack_auth_url = ENV['OS_AUTH_URL']
    os.username           = ENV['OS_USERNAME']
    os.password           = ENV['OS_PASSWORD']
    os.tenant_name        = ENV['OS_TENANT_NAME']
    os.region             = ENV['OS_REGION_NAME']
    os.server_name        = "server"
    os.flavor             = 'm1.small'
    os.image              = 'Debian Jessie 8.2'
    os.security_groups    = ['default']
    os.floating_ip_pool   = 'ext-net'
    os.networks = ['red']
  end
end</pre>

<p style="text-align: justify;">
  <!--more-->Veamos los distintos parámetros que hemos indicado:
</p>

<li style="text-align: justify;">
  <strong>config.vm.box</strong>: Por compatibilidad con las distintas versiones de vagrant, se indica el box que vamos a utilizar, aunque evidentemente no corresponde con ningún box que tengamos en el disco local.
</li>
<li style="text-align: justify;">
  <strong>config.ssh.username</strong>: El nombre de usuario que voy a usar para conectarme por ssh a la instancia. Veremos posteriormente que si creamos varias máquinas con distintas distribuciones Linux, este parámetro se puede configurar para cada una de las máquinas.
</li>
<li style="text-align: justify;">
  <strong>os.openstack_auth_url, os.username, os.password, os.tenant_name, os.region</strong>: Credenciales de acceso a OpenStack.
</li>
<li style="text-align: justify;">
  <strong>os.server_name</strong>: Nombre de la instancia.
</li>
<li style="text-align: justify;">
  <strong>os.flavor</strong>: Sabor que se va a utilizar para crear la instancia.
</li>
<li style="text-align: justify;">
  <strong>os.image</strong>: Imagen que se va a instanciar.
</li>
<li style="text-align: justify;">
  <strong>os.security_groups</strong>: Lista con los grupos de seguridad que afectan a la instancia.
</li>
<li style="text-align: justify;">
  <strong>os.floating_ip_pool</strong>: Indicamos el pool de ip flotantes. También podemos usar el parámetro <strong>floating_ip</strong>, indicando directamente una IP flotante que tiene que estar reservada en el proyecto.
</li>
<li style="text-align: justify;">
  <strong>os.networks</strong>: Lista de redes donde vamos a conectar la instancia.
</li>

Para crear la instancia, ejecutamos la siguiente instrucción:

<pre>$ vagrant up --provider=openstack
Bringing machine 'default' up with 'openstack' provider...
==&gt; default: Finding flavor for server...
==&gt; default: Finding image for server...
==&gt; default: Finding network(s) for server...
==&gt; default: Launching a server with the following settings...
==&gt; default:  -- Tenant          : Proyecto de josedom
==&gt; default:  -- Name            : server
==&gt; default:  -- Flavor          : m1.small
==&gt; default:  -- FlavorRef       : 3
==&gt; default:  -- Image           : Debian Jessie 8.2
==&gt; default:  -- ImageRef        : d303f65a-ff05-4bd3-a857-fd095699106e
==&gt; default:  -- KeyPair         : vagrant-generated-v93pw19v
==&gt; default:  -- Network         : 238f2e88-0322-43ce-895b-cadffab89dc9
==&gt; default: Waiting for the server to be built...
==&gt; default: Using floating IP 172.22.204.198
==&gt; default: Waiting for SSH to become available...
ssh: connect to host 172.22.204.198 port 22: Connection refused
ssh: connect to host 172.22.204.198 port 22: Connection refused
Connection to 172.22.204.198 closed.
==&gt; default: The server is ready!</pre>

<p style="text-align: justify;">
  Y podemos acceder a la instancia ejecutando la siguiente instrucción:
</p>

<pre>$ vagrant ssh

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Sat Jan 16 16:40:03 2016 from 172.19.0.26
debian@server:~$</pre>

<p style="text-align: justify;">
  Y podemos comprobar que realmente se ha creado una instancia en openstack utilizando el cliente de línea de comandos:
</p>

<pre>$ nova show server
+--------------------------------------+----------------------------------------------------------+
| Property                             | Value                                                    |
+--------------------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig                    | MANUAL                                                   |
| OS-EXT-AZ:availability_zone          | nova                                                     |
| OS-EXT-STS:power_state               | 1                                                        |
| OS-EXT-STS:task_state                | -                                                        |
| OS-EXT-STS:vm_state                  | active                                                   |
| OS-SRV-USG:launched_at               | 2016-01-16T16:39:42.000000                               |
| OS-SRV-USG:terminated_at             | -                                                        |
| accessIPv4                           |                                                          |
| accessIPv6                           |                                                          |
| config_drive                         |                                                          |
| created                              | 2016-01-16T16:38:41Z                                     |
| flavor                               | m1.small (3)                                             |
| hostId                               | e4f23fc1be36f4bacde067d97c4a4d1a11dd99941ca8df1a442657a7 |
| id                                   | 2654cdeb-ffe5-429e-91a3-c43d26bc566c                     |
| image                                | Debian Jessie 8.2 (d303f65a-ff05-4bd3-a857-fd095699106e) |
| key_name                             | vagrant-generated-v93pw19v                               |
| metadata                             | {}                                                       |
| name                                 | server                                                   |
| os-extended-volumes:volumes_attached | []                                                       |
| progress                             | 0                                                        |
| red network                          | 10.0.0.138, 172.22.204.198                               |
| security_groups                      | default                                                  |
| status                               | ACTIVE                                                   |
| tenant_id                            | 6154f7897cd64fbbb8da7de098e1b0b4                         |
| updated                              | 2016-01-16T16:39:08Z                                     |
| user_id                              | 99633b6e37bb4a7e9fbf387b0f10857d                         |
+--------------------------------------+----------------------------------------------------------+</pre>

## Creando varias instancias

En el siguiente ejemplo vamos a crear dos instancias, veamos el fichero Vagrantfile:

<pre>require 'vagrant-openstack-provider'

Vagrant.configure('2') do |config|

  config.vm.box       = 'openstack'
  config.ssh.username = ''

  config.vm.provider :openstack do |os|
    os.openstack_auth_url = ENV['OS_AUTH_URL']
    os.username           = ENV['OS_USERNAME']
    os.password           = ENV['OS_PASSWORD']
    os.tenant_name        = ENV['OS_TENANT_NAME']
    os.region             = ENV['OS_REGION_NAME']
  end

    config.vm.define 'server-1' do |s|
     s.vm.provider :openstack do |os, override|
      override.ssh.username = 'debian'
      os.server_name        = 'server-1'
      os.image              = 'Debian Jessie 8.2'
      os.flavor             = 'm1.small'
      os.security_groups    = ['default']
      os.networks           = ['red']
      os.volumes            = ['vol1']
      os.floating_ip_pool   = 'ext-net'

    end
    end

  config.vm.define 'server-2' do |s|
    s.vm.provider :openstack do |os, override|
      override.ssh.username = 'ubuntu'
      os.server_name        = 'server-2'
      os.image              = 'Ubuntu 14.04 LTS'
      os.flavor             = 'm1.small'
      os.security_groups    = ['default']
      os.networks           = ['red2']
      os.volumes            = ['vol2']
      os.floating_ip_pool   = 'ext-net'

    end
  end
end</pre>

Como podemos observar tenemos las siguientes características:

  * Vamos a crear una instancia desde una imagen correspondiente a una distribución Debian y otra desde una Ubuntu, por lo que hay que indicar usuarios distintos para acceder por ssh a cada instancia  (**override.ssh.username**).
  * Las dos instancias tienen el mismo sabor y el mismo grupo de seguridad, pero podrían ser distintos.
  * Las dos instancias están conectadas a redes diferentes. Las redes deben estar creadas en nuestro proyecto.
  * Con el parámetro **os.volumes**, indicamos una lista de volúmenes que se van a conectar a la instancia. Cada instancia tiene un volumen conectado, estos volúmenes deben estar creado en nuestro proyecto.

Creamos las instancias:

<pre>$ vagrant up --provider=openstack
Bringing machine 'server-1' up with 'openstack' provider...
Bringing machine 'server-2' up with 'openstack' provider...
==&gt; server-1: Finding flavor for server...
==&gt; server-1: Finding image for server...
==&gt; server-1: Finding network(s) for server...
==&gt; server-1: Finding volume(s) to attach on server...
==&gt; server-1: Launching a server with the following settings...
==&gt; server-1:  -- Tenant          : Proyecto de josedom
==&gt; server-1:  -- Name            : server-1
==&gt; server-1:  -- Flavor          : m1.small
==&gt; server-1:  -- FlavorRef       : 3
==&gt; server-1:  -- Image           : Debian Jessie 8.2
==&gt; server-1:  -- ImageRef        : d303f65a-ff05-4bd3-a857-fd095699106e
==&gt; server-1:  -- KeyPair         : vagrant-generated-exrdx618
==&gt; server-1:  -- Network         : 238f2e88-0322-43ce-895b-cadffab89dc9
==&gt; server-1:  -- Volume attached : e34769d3-3bdc-43ed-ad31-837af2dc14ef =&gt; auto
==&gt; server-1: Waiting for the server to be built...
==&gt; server-1: Using floating IP 172.22.203.243
==&gt; server-1: Waiting for SSH to become available...
==&gt; server-1: The server is ready!
==&gt; server-2: Finding flavor for server...
==&gt; server-2: Finding image for server...
==&gt; server-2: Finding network(s) for server...
==&gt; server-2: Finding volume(s) to attach on server...
==&gt; server-2: Launching a server with the following settings...
==&gt; server-2:  -- Tenant          : Proyecto de josedom
==&gt; server-2:  -- Name            : server-2
==&gt; server-2:  -- Flavor          : m1.small
==&gt; server-2:  -- FlavorRef       : 3
==&gt; server-2:  -- Image           : Ubuntu 14.04 LTS
==&gt; server-2:  -- ImageRef        : b8a89bd8-cf98-4902-a699-b2810341c59b
==&gt; server-2:  -- KeyPair         : vagrant-generated-qhyppfck
==&gt; server-2:  -- Network         : 5ba0f55a-9265-4d14-881c-9f291fa5b879
==&gt; server-2:  -- Volume attached : 6e64c6b0-c26a-4a0c-b9c7-946e85ec3ab1 =&gt; auto
==&gt; server-2: Waiting for the server to be built...
==&gt; server-2: Using floating IP 172.22.203.58
==&gt; server-2: Waiting for SSH to become available...
==&gt; server-2: The server is ready!</pre>

Podemos acceder, por ejemplo, a la segunda instancia y comprobar que tiene un volumen asociado:

<pre>$ vagrant ssh server-2
Welcome to Ubuntu 14.04.3 LTS (GNU/Linux 3.13.0-65-generic x86_64)

 * Documentation:  https://help.ubuntu.com/

  System information as of Sat Jan 16 17:00:51 UTC 2016

  System load:  0.4              Processes:           76
  Usage of /:   7.2% of 9.81GB   Users logged in:     0
  Memory usage: 5%               IP address for eth0: 192.168.0.4
  Swap usage:   0%

  Graph this data and manage this system at:
    https://landscape.canonical.com/

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

0 packages can be updated.
0 updates are security updates.


Last login: Sat Jan 16 17:00:45 2016 from 172.19.0.26
ubuntu@server-2:~$ lsblk
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
vda    253:0    0  10G  0 disk 
└─vda1 253:1    0  10G  0 part /
vdb    253:16   0   1G  0 disk</pre>

Y finalmente comprobamos con los clinetes **nova** y **cinder** que, efectivamente las instancias están conectadas a redes distintas y que tienen un volumen asociado:

<pre>$ nova list
+--------------------------------------+----------+---------+------------+-------------+---------------------------------+
| ID                                   | Name     | Status  | Task State | Power State | Networks                        |
+--------------------------------------+----------+---------+------------+-------------+---------------------------------+
| eac4c1e3-8be6-4061-8e59-85b3a891a1a5 | server-1 | ACTIVE  | -          | Running     | red=10.0.0.139, 172.22.203.243  |
| be1e8a5c-1498-4549-a68a-52a24b1a0fbf | server-2 | ACTIVE  | -          | Running     | red2=192.168.0.4, 172.22.203.58 |
+--------------------------------------+----------+---------+------------+-------------+---------------------------------+</pre>

<pre>$ cinder list
+--------------------------------------+--------+--------------+------+-------------+----------+--------------------------------------+
|                  ID                  | Status | Display Name | Size | Volume Type | Bootable |             Attached to              |
+--------------------------------------+--------+--------------+------+-------------+----------+--------------------------------------+
| 6e64c6b0-c26a-4a0c-b9c7-946e85ec3ab1 | in-use |     vol2     |  1   |     None    |  false   | be1e8a5c-1498-4549-a68a-52a24b1a0fbf |
| e34769d3-3bdc-43ed-ad31-837af2dc14ef | in-use |     vol1     |  1   |     None    |  false   | eac4c1e3-8be6-4061-8e59-85b3a891a1a5 |
+--------------------------------------+--------+--------------+------+-------------+----------+--------------------------------------+</pre>

## Conclusiones

<p style="text-align: justify;">
  Aunque parece que el plagin de vagrant que estamos estudiando está en desarrollo y tiene funcionalidades limitadas, por ejemplo sólo se puede crear instancias, no se pueden crear otros recursos (volúmenes, redes, &#8230;), puede ser una forma sencilla de gestionar pequeños escenarios con openstack si estás acostumbrado a usar vagrant. En este artículo hemos visto muchas de las funcionalidades desarrolladas, pero existen más que puedes encontrar en la <a href="https://github.com/ggiamarchi/vagrant-openstack-provider/blob/master/README.md">documentación</a>.
</p>

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->