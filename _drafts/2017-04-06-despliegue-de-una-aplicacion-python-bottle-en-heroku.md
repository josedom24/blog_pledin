---
id: 1806
title: Despliegue de una aplicación Python Bottle en Heroku
date: 2017-04-06T20:34:51+00:00


guid: http://www.josedomingo.org/pledin/?p=1806
permalink: /2017/04/despliegue-de-una-aplicacion-python-bottle-en-heroku/


tags:
  - bottle
  - Heroku
  - PaaS
  - Python
---
<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/04/python.png"><img class="size-full wp-image-1820 aligncenter" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/04/python.png" alt="" width="318" height="159" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/04/python.png 318w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/04/python-300x150.png 300w" sizes="(max-width: 318px) 100vw, 318px" /></a>

En una <a href="http://www.josedomingo.org/pledin/2015/11/instalacion-de-drupal-en-heroku/">,entrada anterior</a>, explicamos cómo trabajar con Heroku, en concreto instalamos un CMS Drupal utilizando la herramienta `heroku-cli`. En este artículo vamos a desplegar una aplicación web desarrollada en python utilizando el framework bottle utilizando sólo la aplicación web Heroku (**Heroku Dashboard*).

<a href="https://www.heroku.com/">Heroku</a> es una aplicación que nos ofrece un servicio de Cloud Computing <a href="https://en.wikipedia.org/wiki/Platform_as_a_service">PaaS</a> (Plataforma como servicio). Como leemos en la <a href="https://es.wikipedia.org/wiki/Heroku">Wikipedia</a> es propiedad de <a href="http://www.salesforce.com">Salesforce.com</a> y es una de las primeras plataformas de computación en la nube, que fue desarrollada desde junio de 2007, con el objetivo de soportar solamente el lenguaje de programación Ruby, pero posteriormente se ha extendido el soporte a Java, Node.js, Scala, Clojure y Python y PHP. La funcionalidad ofrecida por heroku esta disponible con el uso de **dynos**, que son una adaptación de los contenedores Linux y nos ofrecen la capacidad de computo dentro de la plataforma.

Este artículo lo escribo como apoyo para la asignatura de Lenguajes de Marcas, que imparto en el ciclo de Grado Superior de Administración de sistemas Informáticos, por lo que vamos a recordar las características de la capa gratuita de Horoku:

* Podemos crear un dyno, que puede ejecutar un máximo de dos tipos de procesos. Para más información sobre la ejecución de los procesos ver: <a href="https://devcenter.heroku.com/articles/process-model">https://devcenter.heroku.com/articles/process-model</a>.
* Nuestro dyno utiliza 512 Mb de RAM
* Tras 30 minutos de inactividad el dyno se para (sleep), además debe estar parado 6 horas cada 24 horas.
* Podemos utilizar una base de datos postgreSQL con no más de 10.000 registros
* Para más información de los planes ofrecido por heroku puedes visitar: <a href="https://www.heroku.com/pricing#dynos-table-modal">https://www.heroku.com/pricing#dynos-table-modal</a>

Veamos los pasos que tenemos que realizar para desplegar nuestra aplicación python bottle en Heroku:

## Preparativos previos

* Tenemos que crear una cuenta gratuita en Heroku (<a href="https://signup.heroku.com/">singup</a>)
* Hemos creado una aplicación web con python bottle siguiendo la estructura que puedes encontrar en el repositorio GiHub <a href="https://github.com/josedom24/heroku-in-a-bottle">heroku-in-a-bottle. </a>, de los ficheros que contiene este repositorio podemos destacar:  
  * `Procfile`: En este fichero se define el proceso que va a ejecutar el dyno. Para más información: <a href="https://devcenter.heroku.com/articles/procfile">Process Types and the Procfile</a>
      </li>
  * `requierements.txt`: Fichero de texto donde guardamos el nombre los módulos python necesarios para que nuestra aplicación funcionen, y que se van a instalar en el dyno cuando despleguemos la aplicación.
