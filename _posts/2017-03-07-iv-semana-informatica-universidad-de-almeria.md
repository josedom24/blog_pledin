---
id: 1779
title: IV Semana Informática. Universidad de Almería
date: 2017-03-07T09:53:06+00:00
author: admin
layout: post
guid: http://www.josedomingo.org/pledin/?p=1779
permalink: /2017/03/iv-semana-informatica-universidad-de-almeria/
categories:
  - General
tags:
  - Cloud Computing
  - Educación
  - OpenStack
---
<p style="text-align: justify;">
  <a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2017/02/jornadas.png"><img class="aligncenter size-full wp-image-1788" src="https://www.josedomingo.org/pledin/wp-content/uploads/2017/02/jornadas.png" alt="" width="573" height="183" srcset="https://www.josedomingo.org/pledin/wp-content/uploads/2017/02/jornadas.png 573w, https://www.josedomingo.org/pledin/wp-content/uploads/2017/02/jornadas-300x96.png 300w" sizes="(max-width: 573px) 100vw, 573px" /></a>
</p>

<h1 style="text-align: center;">
  <strong>Programando infraestructura en la nube</strong><br />
</h1>

<p style="text-align: justify;">
  El pasado 23 de febrero participé, junto a mi compañero <a href="https://twitter.com/alberto_molina">Alberto Molina</a> en las <a href="http://www.ual.es/eventos/jornadasinformatica/">IV Jornadas de Informática de la Universidad de Almería</a>. Nos invitaron a dar una charla sobre Cloud Computing y decidimos presentar un tema que estamos trabajando en los últimos meses: la importancia y necesidad de programar la infraestructura. Por lo tanto, con el título &#8220;<strong>Programando infraestructura en la nube</strong>&#8221; abordamos el concepto de Cloud Computing, centrándonos en las dos capas que más nos interesaban: en el SaaS (Software como servicio) y en el IaaS (Infraestructura como servicio). Mientras que todo el mundo entiende que el SaaS es programable (generalmente mediante APIs), la pregunta que nos hacíamos era: ¿la IaaS se puede programar?
</p>

## ¿Por qué programar la infraestructura en la nube? Podemos indicar varias razones:

<li style="text-align: justify;">
  Las nueva metodología DevOps que trata de resolver el tradicional conflicto entre desarrollo y sistemas, con objetivos y responsabilidades diferentes. ¿Cómo solucionarlo?, pues indicábamos que habría que utilizar las mismas herramientas y que se deberían seguir las mismas metodologías de trabajo, pasando de &#8220;integración continua&#8221; a &#8220;entrega continua o a despliegue continuo&#8221;. En este escenario resulta imprescindible el uso de escenarios replicables y automatización de la configuración.
</li>
<li style="text-align: justify;">
  Una de las características más importantes y novedosas de los servicios que podemos obtener en la nube es la elasticidad, está nos proporciona la posibilidad de obtener más servicios (en nuestro caso más infraestructura) en el momento que la necesitamos. Poníamos de ejemplo un escenario donde tuviéramos una demanda variable sobre nuestro servicio web, es decir al tener un pico de demanda podemos, mediante la elasticidad, realizar un escalado horizontal, añadiendo más recursos a nuestro cluster. En este escenario también es necesario la automatización en la creación y destrucción de servidores web que formarán parte de nuestro cluster.
</li>
<li style="text-align: justify;">
  Se está pasando de crear aplicaciones monolíticas a crear aplicaciones basadas en &#8220;microservicios&#8221;.  Normalmente para implementar está nueva arquitectura se utilizan contenedores. Los contenedores se suelen ejecutar en cluster (por ejemplo kubernetes o docker swarm). Pero el software que vamos a usar para orquestar nuestros contenedores utiliza una infraestructura de servidores, almacenamiento y redes. También llegamos a la conclusión que la creación y configuración de esta infraestructura hay que automatizarlas.
</li>
<li style="text-align: justify;">
  En los últimos tiempo se empieza hablar de la &#8220;Infraestructura como código&#8221;, es decir, tratar la configuración de nuestros servicios como nuestro código, y por tanto utilizar las mismas herramientas y metodologías al tratar nuestra configuración: usar metodologías ágiles, entornos de desarrollo, prueba y producción, entrega / despliegue continuo. En este caso estamos automatizando la configuración de nuestra infraestructura.
