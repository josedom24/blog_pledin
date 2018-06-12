---
id: 1541
title: Almacenamiento de objetos con Amazon Web Service S3
date: 2016-02-02T19:34:53+00:00


guid: http://www.josedomingo.org/pledin/?p=1541
permalink: /2016/02/almacenamiento-de-objetos-con-aws-s3/


tags:
  - aws
  - Cloud Computing
  - Objetos
---

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/AWS-S3.png" rel="attachment wp-att-1556"><img class="aligncenter wp-image-1556" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/AWS-S3.png" alt="AWS-S3" width="376" height="188" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/AWS-S3.png 845w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/AWS-S3-300x150.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/AWS-S3-768x384.png 768w" sizes="(max-width: 376px) 100vw, 376px" /></a>

En este artículo voy a hacer una introducción a <strong>Amazon Web Service</strong> <strong>S3(Simple Storage Service)</strong>, que nos ofrece un servicio de almacenamiento masivo de objetos. AWS S3 ofrece un almacén de objetos distribuido y altamente escalable. Se utiliza para almacenar grandes cantidades de datos de forma segura y económica. El almacenamiento de objetos es ideal para almacenar grandes ficheros multimedia o archivos grandes como copias de seguridad. Otra utilidad que nos ofrece es el almacenamiento de los datos estáticos de nuestra página web, que es lo que vamos a estudiar en esta entrada.

## Conceptos sobre AWS S3

Para la organización de nuestros archivos, tenemos que conocer los siguientes conceptos:

* **buckets**: son algo parecido a un directorio o carpeta de nuestro sistema operativo, donde colocaremos nuestros archivos. Los nombres de los buckets están compartidos entre toda la red de Amazon S3, por lo que si creamos un bucket, nadie más podrá usar ese nombre para un nuevo bucket.
* **objects**: son las entidades de datos en sí, es decir, nuestros archivos. Un object almacena tanto los datos como los metadatos necesarios para S3, y pueden ocupar entre 1 byte y 5 Gigabytes.
* **keys**: son una clave única dentro de un bucket que identifica a los objects de cada bucket. Un object se identifica de manera unívoca dentro de todo S3 mediante su bucket+key.
* **ACL**: Podemos indicar el control de acceso a nuestro objetos, podremos dar capacidad de “Lectura”, “Escritura” o “Control Total”.

## Más características de AWS S3

* Uso de una API sencilla para la comunicación de nuestras aplicaciones con S3. Estas peticiones HTTP nos permitirán la gestión de los objetos, buckets, … En definitiva, todas las acciones necesarias para administrar nuestro S3. Toda la información en cuanto accesos y códigos de ejemplo se pueden encontrar en la <a href="http://docs.amazonwebservices.com/AmazonS3/2006-03-01/gsg/">documentación oficial</a>.
* Para la descargas de los objetos tenemos dos alternativas: si eres el propietario del objeto puedes hacer una llamada a la API para la descarga, sino, si hemos configurado el objeto con una ACL de lectura, podemos utilizar una URL para accder a él. Cada archivo en S3 posee una URL única, lo que nos facilitará mucho el poner a disposición de nuestros clientes todos los datos que almacenemos.
* El servicio se paga por distintos conceptos: almacenamiento, transferencia, peticiones GET o PUT,&#8230; pero hay que tener en cuenta, siendo un servicio de Cloud Computing, que el pago se realiza por uso. La tarifas son baratas y las puedes consultar en la siguiente <a href="http://aws.amazon.com/es/s3/pricing/">página</a>.

## Instalación y configuración del cliente de línea de comando AWS

La forma más cómoda de instalar el cliente de línea de comando en un sistema operativo GNU/Linux Debian es utilizando la utilidad <a href="https://pypi.python.org/pypi/pip">pip</a>, para ello ejecutamos los siguientes comandos:

    # apt-get install python-pip
    # pip install awscli

