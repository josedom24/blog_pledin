---
layout: post
status: publish
published: true
title: Desplegando una aplicaci&oacute;n en Kubernetes
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1995
wordpress_url: https://www.josedomingo.org/pledin/?p=1995
date: '2018-05-23 20:53:37 +0000'
date_gmt: '2018-05-23 18:53:37 +0000'
categories:
- General
tags:
- Cloud Computing
- kubernetes
comments: []
---
<p>Un escenario com&uacute;n cuando desplegamos una aplicaci&oacute;n web puede ser el siguiente:</p>
<p><a class="thumbnail" href="https://www.josedomingo.org/pledin/wp-content/uploads/2018/05/deploy1.png"><img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/05/deploy1.png" alt="" width="685" height="387" class="aligncenter size-full wp-image-1997" /></a></p>
<p>En este escenario tenemos los siguientes elementos:</p>
<ul>
<li>Un conjunto de m&aacute;quinas (normalmente virtuales) que sirven la aplicaci&oacute;n web (<strong>frontend</strong>).</li>
<li>Un balanceador de carga externo que reparte el tr&aacute;fico entre las diferentes m&aacute;quinas.</li>
<li>Un n&uacute;mero de servidores de bases de datos (<strong>backend</strong>).</li>
<li>Un balanceador de carga interno que reparte el acceso a las bases de datos.</li>
</ul>
<p>El escenario anterior se podr&iacute;a montar en Kubernetes de la siguiente forma:</p>
<p><a class="thumbnail" href="https://www.josedomingo.org/pledin/wp-content/uploads/2018/05/deploy2.png"><img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/05/deploy2.png" alt="" width="754" height="388" class="aligncenter size-full wp-image-1996" /></a></p>
<p>Los distintos recursos de Kubernetes nos proporcionan distintas caracter&iacute;sticas muy deseadas:</p>
<ul>
<li><code>Pods</code>: La unidad m&iacute;nima de computaci&oacute;n en Kubernetes, permite ejecutar contenedores. Representa un conjunto de contenedores y almacenamiento compartido que comparte una &uacute;nica IP.</li>
<li><code>ReplicaSet</code>: Recurso de un cluster Kubernetes que asegura que siempre se ejecute un n&uacute;mero de replicas de un pod determinado. Nos proporciona las siguientes caracter&iacute;sticas:
<ul>
<li>Que no haya ca&iacute;da del servicio</li>
<li>Tolerancia a errores</li>
<li>Escabilidad din&aacute;mica</li>
</ul>
</li>
<li><code>Deployment</code>: Recurso del cluster Kubernetes que nos permite manejar los <code>ReplicaSets</code>. Nos proporciona las siguientes caracter&iacute;sticas:
<ul>
<li>Actualizaciones contin&uacute;as</li>
<li>Despliegues autom&aacute;ticos</li>
</ul>
</li>
<li><code>Service</code>: Nos permite el acceso a los pod. </li>
<li><code>Ingress</code>: Nos permite implementar un proxy inverso para el acceso a los distintos servicios establecidos. Estos dos elementos nos proporcionan la siguiente funcionalidad:
<ul>
<li>Balanceo de carga</li>
</ul>
</li>
<li>Otros recursos de un cluster Kubernetes nos pueden proporcional caracter&iacute;sticas adicionales:
<ul>
<li>Migraciones sencillas</li>
<li>Monitorizaci&oacute;n</li>
<li>Control de acceso basada en Roles</li>
<li>Integraci&oacute;n y despliegue continuo</li>
</ul>
</li>
</ul>
<p>En las siguientes entradas vamos a ir estudiando cada uno de estos recursos.</p>
