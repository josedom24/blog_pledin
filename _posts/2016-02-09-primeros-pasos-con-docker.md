---
id: 1577
title: Primeros pasos con Docker
date: 2016-02-09T12:38:31+00:00


guid: http://www.josedomingo.org/pledin/?p=1577
permalink: /2016/02/primeros-pasos-con-docker/


tags:
  - docker
  - Virtualización
---

  <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/docker2.png" rel="attachment wp-att-1578"><img class="size-full wp-image-1578 aligncenter" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/docker2.png" alt="docker2" width="795" height="419" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/docker2.png 795w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/docker2-300x158.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/docker2-768x405.png 768w" sizes="(max-width: 795px) 100vw, 795px" /></a>
  
  En una <a href="http://www.josedomingo.org/pledin/2015/12/introduccion-a-docker/">entrada anterior</a>, veíamos los fundamentos de docker, y repasábamos los principales componentes de la arquitectura de docker:

* **El cliente de Docker** es la principal interfaz de usuario para docker, acepta los comandos del usuario y se comunica con el daemon de docker.
* **Imágenes de Docker (Docker Images)**: Las imágenes de Docker son plantillas de solo lectura, es decir, una imagen puede contener el sistema de archivo de un sistema operativo como Debian, pero esto solo nos permitirá crear los contenedores basados en esta configuración. Si hacemos cambios en el contenedor ya lanzado, al detenerlo esto no se verá reflejado en la imagen.
* **Registros de Docker (Docker Registries)**: Los registros de Docker guardan las imágenes, estos son repositorios públicos o privados donde podemos subir o descargar imágenes. El registro público del proyecto se llama Docker Hub y es el componente de distribución de Docker.
* **Contenedores de Docker (Docker Containers)**: El contenedor de docker aloja todo lo necesario para ejecutar una aplicación. Cada contenedor es creado de una imagen de docker. Cada contenedor es una plataforma aislada.

## Instalación de docker

Vamos a instalar docker engine en un equipo con Debian Jessie, para ello, en primer lugar nos aseguramos de instalar el paquete que permite trabajar a la utilidad apt con htpps, y los certificados CA:

    $ apt-get update
    $ apt-get install apt-transport-https ca-certificates

A continuación añadimos la clave GPG:

    $ apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

Y añadimos el nuevo repositorio:

    $ nano /etc/apt/sources.list.d/docker.list

Indicando el repositorio para Debian Jessie:

    deb https://apt.dockerproject.org/repo debian-jessie main

Y ya estamos en disposición de realizar la instalación:

    $ apt-get update
    $ apt-get install docker-engine


    $  docker version
    Client:
    Version:      1.10.0
    API version:  1.22
    Go version:   go1.5.3
    Git commit:   590d5108
    Built:        Thu Feb  4 18:16:19 2016
    OS/Arch:      linux/amd64

    Server:
    Version:      1.10.0
    API version:  1.22
    Go version:   go1.5.3
    Git commit:   590d5108
    Built:        Thu Feb  4 18:16:19 2016
    OS/Arch:      linux/amd64


### Ejecutando docker con un usuario sin privilegios

El demonio docker cuando se indicia siempre se ejecuta como root y espera una conexión a un socket unix y no a un puerto TCP. Por defecto el socker unix es propiedad del usuario root por lo que debemos usar el cliente docker como root. Para solucionar esto podemos añadir nuestro usuario sin privilegio al grupo docker, todos los usuarios pertenecientes a este grupo tienen permiso de lectura y escritura sobre el socket por lo que podremos conectar al docker engine desde nuestro usuario.

    # usermod -a -G docker usuario

Y ya podemos usar el usuario para utilizar el cliente docker.

### Acceder a docker engine desde otra máquina

En ocasiones es preferible tener instalado el cliente docker y el demonio en diferentes máquinas, para ello hay que configurar el docker engine para que escuche por un puerto TCP, para ello:

    $ nano /etc/systemd/system/multi-user.target.wants/docker.service

    ...
    ExecStart=/usr/bin/docker daemon -H fd:// -H tcp://0.0.0.0:2376
    ...

    systemctl daemon-reload
    service docker restart

En la máquina cliente instalamos el cliente docker:

    # apt-get install docker.io

Y podemos utilizarlo indicando la dirección ip y el puerto del docker daemon:

    $ docker -H 192.168.0.100:2376 ps
     CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

En esta entrada vamos a utilizar el cliente docker desde la misma máquina donde tenemos el demonio.

## Nuestro primer contenedor "Hola Mundo"

Para crear nuestro primer contenedor vamos a ejecutar la siguiente instrucción:

    $ docker run ubuntu /bin/echo 'Hello world'
    Unable to find image 'ubuntu:latest' locally
    latest: Pulling from library/ubuntu
    8387d9ff0016: Pull complete 
    3b52deaaf0ed: Pull complete 
    4bd501fad6de: Pull complete 
    a3ed95caeb02: Pull complete 
    Digest: sha256:457b05828bdb5dcc044d93d042863fba3f2158ae249a6db5ae3934307c757c54
    Status: Downloaded newer image for ubuntu:latest
    Hello world

Con el comando `run` vamos a crear un contenedor donde vamos a ejecutar un comando, en este caso vamos a crear el contenedor a partir de una imagen ubuntu. Como todavía no hemos descargado ninguna imagen del registro docker hub, es necesario que se descargue la  imagen. Si la tenemos ya en nuestro ordenador no será necesario la descarga. Más adelante estudiaremos como funcionan las imágenes en docker. Finalmente indicamos el comando que vamos a ejecutar en el contenedor, en este caso vamos a escribir un "Hola Mundo".

