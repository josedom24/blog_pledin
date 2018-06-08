---
layout: post
status: publish
published: true
title: 'Dockerfile: Creaci&oacute;n de im&aacute;genes docker'
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1620
wordpress_url: http://www.josedomingo.org/pledin/?p=1620
date: '2016-02-15 19:10:48 +0000'
date_gmt: '2016-02-15 18:10:48 +0000'
categories:
- General
tags:
- Virtualizaci&oacute;n
- docker
comments: []
---
<p style="text-align: justify;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile.png" rel="attachment wp-att-1636"><img class="size-full wp-image-1636 aligncenter" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/dockerfile.png" alt="dockerfile" width="307" height="180" /></a>En la entrada anterior, estudiamos un m&eacute;todo para crear nuevas im&aacute;genes a partir de contenedores que anteriormente hab&iacute;amos configurado. En esta entrada vamos a presentar la forma m&aacute;s usual de crear nuevas im&aacute;genes: usando el comando <em>docker buid</em> y definiendo las caracter&iacute;sticas que queremos que tenga la imagen en un fichero <strong><em>Dockerfile</em></strong>.</p>
<h2 style="text-align: justify;">&iquest;C&oacute;mo funciona docker build?</h2>
<p style="text-align: justify;">Un <strong>Dockerfile</strong> es un fichero de texto donde indicamos los comandos que queremos ejecutar sobre una imagen base para crear una nueva imagen. El comando <em>docker build</em> construye la nueva imagen leyendo las instrucciones del fichero <strong>Dockerfile</strong> y la informaci&oacute;n de un entorno, que para nosotros va a ser un directorio (aunque tambi&eacute;n podemos guardar informaci&oacute;n, por ejemplo, en un repositorio git).</p>
<p style="text-align: justify;">La creaci&oacute;n de la imagen es ejecutada por el <strong>docker engine</strong>, que recibe toda la informaci&oacute;n del entorno, por lo tanto es recomendable guardar el <strong>Dockerfile</strong> en un directorio vac&iacute;o y a&ntilde;adir los ficheros necesarios para la creaci&oacute;n de la imagen. El comando <em>docker build</em> ejecuta las instrucciones de un <strong>Dockerfile</strong> l&iacute;nea por l&iacute;nea y va mostrando los resultados en pantalla.</p>
<p style="text-align: justify;">Tenemos que tener en cuenta que cada instrucci&oacute;n ejecutada crea una imagen intermedia, una vez finalizada la construcci&oacute;n de la imagen nos devuelve su <em>id</em>. Alguna im&aacute;genes intermedias se guardan en cach&eacute;, otras se borran. Por lo tanto, si por ejemplo, en un comando ejecutamos <code>cd /scripts/</code> y en otra linea le mandamos a ejecutar un script (<code>./install.sh</code>) no va a funcionar, ya que ha lanzado otra imagen intermedia. Teniendo esto en cuenta, la manera correcta de hacerlo ser&iacute;a:</p>
<pre>cd /scripts/;./install.sh</pre>
<p style="text-align: justify;">Para terminar indicar que la creaci&oacute;n de im&aacute;genes intermedias generadas por la ejecuci&oacute;n de cada instrucci&oacute;n del <strong>Dockerfile</strong>, es un mecanismo de cach&eacute;, es decir, si en alg&uacute;n momento falla la creaci&oacute;n de la imagen, al corregir el <strong>Dockerfile</strong> y volver a construir la imagen, los pasos que hab&iacute;an funcionado anteriormente no se repiten ya que tenemos a nuestra disposici&oacute;n las im&aacute;genes intermedias, y el proceso contin&uacute;a por la instrucci&oacute;n que caus&oacute; el fallo.<!--more--></p>
<h2 style="text-align: justify;">Buenas pr&aacute;cticas al crear Dockerfile</h2>
<h3>Los contenedores deber ser "ef&iacute;meros"</h3>
<p style="text-align: justify;">Cuando decimos "ef&iacute;meros" queremos decir que la creaci&oacute;n, parada, despliegue de los contenedores creados a partir de la imagen que vamos a generar con nuestro <strong>Dockerfile </strong>debe tener una m&iacute;nima configuraci&oacute;n.</p>
<h3 style="text-align: justify;">Uso de ficheros .dockerignore</h3>
<p style="text-align: justify;">Como hemos indicado anteriormente, todos los ficheros del contexto se env&iacute;an al <strong>docker engine</strong>, es recomendable usar un directorio vac&iacute;o donde vamos creando los ficheros que vamos a enviar. Adem&aacute;s, para aumentar el rendimiento, y no enviar al <em>daemon </em>ficheros innecesarios podemos hacer uso de un fichero <em>.dockerignore</em>, para excluir ficheros y directorios.</p>
<h3>No instalar paquetes innecesarios</h3>
<p style="text-align: justify;">Para reducir la complejidad, dependencias, tiempo de creaci&oacute;n y tama&ntilde;o de la imagen resultante, se debe evitar instalar paquetes extras o innecesarios Si alg&uacute;n paquete es necesario durante la creaci&oacute;n de la imagen, lo mejor es desinstalarlo durante el proceso.</p>
<h3>Minimizar el n&uacute;mero de capas</h3>
<p style="text-align: justify;">Debemos encontrar el balance entre la legibilidad del <strong>Dockerfile</strong> y minimizar el n&uacute;mero de capa que utiliza.</p>
<h3 style="text-align: justify;">Indicar las instrucciones a ejecutar en m&uacute;ltiples l&iacute;neas</h3>
<p style="text-align: justify;">Cada vez que sea posible y para hacer m&aacute;s f&aacute;cil futuros cambios, hay que organizar los argumentos de las instrucciones que contengan m&uacute;ltiples l&iacute;neas, esto evitar&aacute; la duplicaci&oacute;n de paquetes y har&aacute; que el archivo sea m&aacute;s f&aacute;cil de leer. Por ejemplo:</p>
<pre>RUN apt-get update &amp;&amp; apt-get install -y \
git \
wget \
apache2 \
php5</pre>
<h2>Instrucciones de Dockerfile</h2>
<p style="text-align: justify;">En este apartado vamos a hacer una introducci&oacute;n al uso de las instrucciones m&aacute;s usadas que podemos definir dentro de un fichero <strong>Dockerfile</strong>, para una descripci&oacute;n m&aacute;s detallada consulta la <a href="https://docs.docker.com/engine/reference/builder/">documentaci&oacute;n oficial</a>.</p>
<h3>FROM</h3>
<p style="text-align: justify;">FROM indica la imagen base que va a utilizar para seguir futuras instrucciones. Buscar&aacute; si la imagen se encuentra localmente, en caso de que no, la descargar&aacute; de internet.</p>
<p><strong>Sintaxis</strong></p>
<pre>FROM <imagen>
FROM <imagen>:<tag></pre>
<h3 style="text-align: justify;">MAINTAINER</h3>
<p style="text-align: justify;">Esta instrucci&oacute;n nos permite configurar datos del autor que genera la imagen.<br />
<strong>Sintaxis</strong></p>
<pre>MAINTAINER <nombre> <Correo></pre>
<h3 style="text-align: justify;">RUN</h3>
<p style="text-align: justify;">Esta instrucci&oacute;n ejecuta cualquier comando en una capa nueva encima de una imagen y hace un commit de los resultados. Esa nueva imagen intermedia es usada para el siguiente paso en el <strong>Dockerfile</strong>. RUN tiene 2 formatos:</p>
<ul>
<li style="text-align: justify;">El modo shell: <code>/bin/sh -c</code></li>
</ul>
<pre>RUN comando</pre>
<ul>
<li>Modo ejecuci&oacute;n:</li>
</ul>
<pre>RUN ["ejecutable", "par&aacute;metro1", "par&aacute;metro2"]</pre>
<p style="text-align: justify;">El modo ejecuci&oacute;n nos permite correr comandos en im&aacute;genes bases que no cuenten con /bin/sh , nos permite adem&aacute;s hacer uso de otra shell si as&iacute; lo deseamos, ejemplo:</p>
<pre>RUN ["/bin/bash", "-c", "echo prueba"]</pre>
<h3 style="text-align: justify;">ENV</h3>
<p style="text-align: justify;">Esta instrucci&oacute;n configura las variables de ambiente, estos valores estar&aacute;n en los ambientes de todos los comandos que sigan en el <strong>Dockerfile</strong>.</p>
<p style="text-align: justify;"><strong>Sintaxis</strong></p>
<pre>ENV <key> <value>
<span class="hljs-keyword">ENV</span> <key>=<value> ...</pre>
<p style="text-align: justify;">Estos valores persistir&aacute;n al momento de lanzar un contenedor de la imagen creada y pueden ser usados dentro de cualquier fichero del entorno, por ejemplo un script ejecutable. Pueden ser sustituida pasando la opci&oacute;n <strong>-env</strong> en<em> docker run</em>. Ejemplo:</p>
<pre>docker run -env <key>=<valor></pre>
<h3>ADD</h3>
<p style="text-align: justify;">Esta instrucci&oacute;n copia los archivos o directorios de una ubicaci&oacute;n especificada y los agrega al sistema de archivos del contenedor en la ruta especificada. Tiene dos formas:</p>
<p style="text-align: justify;"><strong>Sintaxis</strong></p>
<pre>ADD <src>... <dest>
ADD ["<src>",... "<dest>"]</pre>
<h3>EXPOSE</h3>
<p style="text-align: justify;">Esta instrucci&oacute;n le especifica a docker que el contenedor escucha en los puertos especificados en su ejecuci&oacute;n. EXPOSE no hace que los puertos puedan ser accedidos desde el host, para esto debemos mapear los puertos usando la opci&oacute;n <strong>-p</strong> en <em>docker run</em>.</p>
<p><strong>Ejemplo:</strong></p>
<pre>EXPOSE 80 443</pre>
<h3>CMD y ENTRYPOINT</h3>
<p style="text-align: justify;">Estas dos instrucciones son muy parecidas, aunque se utilizan en situaciones diferentes, y adem&aacute;s pueden ser usadas conjuntamente, en el <a href="https://www.ctl.io/developers/blog/post/dockerfile-entrypoint-vs-cmd/">siguiente art&iacute;culo</a> se explica muy bien su uso.</p>
<p style="text-align: justify;">Estas dos instrucciones nos permiten especificar el comando que se va a ejecutar por defecto, sino indicamos ninguno cuando ejecutamos el <code>docker run</code>. Normalmente las im&aacute;genes bases (debian, ubuntu,...) est&aacute;n configuradas con estas instrucciones para ejecutar el comando <em>/bin/sh</em> o <em>/bin/bash</em>. Podemos comprobar el comando por defecto que se ha definido en una imagen con el siguiente comando:</p>
<pre>$ docker inspect debian
...
 "Cmd": [
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "/bin/bash"
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ],
...</pre>
<p style="text-align: justify;">Por lo tanto no es necesario indicar el comando como argumento, cuando se inicia un contenedor:</p>
<pre>$ docker run -i -t&nbsp; debian</pre>
<p>En el siguiente gr&aacute;fico puedes ver los detalles de algunas im&aacute;genes oficiales: su tama&ntilde;o, las capas que la conforman y el comando que se define por defecto:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/image-layers.png" rel="attachment wp-att-1633"><img class="aligncenter size-full wp-image-1633" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/image-layers.png" alt="image-layers" width="478" height="292" /></a></p>
<p><strong>CMD</strong></p>
<p>CMD tiene tres formatos:</p>
<ul>
<li>Formato de ejecuci&oacute;n:</li>
</ul>
<pre>CMD ["ejecutable", "par&aacute;metro1", "par&aacute;metro2"]</pre>
<ul>
<li>Modo shell:</li>
</ul>
<pre>CMD comando par&aacute;metro1 par&aacute;metro2</pre>
<ul>
<li>Formato para usar junto a la instrucci&oacute;n ENTRYPOINT</li>
</ul>
<pre>CMD ["par&aacute;metro1","par&aacute;metro2"]</pre>
<p style="text-align: justify;">Solo puede existir una instrucci&oacute;n <em>CMD </em>en un <strong>Dockerfile</strong>, si colocamos m&aacute;s de una, solo la &uacute;ltima tendr&aacute; efecto.Se debe usar para indicar el comando por defecto que se va a ejecutar al crear el contenedor, pero permitimos que el usuario ejecute otro comando al iniciar el contenedor.</p>
<p><strong>ENTRYPOINT</strong></p>
<p><em>ENTRYPOINT</em> tiene dos formatos:</p>
<ul>
<li>Formato de ejecuci&oacute;n:</li>
</ul>
<pre>ENTRYPOINT ["ejecutable", "par&aacute;metro1", "par&aacute;metro2"]</pre>
<ul>
<li>Modo shell:</li>
</ul>
<pre>ENTRYPOINT comando par&aacute;metro1 par&aacute;metro2</pre>
<p style="text-align: justify;">Esta instrucci&oacute;n tambi&eacute;n nos permite indicar el comando que se va ejecutar al iniciar el contenedor, pero en este caso el usuario no puede indicar otro comando al iniciar el contenedor. Si usamos esta instrucci&oacute;n no permitimos o no&nbsp; esperamos que el usuario ejecute otro comando que el especificado. Se puede usar junto a una instrucci&oacute;n<em> CMD</em>, donde se indicar&aacute; los par&aacute;metro por defecto que tendr&aacute; el comando indicado en el <em>ENTRYPOINT</em>. Cualquier argumento que pasemos en la l&iacute;nea de comandos mediante&nbsp;<code>docker run</code> ser&aacute;n anexados despu&eacute;s de todos los elementos especificados mediante la instrucci&oacute;n <em>ENTRYPOINT</em>, y anular&aacute; cualquier elemento especificado con CMD.</p>
<p><strong>Ejemplo:</strong></p>
<p>Si tenemos un fichero <strong>Dockerfile</strong>, que tiene las siguientes instrucciones:</p>
<pre>ENTRYPOINT [&ldquo;http&rdquo;, &ldquo;-v ]&rdquo;</pre>
<pre>CMD [&ldquo;-p&rdquo;, &ldquo;80&rdquo;]</pre>
<p>Podemos crear un contenedor a partir de la imagen generada:</p>
<ul>
<li style="text-align: justify;"><code>docker run centos:centos7</code>: Se crear&aacute; el contenedor con el servidor web escuchando en el puerto 80.</li>
<li style="text-align: justify;"><code>docker run centos:centros7 -p 8080</code>: Se crear&aacute; el contenedor con el servidor web escuchando en el puerto 8080.</li>
</ul>
<h2>Conclusiones</h2>
<p style="text-align: justify;">En esta entrada hemos estudiado los fundamentos y conceptos necesarios para crear im&aacute;genes a partir de fichero <strong>Dockerfile</strong> y el comando <em>docker build</em>. En la pr&oacute;xima entrada vamos a estudiar algunos ejemplos de ficheros <strong>Dockerfile</strong>, y la creaci&oacute;n de contenedores a partir de las im&aacute;genes que vamos a generar.</p>
