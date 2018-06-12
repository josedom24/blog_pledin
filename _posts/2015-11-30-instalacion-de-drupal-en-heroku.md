---
id: 1388
title: Instalación de drupal en heroku
date: 2015-11-30T21:33:48+00:00


guid: http://www.josedomingo.org/pledin/?p=1388
permalink: /2015/11/instalacion-de-drupal-en-heroku/


tags:
  - Cloud Computing
  - CMS
  - drupal
  - Heroku
  - PaaS
  - php
---
<p style="text-align: center;">
  <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/intro.png"><img class="aligncenter size-full wp-image-1389" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/intro.png" alt="intro" width="789" height="231" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/intro.png 789w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/intro-300x88.png 300w" sizes="(max-width: 789px) 100vw, 789px" /></a>


<a href="https://www.heroku.com/">Heroku</a> es una aplicación que nos ofrece un servicio de Cloud Computing <a href="https://en.wikipedia.org/wiki/Platform_as_a_service">PaaS</a> (Plataforma como servicio). Como leemos en la <a href="https://es.wikipedia.org/wiki/Heroku">Wikipedia</a> es propiedad de <a href="http://www.salesforce.com">Salesforce.com</a> y es una de las primeras plataformas de computación en la nube, que fue desarrollada desde junio de 2007, con el objetivo de soportar solamente el lenguaje de programación Ruby, pero posteriormente se ha extendido el soporte a Java, Node.js, Scala, Clojure y Python y PHP.

## Características de heroku

La funcionalidad ofrecida por heroku esta disponible con el uso de <em><strong>dynos</strong></em>, que son una adaptación de los contenedores Linux y nos ofrecen la capacidad de computo dentro de la plataforma.

Cada dyno ejecuta distintos procesos, por ejemplo ejecuta los servidores web y los servidores de bases de datos, o cualquier otro proceso que le indiquemos en un fichero <a href="https://devcenter.heroku.com/articles/deploying-php#the-procfile"><em>Procfile</em></a>. Las características principales de los dynos son:


<li style="text-align: justify;">
  <strong>Escabilidad</strong>: Si, por ejemplo, tenemos muchas peticiones a nuestra aplicación podemos hacer un escalado horizontal, es decir, podemos crear más dynos que respondan las peticiones. La carga de peticiones se balanceará entre los dynos existentes. Además podemos hacer una escalabilidad vertical, en este caso lo que hacemos es cambiar las características hardware de nuestro dyno, por ejemplo aumentar la cantidad de RAM. Las características de escabilidad no están activadas en el plan gratuito de heroku. Además la escabilidad no es automática, hay que realizarla manualmente.
</li>
<li style="text-align: justify;">
  <strong>Redundancia</strong>: En el momento en que podemos tener varios dynos detrás de una balanceado de carga, nuestra aplicación es redundante. Es decir, si algún dyno tiene un problema, los demás responderían las peticiones.
</li>
<li style="text-align: justify;">
  <strong>Aislamiento y seguridad</strong>: Cada uno de los dynos está aislado de los demás. Esto nos ofrece seguridad frente a la ejecución de procesos en otros dynos, además también nos ofrece protección para que ningún dyno consuma todos los recursos de la máquina.
</li>
<li style="text-align: justify;">
  <strong>Sistema de archivo efímero</strong>: Cada dyno posee un sistema de archivo cuya principal característica es que es efímero. Es decir los datos de nuestra aplicación (por ejemplo ficheros subidos) no son accesibles desde otros dynos, y si reiniciamos el dyno estos datos se pierden. Es muy recomendable tener los datos de la aplicación en un sistema externo, por ejemplo un almacén de objetos, como Amanzon S3 o OpenStack Swift.
</li>
<li style="text-align: justify;">
  <strong>Direccionamiento IP</strong>: Cuando tenemos varios dynos, cada uno de ellos puede estar ejecutándose en máquinas diferentes. El acceso a nuestra aplicación siempre se hace desde un balanceador de carga (<a href="https://devcenter.heroku.com/articles/http-routing">routers</a>). Esto significa que los dynos no tienen una ip estática, y el acceso a ellos siempre se hace a la dirección IP que tiene el balanceador. Cuando se reinicia un dyno se puede ejecutar en otra máquina, y por lo tanto puede cambiar de dirección IP.
