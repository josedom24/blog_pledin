---
id: 920
title: Instalando OpenStack en mi portátil
date: 2014-02-11T00:04:30+00:00


guid: http://www.josedomingo.org/pledin/?p=920
permalink: /2014/02/instalando-openstack-en-mi-portatil/


tags:
  - ansible
  - Cloud Computing
  - OpenStack
  - Vagrant
  - Virtualización
---
<p style="text-align: center;">
  <a href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/vao.png"><img class="aligncenter size-full wp-image-924" alt="vao" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/vao.png" width="800" height="250" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/vao.png 800w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/vao-300x93.png 300w" sizes="(max-width: 800px) 100vw, 800px" /></a>
</p>

El objetivo de esta entrada es contar mi experiencia de instalar el software de Cloud Computing OpenStack en mi ordenador a partir del repositorio de GitHub: <https://github.com/openstack-ansible/openstack-ansible>. Se trata de la instalación de un escenario formado por varias máquinas virtuales desplegadas con Vagrant donde se instala OpenStack a partir de recetas desarrolladas en ansible. Las personas que han desarrollado dichas recetas y son los mantenedores del repositorio son [Lorin Hochstein](https://github.com/lorin)  y [Mark Stillwell](https://github.com/marklee77).


## ¿Qué necesito para realizar la instalación?

* En primer lugar tenemos que tener en cuenta la memoria RAM que disponemos. Las cuatro máquinas que se despliegan necesitan 2,5 GB de RAM, por lo que creo que con un ordenador de 4 GB sería suficiente. Por otro lado partimos de que estamos usando un equipo con la extensión de virtualización hardware VT-x/AMD-v activada.
* El repositorio que vamos a utilizar se encuentra en GitHub por lo tanto tenemos que tener instalado el paquete git en nuestro ordenador:

        # apt-get install git

* El software que se va a utilizar para ejecutar las máquinas virtuales es VirtualBox que en mi caso está instalado sobre un sistema operativo GNU Linux Debian Wheezy. La versión de VirtualBox que estoy utilizando es 4.1.18. Para la instalación, ejecutamos simplemente:

        # apt-get install virtualbox

