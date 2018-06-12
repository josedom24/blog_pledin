---
id: 1686
title: Enlazando contenedores docker
date: 2016-02-24T20:36:25+00:00


guid: http://www.josedomingo.org/pledin/?p=1686
permalink: /2016/02/enlazando-contenedores-docker/


tags:
  - docker
  - Virtualización
---
<p style="text-align: justify;">
  <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/wordpress-mysql-db-merge-180x180.png" rel="attachment wp-att-1699"><img class="size-full wp-image-1699 aligncenter" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/wordpress-mysql-db-merge-180x180.png" alt="wordpress-mysql-db-merge-180x180" width="180" height="180" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/wordpress-mysql-db-merge-180x180.png 180w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/wordpress-mysql-db-merge-180x180-150x150.png 150w" sizes="(max-width: 180px) 100vw, 180px" /></a>
</p>

<p style="text-align: justify;">
  En los artículos anteriores hemos estudiado como trabajar con imágenes y contenedores docker. En todos los ejemplos que hemos mostrado, los contenedores han trabajado ofreciendo uno o varios servicios, pero no se han comunicado o enlazado con ningún otro. En realidad sería muy deseable trabajar con el paradigma de &#8220;microservicio&#8221; donde cada contenedor ofrezca un servicio que funcione de forma autónoma y aislada del resto, pero que tenga cierta relación con otro contenedor (que ofrezca también un sólo servicio) para que entre todos ofrezcan una infraestructura más o menos compleja. En esta entrada vamos a mostrar un ejemplo de como podemos aislar servicios en distintos contenedores y enlazarlos para que trabajen de forma conjunta.
</p>

<h2 style="text-align: justify;">
  Instalación de wordpress en docker
</h2>

<p style="text-align: justify;">
  Más concretamente vamos a crear un contenedor con un servidor web con wordpress instalado que lo vamos a enlazar con otro contenedor con un servidor de base de datos mysql. Para realizar el ejemplo vamos a utilizar las imágenes oficiales de wordpress y mysql que encontramos en docker hub.
</p>

<pre>$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
wordpress           latest              55f2580b9cc9        5 days ago          516.5 MB
mysql               latest              e13b20a4f248        5 days ago          361.2 MB
debian              latest              256adf7015ca        5 days ago          125.1 MB
ubuntu              14.04               14b59d36bae0        5 days ago          187.9 MB</pre>

<p style="text-align: justify;">
  Docker nos permite un mecanismo de enlace entre contenedores, posibilitando enviar información de forma segura entre ellos y pudiendo compartir información entre ellos, por ejemplo las variables de entorno. Para establecer la asociación entre contenedores es necesario usar el nombre con el que creamos el contenedor, el nombre sirve como punto de referencia para enlazarlo con otros contenedores.
</p>

<p style="text-align: justify;">
  Por lo tanto, lo primero que vamos a hacer es crear un contenedor desde la imagen mysql con el nombre <em>servidor_mysql</em>, siguiendo las instrucción del <a href="https://hub.docker.com/_/mysql/">repositorio</a> de docker hub:
</p>

<pre>$ docker run --name servidor_mysql -e MYSQL_ROOT_PASSWORD=asdasd -d mysql</pre>

<p style="text-align: justify;">
  En este caso sólo hemos indicado la variable de entrono <em>MYSQL_ROOT_PASSWORD</em>, que es obligatoria, indicando la contraseña del usuario root. Si seguimos las instrucciones del <a href="https://hub.docker.com/_/mysql/">repositorio</a> de docker hub podemos observar que podríamos haber creado más variables, por ejemplo:  <em>MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD</em>.
</p>

A continuación vamos a crear un nuevo contenedor, con el nombre _servidor_wp_, con el servidor web a partir de la imagen wordpress, enlazado con el contenedor anterior.

<pre>$ docker run --name servidor_wp -p 80:80 --link servidor_mysql:mysql -d wordpress</pre>

<p style="text-align: justify;">
  Para realizar la asociación entre contenedores hemos utilizado el parámetro <code>--link</code>, donde se indica el nombre del contenedor enlazado y un alias por el que nos podemos referir a él.<!--more-->
</p>

<p style="text-align: justify;">
  Podemos comprobar los contenedores con los que está asociado un determinado contenedor con la siguiente instrucción:
