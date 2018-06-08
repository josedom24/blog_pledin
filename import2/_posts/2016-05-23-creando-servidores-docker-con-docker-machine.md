---
layout: post
status: publish
published: true
title: Creando servidores docker con Docker Machine
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1721
wordpress_url: http://www.josedomingo.org/pledin/?p=1721
date: '2016-05-23 08:23:38 +0000'
date_gmt: '2016-05-23 06:23:38 +0000'
categories:
- General
tags:
- Virtualizaci&oacute;n
- OpenStack
- docker
comments: []
---
<p style="text-align: center;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/05/machine.png" rel="attachment wp-att-1722"><img class="aligncenter size-full wp-image-1722" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/05/machine.png" alt="machine" width="599" height="169" /></a></p>
<p style="text-align: justify;">Docker Machine es una herramienta que nos ayuda a crear, configurar y manejar m&aacute;quinas (virtuales o f&iacute;sicas) con Docker Engine. Con Docker Machine podemos iniciar, parar o reiniciar los nodos docker, actualizar el cliente o el demonio docker y configurar el cliente docker para acceder a los distintos Docker Engine. El prop&oacute;sito principal del uso de esta herramienta es la de crear m&aacute;quinas con Docker Engine en sistemas remotos y centralizar su gesti&oacute;n.</p>
<p style="text-align: justify;">Docker Machine utiliza distintos drivers que nos permiten crear y configurar Docker Engine en distintos entornos y proveedores, por ejemplo virtualbox, AWS, VMWare, OpenStack, ...</p>
<p style="text-align: justify;">Las tareas fundamentales que realiza Docker Machine, son las siguientes:</p>
<ul>
<li style="text-align: justify;">Crea una m&aacute;quina en el entorno que hayamos indicado (virtualbox, openstack,...) donde va a instalar y configurar Docker Engine.</li>
<li style="text-align: justify;">Genera los certificados TLS para la comunicaci&oacute;n segura.</li>
</ul>
<p>Tambi&eacute;n podemos utilizar un driver gen&eacute;rico (generic) que nos permite manejar m&aacute;quinas que ya est&aacute;n creadas (f&iacute;sicas o virtuales) y configurarlas por SSH.</p>
<h2>Instalaci&oacute;n de Docker Machine</h2>
<p>Para instalar la &uacute;ltima versi&oacute;n (0.7.0) de esta herramienta ejecutamos:</p>
<pre>$ curl -L https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine &amp;&amp; \
chmod +x /usr/local/bin/docker-machine
</pre>
<p>Y comprobamos la instalaci&oacute;n:</p>
<pre>$ docker-machine -version
docker-machine version 0.7.0, build a650a40</pre>
<p><!--more--></p>
<h2>Utilizando Docker Machine con VirtualBox</h2>
<p style="text-align: justify;">Vamos a ver distintos ejemplos de Docker Machine, utilizando distintos drivers. En primer lugar vamos a utilizar el driver de VirtualBox que nos permitir&aacute; crear una m&aacute;quina virtual con Docker Engine en un ordenador donde tengamos instalado VirtualBox. Para ello ejecutamos la siguiente instrucci&oacute;n:</p>
<pre>$ docker-machine create -d virtualbox nodo1
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
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env nodo1</pre>
<p style="text-align: justify;">Esta instrucci&oacute;n va&nbsp; a crear una nueva m&aacute;quina (nodo1) donde se va a instalar una distribuci&oacute;n Linux llamada boot2docker con el Docker Engine instalado. Utilizando el driver de VirtualBox podemos indicar las caracter&iacute;sticas de la m&aacute;quina que vamos a crear por medio de par&aacute;metros, por ejemplo podemos indicar las caracter&iacute;sticas hardware (<code>--virtualbox-memory</code>, <code>--virtualbox-disk-size</code>, ...) Para m&aacute;s informaci&oacute;n de los par&aacute;metros que podemos usar puedes mirar la <a href="https://docs.docker.com/machine/drivers/virtualbox/">documentaci&oacute;n del driver</a>.</p>
<p style="text-align: justify;">Una vez creada la m&aacute;quina podemos comprobar que lo tenemos gestionados por Docker Machine, para ello:</p>
<pre>$ docker-machine ls
NAME&nbsp;&nbsp;&nbsp; ACTIVE&nbsp;&nbsp; DRIVER&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STATE&nbsp;&nbsp;&nbsp;&nbsp; URL&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SWARM&nbsp;&nbsp; DOCKER&nbsp;&nbsp;&nbsp; ERRORS
nodo1&nbsp;&nbsp; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; virtualbox&nbsp;&nbsp; Running&nbsp;&nbsp; tcp://192.168.99.100:2376&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v1.11.1</pre>
<p style="text-align: justify;">A continuaci&oacute;n para conectarnos desde nuestro cliente docker al Docker Engine de la nueva m&aacute;quina necesitamos declarar las variables de entornos adecuadas, para obtener las variables de entorno de esta m&aacute;quina podemos ejecutar:</p>
<pre>$ docker-machine env nodo1
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/home/jose/.docker/machine/machines/nodo1"
export DOCKER_MACHINE_NAME="nodo1"</pre>
<p style="text-align: justify;">Y para ejecutar estos comandos y que se creen las variables de entorno, ejecutamos:</p>
<pre>$ eval $(docker-machine env nodo1)</pre>
<p style="text-align: justify;">A partir de ahora, y utilizando el cliente docker, estaremos trabajando con el Docker Engine de nodo1:</p>
<pre>$ docker run -d -p 80:5000 training/webapp python app.py
1450b7b2c785333834b43332a4b86505c0167893306ac511489b0f922560a938</pre>
<pre>$ docker ps
CONTAINER ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; COMMAND&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STATUS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PORTS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NAMES
1450b7b2c785&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; training/webapp&nbsp;&nbsp;&nbsp;&nbsp; "python app.py"&nbsp;&nbsp;&nbsp;&nbsp; 8 minutes ago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Up 8 minutes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.0.0.0:80->5000/tcp&nbsp;&nbsp; cranky_hopper&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
</pre>
<p>Y para acceder al contenedor deber&iacute;amos utilizar la ip del servidor docker, que la podemos obtener:</p>
<pre>$ docker-machine ip nodo1
192.168.99.100</pre>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/05/docker1.png"><img class="aligncenter size-full wp-image-1731" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/05/docker1.png" alt="docker1" width="186" height="91" /></a>Otras opciones de docker-machine que podemos utilizar son:</p>
<ul>
<li style="text-align: justify;"><code>inspect</code>: Nos devuelve informaci&oacute;n de una m&aacute;quina.</li>
<li style="text-align: justify;"><code>ssh, scp</code>: Nos permite acceder por ssh y copiar ficheros a una determinada m&aacute;quina.</li>
<li style="text-align: justify;"><code>start, stop, restart, status</code>: Podemos controlar una m&aacute;quina.</li>
<li style="text-align: justify;"><code>rm</code>: Es la opci&oacute;n que borra una m&aacute;quina de la base de datos de Docker Machine. Con determinados drivers tambi&eacute;n elimina la m&aacute;quina.</li>
<li style="text-align: justify;"><code>upgrade</code>: Actualiza a la &uacute;ltima versi&oacute;n de docker la m&aacute;quina indicada.</li>
</ul>
<h2>Utilizando Docker Machine con OpenStack</h2>
<p style="text-align: justify;">En el ejemplo anterior hemos utilizado el driver VirtualBox que nos permite crear una m&aacute;quina docker en un entorno local. Quiz&aacute;s lo m&aacute;s interesante es utilizar Docker Machine para crear nodos docker en m&aacute;quinas remotas, para ello tenemos varios drivers seg&uacute;n el proveedor: AWS, Microsoft Azure, Google Compute Engine,... En este ejemplo vamos a a hacer uso del driver OpenStack para crear una m&aacute;quina en nuestra infraestructura OpenStack con el demonio docker instalado. Para ello vamos a cargar nuestras credenciales de OpenStack y a continuaci&oacute;n creamos la nueva m&aacute;quina:</p>
<pre>$ source openrc.sh 
Please enter your OpenStack Password:</pre>
<pre>$ docker-machine create -d openstack \
> --openstack-flavor-id 3 \
> --openstack-image-id 030b7fe8-ed5d-46b8-81fb-62587c944936 \
> --openstack-net-name red \
> --openstack-floatingip-pool ext-net \
> --openstack-ssh-user debian \
> --openstack-sec-groups default \
> --openstack-keypair-name jdmr \
> --openstack-private-key-file ~/.ssh/id_rsa \
>&nbsp; nodo2

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
Docker is up and running!</pre>
<p style="text-align: justify;">Al ejecutar el comando anterior se han realizado las siguientes acciones:</p>
<ul>
<li style="text-align: justify;">Docker Machine se ha autentificado en OpenStack utilizando las credenciales que hemos cargado.</li>
<li style="text-align: justify;">Docker Machine ha creado una nueva instancia con las caracter&iacute;sticas indicadas. Si no se indica la clave SSH se genera una nueva que ser&aacute; la que se usar&aacute; para acceder a la instancia.</li>
<li style="text-align: justify;">Cuando la instancia es accesible por SSH, Docker Machine se conecta a la instancia, instala Docker Engine y lo configura de forma adecuada habilitando TLS).</li>
<li style="text-align: justify;">Finalmente, recordar que el comando <code>docker-machine rm</code> no s&oacute;lo elimina la referencia local de la m&aacute;quina, tambi&eacute;n elimina la instancia que hemos creado.</li>
</ul>
<p style="text-align: justify;">Como podemos comprobar se ha creado una instancia desde una imagen Debian Jessie, con un sabor <em>m1.nano, </em>conectada a nuestra red interna, se le ha asociado una ip flotante, se ha configurado el grupo de seguridad por defecto (recuerda que debes abrir el puerto TCP 2376 para que el servidor docker sea accesible) y se han inyectado mis claves SSH. Podemos comprobar que ya tenemos dada de alta la nueva m&aacute;quina:</p>
<pre>$ docker-machine ls
NAME&nbsp;&nbsp;&nbsp; ACTIVE&nbsp;&nbsp; DRIVER&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STATE&nbsp;&nbsp;&nbsp;&nbsp; URL&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SWARM&nbsp;&nbsp; DOCKER&nbsp;&nbsp;&nbsp; ERRORS
nodo1&nbsp;&nbsp; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; virtualbox&nbsp;&nbsp; Running&nbsp;&nbsp; tcp://192.168.99.100:2376&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v1.11.1
nodo2&nbsp;&nbsp; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; openstack&nbsp;&nbsp;  Running&nbsp;&nbsp; tcp://172.22.206.15:2376&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  v1.11.1&nbsp; &nbsp;
</pre>
<p style="text-align: justify;">A continuaci&oacute;n creamos las variables de entorno para trabajar con esta m&aacute;quina y comprobamos (como es evidente) que no tiene ning&uacute;n contenedor creado:</p>
<pre>$ eval $(docker-machine env nodo2)
$ docker ps
CONTAINER ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; COMMAND&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STATUS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PORTS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NAMES
</pre>
<p style="text-align: justify;">Puedes obtener m&aacute;s informaci&oacute;n del uso del driver OpenStack en la <a href="https://docs.docker.com/machine/drivers/openstack/">documentaci&oacute;n oficial</a>.</p>
<h2>Utilizando Docker Machine con m&aacute;quinas que ya tenemos funcionando</h2>
<p style="text-align: justify;">En los dos casos anteriores Docker Machine ha sido la responsable de crear las m&aacute;quinas donde se va a instalar y configurar el demonio docker. En este &uacute;ltimo caso, ya tenemos una m&aacute;quina (f&iacute;sica o virtual) ya funcionando y queremos gestionarla con Docker Machine. Para conseguir esto tenemos que utilizar el driver gen&eacute;rico (generic) que ejecutar&aacute; las siguientes tareas:</p>
<ul>
<li style="text-align: justify;">&nbsp;Si la m&aacute;quina no tiene instalado docker, lo instalar&aacute; y lo configurar&aacute;.</li>
<li style="text-align: justify;">Actualiza todos los paquetes de la m&aacute;quina.</li>
<li style="text-align: justify;">Genera los certificados TLS para la comunicaci&oacute;n segura.</li>
<li style="text-align: justify;">Reiniciar&aacute; el Docker Engine, por lo tanto si tuvi&eacute;ramos contenedores, estos ser&aacute;n detenidos.</li>
<li style="text-align: justify;">Se cambia el nombre de la m&aacute;quina para que coincida con el que le hemos dado con Docker Machine.</li>
</ul>
<p>Vamos a gestionar una m&aacute;quina que ya tenemos funcionando con la siguiente instrucci&oacute;n:</p>
<pre>$ docker-machine create -d generic \
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
Docker is up and running!</pre>
<p>Por &uacute;ltimo comprobamos que Docker Machine gestiona el nuevo nodo:</p>
<pre>$ docker-machine ls
NAME&nbsp;&nbsp;&nbsp; ACTIVE&nbsp;&nbsp; DRIVER&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STATE&nbsp;&nbsp;&nbsp;&nbsp; URL&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SWARM&nbsp;&nbsp; DOCKER&nbsp;&nbsp;&nbsp; ERRORS</pre>
<pre>nodo1&nbsp;&nbsp; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; virtualbox&nbsp;&nbsp; Running&nbsp; tcp://192.168.99.100:2376&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v1.11.1
nodo2&nbsp;&nbsp; - &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; openstack&nbsp;&nbsp; Running&nbsp;&nbsp; tcp://172.22.206.15:2376&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v1.11.1&nbsp; &nbsp;
nodo3&nbsp;&nbsp; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; generic&nbsp;&nbsp;&nbsp;&nbsp; Running&nbsp;&nbsp; tcp://172.22.205.103:2376&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v1.11.1</pre>
<p>Cargamos las variables de entorno del nuevo nodo y ya poedmos empezar a trabajar con &eacute;l:</p>
<pre>$ eval $(docker-machine env nodo3)
$ docker ps
CONTAINER ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IMAGE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; COMMAND&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CREATED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STATUS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PORTS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NAMES
</pre>
<p style="text-align: justify;">Como siempre puede obtener m&aacute;s informaci&oacute;n del driver generic en la <a href="https://docs.docker.com/machine/drivers/generic/">documentaci&oacute;n oficial</a>.</p>
<h2>Conclusiones</h2>
<p style="text-align: justify;">Esta entrada ha sido una introducci&oacute;n a la herramienta Docker Machine y al uso de diferentes drivers para la creaci&oacute;n de nodos docker. Para m&aacute;s informaci&oacute;n sobre esta herramienta consulta la <a href="https://docs.docker.com/machine/overview/">documentaci&oacute;n oficial</a>.</p>