Por lo tanto, cuando se finaliza la descarga de la imagen, se crea un contenedor a partir de la imagen y se ejecuta el comando que hemos indicado, podemos ver la salida en pantalla. Una vez que se ejecuta la instrucción el contenedor se detiene (stop), podemos ver la lista de contenedores detenidos con el siguiente comando:

    $ docker ps -a
    CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS                          PORTS                  NAMES
    b0ca02c7b956        ubuntu              "/bin/echo 'Hello wor"   About a minute ago   Exited (0) About a minute ago                          boring_jennings

## Ejecutando un contenedor interactivo

En este caso usamos la opción `-i` para abrir una sesión interactiva, `-t` nos permite crear un pseoude-terminal que nos va a permitir interaccionar con el contenedor, indicamos un nombre del contenedor con la opción `--name`, y la imagen que vamos a utilizar para crearlo, en este caso "ubuntu",  y por último el comando que vamos a ejecutar, en este caso `/bin/bash`, que lanzará una sesión bash en el contenedor:

    $ docker run -i -t --name contenedor1 ubuntu /bin/bash 
    root@2bfa404bace0:/# ls
    bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
    root@2bfa404bace0:/# exit
    $

Como podemos comprobar podemos ejecutar distintos comandos dentro del contenedor, por ejemplo hemos visto el árbol de directorios. Cuando salimos de la sesión, el contenedor se detiene. De nuevo podemos ver los contenedores detenidos:

    $ docker ps -a
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                        PORTS                  NAMES
    2bfa404bace0        ubuntu              "/bin/bash"              13 minutes ago      Exited (0) 9 minutes ago                             contenedor1
    b0ca02c7b956        ubuntu              "/bin/echo 'Hello wor"   21 minutes ago      Exited (0) 15 minutes ago                            boring_jennings

A continuación vamos a iniciar el contenedor y nos vamos a conectar a él:

    $ docker start contendor1
    contendor1
    $ docker attach contendor1
    root@2bfa404bace0:/#

Para obtener información del contenedor:

    $ docker inspect contenedor1
    [
        {
            "Id": "2bfa404bace09e244df4528e41f94523dcaa4f8ddeae992259fde0d2151eea03",
            "Created": "2016-02-08T21:14:56.157787821Z",
            "Path": "/bin/bash",
            "Args": [],
            "State": {
                "Status": "exited",
                "Running": false,
                "Paused": false,
                "Restarting": false,
                "OOMKilled": false,
                "Dead": false,
                "Pid": 0,
                "ExitCode": 0,
                "Error": "",
                "StartedAt": "2016-02-08T21:14:56.40323815Z",
                "FinishedAt": "2016-02-08T21:18:37.272925413Z"
            },
            "Image": "sha256:3876b81b5a81678926c601cd842040a69eb0456d295cd395e7a895a416cf7d91",
            "ResolvConfPath": "/var/lib/docker/containers/2bfa404bace09e244df4528e41f94523dcaa4f8ddeae992259fde0d2151eea03/resolv.conf",
            "HostnamePath": "/var/lib/docker/containers/2bfa404bace09e244df4528e41f94523dcaa4f8ddeae992259fde0d2151eea03/hostname",
            "HostsPath": "/var/lib/docker/containers/2bfa404bace09e244df4528e41f94523dcaa4f8ddeae992259fde0d2151eea03/hosts",
            "LogPath": "/var/lib/docker/containers/2bfa404bace09e244df4528e41f94523dcaa4f8ddeae992259fde0d2151eea03/2bfa404bace09e244df4528e41f94523dcaa4f8ddeae992259fde0d2151eea03-json.log",
            "Name": "/contenedor1",
           ...


## Creando un contenedor demonio

Crear un contenedor que ejecute una sola instrucción y que luego se pare no es muy útil, a continuación vamos a crear un contenedor que funcione como un demonio y este continuamente ejecutándose.

    $ docker run -d ubuntu /bin/sh -c "while true; do echo hello world; sleep 1; done"
    7b6c3b1c0d650445b35a1107ac54610b65a03eda7e4b730ae33bf240982bba08

En esta ocasión hemos utilizado la opción `-d` del comando `run`, para la ejecución el comando en el contenedor se haga en segundo plano. La salida que hemos obtenido el el <em>ID</em> del contenedor que se está ejecutando, aunque cuando visualizamos los contenedores en ejecución sólo vemos un <em>ID</em> corto:

    $ docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    7b6c3b1c0d65        ubuntu              "/bin/sh -c 'while tr"   2 minutes ago       Up 2 minutes                            happy_euclid

Podemos ver la salida del contenedor accediendo a los logs del contenedor, indicando el id o el nombre que se ha asignado:

    $ docker logs happy_euclid
    hello world
    hello world
    hello world
    hello world
    ...

Por último podemos parar el contenedor y borrarlo con las siguientes instrucciones:

    $ docker stop happy_euclid
    $ docker rm happy_euclid

## Conclusiones

En esta primera entrada hemos hecho una introducción a la instalación de docker y hemos comenzado a crear contenedores. Realmente estos contenedores no nos sirven de mucho ya que ejecutan instrucciones muy básicas. En la próxima entrada vamos a trabajar com imágenes docker y vamos a profundizar en la creación de contenedores para ejecutar aplicaciones web.


<h6 style="text-align: justify;">
  La imagen de cabecera ha sido tomado de la URL: <a href="http://www.jsitech.com/generales/docker-fundamentos/">http://www.jsitech.com/generales/docker-fundamentos/</a>
</h6>

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->