</p>
{% raw %}
<pre>$ docker inspect -f "{{ .HostConfig.Links }}" servidor_wp
 [/servidor_mysql:/servidor_wp/mysql]</pre>
{% endraw %}
<p style="text-align: justify;">
  En esta situación el contenedor <em>servidor_web</em> puede acceder a información del contenedor <em>servidor_mysql</em>, para hacer esto docker construye un túnel seguro entre los contenedores y no es necesario exponer ningún puerto entre ellos (cuando hemos creado el contenedor <em>servidor_mysql</em> no hemos utilizado el parámetro <em>-p</em>), por lo tanto al <em>servidor_mysql</em> no se expone al exterior. Para facilitar la comunicación entre contenedores, docker utiliza las variables de entrono y modifica el fichero<em> /etc/hosts</em>.
</p>

<h3 style="text-align: justify;">
  Variables de entorno en contenedores asociados
</h3>

<p style="text-align: justify;">
  Por cada asociación de contenedores, docker crea una serie de variables de entorno, en este caso, en el contenedor <em>servidor_wp</em>, se crearán las siguientes variables, donde se utiliza el nombre del alias indicada en el parámetro <code>--link</code>:
</p>

<ul style="text-align: justify;">
  <li>
    MYSQL_NAME: Con el nombre del contenedor <em>servidor_mysql.</em>
  </li>
  <li>
    MYSQL_PORT_3306_TCP_ADDR: Por cada puerto que expone la imagen desde la que hemos creado el contenedor se crea una variable de entorno de este tipo. El contenido de esta variable es la dirección IP del contenedor.
  </li>
  <li>
    MYSQL_PORT_3306_TCP_PORT: De la misma manera se crea una por cada puerto expuesto por la imagen, en este caso guardamos el puerto expuesto.
  </li>
  <li>
    MYSQL_PORT_3306_TCP_PROTOCOL: Una vez más se crean tantas variables como puertos hayamos expuesto. En esta variable se guarda el protocolo del puerto.
  </li>
  <li>
    MYSQL_PORT: En esta variable se guarda la url del contenedor, con la ip del mismo y el puerto más bajo expuesto. Por ejemplo <em>MYSQL_PORT=tcp://172.17.0.82:3306.</em>
  </li>
  <li>
    Finalmente por cada variable de entorno definido en el contenedor enlazado, en este caso <em>servidor_mysql</em>, se crea una en el contenedor principal, en este caso <em>servidor_web. </em>Si en el contenedor_mysql hay una variable MYSQL_ROOT_PASSWORD, en el servidor web se creará la variable MYSQL_ENV_MYSQL_ROOT_PASSWORD
  </li>
</ul>

<p style="text-align: justify;">
  Podemos comprobar esto creando un contenedor (que vamos a borrar inmediatamente, opciones <em>-rm</em>) donde vemos las variables de entorno.
</p>

<pre>$ docker run --rm --name web2 --link servidor_mysql:mysql wordpress env
HOSTNAME=728f7e897f07
MYSQL_ENV_MYSQL_ROOT_PASSWORD=asdasd
MYSQL_PORT_3306_TCP_PORT=3306
MYSQL_PORT_3306_TCP=tcp://172.17.0.2:3306
MYSQL_ENV_MYSQL_VERSION=5.7.11-1debian8
MYSQL_NAME=/web2/mysql
MYSQL_PORT_3306_TCP_PROTO=tcp
MYSQL_PORT_3306_TCP_ADDR=172.17.0.2
MYSQL_PORT=tcp://172.17.0.2:3306
...</pre>

