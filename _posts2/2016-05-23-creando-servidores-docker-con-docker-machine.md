---
id: 1721
title: Creando servidores docker con Docker Machine
date: 2016-05-23T08:23:38+00:00


guid: http://www.josedomingo.org/pledin/?p=1721
permalink: /2016/05/creando-servidores-docker-con-docker-machine/


tags:
  - docker
  - OpenStack
  - Virtualización
---
<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/05/machine.png" rel="attachment wp-att-1722"><img class="aligncenter size-full wp-image-1722" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/05/machine.png" alt="machine" width="599" height="169" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/05/machine.png 599w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/05/machine-300x85.png 300w" sizes="(max-width: 599px) 100vw, 599px" /></a>

Docker Machine es una herramienta que nos ayuda a crear, configurar y manejar máquinas (virtuales o físicas) con Docker Engine. Con Docker Machine podemos iniciar, parar o reiniciar los nodos docker, actualizar el cliente o el demonio docker y configurar el cliente docker para acceder a los distintos Docker Engine. El propósito principal del uso de esta herramienta es la de crear máquinas con Docker Engine en sistemas remotos y centralizar su gestión.

Docker Machine utiliza distintos drivers que nos permiten crear y configurar Docker Engine en distintos entornos y proveedores, por ejemplo virtualbox, AWS, VMWare, OpenStack,...

Las tareas fundamentales que realiza Docker Machine, son las siguientes:

* Crea una máquina en el entorno que hayamos indicado (virtualbox, openstack,...) donde va a instalar y configurar Docker Engine.
* Genera los certificados TLS para la comunicación segura.

También podemos utilizar un driver genérico (generic) que nos permite manejar máquinas que ya están creadas (físicas o virtuales) y configurarlas por SSH.

## Instalación de Docker Machine

Para instalar la última versión (0.7.0) de esta herramienta ejecutamos:

    $ curl -L https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine && \
    chmod +x /usr/local/bin/docker-machine

Y comprobamos la instalación:

    $ docker-machine -version
    docker-machine version 0.7.0, build a650a40

## Utilizando Docker Machine con VirtualBox

Vamos a ver distintos ejemplos de Docker Machine, utilizando distintos drivers. En primer lugar vamos a utilizar el driver de VirtualBox que nos permitirá crear una máquina virtual con Docker Engine en un ordenador donde tengamos instalado VirtualBox. Para ello ejecutamos la siguiente instrucción:

    $ docker-machine create -d virtualbox nodo1
    Running pre-create checks...
    Creating machine...
    (nodo1) Copying /home/jose/.docker/machine/cache/boot2docker.iso to /home/jose/.docker/machine/machines/nodo1/boot2docker.iso...
    (nodo1) Creating VirtualBox VM...
    (nodo1) Creating SSH key...
    (nodo1) Starting the VM...
    (nodo1) Check network to re-create if needed...
    (nodo1) Found a new host-only adapter: "vboxnet0"
    (nodo1) Waiting for an IP...
    Waiting for machine to be running, this may take a few minutes...
    Detecting operating system of created instance...
    Waiting for SSH to be available...
    Detecting the provisioner...
    Provisioning with boot2docker...
    Copying certs to the local machine directory...
    Copying certs to the remote machine...
    Setting Docker configuration on the remote daemon...
    Checking connection to Docker...
    Docker is up and running!
    To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env nodo1

Esta instrucción va  a crear una nueva máquina (nodo1) donde se va a instalar una distribución Linux llamada boot2docker con el Docker Engine instalado. Utilizando el driver de VirtualBox podemos indicar las características de la máquina que vamos a crear por medio de parámetros, por ejemplo podemos indicar las características hardware (`--virtualbox-memory`, `--virtualbox-disk-size`, ...) Para más información de los parámetros que podemos usar puedes mirar la <a href="https://docs.docker.com/machine/drivers/virtualbox/">documentación del driver</a>.

