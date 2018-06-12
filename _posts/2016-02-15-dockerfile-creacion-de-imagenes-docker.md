---
id: 1620
title: 'Dockerfile: Creación de imágenes docker'
date: 2016-02-15T19:10:48+00:00


guid: http://www.josedomingo.org/pledin/?p=1620
permalink: /2016/02/dockerfile-creacion-de-imagenes-docker/


tags:
  - docker
  - Virtualización
---
<p style="text-align: justify;">
  <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile.png" rel="attachment wp-att-1636"><img class="size-full wp-image-1636 aligncenter" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile.png" alt="dockerfile" width="307" height="180" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile.png 307w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile-300x176.png 300w" sizes="(max-width: 307px) 100vw, 307px" /></a>En la entrada anterior, estudiamos un método para crear nuevas imágenes a partir de contenedores que anteriormente habíamos configurado. En esta entrada vamos a presentar la forma más usual de crear nuevas imágenes: usando el comando <em>docker buid</em> y definiendo las características que queremos que tenga la imagen en un fichero <strong><em>Dockerfile</em></strong>.
</p>

<h2 style="text-align: justify;">
  ¿Cómo funciona docker build?
</h2>

<p style="text-align: justify;">
  Un <strong>Dockerfile</strong> es un fichero de texto donde indicamos los comandos que queremos ejecutar sobre una imagen base para crear una nueva imagen. El comando <em>docker build</em> construye la nueva imagen leyendo las instrucciones del fichero <strong>Dockerfile</strong> y la información de un entorno, que para nosotros va a ser un directorio (aunque también podemos guardar información, por ejemplo, en un repositorio git).
</p>

<p style="text-align: justify;">
  La creación de la imagen es ejecutada por el <strong>docker engine</strong>, que recibe toda la información del entorno, por lo tanto es recomendable guardar el <strong>Dockerfile</strong> en un directorio vacío y añadir los ficheros necesarios para la creación de la imagen. El comando <em>docker build</em> ejecuta las instrucciones de un <strong>Dockerfile</strong> línea por línea y va mostrando los resultados en pantalla.
</p>

<p style="text-align: justify;">
  Tenemos que tener en cuenta que cada instrucción ejecutada crea una imagen intermedia, una vez finalizada la construcción de la imagen nos devuelve su <em>id</em>. Alguna imágenes intermedias se guardan en caché, otras se borran. Por lo tanto, si por ejemplo, en un comando ejecutamos <code>cd /scripts/</code> y en otra linea le mandamos a ejecutar un script (<code>./install.sh</code>) no va a funcionar, ya que ha lanzado otra imagen intermedia. Teniendo esto en cuenta, la manera correcta de hacerlo sería:
</p>

<pre>cd /scripts/;./install.sh</pre>

<p style="text-align: justify;">
  Para terminar indicar que la creación de imágenes intermedias generadas por la ejecución de cada instrucción del <strong>Dockerfile</strong>, es un mecanismo de caché, es decir, si en algún momento falla la creación de la imagen, al corregir el <strong>Dockerfile</strong> y volver a construir la imagen, los pasos que habían funcionado anteriormente no se repiten ya que tenemos a nuestra disposición las imágenes intermedias, y el proceso continúa por la instrucción que causó el fallo.<!--more-->
</p>

<h2 style="text-align: justify;">
  Buenas prácticas al crear Dockerfile
</h2>

### Los contenedores deber ser &#8220;efímeros&#8221;

<p style="text-align: justify;">
  Cuando decimos &#8220;efímeros&#8221; queremos decir que la creación, parada, despliegue de los contenedores creados a partir de la imagen que vamos a generar con nuestro <strong>Dockerfile </strong>debe tener una mínima configuración.
</p>

<h3 style="text-align: justify;">
  Uso de ficheros .dockerignore
</h3>

<p style="text-align: justify;">
  Como hemos indicado anteriormente, todos los ficheros del contexto se envían al <strong>docker engine</strong>, es recomendable usar un directorio vacío donde vamos creando los ficheros que vamos a enviar. Además, para aumentar el rendimiento, y no enviar al <em>daemon </em>ficheros innecesarios podemos hacer uso de un fichero <em>.dockerignore</em>, para excluir ficheros y directorios.
</p>

### No instalar paquetes innecesarios

<p style="text-align: justify;">
  Para reducir la complejidad, dependencias, tiempo de creación y tamaño de la imagen resultante, se debe evitar instalar paquetes extras o innecesarios Si algún paquete es necesario durante la creación de la imagen, lo mejor es desinstalarlo durante el proceso.
