---
layout: post
status: publish
published: true
title: Introducci&oacute;n a las bases de datos como servicio (DBaaS). RedisLabs.
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1244
wordpress_url: http://www.josedomingo.org/pledin/?p=1244
date: '2015-02-03 20:32:06 +0000'
date_gmt: '2015-02-03 19:32:06 +0000'
categories:
- General
tags:
- Cloud Computing
- Base de datos
- Redis
- DBaaS
comments: []
---
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/02/&iacute;ndice.png"><img class="aligncenter size-full wp-image-1248" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/02/&iacute;ndice.png" alt="&iacute;ndice" width="487" height="103" /></a></p>
<p>Entendiendo las bases de datos como una aplicaci&oacute;n m&aacute;s cualquiera, y extendiendo el concepto de SaaS (software como servicio), se puede entender las DBaaS como una nueva manera de acceder al uso de una base de datos, respondiendo a los principios del cloud computing:</p>
<ul>
<li>Vamos a tener disponible nuestro servicio, en nuestro caso, una base de datos, de forma autom&aacute;tica y bajo demanda, es decir sin que ning&uacute;n operador de la empresa que ofrece el servicio tenga que realizar ninguna operaci&oacute;n para que el cliente obtenga el servicio.</li>
<li>La base de datos debe ser accesible desde internet.</li>
<li>Se puede ofrecer el servicio usando el modelo de recurso compartido, donde varios usuarios pueden estar compartiendo recursos, por lo tanto es necesario garantizar el aislamiento y la seguridad entre usuarios.</li>
<li>Elasticidad, que es la propiedad que me permite aumentar o disminuir la capacidad de mi recurso, mi base de datos, de forma autom&aacute;tica y en cualquier momento.</li>
<li>El pago por uso.</li>
</ul>
<p>Evidentemente a ser la base de datos un software, es necesario combinar los DBaaS con un PaaS o un IaaS para conseguir una infraestructura totalmente operativa. Los DBaaS ofrecen tanto bases de datos relacionales (MySql, PostgreSQL,..), como base de datos no relacionales o noSQL c&oacute;mo Redis, CouchDB o MongoDB. Como ejemplo de empresas que ofrecen estos servicios tenemos <a href="http://aws.amazon.com/es/dynamodb/?nc2=h_l3_db">Amazon, que ofrece Amazon DynamoDB</a> o <a href="https://www.cleardb.com/home.view">ClearDB que ofrece un servicio MySQL</a>.</p>
<h2>RedisLabs: Redis como DBaaS</h2>
<p>Como vimos en el <a title="Redis, base de datos no relacional" href="http://www.josedomingo.org/pledin/2015/02/redis-base-de-datos-no-relacional/">art&iacute;culo anterior</a>, Redis es una base de datos no relacional, que guarda la informaci&oacute;n en conjuntos clave-valor. La empresa <a href="https://redislabs.com/">RedisLabs</a> nos ofrece Redis como DBaaS. Nos podemos dar de alta en la p&aacute;gina y podemos obtener de forma gratuita a una instancia con una base de datos Redis con una limitaci&oacute;n de 25 Mb de memoria y 10 conexiones simultaneas. Para empezar a trabajar con esta infraestructura es suficiente, si necesitamos m&aacute;s recursos podemos obtenerlos por una <a href="https://redislabs.com/pricing">cuota mensual</a>. Tras darte de alta en la p&aacute;gina, puedes dar de alta una nueva base de datos con el plan gratuito, y puedes obtener el servicio de una nueva base de datos, como observamos en la siguiente imagen:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/02/redis.png"><img class="aligncenter size-full wp-image-1250" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/02/redis.png" alt="redis" width="592" height="498" /></a></p>
<p>En el par&aacute;metro <em><strong>Endpoint</strong></em> obtenemos la direcci&oacute;n de la instancia y el puerto al que nos tenemos que conectar. Adem&aacute;s hemos configurado una contrase&ntilde;a para el acceso a nuestra base de datos, la puedes ver en el par&aacute;metro <em><strong>Redis Password</strong></em>. Usando por lo tanto un cliente de redis, podemos realizar la conexi&oacute;n a la base de datos y empezar a trabajar con ella:</p>
<pre># redis-cli -h pub-redis-99999.us-east-1-3.3.ec2.garantiadata.com -p 12345
pub-redis-99999.us-east-1-3.3.ec2.garantiadata.com:12345> AUTH la_contrase&ntilde;a
OK
pub-redis-99999.us-east-1-3.3.ec2.garantiadata.com:12345> SET usuario pepe
OK
pub-redis-99999.us-east-1-3.3.ec2.garantiadata.com:12345> GET usuario
"pepe"</pre>
<p>Como siempre esto es s&oacute;lo una introducci&oacute;n sobre DBaaS, si quieres seguir form&aacute;ndote sobre el tema, te recomiendo leer el art&iacute;culo <a href="http://jj.github.io/dbaas/">Dbaas, Database as a Service, una introducci&oacute;n usando Redis</a> de <a href="https://github.com/JJ">J.J. Merelo</a>.</p>
