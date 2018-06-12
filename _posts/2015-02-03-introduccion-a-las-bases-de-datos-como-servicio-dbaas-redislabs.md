---
id: 1244
title: Introducción a las bases de datos como servicio (DBaaS). RedisLabs.
date: 2015-02-03T20:32:06+00:00


guid: http://www.josedomingo.org/pledin/?p=1244
permalink: /2015/02/introduccion-a-las-bases-de-datos-como-servicio-dbaas-redislabs/


tags:
  - Base de datos
  - Cloud Computing
  - DBaaS
  - Redis
---
![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/02/índice.png)

Entendiendo las bases de datos como una aplicación más cualquiera, y extendiendo el concepto de SaaS (software como servicio), se puede entender las DBaaS como una nueva manera de acceder al uso de una base de datos, respondiendo a los principios del cloud computing:

* Vamos a tener disponible nuestro servicio, en nuestro caso, una base de datos, de forma automática y bajo demanda, es decir sin que ningún operador de la empresa que ofrece el servicio tenga que realizar ninguna operación para que el cliente obtenga el servicio.
* La base de datos debe ser accesible desde internet.
* Se puede ofrecer el servicio usando el modelo de recurso compartido, donde varios usuarios pueden estar compartiendo recursos, por lo tanto es necesario garantizar el aislamiento y la seguridad entre usuarios.
* Elasticidad, que es la propiedad que me permite aumentar o disminuir la capacidad de mi recurso, mi base de datos, de forma automática y en cualquier momento.
* El pago por uso.

Evidentemente a ser la base de datos un software, es necesario combinar los DBaaS con un PaaS o un IaaS para conseguir una infraestructura totalmente operativa. Los DBaaS ofrecen tanto bases de datos relacionales (MySql, PostgreSQL,..), como base de datos no relacionales o noSQL cómo Redis, CouchDB o MongoDB. Como ejemplo de empresas que ofrecen estos servicios tenemos [Amazon, que ofrece Amazon DynamoDB](http://aws.amazon.com/es/dynamodb/?nc2=h_l3_db) o [ClearDB que ofrece un servicio MySQL](https://www.cleardb.com/home.view).

## RedisLabs: Redis como DBaaS

Como vimos en el [artículo anterior](http://www.josedomingo.org/pledin/2015/02/redis-base-de-datos-no-relacional/ "Redis, base de datos no relacional"), Redis es una base de datos no relacional, que guarda la información en conjuntos clave-valor. La empresa [RedisLabs](https://redislabs.com/) nos ofrece Redis como DBaaS. Nos podemos dar de alta en la página y podemos obtener de forma gratuita a una instancia con una base de datos Redis con una limitación de 25 Mb de memoria y 10 conexiones simultaneas. Para empezar a trabajar con esta infraestructura es suficiente, si necesitamos más recursos podemos obtenerlos por una [cuota mensual](https://redislabs.com/pricing). Tras darte de alta en la página, puedes dar de alta una nueva base de datos con el plan gratuito, y puedes obtener el servicio de una nueva base de datos, como observamos en la siguiente imagen:

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/02/redis.png)

En el parámetro `Endpoint` obtenemos la dirección de la instancia y el puerto al que nos tenemos que conectar. Además hemos configurado una contraseña para el acceso a nuestra base de datos, la puedes ver en el parámetro `Redis Password`  Usando por lo tanto un cliente de redis, podemos realizar la conexión a la base de datos y empezar a trabajar con ella:

    # redis-cli -h pub-redis-99999.us-east-1-3.3.ec2.garantiadata.com -p 12345
    pub-redis-99999.us-east-1-3.3.ec2.garantiadata.com:12345> AUTH la_contraseña
    OK
    pub-redis-99999.us-east-1-3.3.ec2.garantiadata.com:12345> SET usuario pepe
    OK
    pub-redis-99999.us-east-1-3.3.ec2.garantiadata.com:12345> GET usuario
    "pepe"

Como siempre esto es sólo una introducción sobre DBaaS, si quieres seguir formándote sobre el tema, te recomiendo leer el artículo [Dbaas, Database as a Service, una introducción usando Redis](http://jj.github.io/dbaas/) de [J.J. Merelo](https://github.com/JJ).

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->