</p>

### Minimizar el número de capas

<p style="text-align: justify;">
  Debemos encontrar el balance entre la legibilidad del <strong>Dockerfile</strong> y minimizar el número de capa que utiliza.
</p>

<h3 style="text-align: justify;">
  Indicar las instrucciones a ejecutar en múltiples líneas
</h3>

<p style="text-align: justify;">
  Cada vez que sea posible y para hacer más fácil futuros cambios, hay que organizar los argumentos de las instrucciones que contengan múltiples líneas, esto evitará la duplicación de paquetes y hará que el archivo sea más fácil de leer. Por ejemplo:
</p>

<pre>RUN apt-get update && apt-get install -y \
git \
wget \
apache2 \
php5</pre>

## Instrucciones de Dockerfile

<p style="text-align: justify;">
  En este apartado vamos a hacer una introducción al uso de las instrucciones más usadas que podemos definir dentro de un fichero <strong>Dockerfile</strong>, para una descripción más detallada consulta la <a href="https://docs.docker.com/engine/reference/builder/">documentación oficial</a>.
</p>

### FROM

<p style="text-align: justify;">
  FROM indica la imagen base que va a utilizar para seguir futuras instrucciones. Buscará si la imagen se encuentra localmente, en caso de que no, la descargará de internet.
</p>

**Sintaxis**

<pre>FROM &lt;imagen&gt;
FROM &lt;imagen&gt;:&lt;tag&gt;</pre>

<h3 style="text-align: justify;">
  MAINTAINER
</h3>

<p style="text-align: justify;">
  Esta instrucción nos permite configurar datos del autor que genera la imagen.<br /> <strong>Sintaxis</strong>
</p>

<pre>MAINTAINER &lt;nombre&gt; &lt;Correo&gt;</pre>

<h3 style="text-align: justify;">
  RUN
</h3>

<p style="text-align: justify;">
  Esta instrucción ejecuta cualquier comando en una capa nueva encima de una imagen y hace un commit de los resultados. Esa nueva imagen intermedia es usada para el siguiente paso en el <strong>Dockerfile</strong>. RUN tiene 2 formatos:
</p>

<li style="text-align: justify;">
  El modo shell: <code>/bin/sh -c</code>
</li>

<pre>RUN comando</pre>

  * Modo ejecución:

<pre>RUN ["ejecutable", "parámetro1", "parámetro2"]</pre>

<p style="text-align: justify;">
  El modo ejecución nos permite correr comandos en imágenes bases que no cuenten con /bin/sh , nos permite además hacer uso de otra shell si así lo deseamos, ejemplo:
</p>

<pre>RUN ["/bin/bash", "-c", "echo prueba"]</pre>

<h3 style="text-align: justify;">
  ENV
</h3>

<p style="text-align: justify;">
  Esta instrucción configura las variables de ambiente, estos valores estarán en los ambientes de todos los comandos que sigan en el <strong>Dockerfile</strong>.
</p>

<p style="text-align: justify;">
  <strong>Sintaxis</strong>
</p>

<pre>ENV &lt;key&gt; &lt;value&gt;
<span class="hljs-keyword">ENV</span> &lt;key&gt;=&lt;value&gt; ...</pre>

<p style="text-align: justify;">
  Estos valores persistirán al momento de lanzar un contenedor de la imagen creada y pueden ser usados dentro de cualquier fichero del entorno, por ejemplo un script ejecutable. Pueden ser sustituida pasando la opción <strong>-env</strong> en<em> docker run</em>. Ejemplo:
</p>

<pre>docker run -env &lt;key&gt;=&lt;valor&gt;</pre>

### ADD

<p style="text-align: justify;">
  Esta instrucción copia los archivos o directorios de una ubicación especificada y los agrega al sistema de archivos del contenedor en la ruta especificada. Tiene dos formas:
</p>

<p style="text-align: justify;">
  <strong>Sintaxis</strong>
</p>

<pre>ADD &lt;src&gt;... &lt;dest&gt;
ADD ["&lt;src&gt;",... "&lt;dest&gt;"]</pre>

### EXPOSE

<p style="text-align: justify;">
  Esta instrucción le especifica a docker que el contenedor escucha en los puertos especificados en su ejecución. EXPOSE no hace que los puertos puedan ser accedidos desde el host, para esto debemos mapear los puertos usando la opción <strong>-p</strong> en <em>docker run</em>.
</p>

**Ejemplo:**

