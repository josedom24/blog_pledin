---
id: 1038
title: Instalar Open Stack Juno con devstack
date: 2014-11-04T19:55:22+00:00


guid: http://www.josedomingo.org/pledin/?p=1038
permalink: /2014/11/instalar-open-stack-juno-con-devstack/


tags:
  - devstack
  - OpenStack
---
![os]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/openstack-logo.jpg)

[DevStack](http://devstack.org/) es un conjunto de script bash que nos permiten instalar OpenStack de forma automática. En este artículo vamos a a utilizarlo para instalar en nuestro ordenador la última versión de OpenStack que tiene el nombre de Juno y que ha sido [liberada el pasado 16 de octubre](https://www.openstack.org/software/roadmap/).

En otra ocasión explicamos como instalar OpenStack Havana ([Instalando OpenStack en mi portátil (2ª parte): DevStack](http://www.josedomingo.org/pledin/2014/03/instalando-openstack-en-mi-portatil-2a-parte-devstack/ "Instalando OpenStack en mi portátil (2ª parte): DevStack")), en este caso vamos a instalar la última versión de OpenStack teniendo en cuenta que se puede instalar en una máquina física o en una virtual, sin embargo hay que tener en cuenta que en este último caso se usará [qemu](http://es.wikipedia.org/wiki/QEMU) para la emulación de las máquinas virtuales con lo que se perderá rendimiento.

## Requisitos mínimos 

* Equipo necesario: RAM 2Gb y procesador VT-x/AMD-v
* Ubuntu 14.04 instalado, con los paquetes actualizados.
* Git instalado 

        $ sudo apt-get upgrade
        $ sudo apt-get install git

## Instalación 

1. Tenemos que clonar el repositorio git de Devstack, la rama de la versión juno: 

        $ git clone -b stable/juno https://github.com/openstack-dev/devstack.git
        $ cd devstack 
2. A continuación tenemos que configurar la instalación de OpenStack, para ello creamos un  archivo `local.conf` y lo guardamos en el directorio `devstack`, con el siguiente contenido: 

        [[local|localrc]]
        # Default passwords
        ADMIN_PASSWORD=devstack
        MYSQL_PASSWORD=devstack
        RABBIT_PASSWORD=devstack
        SERVICE_PASSWORD=devstack
        SERVICE_TOKEN=devstack
        RECLONE=yes
        
        SCREEN_LOGDIR=/opt/stack/logs
        disable_service n-net
        enable_service q-svc
        enable_service q-agt
        enable_service q-dhcp
        enable_service q-l3
        enable_service q-meta
        enable_service neutron
        enable_service q-lbaas
        disable_service tempest
        enable_service s-proxy s-object s-container s-account
        SWIFT_HASH=66a3d6b56c1f479c8b4e70ab5c2000f5

3. Y ya podemos comenzar la instalación: 

        ~/devstack$./stack.sh

4. Una vez terminada la instalación, para acceder a la aplicación web Horizon: 
    * Accedemos a la URL _http://localhost_.
    * Usuario de prueba: **demo** con contraseña **devstack**.
    * Usuario de administración: **admin** con contraseña **devstack**.
    * El usuario **demo** debe trabajar en el proyecto _“demo”_, no en uno que se llama _“invisible\_to\_admin”_.

5. Estamos trabajando en un entorno de pruebas, por lo tanto si terminamos de trabajar con Openstack y apagamos el ordenador, la próxima vez que queramos trabajar con él los servicios no estarán arrancados. Por lo tanto si queremos seguir trabajando con la sesión anterior, tendremos que ejecutar la siguiente instrucción: 
         
        $ cd devstack
        ~/devstack$ ./rejoin-stack.sh

    Si comprobamos que no funciona bien, tendremos que volver a instalar devstack (aunque esta segunda vez la instalación será mucho más rápida) aunque perderemos todos los cambios realizados (instancias, imágenes, grupos de seguridad,…):
    
         $ cd devstack
         ~/devstack$ ./stack.sh

##  Accediendo a OpenStack

Abrimos un navegador y accedemos a _localhost_:

![os]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/10/intro.png)

En las próximas entradas iremos viendo los distintos conceptos relacionados con OpenStack y algunas prácticas para que veamos cómo funciona.

