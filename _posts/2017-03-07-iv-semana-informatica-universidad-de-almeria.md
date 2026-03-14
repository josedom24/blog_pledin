---
id: 1779
title: IV Semana Informática. Universidad de Almería
date: 2017-03-07T09:53:06+00:00


guid: http://www.josedomingo.org/pledin/?p=1779
permalink: /2017/03/iv-semana-informatica-universidad-de-almeria/


tags:
  - Cloud Computing
  - Educación
  - OpenStack
---

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/02/jornadas.png"><img class="aligncenter size-full wp-image-1788" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/02/jornadas.png" alt="" width="573" height="183" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/02/jornadas.png 573w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/02/jornadas-300x96.png 300w" sizes="(max-width: 573px) 100vw, 573px" /></a>

## Programando infraestructura en la nube

El pasado 23 de febrero participé, junto a mi compañero <a href="https://twitter.com/alberto_molina">Alberto Molina</a> en las <a href="http://www.ual.es/eventos/jornadasinformatica/">IV Jornadas de Informática de la Universidad de Almería</a>. Nos invitaron a dar una charla sobre Cloud Computing y decidimos presentar un tema que estamos trabajando en los últimos meses: la importancia y necesidad de programar la infraestructura. Por lo tanto, con el título "**Programando infraestructura en la nube**" abordamos el concepto de Cloud Computing, centrándonos en las dos capas que más nos interesaban: en el SaaS (Software como servicio) y en el IaaS (Infraestructura como servicio). Mientras que todo el mundo entiende que el SaaS es programable (generalmente mediante APIs), la pregunta que nos hacíamos era: ¿la IaaS se puede programar?

## ¿Por qué programar la infraestructura en la nube? Podemos indicar varias razones:

* Las nueva metodología DevOps que trata de resolver el tradicional conflicto entre desarrollo y sistemas, con objetivos y responsabilidades diferentes. ¿Cómo solucionarlo?, pues indicábamos que habría que utilizar las mismas herramientas y que se deberían seguir las mismas metodologías de trabajo, pasando de "integración continua" a "entrega continua o a despliegue continuo". En este escenario resulta imprescindible el uso de escenarios replicables y automatización de la configuración.
* Una de las características más importantes y novedosas de los servicios que podemos obtener en la nube es la elasticidad, está nos proporciona la posibilidad de obtener más servicios (en nuestro caso más infraestructura) en el momento que la necesitamos. Poníamos de ejemplo un escenario donde tuviéramos una demanda variable sobre nuestro servicio web, es decir al tener un pico de demanda podemos, mediante la elasticidad, realizar un escalado horizontal, añadiendo más recursos a nuestro cluster. En este escenario también es necesario la automatización en la creación y destrucción de servidores web que formarán parte de nuestro cluster.
* Se está pasando de crear aplicaciones monolíticas a crear aplicaciones basadas en "microservicios".  Normalmente para implementar está nueva arquitectura se utilizan contenedores. Los contenedores se suelen ejecutar en cluster (por ejemplo kubernetes o docker swarm). Pero el software que vamos a usar para orquestar nuestros contenedores utiliza una infraestructura de servidores, almacenamiento y redes. También llegamos a la conclusión que la creación y configuración de esta infraestructura hay que automatizarlas.
* En los últimos tiempo se empieza hablar de la "Infraestructura como código", es decir, tratar la configuración de nuestros servicios como nuestro código, y por tanto utilizar las mismas herramientas y metodologías al tratar nuestra configuración: usar metodologías ágiles, entornos de desarrollo, prueba y producción, entrega / despliegue continuo. En este caso estamos automatizando la configuración de nuestra infraestructura.
* "Big Data": En los nuevos sistemas de análisis de datos se necesitan una gran cantidad de recursos para los cálculos que hay que realizar y además podemos tener cargas variables e impredecibles. Por lo tanto la sería deseable que la creación y configuración de la infraestructura donde se van a realizar dichos cálculos se cree y configure de forma automática.
* Quizás esta razón, no es tan evidente, ya que se trata de la solución cloud "Función como servicio" o "serverless" que nos posibilita la ejecución de un código con características cloud (elasticidad, escabilidad, pago por uso,...) sin tener que preocuparnos por los servidores y recursos necesarios. Evidentemente, y no por el usuario final, será necesario la gestión automática de una infraestructura para que este sistema funcione.
* Por último, y quizás como una opción donde todavía hay que llegar, señalamos la posibilidad de desarrollar aplicaciones nativas cloud, entendiendo este tipo de aplicaciones, aquellas que pudieran autogestionar la infraestructura donde se esté ejecutando, creando de esta manera aplicaciones resilientes y infraestructura dinámica autogestionada.

## ¿Qué vamos a programar? Indicamos varios aspectos que podríamos programar en nuestra infraestructura:

* Escenarios: máquinas virtuales, redes o almacenamiento
* Configuración de sistemas o aplicaciones
* Recursos de alto nivel: DNSaaS, LBaaS, DBaaS, ...
* Respuestas ante eventos

Aunque cómo ahora veremos existen herramientas más especializadas en la creación de escenarios y otras en la configuración automática de los sistemas o aplicaciones, hacíamos a los asistentes la siguiente pregunta: ¿no estamos hablando de lo mismo?, y llegábamos a la conclusión que en realidad, la creación de escenarios y la automatización de la configuración son cosas similares, ya que finalmente sólo se trata de automatizar la configuración de una aplicación software. Dicho con otras palabras cuando creamos una infraestructura en OpenSatck lo que realmente estamos haciendo es configurando el software "OpenStack".

## Herramientas que podemos utilizar

Aunque podríamos usar lenguajes de programación tradicionales, nos vamos a fijar en el llamado "Software de orquestación", para la creación de escenarios y "Software de gestión de la configuración", para la configuración automática.

Cómo software de orquestación podemos señalar:

* Vagrant (escenarios simples)
* Cloudformation (AWS)
* Heat (OpenStack)
* Terraform
* Juju

Y ejemplos de Software de gestión de la configuración:


* Puppet
* Chef
* Ansible
* Salt (SaltStack)

Para terminar nuestra presentación realizamos una <a href="https://github.com/iesgn/presentacion-ual17/tree/gh-pages/ejemplo">demostración</a> donde creamos en AWS una máquina virtual donde instalamos docker, para ello utilizamos el software Terraform, para a continuación, utilizando Ansible, desplegamos una aplicación web utilizando dos contenedores: una base de datos mongoDB, y una aplicación web desarrollada en nodeJS, Let's chat.

Aquí os dejo la presentación que hemos utilizado para nuestra charla:

**[Infraestructura en la nube con OpenStack](http://iesgn.github.io/presentacion-ual17/#/).**   

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->