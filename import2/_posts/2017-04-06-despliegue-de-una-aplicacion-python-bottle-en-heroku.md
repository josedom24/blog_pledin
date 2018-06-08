---
layout: post
status: publish
published: true
title: Despliegue de una aplicaci&oacute;n Python Bottle en Heroku
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1806
wordpress_url: http://www.josedomingo.org/pledin/?p=1806
date: '2017-04-06 20:34:51 +0000'
date_gmt: '2017-04-06 18:34:51 +0000'
categories:
- General
tags:
- Python
- PaaS
- bottle
- Heroku
comments: []
---
<p style="text-align: justify;">
  <a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2017/04/python.png"><img class="size-full wp-image-1820 aligncenter" src="https://www.josedomingo.org/pledin/wp-content/uploads/2017/04/python.png" alt="" width="318" height="159" /></a></p>
<p style="text-align: justify;">
  En una <a href="http://www.josedomingo.org/pledin/2015/11/instalacion-de-drupal-en-heroku/,">entrada anterior</a>, explicamos c&oacute;mo trabajar con Heroku, en concreto instalamos un CMS Drupal utilizando la herramienta <code>heroku-cli</code>. En este art&iacute;culo vamos a desplegar una aplicaci&oacute;n web desarrollada en python utilizando el framework bottle utilizando s&oacute;lo la aplicaci&oacute;n web Heroku (<strong>Heroku Dashboard</strong>).</p>
<p style="text-align: justify;">
  <a href="https://www.heroku.com/">Heroku</a> es una aplicaci&oacute;n que nos ofrece un servicio de Cloud Computing <a href="https://en.wikipedia.org/wiki/Platform_as_a_service">PaaS</a> (Plataforma como servicio). Como leemos en la <a href="https://es.wikipedia.org/wiki/Heroku">Wikipedia</a> es propiedad de <a href="http://www.salesforce.com">Salesforce.com</a> y es una de las primeras plataformas de computaci&oacute;n en la nube, que fue desarrollada desde junio de 2007, con el objetivo de soportar solamente el lenguaje de programaci&oacute;n Ruby, pero posteriormente se ha extendido el soporte a Java, Node.js, Scala, Clojure y Python y PHP. La funcionalidad ofrecida por heroku esta disponible con el uso de <em><strong>dynos</strong></em>, que son una adaptaci&oacute;n de los contenedores Linux y nos ofrecen la capacidad de computo dentro de la plataforma.</p>
<p style="text-align: justify;">
  Este art&iacute;culo lo escribo como apoyo para la asignatura de Lenguajes de Marcas, que imparto en el ciclo de Grado Superior de Administraci&oacute;n de sistemas Inform&aacute;ticos, por lo que vamos a recordar las caracter&iacute;sticas de la capa gratuita de Horoku:</p>
<ul style="text-align: justify;">
<li>
    Podemos crear un dyno, que puede ejecutar un m&aacute;ximo de dos tipos de procesos. Para m&aacute;s informaci&oacute;n sobre la ejecuci&oacute;n de los procesos ver: <a href="https://devcenter.heroku.com/articles/process-model">https://devcenter.heroku.com/articles/process-model</a>.
  </li>
<li>
    Nuestro dyno utiliza 512 Mb de RAM
  </li>
<li>
    Tras 30 minutos de inactividad el dyno se para (sleep), adem&aacute;s debe estar parado 6 horas cada 24 horas.
  </li>
<li>
    Podemos utilizar una base de datos postgreSQL con no m&aacute;s de 10.000 registros
  </li>
<li>
    Para m&aacute;s informaci&oacute;n de los planes ofrecido por heroku puedes visitar: <a href="https://www.heroku.com/pricing#dynos-table-modal">https://www.heroku.com/pricing#dynos-table-modal</a>
  </li>
</ul>
<p>Veamos los pasos que tenemos que realizar para desplegar nuestra aplicaci&oacute;n python bottle en Heroku:</p>
<p><!--more--></p>
<h2>Preparativos previos</h2>
<ul style="text-align: justify;">
<li>
    Tenemos que crear una cuenta gratuita en Heroku (<a href="https://signup.heroku.com/">singup</a>)
  </li>
<li>
    Hemos creado una aplicaci&oacute;n web con python bottle siguiendo la estructura que puedes encontrar en el repositorio GiHub <a href="https://github.com/josedom24/heroku-in-a-bottle">heroku-in-a-bottle. </a>, de los ficheros que contiene este repositorio podemos destacar:
<ul style="text-align: justify;">
<li>
        <strong>Procfile</strong>: En este fichero se define el proceso que va a ejecutar el dyno. Para m&aacute;s informaci&oacute;n: <a href="https://devcenter.heroku.com/articles/procfile">Process Types and the Procfile</a>
      </li>
