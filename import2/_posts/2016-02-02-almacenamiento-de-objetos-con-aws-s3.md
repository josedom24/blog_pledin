---
layout: post
status: publish
published: true
title: Almacenamiento de objetos con Amazon Web Service S3
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1541
wordpress_url: http://www.josedomingo.org/pledin/?p=1541
date: '2016-02-02 19:34:53 +0000'
date_gmt: '2016-02-02 18:34:53 +0000'
categories:
- General
tags:
- Cloud Computing
- aws
- Objetos
comments: []
---
<p style="text-align: justify;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/01/AWS-S3.png" rel="attachment wp-att-1556"><img class="aligncenter wp-image-1556" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/01/AWS-S3.png" alt="AWS-S3" width="376" height="188" /></a></p>
<p style="text-align: justify;">En este art&iacute;culo voy a hacer una introducci&oacute;n a <strong>Amazon Web Service</strong> <strong>S3 <span class="st">(Simple Storage Service)</span></strong>, que nos ofrece un servicio de almacenamiento masivo de objetos. AWS S3 ofrece un almac&eacute;n de objetos distribuido y altamente escalable. Se utiliza para almacenar grandes cantidades de datos de forma segura y econ&oacute;mica. El almacenamiento de objetos es ideal para almacenar grandes ficheros multimedia o archivos grandes como copias de seguridad. Otra utilidad que nos ofrece es el almacenamiento de los datos est&aacute;ticos de nuestra p&aacute;gina web, que es lo que vamos a estudiar en esta entrada.</p>
<h2 style="text-align: justify;">Conceptos sobre AWS S3</h2>
<p style="text-align: justify;">Para la organizaci&oacute;n de nuestros archivos, tenemos que conocer los siguientes conceptos:</p>
<ul>
<li style="text-align: justify;"><strong>buckets:</strong> son algo parecido a un directorio o carpeta de nuestro sistema operativo, donde colocaremos nuestros archivos. Los nombres de los buckets est&aacute;n compartidos entre toda la red de Amazon S3, por lo que si creamos un bucket, nadie m&aacute;s podr&aacute; usar ese nombre para un nuevo bucket.</li>
<li style="text-align: justify;"><strong>objects:</strong> son las entidades de datos en s&iacute;, es decir, nuestros archivos. Un object almacena tanto los datos como los metadatos necesarios para S3, y pueden ocupar entre 1 byte y 5 Gigabytes.</li>
<li style="text-align: justify;"><strong>keys:</strong> son una clave &uacute;nica dentro de un bucket que identifica a los objects de cada bucket. Un object se identifica de manera un&iacute;voca dentro de todo S3 mediante su bucket+key.</li>
<li style="text-align: justify;"><strong>ACL: </strong>Podemos indicar el control de acceso a nuestro objetos, podremos dar capacidad de &ldquo;Lectura&rdquo;, &ldquo;Escritura&rdquo; o &ldquo;Control Total&rdquo;.</li>
</ul>
<h2>M&aacute;s caracter&iacute;sticas de AWS S3</h2>
<ul>
<li style="text-align: justify;">Uso de una API sencilla para la comunicaci&oacute;n de nuestras aplicaciones con S3. Estas peticiones HTTP nos permitir&aacute;n la gesti&oacute;n de los objetos, buckets, &hellip; En definitiva, todas las acciones necesarias para administrar nuestro S3. Toda la informaci&oacute;n en cuanto accesos y c&oacute;digos de ejemplo se pueden encontrar en la <a href="http://docs.amazonwebservices.com/AmazonS3/2006-03-01/gsg/">documentaci&oacute;n oficial</a>.</li>
<li style="text-align: justify;">Para la descargas de los objetos tenemos dos alternativas: si eres el propietario del objeto puedes hacer una llamada a la API para la descarga, sino, si hemos configurado el objeto con una ACL de lectura, podemos utilizar una URL para accder a &eacute;l. Cada archivo en S3 posee una URL &uacute;nica, lo que nos facilitar&aacute; mucho el poner a disposici&oacute;n de nuestros clientes todos los datos que almacenemos.</li>
<li style="text-align: justify;">El servicio se paga por distintos conceptos: almacenamiento, transferencia, peticiones GET o PUT,... pero hay que tener en cuenta, siendo un servicio de Cloud Computing, que el pago se realiza por uso. La tarifas son baratas y las puedes consultar en la siguiente <a href="http://aws.amazon.com/es/s3/pricing/">p&aacute;gina</a>.</li>
</ul>
<p><!--more--></p>
<h2>Instalaci&oacute;n y configuraci&oacute;n del cliente de l&iacute;nea de comando AWS</h2>
<p style="text-align: justify;">La forma m&aacute;s c&oacute;moda de instalar el cliente de l&iacute;nea de comando en un sistema operativo GNU/Linux Debian es utilizando la utilidad <a href="https://pypi.python.org/pypi/pip">pip</a>, para ello ejecutamos los siguientes comandos:</p>
<pre># apt-get install python-pip
# pip install awscli</pre>
<p>Podemos comprobar la versi&oacute;n que hemos instalado:</p>
<pre># aws --version
aws-cli/1.10.1 Python/2.7.9 Linux/3.16.0-4-amd64 botocore/1.3.23
</pre>
<p style="text-align: justify;">La CLI de AWS nos permite gestionar todo lo relacionado con Amazon Web Services sin necesidad de acceder a la consola de administraci&oacute;n web. Para poder utilizarlo tenemos que configurar el cliente para autentificarnos, especificando nuestro <strong>AWS Access Key ID</strong> y <strong>AWS Secret Access Key</strong> que hemos creado en la consola web:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/aws1.png" rel="attachment wp-att-1564"><img class="aligncenter size-full wp-image-1564" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/aws1.png" alt="aws1" width="974" height="569" /></a></p>
<p>Para realizar la configuraci&oacute;n:</p>
<pre>$ aws configure
 AWS Access Key ID [None]: AKIAIW2A7LBLHZKRQRNQ
 AWS Secret Access Key [None]: **********************************
 Default region name [None]:
 Default output format [None]:</pre>
