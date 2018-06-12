---
id: 1228
title: Redis, base de datos no relacional
date: 2015-02-01T21:04:17+00:00


guid: http://www.josedomingo.org/pledin/?p=1228
permalink: /2015/02/redis-base-de-datos-no-relacional/


tags:
  - Base de datos
  - Redis
---
![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/01/redis-300dpi.png)

Redis es una base de datos no relacional, que guarda la información en conjuntos clave-valor. La información es guardada en memoria, aunque se puede escribir en disco para conseguir la persistencia. Los valores que se pueden guardar corresponden a cinco estructuras de datos: cadenas, listas, conjuntos, conjuntos ordenados y tablas hash. Está liberado bajo licencia BSD por lo que es considerado software de código abierto.

## Instalación de Redis en Linux Debian

La versión estable en la actualidad (Febrero de 2015) que podemos [descargar de la página oficial de redis](http://redis.io/download) es la 2.8.19. En la actual versión estable de Debian (Wheezy) podemos instalar desde los repositorios oficiales el paquete `redis-server` que nos ofrece la versión 2.4.14. Si instalamos dicho paquetes tendremos a nuestra disposición tanto el servidor como la aplicación cliente: `redis-cli`.

Nosotros vamos a realizar la instalación del servidor redis en la versión testing de debian (Jessie) que nos ofrece la versión 2.8.17:

    # apt-get install redis-server redis-tools

En esté caso el cliente `redis-cli` lo obtenemos instalando el paquete `redis-tools`.

## Configuración y acceso al servidor Redis

La configuración por defecto del servidor sólo acepta conexiones desde `localhost` al puerto 6379. A esa dirección y a ese puerto se conecta de  forma predeterminada el cliente `redis-cli`.

Si instalamos el servidor y el cliente en máquinas distintas, tendremos que configurar el servidor para que permita la conexión desde el otro equipo (indicamos en la directiva `bind` la ip de la interfaz por la que va a esperar conexiones) y tendremos que indicar a que dirección nos conectamos desde el cliente. Otra opción que vamos a configurar en el servidor es establecer una contraseña que tendremos que indicar del cliente para poder trabajar.

En el servidor modificamos en el fichero `/etc/redis/redis.conf`:

    bind 192.168.0.199
    requirepass una_password

Reiniciamos el servicio:

    # service redis-server restart

Desde el ordenador cliente nos conectamos con `redis-cli`:

    $ redis-cli -h 192.168.0.199
    192.168.0.199:6379> AUTH una_password
    OK
    192.168.0.199:6379>

## Bases de datos

En Redis, las bases de datos están identificadas simplemente con un número, siendo la base de datos por defecto el número 0. Si quieres cambiar a otra base de datos puedes hacerlo a través del comando `select`.

    192.168.0.199:6379> SELECT 1
    OK
    192.168.0.199:6379[1]> SELECT 2
    OK
    192.168.0.199:6379[2]> SELECT 0
    OK
    192.168.0.199:6379>

## Estructuras de datos que podemos guardar en Redis

Como hemos dicho anteriormente la información se guarda en Redis como conjunto clave-valor. Las claves son lo que vamos a utilizar para identificar conjuntos de datos. Una clave puede estar definida por una sola palabra, pero normalmente tiene un aspecto similar a `usuario:pepe`, en este ejemplo, podríamos guardar información sobre un usuario llamado "pepe". Los valores representan los datos que se encuentran relacionados con la clave. Pueden ser cualquier cosa. A veces almacenarás cadenas de texto, a veces números enteros, a veces almacenarás objetos serializados (como JSON, XML, o cualquier otro formato). Vamos a estudiar las distintas estructuras de datos con las que podemos guardar la información:

### Cadenas de texto

Las cadenas de caracteres son las forma más simple que tenemos para guardar información en redis. Algunos de los comandos que podemos utilizar serían:

* SET: Guarda un valor en una clave
* GET: Obtiene el valor de una clave dada.
* DEL: Borra una clave y su valor
* INCR: Incrementa automáticamente una clave
* INCRBY: Incrementa el valor de una clave hasta un valor designado
* EXPIRE: Indica el tiempo (expresado en segundos en que una clave y su valor existirán.

Ejemplo:

    192.168.0.199:6379> SET usuario:pepe "pepe garcia"
    OK
    192.168.0.199:6379> GET usuario:pepe
    "pepe garcia"
    192.168.0.199:6379> SET contador 1
    OK
    192.168.0.199:6379> INCR contador
    (integer) 2
    192.168.0.199:6379> INCRBY contador 5
    (integer) 7

### Conjuntos

Los conjuntos se emplean para almacenar valores únicos y facilitan un número de operaciones útiles para tratar con ellos, como las uniones. Los conjuntos no mantienen orden pero brindan operaciones eficientes basándose en los valores. Veamos algunos comandos:

* SADD: Añade un nuevo valor al conjunto
* SMEMBERS: Devuelve todos los valores del conjunto
* SINTER: Calcula la intersección de varios conjuntos
* SISMEMBER: Comprueba si un valor pertenece a un conjunto
* SRANDMEMBER:Devuelve un valor aleatorio del conjunto

Ejemplo:

    192.168.0.199:6379> SADD colors:id1 red
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
    "orange"

### Conjuntos ordenados

En este caso tenemos un conjunto donde podemos indicar para cada valor una puntuación que nos permite su ordenación. Algunas de la operaciones que podemos realizar con los conjuntos ordenados son:

* ZADD: Añade valores a un conjunto ordenado
* ZRANGE: Muestra los valores ordenados según el índice de menor a mayor.
* ZREVRANGE: Muestra los valores ordenados según el índice de mayor a menor.
* ZCOUNT: devuelve los valores cuya puntuación está comprendida en el rango dado.
* ZREM: Elimina valores de un conjunto ordenado.

Ejemplo:

    192.168.0.199:6379> ZADD amigos:jose 70 maria 80 pepe 90 manolo 1 julia
    (integer) 4
    192.168.0.199:6379> ZCOUNT amigos:jose 80 100
    (integer) 2
    192.168.0.199:6379> ZRANGE amigos:jose 0 -1
    1) "julia"
    2) "maria"
    3) "pepe"
    4) "manolo"