</li>
<li style="text-align: justify;">
  <strong>Interfaces de red</strong>: Cada dyno tiene una interfaz de red con un direccionamiento privado /30, en el rango 172.16.0.0/12. Por lo tanto cada dyno está conecta a una red independiente que no comparte con ningún otro dyno. Para acceder a él, como hemos indicado anteriormente, habrá que hacerlo a través de la ip pública que tiene asignada el balanceador de carga.
</li>

## Despliegue de la aplicación web drupal en Heroku

En este ejemplo vamos a utilizar la capa gratuita que nos ofrece Heroku, que tiene las siguientes características:


<ul style="text-align: justify;">
  <li>
    Podemos crear un dyno, que puede ejecutar un máximo de dos tipos de procesos. Para más información sobre la ejecución de los procesos ver: <a href="https://devcenter.heroku.com/articles/process-model">https://devcenter.heroku.com/articles/process-model</a>.
  </li>
  <li>
    Nuestro dyno utiliza 512 Mb de RAM
  </li>
  <li>
    Tras 30 minutos de inactividad el dyno se para (sleep), además debe estar parado 6 horas cada 24 horas.
  </li>
  <li>
    Podemos utilizar una base de datos postgreSQL con no más de 10.000 registros
  </li>
  <li>
    Para más información de los planes ofrecido por heroku puedes visitar: <a href="https://www.heroku.com/pricing#dynos-table-modal">https://www.heroku.com/pricing#dynos-table-modal</a>
  </li>
</ul>

Para ampliar la funcionalidad de nuestra aplicación podemos añadir a nuestro dyno distintos <a href="https://elements.heroku.com/addons">add-ons</a>. Algunos lo podemos usar de forma gratuita y otros son de pago. El add-ons de mysql (ClearDB mysql) no lo podemos usar en el plan gratuito, por lo que vamos a usar una base de datos postgreSQL.

Siguiendo las<a href="https://www.drupal.org/documentation/install"> instrucciones de instalación</a> de la página oficial hemos instalado la última versión del CMS drupal en un servidor local, hemos utilizado como base de datos un servidor postgreSQL (<strong>Recordatorio:</strong> es necesario instalar el paquete <em>php5-pgsql</em> que es la libreria PHP de postgreSQL). Como hemos indicado anteriormente heroku nos ofrece una infraestructura para desplegar nuestra aplicación web cuyo sistema de archivo es efímero, por lo tanto no podemos realizar la instalación de las aplicaciones web directamente en heroku, ya que cada vez que reiniciemos nuestro dyno perderemos los ficheros creados, por ejemplo el fichero de configuración. Vamos a hacer una migración desde el entorno de pruebas (servidor local) a nuestro entorno de producción (dyno de herku).

###  Instalación de Heroku CLI

Como podemos ver en esta <a href="https://toolbelt.heroku.com/">página</a>, tenemos que ejecutar un script bash que nos bajamos con la siguiente instrucción y que realizará la instalación de los paquetes necesarios y la configuración inicial.

    wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh

Ahora tenemos que iniciar sesión en heroku, utilizando el correo electrónico y la contraseña que hemos indicado durante el registro de la cuenta. La primera vez que ejecutamos la siguiente instrucción, se termina de configurar el cliente heroku:

    # heroku login
    heroku-cli: Installing Toolbelt v4... done.
    For more information on Toolbelt v4: https://github.com/heroku/heroku-cli
    heroku-cli: Adding dependencies... done
    heroku-cli: Installing core plugins... done
    Enter your Heroku credentials.
    Email: tucorreo@electronico.com
    Password (typing will be hidden):

Para ver la versión del cliente que estamos utilizando, además salen los plugins instalados:

    # heroku version
    heroku-toolbelt/3.42.22 (x86_64-linux-gnu) ruby/2.1.5
    heroku-cli/4.27.6-e59743f (amd64-linux) go1.5.1

