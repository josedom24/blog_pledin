---
layout: post
status: publish
published: true
title: Instalar Open Stack Juno con devstack
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1038
wordpress_url: http://www.josedomingo.org/pledin/?p=1038
date: '2014-11-04 19:55:22 +0000'
date_gmt: '2014-11-04 18:55:22 +0000'
categories:
- General
tags:
- OpenStack
- devstack
comments: []
---
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/openstack-logo.jpg"><img class="alignleft wp-image-1043 size-medium" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/openstack-logo-300x300.jpg" alt="openstack-logo" width="300" height="300" /></a><a href="http://devstack.org/">DevStack</a> es un conjunto de script bash que nos permiten instalar OpenStack de forma autom&aacute;tica. En este art&iacute;culo vamos a a utilizarlo para instalar en nuestro ordenador la &uacute;ltima versi&oacute;n de OpenStack que tiene el nombre de Juno y que ha sido <a href="https://www.openstack.org/software/roadmap/">liberada el pasado 16 de octubre</a>.</p>
<p>En otra ocasi&oacute;n explicamos como instalar OpenStack Havana (<a title="Instalando OpenStack en mi port&aacute;til (2&ordf; parte): DevStack" href="http://www.josedomingo.org/pledin/2014/03/instalando-openstack-en-mi-portatil-2a-parte-devstack/">Instalando OpenStack en mi port&aacute;til (2&ordf; parte): DevStack</a>), en este caso vamos a intalar la &uacute;ltima versi&oacute;n de OpenStack teniendo en cuenta que se puede instalar en una m&aacute;quina f&iacute;sica o en una virtual, sin embargo hay que tener en cuenta que en este &uacute;ltimo caso se usar&aacute; <a href="http://es.wikipedia.org/wiki/QEMU">qemu</a> para la emulaci&oacute;n de las m&aacute;quinas virtuales con lo que se perder&aacute; rendimiento.</p>
<p><!--more--></p>
<h4 id="requisitos-mnimos">Requisitos m&iacute;nimos</h4>
<ul>
<li>Equipo necesario: RAM 2Gb y procesador VT-x/AMD-v</li>
<li>Ubuntu 14.04 instalado, con los paquetes actualizados.</li>
<li>Git instalado
<pre><code>  $ sudo apt-get upgrade
  $ sudo apt-get install git
</code></pre>
</li>
</ul>
<h4 id="instalacin">Instalaci&oacute;n</h4>
<ol>
<li>Tenemos que clonar el repositorio git de Devstack, la rama de la versi&oacute;n juno:
<pre><code> $ git clone -b stable/juno https://github.com/openstack-dev/devstack.git
 $ cd devstack 
</code></pre>
</li>
<li>A continuaci&oacute;n tenemos que configurar la instalaci&oacute;n de OpenStack, para ello creamos un&nbsp; archivo local.conf y lo guardamos en el directorio devstack, con el siguiente contenido:
<pre><code>[[local|localrc]]
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
</code></pre>
</li>
<li>Y ya podemos comenzar la instalaci&oacute;n:
<pre><code> ~/devstack$./stack.sh</code></pre>
</li>
<li>Una vez terminada la instalaci&oacute;n, para acceder a la aplicaci&oacute;n web Horizon:
<ul>
<li>Accedemos a la URL <em>http://localhost</em>.</li>
<li>Usuario de prueba: <strong>demo</strong> con contrase&ntilde;a <strong>devstack</strong>.</li>
<li>Usuario de administraci&oacute;n: <strong>admin</strong> con contrase&ntilde;a <strong>devstack</strong>.</li>
<li>El usuario <strong>demo</strong> debe trabajar en el proyecto <em>&ldquo;demo&rdquo;</em>, no en uno que se llama <em>&ldquo;invisible_to_admin&rdquo;</em>.</li>
</ul>
</li>
<li>Estamos trabajando en un entorno de pruebas, por lo tento si terminamos de trabajar con Openstack y apagamos el ordenador, la pr&oacute;xima vez que queramos trabajar con &eacute;l los servicios no estar&aacute;n arrancados. Por lo tanto si queremos seguir trabajando con la sesi&oacute;n anterior, tendremos que ejecutar la siguiente instrucci&oacute;n:
<pre><code> $ cd devstack
 ~/devstack$ ./rejoin-stack.sh
</code></pre>
<p>Si comprobamos que no funciona bien, tendremos que volver a instalar devstack (aunque esta segunda vez la instalaci&oacute;n ser&aacute; mucho m&aacute;s r&aacute;pida) aunque perderemos todos los cambios realizados (instancias, im&aacute;genes, grupos de seguridad,&hellip;):</p>
<pre><code> $ cd devstack
 ~/devstack$ ./stack.sh
</code></pre>
</li>
</ol>
<h4>&nbsp;Accediendo a OpenStack</h4>
<p>Abrimos un navegador y accedemos a <em>localhost</em>:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/intro.png"><img class="aligncenter wp-image-1048 size-medium" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/10/intro-233x300.png" alt="intro" width="233" height="300" /></a></p>
<p>En las pr&oacute;ximas entradas iremos viendo los distintos conceptos relacionados con OpenStack y algunas pr&aacute;cticas para que veamos c&oacute;mo funciona.</p>