Podemos comprobar la versión que hemos instalado:
    
    # aws --version
    aws-cli/1.10.1 Python/2.7.9 Linux/3.16.0-4-amd64 botocore/1.3.23

La CLI de AWS nos permite gestionar todo lo relacionado con Amazon Web Services sin necesidad de acceder a la consola de administración web. Para poder utilizarlo tenemos que configurar el cliente para autentificarnos, especificando nuestro <strong>AWS Access Key ID</strong> y <strong>AWS Secret Access Key</strong> que hemos creado en la consola web:

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/aws1.png" rel="attachment wp-att-1564"><img class="aligncenter size-full wp-image-1564" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/aws1.png" alt="aws1" width="974" height="569" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/aws1.png 974w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/aws1-300x175.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/aws1-768x449.png 768w" sizes="(max-width: 974px) 100vw, 974px" /></a>

Para realizar la configuración:

    $ aws configure
     AWS Access Key ID [None]: AKIAIW2A7LBLHZKRQRNQ
     AWS Secret Access Key [None]: **********************************
     Default region name [None]:
     Default output format [None]:

Para trabajar con AWS S3 no hace falta indicar la región que vamos a usar, y el formato de salida tampoco lo hemos indicado.

## Uso del cliente de línea de comando AWS

Para empezar vamos a comprobar si tenemos permiso para acceder a los recursos de nuestra cuenta en AWS S3, por ejemplo intentando visualizar la lista de buckets que tenemos:

    $ aws s3 ls

A client error (AccessDenied) occurred when calling the ListBuckets operation: Access Denied

Como podemos comprobar tenemos que añadir una política de acceso para permitir el acceso a S3, para ello desde la consola web, nos vamos a la pestaña <strong>Permissions</strong> y añadimos una nueva política en la opción <strong>Attach Policy</strong> y escogemos: <strong>AmazonS3FullAccess:</strong>

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/aws2.png" rel="attachment wp-att-1566"><img class="aligncenter size-full wp-image-1566" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/aws2.png" alt="aws2" width="975" height="538" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/aws2.png 975w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/aws2-300x166.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/aws2-768x424.png 768w" sizes="(max-width: 975px) 100vw, 975px" /></a>

Y podemos comenzar a trabajar:

### Listar, crear y eliminar buckets

Los &#8220;<strong>buckets&#8221;</strong> o &#8220;cubos&#8221; es el contenedor S3 donde se almacenarán los datos. Para crear uno, debemos elegir un nombre (tiene que ser <strong>válido a nivel de DNS y único</strong>). Para crear un nuevo buckets:

    $ aws s3 mb s3://storage_pledin1
    make_bucket: s3://storage_pledin1/

Para listar los buckets que tenemos creado:

    $ aws s3 ls
    2016-02-01 08:22:25 storage_pledin1

Y si quisiéramos borrarlo:

    $ aws s3 rb s3://storage_pledin1
    remove_bucket: s3://storage_pledin1/

### Subir, descargar y eliminar objetos

Con la CLI de aws se incluyen los comandos <strong>cp, ls, mv, rm y sync</strong>. Todos ellos funcionan igual que en las shell de Linux. Sync es un añadido que permite sincronizar directorios completos. Vamos a ver unos ejemplos:

**Copiar de local a remoto:**

    $ aws s3 cp BabyTux.png s3://storage_pledin1
    upload: ./BabyTux.png to s3://storage_pledin1/BabyTux.png

**Listar el contenido de un bucket:**

    $ aws s3 ls s3://storage_pledin1
    2016-02-01 08:29:49     147061 BabyTux.png

**Mover/renombrar un archivo remoto:**

    $ aws s3 mv s3://storage_pledin1/BabyTux.png s3://storage_pledin1/tux.png
    move: s3://storage_pledin1/BabyTux.png to s3://storage_pledin1/tux.png