Para pedir información de las funciones disponibles podemos pedir la ayuda:

    # heroku help

### Subir nuestra clave pública para acceder a nuestro dyno

Siguiendo la [documentación oficial](https://devcenter.heroku.com/articles/keys), es necesario subir una clave pública para permitir el acceso por SSH a nuestro dyno:

    # heroku keys:add
    Found existing public key: ~/.ssh/id_rsa.pub
    Uploading SSH public key /Users/adam/.ssh/id_rsa.pub... done

### Creación de nuestra primera aplicación

Para crear nuestra primera aplicación (dyno) ejecutamos la siguiente instrucción:

    # heroku apps:create pledinjd
    Creating pledinjd... done, stack is cedar-14
    https://pledinjd.herokuapp.com/ | https://git.heroku.com/pledinjd.git

Se ha creado un nuevo dyno con un repositorio git, que a continuación vamos a clonar. Además se ha generado un FQHN que nos permite acceder a nuestra aplicación:

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/drupal1.png"><img class="size-full wp-image-1398 alignnone" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/drupal1.png" alt="drupal1" width="577" height="250" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/drupal1.png 577w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/drupal1-300x130.png 300w" sizes="(max-width: 577px) 100vw, 577px" /></a>

A continuación vamos a clonar el repositorio y vamos a desplegar un fichero index.php de inicio:

    # git clone https://git.heroku.com/pledinjd.git
    Cloning into 'pledinjd'...
    warning: You appear to have cloned an empty repository.
    Checking connectivity... done.
    # cd pledinjd/
    pledinjd# echo "<h1>pledinjd funcionando</h1>">index.php
    pledinjd# git add index.php 
    pledinjd# git commit -m "El primer fichero"
    pledinjd# git push origin master
    Counting objects: 3, done.
    Writing objects: 100% (3/3), 245 bytes | 0 bytes/s, done.
    Total 3 (delta 0), reused 0 (delta 0)
    remote: Compressing source files... done.
    remote: Building source:
    remote: 
    remote: -----> PHP app detected
    remote: 
    remote: ! WARNING: No 'composer.json' found.
    remote: Using 'index.php' to declare PHP applications is considered legacy
    remote: functionality and may lead to unexpected behavior.
    remote: 
    remote: -----> No runtime required in 'composer.json', defaulting to PHP 5.6.15.
    remote: -----> Installing system packages...
    remote: - PHP 5.6.15
    remote: - Apache 2.4.16
    remote: - Nginx 1.8.0
    remote: -----> Installing PHP extensions...
    remote: - zend-opcache (automatic; bundled)
    remote: -----> Installing dependencies...
    remote: Composer version 1.0.0-alpha11 2015-11-14 16:21:07
    remote: -----> Preparing runtime environment...
    remote: NOTICE: No Procfile, using 'web: vendor/bin/heroku-php-apache2'.
    remote: -----> Discovering process types
    remote: Procfile declares types -> web
    remote: 
    remote: -----> Compressing... done, 72.8MB
    remote: -----> Launching... done, v3
    remote: https://pledinjd.herokuapp.com/ deployed to Heroku
    remote: 
    remote: Verifying deploy... done.
    To https://git.heroku.com/pledinjd.git
     * [new branch] master -> master

Como se puede observar cuando se sube un nuevo fichero, se configura de forma adecuada el entorno de producción, reiniciando los servidores necesarios, y podemos acceder a nuestra nueva página:

[<img class="size-full wp-image-1400 alignnone" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/drupal2.png" alt="drupal2" width="452" height="138" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/drupal2.png 452w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/drupal2-300x92.png 300w" sizes="(max-width: 452px) 100vw, 452px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/drupal2.png){.thumbnail}

### Migración de la base de datos

A continuación, vamos a instalar un addons en nuestro proyecto que nos proporciona una base de datos postgreSQL:

    # heroku addons:create heroku-postgresql
    Creating postgresql-amorphous-6708... done, (free)
    Adding postgresql-amorphous-6708 to pledinjd... done
    Setting DATABASE_URL and restarting pledinjd... done, v4
    Database has been created and is available
     ! This database is empty. If upgrading, you can transfer
     ! data from another database with pg:copy
    Use `heroku addons:docs heroku-postgresql` to view documentation.

Para ver información de los addons instalados:

    # heroku addons
    Add-on                                         Plan       Price
    ─────────────────────────────────────────────  ─────────  ─────
    heroku-postgresql (postgresql-amorphous-6708)  hobby-dev  free 
     └─ as DATABASE

Y comprobamos que nuestra base de datos se identifica con el nombre DATABASE, y podemos pedir las credenciales para conectarnos a ella (nombre de la base de datos, usuario y contraseña y servidor de la base de datos) con el siguiente comando:

    # heroku pg:credentials DATABASE
    Connection info string:
       "dbname=d3bo6f4g2gbilu host=ec2-54-83-202-218.compute-1.amazonaws.com port=5432 user=pwcbycuykpmhqb    password=1dg2xwsRb6fcMRhHdtkfTlkahw sslmode=require"
    Connection URL:
            postgres://pwcbycuykpmhqb:1dg2xwsRb6fcMRhHdtkfTlkahw@ec2-54-83-202-218.compute-1.amazonaws.com:5432/d3bo6f4g2gbilu

Nos queda hacer la migración de la base de datos, para ello vamos a seguir las indicaciones de la [documentación oficial](https://devcenter.heroku.com/articles/heroku-postgres-import-export), primero hacemos la copia de seguridad de la base de datos `drupal` en local y posteriormente la restauramos en heroku:

    pg_dump -Fc --no-acl --no-owner -h localhost -U jose drupal > drupal.dump

Para restaurar la copia de seguridad es necesario que la copia que hemos realizado este accesible desde una URL (por ejemplo lo podemos subir a un almacén de datos como Amazon S3), en este caso para agilizar el ejemplo lo he subido a nuestra aplicación:

    pledinjd# git add drupal.dump 
    pledinjd# git commit -m "Copia de seguridad BD"
    pledinjd# git push

    pledinjd# heroku pg:backups restore 'http://pledinjd.herokuapp.com/drupal.dump' DATABASE --confirm pledinjd
    Use Ctrl-C at any time to stop monitoring progress; the backup
    will continue restoring. Use heroku pg:backups to check progress.
    Stop a running restore with heroku pg:backups cancel.

    r001 ---restore---> DATABASE
    Restore completed

Y podemos ver las tablas creadas:

    # heroku pg:psql DATABASE
    ---> Connecting to DATABASE_URL
    psql (9.4.5)
    conexión SSL (protocolo: TLSv1.2, cifrado: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compresión: desactivado)
    Digite «help» para obtener ayuda.

    pledinjd::DATABASE=> \dt

### Despliegue de nuestra aplicación

Vamos a copiar los ficheros desde nuestro servidor local, y vamos a modificar el fichero de configuración con las credenciales de la base de datos de heroku:

    pledinjd# cp -r /var/www/pledinjd/drupal .

Y el fichero de configuración `sites/default/settings.php` hay que modificarlo para configurar los parámetros de acceso a la base de datos de nuestro proyecto:

    $databases['default']['default'] = array (
      'database' => 'd3bo6f4g2gbilu',
      'username' => 'pwcbycuykpmhqb',
      'password' => '1dg2xwsRb6fcMRhHdtkfTlkahw',
      'prefix' => '',
      'host' => 'ec2-54-83-202-218.compute-1.amazonaws.com',
      'port' => '5432',
      'namespace' => 'Drupal\\Core\\Database\\Driver\\pgsql',
      'driver' => 'pgsql',
    );

Y a continuación hacemos el despliegue:

    pledinjd# git add drupal
    pledinjd# git commit -m "Despliegue de drupal"
    pledinjd# git push

### Instalando librerias PHP necesarias

Si accedemos a nuestra aplicación nos daremos cuenta que no funciona, podemos ver los logs de error de la misma ejecutando la siguente instrucción:

    pledinjd# heroku logs

Necesitamos instalar en nuestro dyno las librerías PHP, la librería gráfica <a href="http://docs.php.net/manual/es/book.image.php">gd</a> y la <a href="http://docs.php.net/mbstring">mbstring</a>. Para definir las librerías que se han de instalar en heroku, siguiendo la<a href="https://devcenter.heroku.com/articles/deploying-php#deploy-your-application-to-heroku"> documentación oficial</a>, tenemos que crear en la raíz de nuestro repositorio git, un fichero `composer.json`  con el siguiente contenido:

    pledinjd# cat composer.json 
    {
     "require": {
     "ext-gd": "*",
     "ext-mbstring": "*"
     }
    }

A partir de este fichero hay que crear el fichero `composer.lock`, utilizando la utilidad <a href="https://getcomposer.org/doc/00-intro.md">`composer`</a>,que nos permite gestionar las dependencias de las librerias. Vamos a intalar la utilidad y generar el fichero pack:

    pledinjd# php -r "readfile('https://getcomposer.org/installer');" | php
    pledinjd# php composer.phar update
    pldinjd# git add composer.lock 
    pledinjd# git commit -m "Librerías"
    pledinjd# git push

Y ya podemos acceder a nuestra aplicación:

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/drupal3.png"><img class="size-full wp-image-1406 alignnone" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/drupal3.png" alt="drupal3" width="991" height="420" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/drupal3.png 991w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2015/11/drupal3-300x127.png 300w" sizes="(max-width: 991px) 100vw, 991px" /></a>

## Accediendo al dyno

Podemos acceder a nuestro dyno con la siguiente instrucción:

    # heroku run bash
    Running bash on pledinjd... up, run.4539
    ~ $

Accedemos al repositorio git, aunque podemos acceder al directorio padre:

    ~ $ ls
    Procfile  composer.json  composer.lock    drupal    drupal.dump  index.php    vendor
    ~ $ cd ..
    / $ ls
    app  bin  dev  etc  home  lib  lib64  lost+found  proc    sbin  sys  tmp    usr  var

Como vimos anteriormente el dyno tiene una dirección en un rango /30:

    $ ip addr show eth0
    27054: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 1e:da:76:65:02:a9 brd ff:ff:ff:ff:ff:ff
        inet 172.18.174.218/30 brd 172.18.174.219 scope global eth0
           valid_lft forever preferred_lft forever
        inet6 fe80::1cda:76ff:fe65:2a9/64 scope link 
           valid_lft forever preferred_lft forever

Y la puerta de enlace es la otra direción disponible en la red, que debe coincidir con la interfaz en el balanceador de carga/router:

    $ ip route
    default via 172.18.174.217 dev eth0 
    172.18.174.216/30 dev eth0 proto kernel scope link src 172.18.174.218

Y para terminar podemos observar que el dyno esta corriendo en una máquina con 60Gb de RAM:

    $ free -h
                 total       used       free     shared    buffers     cached
    Mem:           60G        58G       2.0G        70M       1.3G       6.1G

## Conclusiones

Si queremos usar heroku para desplegar aplicaciones web tradicionales escritas en PHP, como drupal, tenemos que tener en cuenta varias cosas:

<li style="text-align: justify;">
  Teniendo en cuenta que el sistema de ficheros es efímero, tenemos que subir nuestros datos de la aplicación web en un sistema exerno, por ejmplo en un almacen de objetos como Amazon S3, apra ello es muy recomendable utilizar un plugin de drupal de <a href="https://www.drupal.org/project/amazons3">Amazon S3</a>.
</li>
<li style="text-align: justify;">
  Heroku no manda correos, por lo tanto necesitamos un servicio externo como <a href="https://www.mandrill.com/">Mandrill</a>, por lo tanto podemos usar el plugin de drupal de <a href="https://www.drupal.org/project/mandrill">Mandrill</a>.
</li>

En alguna futura entrada del blog se podría realizar un despliegue de alguna aplicación web utilizado Python o Ruby y estudiar las funcionalidades que nos ofrece Heroku.