Una vez creada la máquina podemos comprobar que lo tenemos gestionados por Docker Machine, para ello:

    $ docker-machine ls
    NAME    ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER    ERRORS
    nodo1   -        virtualbox   Running   tcp://192.168.99.100:2376           v1.11.1

A continuación para conectarnos desde nuestro cliente docker al Docker Engine de la nueva máquina necesitamos declarar las variables de entornos adecuadas, para obtener las variables de entorno de esta máquina podemos ejecutar:

    $ docker-machine env nodo1
    export DOCKER_TLS_VERIFY="1"
    export DOCKER_HOST="tcp://192.168.99.100:2376"
    export DOCKER_CERT_PATH="/home/jose/.docker/machine/machines/nodo1"
    export DOCKER_MACHINE_NAME="nodo1"

Y para ejecutar estos comandos y que se creen las variables de entorno, ejecutamos:

    $ eval $(docker-machine env nodo1)

A partir de ahora, y utilizando el cliente docker, estaremos trabajando con el Docker Engine de nodo1:

    $ docker run -d -p 80:5000 training/webapp python app.py
    1450b7b2c785333834b43332a4b86505c0167893306ac511489b0f922560a938

    $ docker ps
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                  NAMES
    1450b7b2c785        training/webapp     "python app.py"     8 minutes ago       Up 8 minutes        0.0.0.0:80->5000/tcp   cranky_hopper       

Y para acceder al contenedor deberíamos utilizar la ip del servidor docker, que la podemos obtener:

    $ docker-machine ip nodo1
    192.168.99.100

[<img class="aligncenter size-full wp-image-1731" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/05/docker1.png" alt="docker1" width="186" height="91" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/05/docker1.png)

Otras opciones de docker-machine que podemos utilizar son:

* `inspect`: Nos devuelve información de una máquina.
* `ssh`, `scp`: Nos permite acceder por ssh y copiar ficheros a una determinada máquina.
* `start`, `stop`, `restart`, `status`: Podemos controlar una máquina.
* `rm`: Es la opción que borra una máquina de la base de datos de Docker Machine. Con determinados drivers también elimina la máquina.
* `upgrade`: Actualiza a la última versión de docker la máquina indicada.

## Utilizando Docker Machine con OpenStack

En el ejemplo anterior hemos utilizado el driver VirtualBox que nos permite crear una máquina docker en un entorno local. Quizás lo más interesante es utilizar Docker Machine para crear nodos docker en máquinas remotas, para ello tenemos varios drivers según el proveedor: AWS, Microsoft Azure, Google Compute Engine,... En este ejemplo vamos a a hacer uso del driver OpenStack para crear una máquina en nuestra infraestructura OpenStack con el demonio docker instalado. Para ello vamos a cargar nuestras credenciales de OpenStack y a continuación creamos la nueva máquina:

    $ source openrc.sh 
    Please enter your OpenStack Password:

    $ docker-machine create -d openstack \
    > --openstack-flavor-id 3 \
    > --openstack-image-id 030b7fe8-ed5d-46b8-81fb-62587c944936 \
    > --openstack-net-name red \
    > --openstack-floatingip-pool ext-net \
    > --openstack-ssh-user debian \
    > --openstack-sec-groups default \
    > --openstack-keypair-name jdmr \
    > --openstack-private-key-file ~/.ssh/id_rsa \
    >  nodo2

    Running pre-create checks...
    Creating machine...
    (nodo2) Creating machine...
    Waiting for machine to be running, this may take a few minutes...
    Detecting operating system of created instance...
    Waiting for SSH to be available...
    Detecting the provisioner...
    Provisioning with debian...
    Copying certs to the local machine directory...
    Copying certs to the remote machine...
    Setting Docker configuration on the remote daemon...
    Checking connection to Docker...
    Docker is up and running!

Al ejecutar el comando anterior se han realizado las siguientes acciones:

* Docker Machine se ha autentificado en OpenStack utilizando las credenciales que hemos cargado.
* Docker Machine ha creado una nueva instancia con las características indicadas. Si no se indica la clave SSH se genera una nueva que será la que se usará para acceder a la instancia.
* Cuando la instancia es accesible por SSH, Docker Machine se conecta a la instancia, instala Docker Engine y lo configura de forma adecuada habilitando TLS).
* Finalmente, recordar que el comando `docker-machine rm` no sólo elimina la referencia local de la máquina, también elimina la instancia que hemos creado.