<li>
        <strong>requierements.txt</strong>: Fichero de texto donde guardamos el nombre los m&oacute;dulos python necesarios para que nuestra aplicaci&oacute;n funcionen, y que se van a instalar en el dyno cuando despleguemos la aplicaci&oacute;n.
      </li>
</ul>
</li>
<li>
    Nuestra aplicaci&oacute;n que queremos desplegar la tenemos guardada en un repositorio GitHub
  </li>
</ul>
<h3>Ejecuci&oacute;n de nuestra aplicaci&oacute;n en local Mientras estemos desarrollando la aplicaci&oacute;n la podemos probar en nuestro ordenador de la siguiente manera:</h3>
<pre>python app.py 8080
Bottle v0.12.8 server starting up (using WSGIRefServer())...
Listening on http://0.0.0.0:8080/
Hit Ctrl-C to quit.</pre>
<h2>Creamos una nueva aplicaci&oacute;n en Heroku</h2>
<p style="text-align: left;">
  <a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2017/03/heroku1.png"><img class="aligncenter size-large wp-image-1805" src="https://www.josedomingo.org/pledin/wp-content/uploads/2017/03/heroku1-1024x496.png" alt="" width="770" height="373" /></a></p>
<p style="text-align: justify;">
  Tenemos que indicar un nombre &uacute;nico. La URL de nuestra aplicaci&oacute;n ser&aacute;: <code>https://pruebajd.herokuapp.com</code></p>
<h2 style="text-align: justify;">
  Conectar nuestro proyecto con GitHub<br />
</h2>
<p style="text-align: justify;">
  El contenido que vamos a desplegar en nuestro proyecto se va a copiar desde el repositorio donde tenemos nuestra aplicaci&oacute;n, para ello desde la pesta&ntilde;a <strong>Deploy </strong>vamos a escoger la opci&oacute;n: <strong>Connect to GitHub. </strong></p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2017/03/heroku2.png"><img class="aligncenter size-large wp-image-1804" src="https://www.josedomingo.org/pledin/wp-content/uploads/2017/03/heroku2-1024x427.png" alt="" width="770" height="321" /></a></p>
<p style="text-align: justify;">
  A continuaci&oacute;n desde GitHub le tenemos que dar permiso a la aplicaci&oacute;n Heroku, para que accede a nuestros repositorios:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2017/03/heroku3.png"><img class="aligncenter size-full wp-image-1803" src="https://www.josedomingo.org/pledin/wp-content/uploads/2017/03/heroku3.png" alt="" width="960" height="628" /></a> Ahora tenemos que conectar el repositorio donde tenemos nuestra aplicaci&oacute;n: <a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2017/03/heroku4.png"><img class="aligncenter size-large wp-image-1802" src="https://www.josedomingo.org/pledin/wp-content/uploads/2017/03/heroku4-1024x467.png" alt="" width="770" height="351" /></a>Tenemos a nuestra disposici&oacute;n dos maneras de hacer los despliegues:</p>
<ul style="text-align: justify;">
<li>
    Autom&aacute;ticos: Esta opci&oacute;n la podemos habilitar. Cada vez que hagamos un commit en nuestro repositorio GitHub, heroku va&nbsp; a desplegar la aplicaci&oacute;n. Tenemos que elegir la rama que se va desplegar de forma autom&aacute;tica.
  </li>
<li>
    Manual: Elegimos la rama que vamos a desplegar y pulsamos el bot&oacute;n <strong>Deploy Branch</strong>
  </li>
</ul>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2017/03/heroku5.png"><img class="aligncenter size-large wp-image-1801" src="https://www.josedomingo.org/pledin/wp-content/uploads/2017/03/heroku5-1024x518.png" alt="" width="770" height="390" /></a></p>
<p style="text-align: justify;">
  Veamos un ejemplo de despliegue manual:<code></code></p>
<p><img class="aligncenter size-large wp-image-1800" src="https://www.josedomingo.org/pledin/wp-content/uploads/2017/03/heroku6-1024x285.png" alt="" width="770" height="214" /> Si todo ha ido bien podremos acceder a nuestra aplicaci&oacute;n: <a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2017/03/heroku7.png"><img class="aligncenter size-full wp-image-1799" src="https://www.josedomingo.org/pledin/wp-content/uploads/2017/03/heroku7.png" alt="" width="312" height="138" /></a></p>
<h2>Conclusiones</h2>
<p style="text-align: justify;">
  Aunque tenemos a nuestro disposici&oacute;n una <span class="st">interfaz de l&iacute;nea de comandos muy completa:<code> heroku-cli</code>, he querido explicar de forma muy simple el despliegue de aplicaciones web python bottle en <strong>Heroku Dashboard</strong> para probar las aplicaciones que van a realizar los alumnos en la asignatura.</span></p>