</li>
<li style="text-align: justify;">
  &#8220;Big Data&#8221;: En los nuevos sistemas de análisis de datos se necesitan una gran cantidad de recursos para los cálculos que hay que realizar y además podemos tener cargas variables e impredecibles. Por lo tanto la sería deseable que la creación y configuración de la infraestructura donde se van a realizar dichos cálculos se cree y configure de forma automática.
</li>
<li style="text-align: justify;">
  Quizás esta razón, no es tan evidente, ya que se trata de la solución cloud &#8220;Función como servicio&#8221; o &#8220;serverless&#8221; que nos posibilita la ejecución de un código con características cloud (elasticidad, escabilidad, pago por uso,&#8230;) sin tener que preocuparnos por los servidores y recursos necesarios. Evidentemente, y no por el usuario final, será necesario la gestión automática de una infraestructura para que este sistema funcione.
</li>
<li style="text-align: justify;">
  Por último, y quizás como una opción donde todavía hay que llegar, señalamos la posibilidad de desarrollar aplicaciones nativas cloud, entendiendo este tipo de aplicaciones, aquellas que pudieran autogestionar la infraestructura donde se esté ejecutando, creando de esta manera aplicaciones resilientes y infraestructura dinámica autogestionada.
</li>

<!--more-->

## ¿Qué vamos a programar? Indicamos varios aspectos que podríamos programar en nuestra infraestructura:

  * Escenarios: máquinas virtuales, redes o almacenamiento
  * Configuración de sistemas o aplicaciones
  * Recursos de alto nivel: DNSaaS, LBaaS, DBaaS, &#8230;
  * Respuestas ante eventos

<p style="text-align: justify;">
  Aunque cómo ahora veremos existen herramientas más especializadas en la creación de escenarios y otras en la configuración automática de los sistemas o aplicaciones, hacíamos a los asistentes la siguiente pregunta: ¿no estamos hablando de lo mismo?, y llegábamos a la conclusión que en realidad, la creación de escenarios y la automatización de la configuración son cosas similares, ya que finalmente sólo se trata de automatizar la configuración de una aplicación software. Dicho con otras palabras cuando creamos una infraestructura en OpenSatck lo que realmente estamos haciendo es configurando el software &#8220;OpenStack&#8221;.
</p>

## Herramientas que podemos utilizar

<p style="text-align: justify;">
  Aunque podríamos usar lenguajes de programación tradicionales, nos vamos a fijar en el llamado &#8220;Software de orquestación&#8221;, para la creación de escenarios y &#8220;Software de gestión de la configuración&#8221;, para la configuración automática.
</p>

<p style="text-align: justify;">
  Cómo software de orquestación podemos señalar:
</p>

<ul style="text-align: justify;">
  <li>
    Vagrant (escenarios simples)
  </li>
  <li>
    Cloudformation (AWS)
  </li>
  <li>
    Heat (OpenStack)
  </li>
  <li>
    Terraform
  </li>
  <li>
    Juju
  </li>
</ul>

<p style="text-align: justify;">
  Y ejemplos de Software de gestión de la configuración:
</p>

<ul style="text-align: justify;">
  <li>
    Puppet
  </li>
  <li>
    Chef
  </li>
  <li>
    Ansible
  </li>
  <li>
    Salt (SaltStack)
  </li>
</ul>

<p style="text-align: justify;">
  Para terminar nuestra presentación realizamos una <a href="https://github.com/iesgn/presentacion-ual17/tree/gh-pages/ejemplo">demostración</a> donde creamos en AWS una máquina virtual donde instalamos docker, para ello utilizamos el software Terraform, para a continuación, utilizando Ansible, desplegamos una aplicación web utilizando dos contenedores: una base de datos mongoDB, y una aplicación web desarrollada en nodeJS, Let&#8217;s chat.
</p>

Aquí os dejo la presentación que hemos utilizado para nuestra charla:

**[Infraestructura en la nube con OpenStack](http://iesgn.github.io/presentacion-ual17/#/).**   

<center>
</center>



<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->