<pre>EXPOSE 80 443</pre>

### CMD y ENTRYPOINT

<p style="text-align: justify;">
  Estas dos instrucciones son muy parecidas, aunque se utilizan en situaciones diferentes, y además pueden ser usadas conjuntamente, en el <a href="https://www.ctl.io/developers/blog/post/dockerfile-entrypoint-vs-cmd/">siguiente artículo</a> se explica muy bien su uso.
</p>

<p style="text-align: justify;">
  Estas dos instrucciones nos permiten especificar el comando que se va a ejecutar por defecto, sino indicamos ninguno cuando ejecutamos el <code>docker run</code>. Normalmente las imágenes bases (debian, ubuntu,&#8230;) están configuradas con estas instrucciones para ejecutar el comando <em>/bin/sh</em> o <em>/bin/bash</em>. Podemos comprobar el comando por defecto que se ha definido en una imagen con el siguiente comando:
</p>

<pre>$ docker inspect debian
...
 "Cmd": [
                "/bin/bash"
            ],
...</pre>

<p style="text-align: justify;">
  Por lo tanto no es necesario indicar el comando como argumento, cuando se inicia un contenedor:
</p>

<pre>$ docker run -i -t  debian</pre>

En el siguiente gráfico puedes ver los detalles de algunas imágenes oficiales: su tamaño, las capas que la conforman y el comando que se define por defecto:

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/image-layers.png" rel="attachment wp-att-1633"><img class="aligncenter size-full wp-image-1633" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/image-layers.png" alt="image-layers" width="478" height="292" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/image-layers.png 478w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/image-layers-300x183.png 300w" sizes="(max-width: 478px) 100vw, 478px" /></a>

**CMD**

CMD tiene tres formatos:

  * Formato de ejecución:

<pre>CMD ["ejecutable", "parámetro1", "parámetro2"]</pre>

  * Modo shell:

<pre>CMD comando parámetro1 parámetro2</pre>

  * Formato para usar junto a la instrucción ENTRYPOINT

<pre>CMD ["parámetro1","parámetro2"]</pre>

<p style="text-align: justify;">
  Solo puede existir una instrucción <em>CMD </em>en un <strong>Dockerfile</strong>, si colocamos más de una, solo la última tendrá efecto.Se debe usar para indicar el comando por defecto que se va a ejecutar al crear el contenedor, pero permitimos que el usuario ejecute otro comando al iniciar el contenedor.
</p>

**ENTRYPOINT**

_ENTRYPOINT_ tiene dos formatos:

  * Formato de ejecución:

<pre>ENTRYPOINT ["ejecutable", "parámetro1", "parámetro2"]</pre>

  * Modo shell:

<pre>ENTRYPOINT comando parámetro1 parámetro2</pre>

<p style="text-align: justify;">
  Esta instrucción también nos permite indicar el comando que se va ejecutar al iniciar el contenedor, pero en este caso el usuario no puede indicar otro comando al iniciar el contenedor. Si usamos esta instrucción no permitimos o no  esperamos que el usuario ejecute otro comando que el especificado. Se puede usar junto a una instrucción<em> CMD</em>, donde se indicará los parámetro por defecto que tendrá el comando indicado en el <em>ENTRYPOINT</em>. Cualquier argumento que pasemos en la línea de comandos mediante <code>docker run</code> serán anexados después de todos los elementos especificados mediante la instrucción <em>ENTRYPOINT</em>, y anulará cualquier elemento especificado con CMD.
</p>

**Ejemplo:**

Si tenemos un fichero **Dockerfile**, que tiene las siguientes instrucciones:

<pre>ENTRYPOINT [“http”, “-v ]”</pre>

<pre>CMD [“-p”, “80”]</pre>

Podemos crear un contenedor a partir de la imagen generada:

<li style="text-align: justify;">
  <code>docker run centos:centos7</code>: Se creará el contenedor con el servidor web escuchando en el puerto 80.
</li>
<li style="text-align: justify;">
  <code>docker run centos:centros7 -p 8080</code>: Se creará el contenedor con el servidor web escuchando en el puerto 8080.
</li>

## Conclusiones

<p style="text-align: justify;">
  En esta entrada hemos estudiado los fundamentos y conceptos necesarios para crear imágenes a partir de fichero <strong>Dockerfile</strong> y el comando <em>docker build</em>. En la próxima entrada vamos a estudiar algunos ejemplos de ficheros <strong>Dockerfile</strong>, y la creación de contenedores a partir de las imágenes que vamos a generar.
</p>

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->