* Siguiendo la documentación también necesitamos instalar el paquete [python-netaddr](https://pypi.python.org/pypi/netaddr/), para ello: # apt-get install python-netaddr

* Con [Vagrant](http://www.vagrantup.com/) podemos virtualizar entornos de desarrollo. Esta herramienta nos permite automatizar la creación y gestión de máquinas virtuales. Vamos a utilizar esta herramienta para definir y gestionar las máquinas virtuales que vamos a usar. Estas máquinas serán ejecutadas en VirtualBox. En el momento de escribir esta entrada la versión de vagrant es la 1.4.3, podemos bajarnos el paquete deb de la página oficial e instalarlo en nuestro sistema:

        # wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.4.3_x86_64.deb
        # dpkg -i vagrant_1.4.3_x86_64.deb

    Las máquinas virtuales que se crean tienen el sistema operativo Ubuntu 12.04 amd64, por lo tanto es conveniente descargar el box de vagrant precise64 con el siguiente comando:

        # vagrant box add precise64 http://files.vagrantup.com/precise64.box

* Por último vamos a utilizar [ansible](http://www.ansible.com/home), una herramienta  que nos permite  automatizar y gestionar la configuración de nuestras máquinas. Podemos utilizar la herramienta pip para instalar la última versión de este programa:

        # apt-get install python-pip python-dev
        # pip install ansible

## Presentando el escenario que vamos a desplegar

Un vez que tenemos instaladas las herramientas necesarias, vamos a obtener el repositorio desde el que vamos a realizar la instalación, para ello tenemos que clonarlo ejecutando los siguientes comandos:

    git clone https://github.com/openstack-ansible/openstack-ansible
    cd openstack-ansible
    git submodule update --init

Para iniciar la instalación simplemente tendremos que ejecutar el comando:

    openstack-ansible# make

Este comando ejecuta los pasos que se encuentran definido en el fichero Makefile, que de forma resumida son los siguientes:

1. **Se crean las máquinas virtuales** con el comando `vagrant up` utilizando como fichero de configuración `Vagranfile`, que podemos encontrar en el directorio `testcase/standard`.

    Es esquema de máquinas que se levantan son las siguientes y la los podemos representar usando el siguiente esquema:

      * 10.1.0.2, nodo controlador.
      * 10.1.0.3, nodo de computación.
      * 10.1.0.4, nodo de red (neutron).
      * 10.1.0.5, nodo de almacenamiento.

![os]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/InstalandoOpenStackEnMiPortatil.jpg)
  

{: .notice--danger}
Nota:Le doy las gracias a mi alumno [@EvaristoGZ](https://twitter.com/EvaristoGZ) por haber diseñado el esquema anterior. Puedes ver el esquema original que diseñé para esta entrada en este [enlace]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/esquema.png).

Además si accedemos a este directorio podemos manejar las máquinas virtuales (pararlas, arrancarlas o destruirlas). Estas tres acciones se harían con los siguientes comandos:

    openstack-ansible/testcases/standard# vagrant halt
    openstack-ansible/testcases/standard# vagrant up
    openstack-ansible/testcases/standard# vagrant destroy

2. **Se instalan los servicios necesarios en cada una de las máquinas que hemos arrancado.** Para ello se ejecuta la receta ansible `openstack-ansible/openstack.yaml` utilizando el fichero de configuración de los hosts que encontramos en el directorio del escenario `openstack-ansible/testcases/standard/ansible_hosts`. Si editamos el fichero de la receta nos daremos cuenta que existe una receta distinta para instalar los distintos servicios: keystone, swift, glance, neutron, cinder, nova, horizon, heat y ceilometer.

3. **Se levanta una instancia de prueba**. Para ello se ejecuta la receta ansible `openstack-ansible/demo.yaml`, utilizando el mismo fichero de configuración de los hosts visto en el punto anterior. Esta receta, sube una imagen cirros al sistema, crea el router y la red necesaria y por último lanza una instancia a la que le asigna una ip flotante.

## Accediendo a openstack

Si utilizamos la aplicación web horizon para trabajar, debemos acceder a la siguiente URL:

    http://10.1.0.2/horizon

![os]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/01.png)

Durante la instalación se han creado dos usuarios: un usuario de prueba: **demo** con contraseña **secret**, este usuario es el propietario del proyecto demo, en el que se ha creado la instancia de prueba. También podemos acceder con el usuario **admin**, cuya contraseña está guardada en un fichero que luego comentaremos.

![os]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/02/02.png)

Si queremos trabajar con el cliente `nova` tenemos que instalar el paquete [`python-novaclient`](http://pypi.python.org/pypi/python-novaclient/), y siguiendo, por ejemplo, este [manual](http://albertomolina.wordpress.com/2013/11/20/how-to-launch-an-instance-on-openstack-ii-openstack-cli/), podemos gestionar las instancias de nuestro cloud. Tenemos que tener en cuenta que en el nodo controlador encontramos dos ficheros de credenciales: `demo.openrc`, donde encontramos las del usuario demo, y `admin.openrc` donde están las del usuario admin (en este fichero puedes encontrar la password del admin por si quieres acceder a horizon con él).

Ejemplo:

    $ source demo.openrc
    $ nova list
    +--------------------------------------+------+--------+------------+-------------+-------------------------------------+
    | ID                                   | Name | Status | Task State | Power State | Networks                            |
    +--------------------------------------+------+--------+------------+-------------+-------------------------------------+
    | 1491f908-42c6-4f7c-a937-5f9ef9a76ba2 | p11  | ACTIVE | None       | Running     | demo-net=192.168.100.2, 10.4.10.101 |
    +--------------------------------------+------+--------+------------+-------------+-------------------------------------+

## Últimas consideraciones

1. Con la asignación de memoria a cada uno de los nodos se pueden crear pocas instancias, una solución puede ser crear un nuevo sabor que tenga 256 MB de RAM (yo lo he llamado m1.enano).
2. Otra opción, si tenemos suficiente RAM en nuestra máquina, es modificar el fichero `Vagranfile`, y asignar más memoria RAM al nodo de computación.
3. Puedes acceder a la instancia cirros por ssh, usando el usuario **cirros**, y la contraseña **cubswin:)**
4. Si necesitas entrar en cualquier de las máquinas virtuales, lo puedes hacer con el usuario **vagrant** y contraseña **vagrant**, o usando la clave privada ssh `vagrant\private\key`.
5. El acceso por ssh a la instancia sólo se puede hacer desde alguna de las máquinas virtuales.

**Modificado el 19/03/20014:**

## Acceso a la instancia por ssh

Primero tenemos que entrar a una máquina virtual, por ejemplo el controlador:

    $  vagrant ssh controller
    Welcome to Ubuntu 12.04.4 LTS (GNU/Linux 3.2.0-60-generic x86_64)
     * Documentation:  https://help.ubuntu.com/
    Welcome to your Vagrant-built virtual machine.
    Last login: Wed Mar 19 16:35:49 2014 from 10.0.2.2

    vagrant@controller:~$ ssh cirros@10.4.10.102
    The authenticity of host '10.4.10.102 (10.4.10.102)' can't be     established.
    RSA key fingerprint is    e1:c3:6f:5a:6a:f9:5d:c8:5a:85:ec:a7:d4:5e:95:ac.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added '10.4.10.101' (RSA) to the list of known hosts.
    $

{% include comentarios.html comments=site.data.comments.openstack2 %}