<p style="text-align: justify;">
  Por tanto llegamos a la conclusión que toda la información que necesitamos para instalar wordpress (dirección y puerto del servidor de base de datos, contraseña del usuario de la base de datos,&#8230;) lo tenemos a nuestra disposición en variables de entorno. El script bash que ejecutamos por defecto al crear el contenedor desde la imagen wordpress utilizará toda esta información, que tiene en variables de entorno, para crear el fichero de configuración de wordpress: <em>wp-config.php</em>. Además podremos crear nuevas variables a la hora de crear el contenedor como nos informa en la documentación del <a href="https://hub.docker.com/_/wordpress/">repositorio</a> de docker hub:
</p>

  * `-e WORDPRESS_DB_HOST=...` (defaults to the IP and port of the linked `mysql` container)
  * `-e WORDPRESS_DB_USER=...` (defaults to &#8220;root&#8221;)
  * `-e WORDPRESS_DB_PASSWORD=...` (defaults to the value of the `MYSQL_ROOT_PASSWORD` environment variable from the linked `mysql` container)
  * `-e WORDPRESS_DB_NAME=...` (defaults to &#8220;wordpress&#8221;)
  * `-e WORDPRESS_TABLE_PREFIX=...` (defaults to &#8220;&#8221;, only set this when you need to override the default table prefix in wp-config.php)
  * `-e WORDPRESS_AUTH_KEY=...`, `-e WORDPRESS_SECURE_AUTH_KEY=...`, `-e WORDPRESS_LOGGED_IN_KEY=...`, `-e WORDPRESS_NONCE_KEY=...`, `-e WORDPRESS_AUTH_SALT=...`, `-e WORDPRESS_SECURE_AUTH_SALT=...`, `-e WORDPRESS_LOGGED_IN_SALT=...`, `-e WORDPRESS_NONCE_SALT=...` (default to unique random SHA1s)

<h3 style="text-align: justify;">
  Actualizando el fichero /etc/hosts
</h3>

<p style="text-align: justify;">
  Otro mecanismo que se realiza para permitir la comunicación entre contenedores asociados es modificar el fichero <em>/etc/hosts</em> para que tengamos resolución estática entre ellos. Si volvemos a crear un contenedor interactivo que conectemos al contenedor <em>servidor_mysql</em>, podemos comprobarlo:
</p>

<pre>$ docker run --rm -i -t --name web3 --link servidor_mysql:mysql wordpress /bin/bash
root@ccc58b7ab132:/var/www/html# cat /etc/hosts
127.0.0.1 localhost
::1 localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.17.0.2 mysql 11615eb26fc9 servidor_mysql
172.17.0.4 ccc58b7ab132

root@ccc58b7ab132:/var/www/html# ping servidor_mysql
PING mysql (172.17.0.2): 56 data bytes
64 bytes from 172.17.0.2: icmp_seq=0 ttl=64 time=0.106 ms
64 bytes from 172.17.0.2: icmp_seq=1 ttl=64 time=0.067 ms</pre>

## Comprobación de la instalación de wordpress

<p style="text-align: justify;">
  Como hemos visto anteriormente, al crear el contenedor <em>servidor_wp </em>asociado al contenedor <em>servidor_mysql, </em>el script bash que se está ejecutando en la creación es capaz de configurar la conexión a la base de datos con los datos de las variables de entorno que se han creado, además, al modificar su fichero <em>/etc/hosts</em>, es capaz de conectar al contenedor utilizando el nombre del mismo. Al exponer el puerto 80 podemos acceder con un navegador web y comprobar que el wordpress está instalado, solo es necesario la configuración del mismo, aunque no será necesario realizar la configuración de la conexión a la base de datos:
</p>

<p style="text-align: justify;">
  <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/link1.png" rel="attachment wp-att-1696"><img class="aligncenter size-full wp-image-1696" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/link1.png" alt="link1" width="696" height="636" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/link1.png 696w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/link1-300x274.png 300w" sizes="(max-width: 696px) 100vw, 696px" /></a>
</p>

<p style="text-align: justify;">
  <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/ink2.png" rel="attachment wp-att-1697"><img class="aligncenter size-full wp-image-1697" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/ink2.png" alt="ink2" width="986" height="718" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/ink2.png 986w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/ink2-300x218.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/ink2-768x559.png 768w" sizes="(max-width: 986px) 100vw, 986px" /></a>
</p>

<p style="text-align: justify;">
  <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/link3.png" rel="attachment wp-att-1698"><img class="aligncenter size-full wp-image-1698" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/link3.png" alt="link3" width="997" height="540" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/link3.png 997w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/link3-300x162.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/link3-768x416.png 768w" sizes="(max-width: 997px) 100vw, 997px" /></a>
</p>

<h2 style="text-align: justify;">
  Conclusiones
</h2>

<p style="text-align: justify;">
  He escrito varios artículos sobre docker, donde he intentado hacer una introducción y ofrecer una visión general de lo que nos puede ofrecer el trabajo con contenedores docker. Como decía en el <a href="http://www.josedomingo.org/pledin/2015/12/introduccion-a-docker/">primer artículo</a>, el objetivo de estas entradas ha sido, desde el primer momento, obligarme a tener la experiencia de conocer los distintos conceptos referidos a docker sobre todo centrado en mostrarles a mis alumnos del módulo de &#8220;Implantación de aplicaciones web&#8221; del Ciclo Formativo de Grado Superior <strong>&#8220;Administración de Sistemas Informáticos y Redes&#8221;</strong> las grandes posibilidades que nos ofrece esta herramienta para la implantación de aplicaciones web. Podría seguir escribiendo más entradas sobre docker, me queda por introducir, las redes, los volúmenes, herramientas especificas como<em> docker machine, docker compose, docker swarm</em>, y seguro que me dejo atrás muchas más cosas, pero me voy a tomar un descanso, y más adelante veré la posibilidad de seguir escribiendo. También tendría que estudiar las posibilidades de orquestación de contenedores, que como nos ofrece docker swarm también nos ofrece <em>Kubernetes</em> de google.
</p>

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->