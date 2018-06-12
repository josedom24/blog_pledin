---
id: 978
title: 'Instalando OpenStack en mi portátil (2ª parte): DevStack'
date: 2014-03-29T21:23:35+00:00


guid: http://www.josedomingo.org/pledin/?p=978
permalink: /2014/03/instalando-openstack-en-mi-portatil-2a-parte-devstack/


tags:
  - ansible
  - Cloud Computing
  - devstack
  - OpenStack
  - Vagrant
  - Virtualización
---
[<img class="aligncenter size-full wp-image-979" alt="devstack" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/03/devstack.png" width="436" height="67" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/03/devstack.png 436w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/03/devstack-300x46.png 300w" sizes="(max-width: 436px) 100vw, 436px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/03/devstack.png)[DevStack](http://devstack.org/) es un conjunto de script bash que nos permiten instalar OpenStack de forma automática. Tenemos varias formas de realizar la instalación:

## En una máquina física

En este caso partimos de un ordenador instalado con Ubuntu 12.04, y como vemos en la página principal los pasos son muy sencillos: clonamos el repositorio git y elegimos la rama estable de la versión **havana**.

<pre>git clone https://github.com/openstack-dev/devstack.git
cd devstack
git checkout stable/havana
Branch stable/havana set up to track remote branch stable/havana from origin.
Switched to a new branch 'stable/havana'
./stack.sh</pre>

Antes de ejecutar el script podemos [configurar](http://devstack.org/configuration.html) distintas opciones de configuración.

## En una máquina virtual

Aunque la opción que nos ofrece más rendimiento es la que hemos visto anteriormente, ya que la virtualización se hace con KVM, DevStack nos ofrece la posibilidad de ejecutar OpenStack sobre una máquina virtual. Evidentemente en este caso tendremos menos rendimiento y las instancias se ejecutarán con el emulador QEMU.

<!--more-->

Para llevar a cabo esta opción podemos utilizar el repositorio GitHub: <https://github.com/xiaohanyu/vagrant-ansible-devstack>, desarrollado por [Xiao Hanyu](https://github.com/xiaohanyu), que nos crea una máquina virtual con Ubuntu 12.04 utilizando Vagrant y posteriormente una receta ansible nos ejecuta el script de DevStack sobre la máquina virtual.

### Pasos para la instalación

1) Partimos de una máquina con el siguiente software instalado (al igual que el comentado en la entrada anterior: [Instalando OpenStack en mi portátil](http://www.josedomingo.org/pledin/2014/02/instalando-openstack-en-mi-portatil/ "Instalando OpenStack en mi portátil")):

  * VirtualBox 4.1.18
  * Vagrant 1.5.1
  * Ansible 1.4.4

2) Clonamos el repositorio:

<pre>git clone https://github.com/xiaohanyu/vagrant-ansible-devstack.git</pre>

3) Configuramos la instalación:

En el directorio devstack encontramos la receta ansible en el fichero devstack.yml, donde podemos hacer las siguientes modificaciones en la configuración de la instalación:

  * **La versión de OpenStack que queremos instalar: **Indicando la rama del repositorio GitHub que queremos instalar, podemos indicar tres valores en la variable _branch_:

<pre>branch: master
branch: stable/havana
branch: stable/icehouse</pre>

La rama _master_ es la de desarrollado, por lo tanto puede tener errores, por lo que nos recomiendan instalar las ramas estables de la versión _havana_ (2013.2) o _icehouse_ (2014.1).

  * **Los componentes de OpenStack que queremos instalar:** para ello indicamos el fichero de configuración que vamos a copiar a la máquina virtual en la tarea  _**&#8220;copy localrc&#8221;**_, tenemos la posibilidad de indicar dos ficheros: <pre class="brush: actionscript3; gutter: false; first-line: 1">template: src=<strong>localrc.basic</strong> dest=/home/vagrant/devstack/localrc
template: src=<strong>localrc.full</strong> dest=/home/vagrant/devstack/localrc</pre>

  1. El fichero **localrc.basic** nos permite hacer una configuración básica con los siguientes componentes: nova, cinder, glance, swift, keystone y horizon. Con este tipo de configuración tenemos suficiente con 1Gb de RAM en la máquina virtual.
  2. El fichero **localrc.full** añade los componentes de neutron, heat y ceilometer. Con esta configuración necesitamos 2Gb de RAM en la máquina virtual.

4) Iniciamos la máquina virtual con vagrant, una vez creada se ejecutará la receta ansible (suponemos que tenemos instalado el box precise64, para más información lee la [entrada anterior](http://www.josedomingo.org/pledin/2014/02/instalando-openstack-en-mi-portatil/ "Instalando OpenStack en mi portátil")):

<pre class="brush: actionscript3; gutter: false; first-line: 1">cd vagrant-ansible-devstack
vagrant up</pre>

## Accediendo a OpenStack

Una vez terminada la instalación, podemos acceder a horizon accediendo a la url http://192.168.27.100/:

[<img class="aligncenter size-full wp-image-984" alt="openstack1" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/03/openstack1.png" width="545" height="586" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/03/openstack1.png 545w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/03/openstack1-279x300.png 279w" sizes="(max-width: 545px) 100vw, 545px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/03/openstack1.png)Se han creado dos usuarios:

  * El usuario administrador se llama **admin**, con contraseña **devstack**.
  * Un usuario sin privilegios llamado **demo**, con contraseña **devstack**.

Ya podemos trabajar con OpenStack, podemos crear un par de claves ssh, añadimos el puerto 22 a nuestras _Reglas de Seguridad_, y creamos una instancia a partir de la imagen cirros, a la que le hemos añadido nuestra claves ssh para acceder y hemos asociado una ip flotante:

[<img class="aligncenter size-full wp-image-991" alt="openstack2" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/03/openstack2.png" width="1114" height="222" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/03/openstack2.png 1114w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/03/openstack2-300x59.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/03/openstack2-1024x204.png 1024w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/03/openstack2-800x159.png 800w" sizes="(max-width: 1114px) 100vw, 1114px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/03/openstack2.png)Podemos también utilizar el cliente **nova** desde la máquina virtual para interactuar con el cloud, para ello:

<pre>cd vagrant-ansible-devstack
vagrant ssh

# cd devstack
devstack# source openrc
devstack# nova list
+--------------------------------------+-----------+--------+------------+-------------+----------------------------------+
| ID                                   | Name      | Status | Task State | Power State | Networks                         |
+--------------------------------------+-----------+--------+------------+-------------+----------------------------------+
| c397c246-3cb8-4f7a-9aec-328a21813f6b | mimaquina | ACTIVE | -          | Running     | private=10.0.0.2, 192.168.27.130 |
+--------------------------------------+-----------+--------+------------+-------------+----------------------------------+</pre>

## Accediendo a la instancia

Desde nuestra máquina podemos acceder a la instancia accediendo por ssh a la ip flotante:

<pre class="brush: actionscript3; gutter: false; first-line: 1">$ chmod 400 miclave.pem 
$ ssh -i miclave.pem cirros@192.168.27.130
The authenticity of host '192.168.27.130 (192.168.27.130)' can't be established.
RSA key fingerprint is f8:63:88:42:e1:0b:6f:4e:2e:64:02:46:5d:bb:d3:97.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.27.130' (RSA) to the list of known hosts.
$</pre>

## ¿Qué hacemos cuando hemos terminado?

Una vez que hemos terminado de trabajar con OpenStack y antes de apagar nuestra máquina virtual, debemos parar los servicios, ejecutando el script _unstack.sh._ Cuando volvamos a __encender la máquina debemos volver a ejecutar los servicios ejecutando el script _rejoin-stack.sh_. __Estos scripts hay que ejecutarlos desde la máquina virtual:

<pre>cd vagrant-ansible-devstack
vagrant ssh
# cd devstack
# ./unstack.sh</pre>

Ahora podemos apagar nuestra máquina virtual. Cuando queramos seguir trabajando, encendemos la máquina y ejecutamos:

<pre>cd vagrant-ansible-devstack
vagrant ssh
# cd devstack
# ./rejoin-stack.sh</pre>

## Solucionar error con ansible

Si estamos utilizando la última versión de Vagrant (1.5.1) nos aparece el siguiente error:

<pre class="brush: actionscript3; gutter: false; first-line: 1"><code>ERROR: provided hosts list is empty 
Ansible failed to complete successfully. Any error output should be 
visible above. Please fix these errors and try again.</code></pre>

Esto es debido a que se añadido cambios en la integración de Vagrant y Ansible y es necesario que las máquinas se llamen igual en Vagrant que en Ansible, para ello es necesario añadir la siguiente línea en el fichero Vagrantfile:

<pre class="brush: actionscript3; gutter: false; first-line: 1">...
config.vm.provision :ansible do |ansible|
    ansible.sudo = true
    ansible.sudo_user = "root"
    ansible.playbook = "devstack/devstack.yml"
    ansible.inventory_path = "devstack/hosts"
    ansible.verbose = true
    <strong>ansible.limit = 'devstack'</strong>
  endcd vagrant-ansible-devstack
...</pre>

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->