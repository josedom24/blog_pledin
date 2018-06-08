---
layout: post
status: publish
published: true
title: Introducci&oacute;n a docker
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1415
wordpress_url: http://www.josedomingo.org/pledin/?p=1415
date: '2015-12-22 09:11:44 +0000'
date_gmt: '2015-12-22 08:11:44 +0000'
categories:
- General
tags:
- Virtualizaci&oacute;n
- docker
comments: []
---
<p style="text-align: justify;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/12/docker.png"><img class="aligncenter wp-image-1417" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/12/docker.png" alt="docker" width="503" height="171" /></a></p>
<p style="text-align: justify;">&Uacute;ltimamente <strong>Docker</strong> est&aacute; de moda. Si haces una b&uacute;squeda por intenet ver&aacute;s que existen multitud de p&aacute;ginas hablando del tema. Podr&iacute;a preguntarme, qu&eacute; necesidad tengo de escribir otra entrada en mi blog sobre un tema tan estudiado. Y la respuesta ser&iacute;a que si lo escribo lo aprendo, y adem&aacute;s he llegado a la conclusi&oacute;n de que tengo que aprenderlo. Empezamos con una definici&oacute;n: <a href="https://www.docker.com/">Docker</a> es un proyecto de <a href="https://github.com/docker/docker">software libre</a> que permite automatizar el despliegue de aplicaciones dentro de contenedores.&nbsp; &iquest;Automatizar el despliegue de aplicaciones?, <strong>&iexcl;esto me interesa!: </strong>este a&ntilde;o estoy impartiendo un m&oacute;dulo del <a href="https://dit.gonzalonazareno.org">CFGS de Administraci&oacute;n de Sistemas Inform&aacute;ticos</a>, que se titula: <strong>"Implantaci&oacute;n de aplicaciones web"</strong>. Parece razonable que mis alumnos deban conocer esta nueva tecnolog&iacute;a, que en los &uacute;ltimos a&ntilde;os (realmente desde marzo de 2013 cuando el proyecto fue liberado como software libre) hemos escuchado como una nueva manera de gestionar contenedores. Docker nos permite, de una forma sencilla, crear contenedores&nbsp; ligeros y portables donde ejecutar nuestras aplicaciones software sobre cualquier m&aacute;quina con Docker instalado, independientemente del sistema operativo que la m&aacute;quina tenga por debajo, facilitando as&iacute; tambi&eacute;n los despliegues. De ah&iacute; que el lema de Docker sea: &ldquo;<strong>Build, Ship and Run. Any application, Anywhere</strong>&rdquo; y se haya convertido en una herramienta fundamental tanto para desarrolladores como para administradores de sistemas.<!--more--></p>
<h2>Virtualizaci&oacute;n ligera</h2>
<p style="text-align: justify;">Tenemos varios tipos de virtualizaci&oacute;n, pero la que nos interesa es la llamada <a href="https://en.wikipedia.org/wiki/Operating-system-level_virtualization"><strong>virtualizaci&oacute;n en el nivel de sistema operativo o ligera</strong></a>. Este tipo de virtualizaci&oacute;n nos permite tener m&uacute;ltiples grupos de procesos aislados, que comparten el mismo sistema operativo y hardware, a los que llamamos contenedores o jaulas. El sistema operativo anfitri&oacute;n virtualiza el hardware a nivel de sistema operativo, esto permite que varios sistemas operativos virtuales se ejecuten de forma aislada en un mismo servidor f&iacute;sico. Existen diferentes alternativas para implementar la virtualizaci&oacute;n ligera: <a href="http://en.wikipedia.org/wiki/FreeBSD_jail">jaulas BSD</a>, <a href="https://es.wikipedia.org/wiki/Linux-VServer">vServers</a>, <a href="https://es.wikipedia.org/wiki/OpenVZ">OpenVZ</a>, <a href="https://es.wikipedia.org/wiki/LXC">LXC</a> y finalmente <strong>Docker</strong>.</p>
<h2 style="text-align: justify;">&iquest;Qu&eacute; novedades ha aportado Docker a la gesti&oacute;n de contenedores?</h2>
<p style="text-align: justify;">Docker implementa una API de alto nivel para proporcionar virtualizaci&oacute;n ligera, es decir, contenedores livianos que ejecutan procesos de manera aislada. Esto lo consigue utilizando principalmente dos caracter&iacute;sticas del kernel linux: <a href="https://en.wikipedia.org/wiki/Cgroups">cgroups</a> y namespaces, que nos proporcionan la posibilidad de utilizar el aislamiento de recursos (CPU, la memoria, el bloque E/S, red, etc.). Mediante el uso de contenedores, los recursos pueden ser aislados, los servicios restringidos, y se otorga a los procesos la capacidad de tener una visi&oacute;n casi completamente privada del sistema operativo con su propio identificador de espacio de proceso, la estructura del sistema de archivos, y las interfaces de red. Contenedores m&uacute;ltiples comparten el mismo n&uacute;cleo, pero cada contenedor puede ser restringido a utilizar s&oacute;lo una cantidad definida de recursos como CPU, memoria y E/S. Resumiendo, algunas caracter&iacute;sticas de docker:</p>
<ul>
<li style="text-align: justify;">Es ligero ya que no hay virtualizaci&oacute;n completa, aprovech&aacute;ndose mejor el hardware y &uacute;nicamente necesitando el sistema de archivos m&iacute;nimo para que funcionen los servicios.</li>
<li style="text-align: justify;">Los contenedores son autosuficientes (aunque pueden depender de otros contenedores)&nbsp; no necesitando nada m&aacute;s que la imagen del contenedor para que funcionen los servicios que ofrece.</li>
<li style="text-align: justify;">Una imagen Docker podr&iacute;amos entenderla como <strong>un Sistema Operativo con aplicaciones instaladas.</strong> A partir de una imagen se puede crear un contenedor. Las im&aacute;genes de docker son portables entre diferentes plataformas, el &uacute;nico requisito es que en el sistema hu&eacute;sped est&eacute; disponible docker.</li>
<li style="text-align: justify;">Es seguro,como hemos explicado anteriormente, con namespaces y cgroups, los recursos est&aacute;n aislados.</li>
<li style="text-align: justify;">El proyecto nos ofrece es un repositorio de im&aacute;genes al estilo Github. Este servicio se llama <a href="https://registry.hub.docker.com/">Registry Docker Hub</a> y permite crear, compartir y utilizar im&aacute;genes creadas por nosotros o por terceros.</li>
</ul>
<h2 style="text-align: justify;">Componentes de Docker</h2>
<p style="text-align: justify;">Docker est&aacute; formado fundamentalmente por tres componentes:</p>
<ul>
<li><strong>Docker Engine</strong>: Es un demonio que corre sobre cualquier distribuci&oacute;n de Linux y que expone una API externa para la gesti&oacute;n de im&aacute;genes y contenedores. Con ella podemos crear im&aacute;gnenes, subirlas y bajarla de un registro de docker y ejecutar y gestionar contenedores.</li>
<li><strong>Docker Client</strong>:&nbsp;Es el cliente de l&iacute;nea de comandos (CLI) que nos permite gestionar el Docker Engine. El cliente docker se puede configurar para trabajar con con un Docker Engine local o remoto, permitiendo gestionar tanto nuestro entorno de desarrollo local, como nuestro entorno de producci&oacute;n.</li>
<li style="text-align: justify;"><strong>Docker Registry</strong>: La finalidad de este componente es almacenar las im&aacute;genes generadas por el Docker Engine. Puede estar instalada en un servidor independiente y es un componente fundamental, ya que nos permite distribuir nuestras aplicaciones. Es un proyecto&nbsp;<a href="https://github.com/docker/distribution"><em>open source </em></a>que puede ser instalado gratuitamente en cualquier servidor, pero, como hemos comentado, el proyecto nos ofrece <em>Docker Hub</em>.</li>
</ul>
<h2>Ventajas del uso de Docker</h2>
<p style="text-align: justify;">El uso de docker aporta beneficios tanto a desarrolladores, testers y administradores de sistema. En el caso de los desarrolladores el uso de docker posibilita el centrarse en la generaci&oacute;n de c&oacute;digo y no preocuparse de las distintas caracter&iacute;sticas que pueden tener los entorno de desarrollo y producci&oacute;n. Por otro lado al ser muy sencillo gestionar contenedores y una de sus principales caracter&iacute;sticas es que son muy ligeros, son muy adecuados para desplegar entorno de pruebas donde poder hacer el testing. Por &uacute;ltimo, tambi&eacute;n aporta ventajas a los administradores de sistemas, ya que el despliegue de las aplicaciones se puede hacer de manera m&aacute;s sencilla, sin necesidad de usar m&aacute;quinas virtuales.</p>
<h2 style="text-align: justify;">Conclusiones</h2>
<p style="text-align: justify;">Como dec&iacute;a al principio, me parece que el uso de docker y entender las ventajas que aporta en el despliegue de aplicaciones es un tema que deben conocer los alumnos del ciclo formativo de Administraci&oacute;n de Sistemas Inform&aacute;ticos, ya que podemos estar ante una nueva forma de trabajar que cambie los distintos roles y perfiles profesionales que tradicionalmente hemos conocido. Por lo tanto, tenemos que ser conscientes de que la labor del administrador de sistema est&aacute; cambiando en los &uacute;ltimos a&ntilde;os, y que el uso de esta tecnolog&iacute;a parece que va a ser importante en este nuevo paradigma de trabajo.</p>
<p style="text-align: justify;">Intentar&eacute; seguir profundizando en el uso de docker y escribir algunas entradas en el blog.</p>