Como podemos comprobar se ha creado una instancia desde una imagen Debian Jessie, con un sabor `m1.nano`, conectada a nuestra red interna, se le ha asociado una ip flotante, se ha configurado el grupo de seguridad por defecto (recuerda que debes abrir el puerto TCP 2376 para que el servidor docker sea accesible) y se han inyectado mis claves SSH. Podemos comprobar que ya tenemos dada de alta la nueva máquina:

    $ docker-machine ls
    NAME    ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER    ERRORS
    nodo1   -        virtualbox   Running   tcp://192.168.99.100:2376           v1.11.1
    nodo2   -        openstack    Running   tcp://172.22.206.15:2376            v1.11.1   

A continuación creamos las variables de entorno para trabajar con esta máquina y comprobamos (como es evidente) que no tiene ningún contenedor creado:

    $ eval $(docker-machine env nodo2)
    $ docker ps
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

Puedes obtener más información del uso del driver OpenStack en la <a href="https://docs.docker.com/machine/drivers/openstack/">documentación oficial</a>.

## Utilizando Docker Machine con máquinas que ya tenemos funcionando

En los dos casos anteriores Docker Machine ha sido la responsable de crear las máquinas donde se va a instalar y configurar el demonio docker. En este último caso, ya tenemos una máquina (física o virtual) ya funcionando y queremos gestionarla con Docker Machine. Para conseguir esto tenemos que utilizar el driver genérico (generic) que ejecutará las siguientes tareas:

* Si la máquina no tiene instalado docker, lo instalará y lo configurará.
* Actualiza todos los paquetes de la máquina.
* Genera los certificados TLS para la comunicación segura.
* Reiniciará el Docker Engine, por lo tanto si tuviéramos contenedores, estos serán detenidos.
* Se cambia el nombre de la máquina para que coincida con el que le hemos dado con Docker Machine.

Vamos a gestionar una máquina que ya tenemos funcionando con la siguiente instrucción:

    $ docker-machine create -d generic \
    --generic-ip-address=172.22.205.103 \
    --generic-ssh-user=debian \ 
    nodo3

    Running pre-create checks...
    Creating machine...
    Waiting for machine to be running, this may take a few minutes...
    Detecting operating system of created instance...
    Waiting for SSH to be available...
    Detecting the provisioner...
    Provisioning with debian...
    Copying certs to the local machine directory...
    Copying certs to the remote machine...
    Setting Docker configuration on the remote daemon...
    Checking connection to Docker...
    Docker is up and running!

Por último comprobamos que Docker Machine gestiona el nuevo nodo:

    $ docker-machine ls
    NAME    ACTIVE   DRIVER      STATE     URL                         SWARM   DOCKER    ERRORS

    nodo1   -        virtualbox   Running  tcp://192.168.99.100:2376           v1.11.1
    nodo2   -        openstack   Running   tcp://172.22.206.15:2376            v1.11.1   
    nodo3   -        generic     Running   tcp://172.22.205.103:2376           v1.11.1

Cargamos las variables de entorno del nuevo nodo y ya poedmos empezar a trabajar con él:

    $ eval $(docker-machine env nodo3)
    $ docker ps
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

Como siempre puede obtener más información del driver generic en la <a href="https://docs.docker.com/machine/drivers/generic/">documentación oficial</a>.

## Conclusiones

Esta entrada ha sido una introducción a la herramienta Docker Machine y al uso de diferentes drivers para la creación de nodos docker. Para más información sobre esta herramienta consulta la <a href="https://docs.docker.com/machine/overview/">documentación oficial</a>.


<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->