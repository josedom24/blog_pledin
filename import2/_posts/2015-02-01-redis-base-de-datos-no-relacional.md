---
layout: post
status: publish
published: true
title: Redis, base de datos no relacional
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1228
wordpress_url: http://www.josedomingo.org/pledin/?p=1228
date: '2015-02-01 21:04:17 +0000'
date_gmt: '2015-02-01 20:04:17 +0000'
categories:
- General
tags:
- Base de datos
- Redis
comments: []
---
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2015/01/redis-300dpi.png"><img class="aligncenter wp-image-1230 size-medium" src="http://www.josedomingo.org/pledin/wp-content/uploads/2015/01/redis-300dpi-300x100.png" alt="redis-300dpi" width="300" height="100" /></a>Redis es una base de datos no relacional, que guarda la informaci&oacute;n en conjuntos clave-valor. La informaci&oacute;n es guardada en memoria, aunque se puede escribir en disco para conseguir la persistencia. Los valores que se pueden guardar corresponden a cinco estructuras de datos: cadenas, listas, conjuntos, conjuntos ordenados y tablas hash. Est&aacute; liberado bajo licencia BSD por lo que es considerado software de c&oacute;digo abierto.</p>
<h2>Instalaci&oacute;n de Redis en Linux Debian</h2>
<p>La versi&oacute;n estable en la actualidad (Febrero de 2015) que podemos <a href="http://redis.io/download">descargar de la p&aacute;gina oficial de redis</a> es la 2.8.19. En la actual versi&oacute;n estable de Debian (Wheezy) podemos instalar desde los repositorios oficiales el paquete <em>redis-server </em>que nos ofrece la versi&oacute;n 2.4.14. Si instalamos dicho paquetes tendremos a nuestra disposici&oacute;n tanto el servidor como la aplicaci&oacute;n cliente: <em>redis-cli.</em></p>
<p>Nosotros vamos a realizar la instalaci&oacute;n del servidor redis en la versi&oacute;n testing de debian (Jessie) que nos ofrece la versi&oacute;n 2.8.17:</p>
<pre>apt-get install redis-server redis-tools</pre>
<p>En est&eacute; caso el cliente <em>redis-cli</em> lo obtenemos instalando el paquete <em>redis-tools</em>.</p>
<p><!--more--></p>
<h2>Configuraci&oacute;n y acceso al servidor Redis</h2>
<p>La configuraci&oacute;n por defecto del servidor s&oacute;lo acepta conexiones desde <em>localhost </em>al puerto 6379. A esa direcci&oacute;n y a ese puerto se conecta de&nbsp; forma predeterminada el cliente <em>redis-cli</em>.</p>
<p>Si instalamos el servidor y el cliente en m&aacute;quinas distintas, tendremos que configurar el servidor para que permita la conexi&oacute;n desde el otro equipo (indicamos en la directiva <em>bind</em> la ip de la interfaz por la que va a esperar conexiones) y tendremos que indicar a que direcci&oacute;n nos conectamos desde el cliente. Otra opci&oacute;n que vamos a configurar en el servidor es establecer una contrase&ntilde;a que tendremos que indicar del cliente para poder trabajar.</p>
<p>En el servidor modificamos en el fichero <em>/etc/redis/redis.conf</em>:</p>
<pre>bind 192.168.0.199
requirepass una_password</pre>
<p>Reiniciamos el servicio:</p>
<pre># service redis-server restart</pre>
<p>Desde el ordenador cliente nos conectamos con <em>redis-cli</em>:</p>
<pre>$ redis-cli -h 192.168.0.199
192.168.0.199:6379> AUTH una_password
OK
192.168.0.199:6379></pre>
<h2>Bases de datos</h2>
<p>En Redis, las bases de datos est&aacute;n identificadas simplemente con un n&uacute;mero, siendo la base de datos por defecto el n&uacute;mero 0. Si quieres cambiar a otra base de datos puedes hacerlo a trav&eacute;s del comando <code>select</code>.</p>
<pre>192.168.0.199:6379> SELECT 1
OK
192.168.0.199:6379[1]> SELECT 2
OK
192.168.0.199:6379[2]> SELECT 0
OK
192.168.0.199:6379></pre>
<h2>Estructuras de datos que podemos guardar en Redis</h2>
<p>Como hemos dicho anteriormente la informaci&oacute;n se guarda en Redis como conjunto clave-valor. Las claves son lo que vamos a utilizar para identificar conjuntos de datos. Una clave puede estar definida por una sola palabra, pero normalmente tiene un aspecto similar a <code>usuario:pepe</code>, en este ejemplo, podr&iacute;amos guardar informaci&oacute;n sobre un usuario llamado "pepe". Los valores representan los datos que se encuentran relacionados con la clave. Pueden ser cualquier cosa. A veces almacenar&aacute;s cadenas de texto, a veces n&uacute;meros enteros, a veces almacenar&aacute;s objetos serializados (como JSON, XML, o cualquier otro formato). Vamos a estudiar las distintas estructuras de datos con las que podemos guardar la informaci&oacute;n:</p>
<h3>Cadenas de texto</h3>
<p>Las cadenas de caracteres son las forma m&aacute;s simple que tenemos para guardar informaci&oacute;n en redis. Algunos de los comandos que podemos utilizar ser&iacute;an:</p>
<ul>
<li>SET: Guarda un valor en una clave</li>
<li>GET: Obtiene el valor de una clave dada.</li>
<li>DEL: Borra una clave y su valor</li>
<li>INCR: Incrementa automaticamente una clave</li>
<li>INCRBY: Incrementa el valor de una clave hasta un valor designado</li>
<li>EXPIRE: Indica el tiempo (expresado en segundos en que una clave y su valor existir&aacute;n.</li>
</ul>
<p>Ejemplo:</p>
<pre>192.168.0.199:6379> SET usuario:pepe "pepe garcia"
OK
192.168.0.199:6379> GET usuario:pepe
"pepe garcia"
192.168.0.199:6379> SET contador 1
OK
192.168.0.199:6379> INCR contador
(integer) 2
192.168.0.199:6379> INCRBY contador 5
(integer) 7

</pre>
<h3>Conjuntos</h3>
<p>Los conjuntos se emplean para almacenar valores &uacute;nicos y facilitan un n&uacute;mero de operaciones &uacute;tiles para tratar con ellos, como las uniones. Los conjuntos no mantienen orden pero brindan operaciones eficientes bas&aacute;ndose en los valores. Veamos algunos comandos:</p>
<ul>
<li>SADD: A&ntilde;ade un nuevo valor al conjunto</li>
<li>SMEMBERS: Devuelve todos los valores del conjunto</li>
<li>SINTER: Calcula la intersecci&oacute;n de varios conjuntos</li>
<li>SISMEMBER: Comprueba si un valor pertenece a un conjunto</li>
<li>SRANDMEMBER:Devuelve un valor aleatorio del conjunto</li>
</ul>
<p>Ejemplo:</p>
<pre>192.168.0.199:6379> SADD colors:id1 red
(integer) 1
192.168.0.199:6379> SADD colors:id1 orange yellow
(integer) 2
192.168.0.199:6379> SMEMBERS colors:id1
1) "red"
2) "yellow"
3) "orange"
192.168.0.199:6379> SISMEMBER colors:id1 yellow
(integer) 1
192.168.0.199:6379> SRANDMEMBER colors:id1
"orange"</pre>
<h3>Conjuntos ordenados</h3>
<p>En este caso tenemos un conjunto donde podemos indicar para cada valor una puntuaci&oacute;n que nos permite su ordenaci&oacute;n. Algunas de la operaciones que podemos realizar con los conjuntos ordenados son:</p>
<ul>
<li>ZADD: A&ntilde;ade valores a un conjunto ordenado</li>
<li>ZRANGE: Muestra los valores ordenados seg&uacute;n el &iacute;ndice de menor a mayor.</li>
<li>ZREVRANGE: Muestra los valores ordenados seg&uacute;n el &iacute;ndice de mayor a menor.</li>
<li>ZCOUNT: devuelve los valores cuya puntuaci&oacute;n est&aacute; comprendida en el rango dado.</li>
<li>ZREM: Elimina valores de un conjunto ordenado.</li>
</ul>
<p>Ejemplo:</p>
<pre>192.168.0.199:6379> ZADD amigos:jose 70 maria 80 pepe 90 manolo 1 julia
(integer) 4
192.168.0.199:6379> ZCOUNT amigos:jose 80 100
(integer) 2
192.168.0.199:6379> ZRANGE amigos:jose 0 -1
1) "julia"
2) "maria"
3) "pepe"
4) "manolo"</pre>
<h3>Listas</h3>
<p>Las listas permiten almacenar y manipular un conjunto de valores dada una clave concreta. Puedes a&ntilde;adir valores a la lista, recuperar el primer o el &uacute;ltimo valor y manipular valores de una posici&oacute;n concreta. Las listas mantienen un orden y son eficientes al realizar operaciones basadas en su &iacute;ndice. Algunas de la operaciones que podemos ejecutar sobre las listas son:</p>
<ul>
<li>LPUSH: A&ntilde;ade un valor al comienzo de la lista</li>
<li>RPUSH: A&ntilde;ade un valor al final de la lista</li>
<li>LPOP: Devuelve y elimina el primer elemento de la lista</li>
<li>RPOP: Devuelve y elimina el &uacute;ltimo valor de la lista</li>
<li>LREM: Borra valores de la lista</li>
<li>LRANGE: Devuelve un rango de valores de la lista</li>
<li>LTRIM: Modifica una lista dejando s&oacute;lo un rango de valores en ella.</li>
</ul>
<p>Ejemplo:</p>
<pre>192.168.0.199:6379> LPUSH localidad:sevilla Utrera "Dos Hermanas"
(integer) 2
192.168.0.199:6379> RPUSH localidad:sevilla "Brenes"
(integer) 3
192.168.0.199:6379> RPUSH localidad:sevilla "El Arahal"
(integer) 4
192.168.0.199:6379> LPOP localidad:sevilla
"Dos Hermanas"
192.168.0.199:6379> RPOP localidad:sevilla
"El Arahal"
192.168.0.199:6379> LRANGE localidad:sevilla 0 -1
1) "Utrera"
2) "Brenes"</pre>
<h3>Hashes</h3>
<p>Con esta estructura de datos podemos guardar informaci&oacute;n clasific&aacute;ndola en campos. Algunas de las operaciones que podemos realizar son:</p>
<ul>
<li>HMSET: A&ntilde;ade varios campos a una clave</li>
<li>HSET: A&ntilde;ade un nuevo campo a una clave</li>
<li>HGET: devuelve el valor de un campo determinado.</li>
<li>HMGET: Devuelve el valor de todos los campos</li>
<li>HGETALL: Devuelve todos los campos de una clave</li>
</ul>
<p>Ejemplo:</p>
<pre>192.168.0.199:6379> HMSET usuario:1 nombre jose password asdasd email jose@gmailOKom
192.168.0.199:6379> HGETALL usuario:1
1) "nombre"
2) "jose"
3) "password"
4) "asdasd"
5) "email"
6) "jose@gmail.com"
192.168.0.199:6379> HMGET usuario:1 nombre email
1) "jose"
2) "jose@gmail.com"</pre>
<p>&nbsp;</p>
<p>Esto ha sido una simple introducci&oacute;n a esta herramienta, si quieres profundizar en el estudio de Redis puedes leer el libro <a href="http://raulexposito.com/documentos/redis/"><i>The Little Redis Book'</i> en espa&ntilde;ol</a>, donde encontrar&aacute;s una informaci&oacute;n mucho m&aacute;s detallada de esta base de datos.</p>