* Nuestra aplicación que queremos desplegar la tenemos guardada en un repositorio GitHub

### Ejecución de nuestra aplicación en local 

Mientras estemos desarrollando la aplicación la podemos probar en nuestro ordenador de la siguiente manera:

    python app.py 8080
    Bottle v0.12.8 server starting up (using WSGIRefServer())...
    Listening on http://0.0.0.0:8080/
    Hit Ctrl-C to quit.

## Creamos una nueva aplicación en Heroku

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku1.png"><img class="aligncenter size-large wp-image-1805" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku1-1024x496.png" alt="" width="770" height="373" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku1-1024x496.png 1024w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku1-300x145.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku1-768x372.png 768w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku1.png 1137w" sizes="(max-width: 770px) 100vw, 770px" /></a>

Tenemos que indicar un nombre único. La URL de nuestra aplicación será: `https://pruebajd.herokuapp.com`

## Conectar nuestro proyecto con GitHub

El contenido que vamos a desplegar en nuestro proyecto se va a copiar desde el repositorio donde tenemos nuestra aplicación, para ello desde la pestaña **Deploy** vamos a escoger la opción: **Connect to GitHub.** 

![<img class="aligncenter size-large wp-image-1804" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku2-1024x427.png" alt="" width="770" height="321" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku2-1024x427.png 1024w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku2-300x125.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku2-768x320.png 768w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku2.png 1195w" sizes="(max-width: 770px) 100vw, 770px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku2.png)

A continuación desde GitHub le tenemos que dar permiso a la aplicación Heroku, para que accede a nuestros repositorios:

![<img class="aligncenter size-full wp-image-1803" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku3.png" alt="" width="960" height="628" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku3.png 960w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku3-300x196.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku3-768x502.png 768w" sizes="(max-width: 960px) 100vw, 960px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku3.png)

 Ahora tenemos que conectar el repositorio donde tenemos nuestra aplicación: 
 
 ![<img class="aligncenter size-large wp-image-1802" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku4-1024x467.png" alt="" width="770" height="351" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku4-1024x467.png 1024w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku4-300x137.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku4-768x350.png 768w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku4.png 1306w" sizes="(max-width: 770px) 100vw, 770px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku4.png)
 
 Tenemos a nuestra disposición dos maneras de hacer los despliegues:

* Automáticos: Esta opción la podemos habilitar. Cada vez que hagamos un commit en nuestro repositorio GitHub, heroku va  a desplegar la aplicación. Tenemos que elegir la rama que se va desplegar de forma automática.
* Manual: Elegimos la rama que vamos a desplegar y pulsamos el botón <strong>Deploy Branch</strong>

![<img class="aligncenter size-large wp-image-1801" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku5-1024x518.png" alt="" width="770" height="390" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku5-1024x518.png 1024w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku5-300x152.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku5-768x389.png 768w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku5.png 1231w" sizes="(max-width: 770px) 100vw, 770px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku5.png)

Veamos un ejemplo de despliegue manual:

<img class="aligncenter size-large wp-image-1800" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku6-1024x285.png" alt="" width="770" height="214" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku6-1024x285.png 1024w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku6-300x84.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku6-768x214.png 768w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku6.png 1313w" sizes="(max-width: 770px) 100vw, 770px" />

Si todo ha ido bien podremos acceder a nuestra aplicación: 

![<img class="aligncenter size-full wp-image-1799" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku7.png" alt="" width="312" height="138" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku7.png 312w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku7-300x133.png 300w" sizes="(max-width: 312px) 100vw, 312px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/03/heroku7.png)

## Conclusiones

Aunque tenemos a nuestro disposición una interfaz de línea de comandos muy completa: `heroku-cli`, he querido explicar de forma muy simple el despliegue de aplicaciones web python bottle en **Heroku Dashboard** para probar las aplicaciones que van a realizar los alumnos en la asignatura.


<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->
