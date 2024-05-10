---
id: 1415
title: Introducción a docker
date: 2015-12-22T09:11:44+00:00


guid: http://www.josedomingo.org/pledin/?p=1415
permalink: /2015/12/introduccion-a-docker/


tags:
  - docker
  - Virtualización
---

  <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/12/docker.png"><img class="aligncenter wp-image-1417" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/12/docker.png" alt="docker" width="503" height="171" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/12/docker.png 792w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/12/docker-300x102.png 300w" sizes="(max-width: 503px) 100vw, 503px" /></a>

Últimamente <strong>Docker</strong> está de moda. Si haces una búsqueda por intenet verás que existen multitud de páginas hablando del tema. Podría preguntarme, qué necesidad tengo de escribir otra entrada en mi blog sobre un tema tan estudiado. Y la respuesta sería que si lo escribo lo aprendo, y además he llegado a la conclusión de que tengo que aprenderlo. Empezamos con una definición: <a href="https://www.docker.com/">Docker</a> es un proyecto de <a href="https://github.com/docker/docker">software libre</a> que permite automatizar el despliegue de aplicaciones dentro de contenedores.  ¿Automatizar el despliegue de aplicaciones?, <strong>¡esto me interesa!: </strong>este año estoy impartiendo un módulo del <a href="https://dit.gonzalonazareno.org">CFGS de Administración de Sistemas Informáticos</a>, que se titula: <strong>&#8220;Implantación de aplicaciones web&#8221;</strong>. Parece razonable que mis alumnos deban conocer esta nueva tecnología, que en los últimos años (realmente desde marzo de 2013 cuando el proyecto fue liberado como software libre) hemos escuchado como una nueva manera de gestionar contenedores. Docker nos permite, de una forma sencilla, crear contenedores  ligeros y portables donde ejecutar nuestras aplicaciones software sobre cualquier máquina con Docker instalado, independientemente del sistema operativo que la máquina tenga por debajo, facilitando así también los despliegues. De ahí que el lema de Docker sea: “<strong>Build, Ship and Run. Any application, Anywhere</strong>” y se haya convertido en una herramienta fundamental tanto para desarrolladores como para administradores de sistemas.<!--more-->

## Virtualización ligera

Tenemos varios tipos de virtualización, pero la que nos interesa es la llamada <a href="https://en.wikipedia.org/wiki/Operating-system-level_virtualization"><strong>virtualización en el nivel de sistema operativo o ligera</strong></a>. Este tipo de virtualización nos permite tener múltiples grupos de procesos aislados, que comparten el mismo sistema operativo y hardware, a los que llamamos contenedores o jaulas. El sistema operativo anfitrión virtualiza el hardware a nivel de sistema operativo, esto permite que varios sistemas operativos virtuales se ejecuten de forma aislada en un mismo servidor físico. Existen diferentes alternativas para implementar la virtualización ligera: <a href="http://en.wikipedia.org/wiki/FreeBSD_jail">jaulas BSD</a>, <a href="https://es.wikipedia.org/wiki/Linux-VServer">vServers</a>, <a href="https://es.wikipedia.org/wiki/OpenVZ">OpenVZ</a>, <a href="https://es.wikipedia.org/wiki/LXC">LXC</a> y finalmente <strong>Docker</strong>.

## ¿Qué novedades ha aportado Docker a la gestión de contenedores?

Docker implementa una API de alto nivel para proporcionar virtualización ligera, es decir, contenedores livianos que ejecutan procesos de manera aislada. Esto lo consigue utilizando principalmente dos características del kernel linux: <a href="https://en.wikipedia.org/wiki/Cgroups">cgroups</a> y namespaces, que nos proporcionan la posibilidad de utilizar el aislamiento de recursos (CPU, la memoria, el bloque E/S, red, etc.). Mediante el uso de contenedores, los recursos pueden ser aislados, los servicios restringidos, y se otorga a los procesos la capacidad de tener una visión casi completamente privada del sistema operativo con su propio identificador de espacio de proceso, la estructura del sistema de archivos, y las interfaces de red. Contenedores múltiples comparten el mismo núcleo, pero cada contenedor puede ser restringido a utilizar sólo una cantidad definida de recursos como CPU, memoria y E/S. Resumiendo, algunas características de docker:

* Es ligero ya que no hay virtualización completa, aprovechándose mejor el hardware y únicamente necesitando el sistema de archivos mínimo para que funcionen los servicios.
* Los contenedores son autosuficientes (aunque pueden depender de otros contenedores)  no necesitando nada más que la imagen del contenedor para que funcionen los servicios que ofrece.
* Una imagen Docker podríamos entenderla como <strong>un Sistema Operativo con aplicaciones instaladas.</strong> A partir de una imagen se puede crear un contenedor. Las imágenes de docker son portables entre diferentes plataformas, el único requisito es que en el sistema huésped esté disponible docker.
* Es seguro,como hemos explicado anteriormente, con namespaces y cgroups, los recursos están aislados.
* El proyecto nos ofrece es un repositorio de imágenes al estilo Github. Este servicio se llama <a href="https://registry.hub.docker.com/">Registry Docker Hub</a> y permite crear, compartir y utilizar imágenes creadas por nosotros o por terceros.

## Componentes de Docker

Docker está formado fundamentalmente por tres componentes:

* **Docker Engine**: Es un demonio que corre sobre cualquier distribución de Linux y que expone una API externa para la gestión de imágenes y contenedores. Con ella podemos crear imágnenes, subirlas y bajarla de un registro de docker y ejecutar y gestionar contenedores.
* **Docker Client**: Es el cliente de línea de comandos (CLI) que nos permite gestionar el Docker Engine. El cliente docker se puede configurar para trabajar con con un Docker Engine local o remoto, permitiendo gestionar tanto nuestro entorno de desarrollo local, como nuestro entorno de producción.
* **Docker Registry**: La finalidad de este componente es almacenar las imágenes generadas por el Docker Engine. Puede estar instalada en un servidor independiente y es un componente fundamental, ya que nos permite distribuir nuestras aplicaciones. Es un proyecto <a href="https://github.com/docker/distribution"><em>open source </em></a>que puede ser instalado gratuitamente en cualquier servidor, pero, como hemos comentado, el proyecto nos ofrece <em>Docker Hub</em>.

## Ventajas del uso de Docker

El uso de docker aporta beneficios tanto a desarrolladores, testers y administradores de sistema. En el caso de los desarrolladores el uso de docker posibilita el centrarse en la generación de código y no preocuparse de las distintas características que pueden tener los entorno de desarrollo y producción. Por otro lado al ser muy sencillo gestionar contenedores y una de sus principales características es que son muy ligeros, son muy adecuados para desplegar entorno de pruebas donde poder hacer el testing. Por último, también aporta ventajas a los administradores de sistemas, ya que el despliegue de las aplicaciones se puede hacer de manera más sencilla, sin necesidad de usar máquinas virtuales.

## Conclusiones

Como decía al principio, me parece que el uso de docker y entender las ventajas que aporta en el despliegue de aplicaciones es un tema que deben conocer los alumnos del ciclo formativo de Administración de Sistemas Informáticos, ya que podemos estar ante una nueva forma de trabajar que cambie los distintos roles y perfiles profesionales que tradicionalmente hemos conocido. Por lo tanto, tenemos que ser conscientes de que la labor del administrador de sistema está cambiando en los últimos años, y que el uso de esta tecnología parece que va a ser importante en este nuevo paradigma de trabajo.

Intentaré seguir profundizando en el uso de docker y escribir algunas entradas en el blog.