### Listas

Las listas permiten almacenar y manipular un conjunto de valores dada una clave concreta. Puedes añadir valores a la lista, recuperar el primer o el último valor y manipular valores de una posición concreta. Las listas mantienen un orden y son eficientes al realizar operaciones basadas en su índice. Algunas de la operaciones que podemos ejecutar sobre las listas son:

* LPUSH: Añade un valor al comienzo de la lista
* RPUSH: Añade un valor al final de la lista
* LPOP: Devuelve y elimina el primer elemento de la lista
* RPOP: Devuelve y elimina el último valor de la lista
* LREM: Borra valores de la lista
* LRANGE: Devuelve un rango de valores de la lista
* LTRIM: Modifica una lista dejando sólo un rango de valores en ella.

Ejemplo:

    192.168.0.199:6379> LPUSH localidad:sevilla Utrera "Dos Hermanas"
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
    2) "Brenes"

### Hashes

Con esta estructura de datos podemos guardar información clasificándola en campos. Algunas de las operaciones que podemos realizar son:

* HMSET: Añade varios campos a una clave
* HSET: Añade un nuevo campo a una clave
* HGET: devuelve el valor de un campo determinado.
* HMGET: Devuelve el valor de todos los campos
* HGETALL: Devuelve todos los campos de una clave

Ejemplo:

    192.168.0.199:6379> HMSET usuario:1 nombre jose password asdasd email jose@gmailOKom
    192.168.0.199:6379> HGETALL usuario:1
    1) "nombre"
    2) "jose"
    3) "password"
    4) "asdasd"
    5) "email"
    6) "jose@gmail.com"
    192.168.0.199:6379> HMGET usuario:1 nombre email
    1) "jose"
    2) "jose@gmail.com"

Esto ha sido una simple introducción a esta herramienta, si quieres profundizar en el estudio de Redis puedes leer el libro [_The Little Redis Book&#8217;_ en español](http://raulexposito.com/documentos/redis/), donde encontrarás una información mucho más detallada de esta base de datos.