<p style="text-align: justify;">Para trabajar con AWS S3 no hace falta indicar la regi&oacute;n que vamos a usar, y el formato de salida tampoco lo hemos indicado.</p>
<h2>Uso del cliente de l&iacute;nea de comando AWS</h2>
<p style="text-align: justify;">Para empezar vamos a comprobar si tenemos permiso para acceder a los recursos de nuestra cuenta en AWS S3, por ejemplo intentando visualizar la lista de buckets que tenemos:</p>
<pre>$ aws s3 ls

A client error (AccessDenied) occurred when calling the ListBuckets operation: Access Denied</pre>
<p style="text-align: justify;">Como podemos comprobar tenemos que a&ntilde;adir una pol&iacute;tica de acceso para permitir el acceso a S3, para ello desde la consola web, nos vamos a la pesta&ntilde;a <strong>Permissions</strong> y a&ntilde;adimos una nueva pol&iacute;tica en la opci&oacute;n <strong>Attach Policy</strong> y escogemos: <strong>AmazonS3FullAccess:</strong></p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/aws2.png" rel="attachment wp-att-1566"><img class="aligncenter size-full wp-image-1566" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/02/aws2.png" alt="aws2" width="975" height="538" /></a>Y podemos comenzar a trabajar:</p>
<h3>Listar, crear y eliminar buckets</h3>
<p style="text-align: justify;">Los "<strong>buckets"</strong> o "cubos" es el contenedor S3 donde se almacenar&aacute;n los datos. Para crear uno, debemos elegir un nombre (tiene que ser <strong>v&aacute;lido a nivel de DNS y &uacute;nico</strong>). Para crear un nuevo buckets:</p>
<pre>$ aws s3 mb s3://storage_pledin1
make_bucket: s3://storage_pledin1/</pre>
<p>Para listar los buckets que tenemos creado:</p>
<pre>$ aws s3 ls
2016-02-01 08:22:25 storage_pledin1</pre>
<p>Y si quisi&eacute;ramos borrarlo:</p>
<pre>$ aws s3 rb s3://storage_pledin1
remove_bucket: s3://storage_pledin1/</pre>
<h3>Subir, descargar y eliminar objetos</h3>
<p style="text-align: justify;">Con la CLI de aws se incluyen los comandos <strong>cp, ls, mv, rm y sync</strong>. Todos ellos funcionan igual que en las shell de Linux. Sync es un a&ntilde;adido que permite sincronizar directorios completos. Vamos a ver unos ejemplos:</p>
<p><strong>Copiar de local a remoto:</strong></p>
<pre>$ aws s3 cp BabyTux.png s3://storage_pledin1
upload: ./BabyTux.png to s3://storage_pledin1/BabyTux.png</pre>
<p><strong>Listar el contenido de un bucket:</strong></p>
<pre>$ aws s3 ls s3://storage_pledin1
2016-02-01 08:29:49&nbsp;&nbsp;&nbsp;&nbsp; 147061 BabyTux.png</pre>
<p><strong>Mover/renombrar un archivo remoto:</strong></p>
<pre>$ aws s3 mv s3://storage_pledin1/BabyTux.png s3://storage_pledin1/tux.png
move: s3://storage_pledin1/BabyTux.png to s3://storage_pledin1/tux.png</pre>
<p><strong>Copiar archivos remotos:</strong></p>
<pre>$ aws s3 cp s3://storage_pledin1/tux.png s3://storage_pledin1/tux2.png
copy: s3://storage_pledin1/tux.png to s3://storage_pledin1/tux2.png

