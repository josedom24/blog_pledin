---
layout: post
status: publish
published: true
title: IV Semana Inform&aacute;tica. Universidad de Almer&iacute;a
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1779
wordpress_url: http://www.josedomingo.org/pledin/?p=1779
date: '2017-03-07 09:53:06 +0000'
date_gmt: '2017-03-07 08:53:06 +0000'
categories:
- General
tags:
- Educaci&oacute;n
- Cloud Computing
- OpenStack
comments: []
---
<p style="text-align: justify;">
  <a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2017/02/jornadas.png"><img class="aligncenter size-full wp-image-1788" src="https://www.josedomingo.org/pledin/wp-content/uploads/2017/02/jornadas.png" alt="" width="573" height="183" /></a></p>
<h1 style="text-align: center;">
  <strong>Programando infraestructura en la nube</strong><br />
</h1>
<p style="text-align: justify;">
  El pasado 23 de febrero particip&eacute;, junto a mi compa&ntilde;ero <a href="https://twitter.com/alberto_molina">Alberto Molina</a> en las <a href="http://www.ual.es/eventos/jornadasinformatica/">IV Jornadas de Inform&aacute;tica de la Universidad de Almer&iacute;a</a>. Nos invitaron a dar una charla sobre Cloud Computing y decidimos presentar un tema que estamos trabajando en los &uacute;ltimos meses: la importancia y necesidad de programar la infraestructura. Por lo tanto, con el t&iacute;tulo "<strong>Programando infraestructura en la nube</strong>" abordamos el concepto de Cloud Computing, centr&aacute;ndonos en las dos capas que m&aacute;s nos interesaban: en el SaaS (Software como servicio) y en el IaaS (Infraestructura como servicio). Mientras que todo el mundo entiende que el SaaS es programable (generalmente mediante APIs), la pregunta que nos hac&iacute;amos era: &iquest;la IaaS se puede programar?</p>
<h2>&iquest;Por qu&eacute; programar la infraestructura en la nube? Podemos indicar varias razones:</h2>
<p>
<li style="text-align: justify;">
  Las nueva metodolog&iacute;a DevOps que trata de resolver el tradicional conflicto entre desarrollo y sistemas, con objetivos y responsabilidades diferentes. &iquest;C&oacute;mo solucionarlo?, pues indic&aacute;bamos que habr&iacute;a que utilizar las mismas herramientas y que se deber&iacute;an seguir las mismas metodolog&iacute;as de trabajo, pasando de "integraci&oacute;n continua" a "entrega continua o a despliegue continuo". En este escenario resulta imprescindible el uso de escenarios replicables y automatizaci&oacute;n de la configuraci&oacute;n.
</li>
<li style="text-align: justify;">
  Una de las caracter&iacute;sticas m&aacute;s importantes y novedosas de los servicios que podemos obtener en la nube es la elasticidad, est&aacute; nos proporciona la posibilidad de obtener m&aacute;s servicios (en nuestro caso m&aacute;s infraestructura) en el momento que la necesitamos. Pon&iacute;amos de ejemplo un escenario donde tuvi&eacute;ramos una demanda variable sobre nuestro servicio web, es decir al tener un pico de demanda podemos, mediante la elasticidad, realizar un escalado horizontal, a&ntilde;adiendo m&aacute;s recursos a nuestro cluster. En este escenario tambi&eacute;n es necesario la automatizaci&oacute;n en la creaci&oacute;n y destrucci&oacute;n de servidores web que formar&aacute;n parte de nuestro cluster.
</li>
<li style="text-align: justify;">
  Se est&aacute; pasando de crear aplicaciones monol&iacute;ticas a crear aplicaciones basadas en "microservicios".&nbsp; Normalmente para implementar est&aacute; nueva arquitectura se utilizan contenedores. Los contenedores se suelen ejecutar en cluster (por ejemplo kubernetes o docker swarm). Pero el software que vamos a usar para orquestar nuestros contenedores utiliza una infraestructura de servidores, almacenamiento y redes. Tambi&eacute;n llegamos a la conclusi&oacute;n que la creaci&oacute;n y configuraci&oacute;n de esta infraestructura hay que automatizarlas.
</li>
<li style="text-align: justify;">
  En los &uacute;ltimos tiempo se empieza hablar de la "Infraestructura como c&oacute;digo", es decir, tratar la configuraci&oacute;n de nuestros servicios como nuestro c&oacute;digo, y por tanto utilizar las mismas herramientas y metodolog&iacute;as al tratar nuestra configuraci&oacute;n: usar metodolog&iacute;as &aacute;giles, entornos de desarrollo, prueba y producci&oacute;n, entrega / despliegue continuo. En este caso estamos automatizando la configuraci&oacute;n de nuestra infraestructura.