**Copiar archivos remotos:**

    $ aws s3 cp s3://storage_pledin1/tux.png s3://storage_pledin1/tux2.png
    copy: s3://storage_pledin1/tux.png to s3://storage_pledin1/tux2.png

    $ aws s3 ls s3://storage_pledin1
    2016-02-01 08:33:07     147061 tux.png
    2016-02-01 08:34:01     147061 tux2.png

La parte de sincronización también es fácil de utilizar usando el comando <strong><a href="http://docs.aws.amazon.com/cli/latest/reference/s3/sync.html">rsync</a></strong>, indicamos el origen y el destino y sincronizará todos los archivos y directorios que contenga:

**Sincronizar los ficheros de un directorio local a remoto:**

    $ aws s3 sync prueba/ s3://storage_pledin1/prueba
    upload: prueba/fich2.txt to s3://storage_pledin1/prueba/fich2.txt
    upload: prueba/fich1.txt to s3://storage_pledin1/prueba/fich1.txt
    upload: prueba/fich3.txt to s3://storage_pledin1/prueba/fich3.txt

    $ aws s3 ls s3://storage_pledin1/prueba/
    2016-02-01 08:50:45          0 fich1.txt
    2016-02-01 08:50:45          0 fich2.txt
    2016-02-01 08:50:45          0 fich3.txt

## Acceso a los objetos

Amazon S3 Access Control Lists (ACLs) nos permite manejar el acceso a los objetos y buckets de nuestro proyecto. Cuando se crea un objeto o un bucket se define una ACL que otorga control total (full control) al propietario del recurso. Podemos otorgar distintos permisos a usuarios y grupos de AWS. Para saber más sobre permisos en S3 puedes consultar el documento: <a href="http://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html">Access Control List (ACL) Overview</a>

En esta entrada nos vamos a conformar en mostrar una ACL que nos permita hacer público un objeto y de esta manera poder acceder a él. Para acceder a un recurso en S3 podemos hacerlo de dos maneras:

* Si somos un usuario o pertenecemos a un grupo de AWS y el propietario del recurso nos ha dado permiso para acceder o modificar el recurso.
* O, sin necesidad de estar autentificados, que el propietario del recurso haya dado permiso de lectura al recurso para todo el mundo, es decir lo haya hecho público. Esta opción es la que vamos a mostrar a continuación.

Anteriormente hemos subido una imagen (tux.png) como objeto a nuestro bucket, como hemos dicho cuando se crea el objeto, por defecto se declara como privado. Si accedemos a dicho recurso utilizando la siguiente URL:

    https://s3.amazonaws.com/storage_pledin1/tux.png

Vemos como el control de acceso no nos deja acceder al recurso:

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/aws3.png" rel="attachment wp-att-1570"><img class="aligncenter size-full wp-image-1570" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/aws3.png" alt="aws3" width="605" height="295" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/aws3.png 605w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/aws3-300x146.png 300w" sizes="(max-width: 605px) 100vw, 605px" /></a>

Cuando copiamos el objeto al bucket podemos indicar la ACL para hacer le objeto público, de la siguiente manera:

    aws s3 cp tux.png s3://storage_pledin1 --acl public-read-write

De tal manera que ahora podemos acceder al recurso:

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/aws4.png" rel="attachment wp-att-1569"><img class="aligncenter size-full wp-image-1569" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/aws4.png" alt="aws4" width="763" height="542" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/aws4.png 763w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/01/aws4-300x213.png 300w" sizes="(max-width: 763px) 100vw, 763px" /></a>

## Conclusiones

El uso del almacenamiento de objetos no es algo nuevo en la informática, pero si ha tenido una gran importancia en los últimos tiempo con el uso masivo que se hace de los entorno IaaS de Cloud Computing. En este artículo he intentado hacer una pequeña introducción a la solución de almacenamiento de objetos que nos ofrece AWS, aunque los conceptos son muy similares y totalmente transportables a otras soluciones, como puede ser OpenStack y su componente de <a href="http://iesgn.github.io/emergya/curso/u4/presentacion_objetos#/">almacenamiento de objetos Swift</a>.


<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->