$ aws s3 ls s3://storage_pledin1
2016-02-01 08:33:07&nbsp;&nbsp;&nbsp;&nbsp; 147061 tux.png
2016-02-01 08:34:01&nbsp;&nbsp;&nbsp;&nbsp; 147061 tux2.png</pre>
<p style="text-align: justify;">La parte de sincronizaci&oacute;n tambi&eacute;n es f&aacute;cil de utilizar usando el comando <strong><a href="http://docs.aws.amazon.com/cli/latest/reference/s3/sync.html">rsync</a></strong>, indicamos el origen y el destino y sincronizar&aacute; todos los archivos y directorios que contenga:</p>
<p><strong>Sincronizar los ficheros de un directorio local a remoto:</strong></p>
<pre>$ $ aws s3 sync prueba/ s3://storage_pledin1/prueba
upload: prueba/fich2.txt to s3://storage_pledin1/prueba/fich2.txt
upload: prueba/fich1.txt to s3://storage_pledin1/prueba/fich1.txt
upload: prueba/fich3.txt to s3://storage_pledin1/prueba/fich3.txt

$ aws s3 ls s3://storage_pledin1/prueba/
2016-02-01 08:50:45&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 fich1.txt
2016-02-01 08:50:45&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 fich2.txt
2016-02-01 08:50:45&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 fich3.txt</pre>
<h2>Acceso a los objetos</h2>
<p style="text-align: justify;">Amazon S3 Access Control Lists (ACLs) nos permite manejar el acceso a los objetos y buckets de nuestro proyecto. Cuando se crea un objeto o un bucket se define una ACL que otorga control total (full control) al propietario del recurso. Podemos otorgar distintos permisos a usuarios y grupos de AWS. Para saber m&aacute;s sobre permisos en S3 puedes consultar el documento: <a href="http://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html">Access Control List (ACL) Overview</a></p>
<p style="text-align: justify;">En esta entrada nos vamos a conformar en mostrar una ACL que nos permita hacer p&uacute;blico un objeto y de esta manera poder acceder a &eacute;l. Para acceder a un recurso en S3 podemos hacerlo de dos maneras:</p>
<ul>
<li style="text-align: justify;">Si somos un usuario o pertenecemos a un grupo de AWS y el propietario del recurso nos ha dado permiso para acceder o modificar el recurso.</li>
<li style="text-align: justify;">O, sin necesidad de estar autentificados, que el propietario del recurso haya dado permiso de lectura al recurso para todo el mundo, es decir lo haya hecho p&uacute;blico. Esta opci&oacute;n es la que vamos a mostrar a continuaci&oacute;n.</li>
</ul>
<p style="text-align: justify;">Anteriormente hemos subido una imagen (tux.png) como objeto a nuestro bucket, como hemos dicho cuando se crea el objeto, por defecto se declara como privado. Si accedemos a dicho recurso utilizando la siguiente URL:</p>
<pre>https://s3.amazonaws.com/storage_pledin1/tux.png</pre>
<p style="text-align: justify;">Vemos como el control de acceso no nos deja acceder al recurso:<br />
<a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/01/aws3.png" rel="attachment wp-att-1570"><img class="aligncenter size-full wp-image-1570" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/01/aws3.png" alt="aws3" width="605" height="295" /></a>Cunado copiamos el objeto al bucket podemos indicar la ACL para hacer le objeto p&uacute;blico, de la siguiente manera:</p>
<pre>aws s3 cp tux.png s3://storage_pledin1 --acl public-read-write</pre>
<p>De tal manera que ahora podemos acceder al recurso:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/01/aws4.png" rel="attachment wp-att-1569"><img class="aligncenter size-full wp-image-1569" src="http://www.josedomingo.org/pledin/wp-content/uploads/2016/01/aws4.png" alt="aws4" width="763" height="542" /></a></p>
<h2>Conclusiones</h2>
<p style="text-align: justify;">El uso del almacenamiento de objetos no es algo nuevo en la inform&aacute;tica, pero si ha tenido una gran importancia en los &uacute;ltimos tiempo con el uso masivo que se hace de los entorno IaaS de Cloud Computing. En este art&iacute;culo he intentado hacer una peque&ntilde;a introducci&oacute;n a la soluci&oacute;n de almacenamiento de objetos que nos ofrece AWS, aunque los conceptos son muy similares y totalmente transportables a otras soluciones, como puede ser OpenStack y su componente de <a href="http://iesgn.github.io/emergya/curso/u4/presentacion_objetos#/">almacenamiento de objetos Swift</a>.</p>