</li>
<li style="text-align: justify;">
  "Big Data": En los nuevos sistemas de an&aacute;lisis de datos se necesitan una gran cantidad de recursos para los c&aacute;lculos que hay que realizar y adem&aacute;s podemos tener cargas variables e impredecibles. Por lo tanto la ser&iacute;a deseable que la creaci&oacute;n y configuraci&oacute;n de la infraestructura donde se van a realizar dichos c&aacute;lculos se cree y configure de forma autom&aacute;tica.
</li>
<li style="text-align: justify;">
  Quiz&aacute;s esta raz&oacute;n, no es tan evidente, ya que se trata de la soluci&oacute;n cloud "Funci&oacute;n como servicio" o "serverless" que nos posibilita la ejecuci&oacute;n de un c&oacute;digo con caracter&iacute;sticas cloud (elasticidad, escabilidad, pago por uso,...) sin tener que preocuparnos por los servidores y recursos necesarios. Evidentemente, y no por el usuario final, ser&aacute; necesario la gesti&oacute;n autom&aacute;tica de una infraestructura para que este sistema funcione.
</li>
<li style="text-align: justify;">
  Por &uacute;ltimo, y quiz&aacute;s como una opci&oacute;n donde todav&iacute;a hay que llegar, se&ntilde;alamos la posibilidad de desarrollar aplicaciones nativas cloud, entendiendo este tipo de aplicaciones, aquellas que pudieran autogestionar la infraestructura donde se est&eacute; ejecutando, creando de esta manera aplicaciones resilientes y infraestructura din&aacute;mica autogestionada.
</li></p>
<p><!--more--></p>
<h2>&iquest;Qu&eacute; vamos a programar? Indicamos varios aspectos que podr&iacute;amos programar en nuestra infraestructura:</h2>
<ul>
<li>Escenarios: m&aacute;quinas virtuales, redes o almacenamiento</li>
<li>Configuraci&oacute;n de sistemas o aplicaciones</li>
<li>Recursos de alto nivel: DNSaaS, LBaaS, DBaaS, ...</li>
<li>Respuestas ante eventos</li>
</ul>
<p style="text-align: justify;">
  Aunque c&oacute;mo ahora veremos existen herramientas m&aacute;s especializadas en la creaci&oacute;n de escenarios y otras en la configuraci&oacute;n autom&aacute;tica de los sistemas o aplicaciones, hac&iacute;amos a los asistentes la siguiente pregunta: &iquest;no estamos hablando de lo mismo?, y lleg&aacute;bamos a la conclusi&oacute;n que en realidad, la creaci&oacute;n de escenarios y la automatizaci&oacute;n de la configuraci&oacute;n son cosas similares, ya que finalmente s&oacute;lo se trata de automatizar la configuraci&oacute;n de una aplicaci&oacute;n software. Dicho con otras palabras cuando creamos una infraestructura en OpenSatck lo que realmente estamos haciendo es configurando el software "OpenStack".</p>
<h2>Herramientas que podemos utilizar</h2>
<p style="text-align: justify;">
  Aunque podr&iacute;amos usar lenguajes de programaci&oacute;n tradicionales, nos vamos a fijar en el llamado "Software de orquestaci&oacute;n", para la creaci&oacute;n de escenarios y "Software de gesti&oacute;n de la configuraci&oacute;n", para la configuraci&oacute;n autom&aacute;tica.</p>
<p style="text-align: justify;">
  C&oacute;mo software de orquestaci&oacute;n podemos se&ntilde;alar:</p>
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
  Y ejemplos de Software de gesti&oacute;n de la configuraci&oacute;n:</p>
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
  Para terminar nuestra presentaci&oacute;n realizamos una <a href="https://github.com/iesgn/presentacion-ual17/tree/gh-pages/ejemplo">demostraci&oacute;n</a> donde creamos en AWS una m&aacute;quina virtual donde instalamos docker, para ello utilizamos el software Terraform, para a continuaci&oacute;n, utilizando Ansible, desplegamos una aplicaci&oacute;n web utilizando dos contenedores: una base de datos mongoDB, y una aplicaci&oacute;n web desarrollada en nodeJS, Let's chat.</p>
<p>Aqu&iacute; os dejo la presentaci&oacute;n que hemos utilizado para nuestra charla:</p>
<p><strong><a href="http://iesgn.github.io/presentacion-ual17/#/">Infraestructura en la nube con OpenStack</a>.</strong> &nbsp; <center></center></p>
<p><iframe src="http://iesgn.github.io/presentacion-ual17/#/" width="560" height="315"></iframe></p>
