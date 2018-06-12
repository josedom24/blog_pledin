---
id: 1085
title: 'Migrando Pledin. De hosting tradicional a PaaS OpenShift: Moodle'
date: 2014-12-10T13:52:38+00:00


guid: http://www.josedomingo.org/pledin/?p=1085
permalink: /2014/12/migrando-pledin-de-hosting-tradicional-a-paas-openshift-moodle/


tags:
  - Hosting
  - Moodle
  - OpenShift
  - PaaS
  - Pledin
---
[<img class="size-full wp-image-1131 aligncenter" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/moodle.jpeg" alt="moodle" width="416" height="121" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/moodle.jpeg 416w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/moodle-300x87.jpeg 300w" sizes="(max-width: 416px) 100vw, 416px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/moodle.jpeg){.thumbnail}En estos días estoy llevando a cabo la migración de mis páginas web de un hosting tradicional a una infraestructura PaaS como es OpenShift. Además de algunas páginas estáticas, mi plataforma se basa en dos CMS: un blog realizado en WordPress y una plataforma educativa realizada con Moodle. En este primer artículo voy a explicar las diferentes decisiones que he tomado para realizar la migración de la plataforma moodle.

## Mi plataforma educativa Moodle

Haciendo un poco de historia tengo que decir que la plataforma Moodle es el primer CMS que utilicé para ir recopilando cursos e información sobre temas de informática y educación. En octubre de 2005 empecé este proyecto con una moodle versión 1.4, y después de más de 9 años y unas cuantas actualizaciones y migraciones, 59 cursos y más de 700 usuarios registrado, el directorio moodledata ocupa casi 2Gb de información. Por lo tanto la primera decisión que he tomado es hacer una instalación nueva de la última versión de moodle. Además en esta moodle (<http://plataforma.josedomingo.org>) sólo voy a poner los cursos más interesantes y actualizados que tengo en la plataforma, y los más antiguos y desactualizados lo voy a subir a una plataforma que he creado en la página [www.gnomio.com](http://www.gnomio.com), plataforma que te ofrece la posibilidad de crear una moodle de forma gratuita.

Por lo tanto después de un buen rato he conseguido hacer las copias de seguridad de todos los cursos, y he restaurado en la moodle de cursos antiguos (<http://pledin.gnomio.com>) los cursos más antiguos y desactualizados. Todos estos cursos tendrán acceso gratuito a los invitados de la plataforma, por lo tanto no va a ser necesario el registro de usuarios. Además uno de las preocupaciones que tengo es mantener la relación entre la antigua URL de acceso a los cursos con las nuevas URL, para ello he apuntado la relación de los identificadores de lo cursos en la plataforma actual y el identificador en esta nueva plataforma, posteriormente explicaré cómo voy a mantener la relación entre las url.<!--more-->

## Instalación de moodle en OpenShift Online

En este punto vamos a explicar los pasos que he seguido para desplegar la aplicación web Moodle en OpenShift Online.

### Conceptos previos {#conceptos-previos}

  * **Gear**: Es un contenedor dentro de una máquina virtual con unos recursos limitados para que pueda ejecutar sus aplicaciones un usuario de OpenShift. En el caso de utilizar una cuenta gratuita se pueden crear como máximo tres gears de tipo “small”, cada uno de ellos puede utilizar un máximo de 512MB de RAM, 100MB de swap y 1GB de espacio en disco. Nuestra aplicación se desplegará y ejecutará utilizando estos recursos asociados al “gear”.
  * **Cartridge**: Son contenedores de software preparados para ejecutarse en un gear. En principio sobre cada gear pueden desplegarse varios cartridges, por ejemplo existen cartridges de php, ruby, jboss, MySQL, django, etc.

### Acceso a OpenShift Online y configuración inicial {#acceso-a-openshift-online-y-configuracin-inicial}

Accedemos a la URL <https://www.openshift.com/>, nos damos de alta y accedemos con nuestra cuenta.

[<img class="aligncenter  wp-image-1121" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift1.png" alt="openshift1" width="551" height="249" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift1.png 925w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift1-300x135.png 300w" sizes="(max-width: 551px) 100vw, 551px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift1.png){.thumbnail}

Cada cuenta de usuario en OpenShift Online está asociada a un “espacio de nombres” para generar un FQDN único para cada gear. En la configuración inicial de la cuenta habrá que seleccionar un espacio de nombres que sea único, este espacio de nombres se aplicará automáticamente a todos los gears que se creen. En mi caso el espacio de nombres en OpenShift Online va a ser “pledin” y el gear que vamos a crear se va a llamar &#8220;moodle&#8221;, entonces esta aplicación será accesible a través de la url http://moodle-pledin.rhcloud.com.Sin embargo, y como veremos posteriormente nosotros vamos a utilizar un nombre de host [plataforma.josedomingo.org](http://plataforma.josedomingo.org) para acceder a nuestra aplicación.

[<img class="aligncenter size-full wp-image-1122" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift2.png" alt="openshift2" width="612" height="219" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift2.png 612w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift2-300x107.png 300w" sizes="(max-width: 612px) 100vw, 612px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift2.png){.thumbnail}

### Acceso por ssh {#acceso-por-ssh}

Una de las características interesantes que proporciona OpenShift es la posibilidad de acceder por ssh a la máquina en la que se está ejecutando nuestra aplicación web, aunque con un usuario con privilegios restringidos.

El acceso remoto a nuestras aplicaciones se hace usando el protocolo SSH. El mecanismo usado para la autentificación ssh es usando claves públicas ssh, y es necesario indicar las claves públicas ssh que queramos usar para poder acceder de forma remota. Además también es necesario hacer esta configuración para poder trabajar con el repositorio Git que tenemos a nuestra disposición. Si no posees un par de claves ssh, puedes generar un par de claves rsa, usando el siguiente comando:

    $ ssh-keygen
    

Por defecto en el directorio ~/.ssh, se generan la clave pública y la privada: id\_rsa.pub y id\_rsa. El contenido del fichero id_rsa.pub es el que tienes que subir a OpenShift.

[<img class="aligncenter size-full wp-image-1123" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift3.png" alt="openshift3" width="993" height="250" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift3.png 993w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift3-300x75.png 300w" sizes="(max-width: 993px) 100vw, 993px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift3.png){.thumbnail}

### Creando nuestra aplicación {#creando-nuestra-aplicacin}

Durante el proceso de creación de una nueva aplicación, tenemos que configurar los siguientes elementos:

<p style="padding-left: 30px;">
  1) Elegir el cartridge (paquete de software) que necesitas para la implantación de tu aplicación web. En el caso de Moodle podemos elegir el componente PHP 5.4.
</p>

<p style="padding-left: 30px;">
  <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift4.png"><img class="aligncenter size-full wp-image-1124" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift4.png" alt="openshift4" width="949" height="984" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift4.png 949w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift4-289x300.png 289w" sizes="(max-width: 949px) 100vw, 949px" /></a>
</p>

<p style="padding-left: 30px;">
  2) Debemos elegir la URL de acceso, teniendo en cuenta el espacio de nombres que habíamos configurado.
</p>

<p style="padding-left: 30px;">
  <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift5.png"><img class="aligncenter size-full wp-image-1125" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift5.png" alt="openshift5" width="980" height="735" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift5.png 980w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift5-300x225.png 300w" sizes="(max-width: 980px) 100vw, 980px" /></a>
</p>

<p style="padding-left: 30px;">
  Una vez que se ha creado la aplicación (gear), se nos ofrece información del repositorio Git que podemos clonar a nuestro equipo local para poder subir los ficheros al gear. Procedemos a seguir estas instrucciones para clonar el repositorio remoto de OpenShift en nuestro equipo.
</p>

<p style="padding-left: 30px;">
  <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift6.png"><img class="aligncenter size-full wp-image-1126" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift6.png" alt="openshift6" width="688" height="484" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift6.png 688w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift6-300x211.png 300w" sizes="(max-width: 688px) 100vw, 688px" /></a>
</p>

<p style="padding-left: 30px;">
  3) Podemos seguir añadiendo nuevos cartridges a nuestro gear, como por ejemplo añadir el cartridge MySQL 5.5 para ofrecer el servicio de base de datos a nuestra aplicación.
</p>

<p style="padding-left: 30px;">
  <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift7.png"><img class="aligncenter size-full wp-image-1127" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift7.png" alt="openshift7" width="1168" height="497" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift7.png 1168w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift7-300x127.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift7-1024x435.png 1024w" sizes="(max-width: 1168px) 100vw, 1168px" /></a>
</p>

<p style="padding-left: 30px;">
  Como vemos en la imagen nos ofrecen el nombre de usuario y la contraseña del usuario de mysql. La dirección IP y el puerto del servidor mysql nos lo ofrece en una variable de entono del sistema ($OPENSHIFT_MYSQL_DB_HOST y $OPENSHIFT_MYSQL_DB_PORT).
</p>

### Creación de un alias

Como hemos dicho anteriormente, no vamos a utilizar la url por defecto que se configuró al crear el gear (http://moodle-pledin.rhcloud.com). Vamos a utilizar la url [plataforma.josedomingo.org](http://plataforma.josedomingo.org) para acceder a nuestra aplicación, para ello tenemos que crear un alias: pulsamos la opción _&#8220;change&#8221;_ que encontramos junto al nombre del gear, y creamos un nuevo alias:

[<img class="aligncenter size-full wp-image-1128" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift8.png" alt="openshift8" width="913" height="283" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift8.png 913w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift8-300x92.png 300w" sizes="(max-width: 913px) 100vw, 913px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift8.png){.thumbnail}

### Despliegue de moodle {#despliegue-de-wordpress}

Ya tenemos nuestro gear preparado, a continuación nos tenemos que bajar la última versión de moodle y sincronizar los ficheros en nuestro repositorio git (el repositorio git lo hemos clonado en el directorio _moodle_ y vamos a copiar los ficheros de moodle al directorio _moodle/pledin_).

    $ wget https://download.moodle.org/download.php/stable28/moodle-latest-28.zip
    $ unzip moodle-latest-28.zip
    $ cp -R moodle/* moodle/pledin
    $ cd moodle 
    ~/moodle$ git add * 
    ~/moodle$ git commit -m "Despliegue inicial de moodle" 
    ~/moodle$ git push 

Vamos a crear un fichero de configuración de moodle utilizando las variables de entornos que tenemos a nuestra disposición en nuestro gear, de este modo:

    ~/moodle$ cd pledin
    ~/moodle/pledin$ nano config.php 

Y quedaría con este contenido:

<pre>&lt;?php // Moodle configuration file
unset($CFG);
global $CFG;
$CFG = new stdClass();
$CFG-&gt;dbtype = 'mysqli';
$CFG-&gt;dblibrary = 'native';
<strong>$CFG-&gt;dbhost = $_ENV['OPENSHIFT_DB_HOST'];
$CFG-&gt;dbname = $_ENV['OPENSHIFT_APP_NAME'];
$CFG-&gt;dbuser = $_ENV['OPENSHIFT_MYSQL_DB_USERNAME'];
$CFG-&gt;dbpass = $_ENV['OPENSHIFT_MYSQL_DB_PASSWORD'];</strong>
$CFG-&gt;prefix = 'mdl_';
$CFG-&gt;dboptions = array (
 'dbpersist' =&gt; 0,
 'dbport' =&gt; '',
 'dbsocket' =&gt; '',
);
<strong>$CFG-&gt;wwwroot = 'http://plataforma.josedomingo.org/pledin';
$CFG-&gt;dataroot = '/var/lib/openshift/54875bc55973ca9be00001e6/app-root/runtime/data/moodledata';</strong>
$CFG-&gt;admin = 'admin';
$CFG-&gt;directorypermissions = 0777;
require_once(dirname(__FILE__) . '/lib/setup.php');
// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!</pre>

Posteriormente añadimos este nuevo fichero a nuestro repositorio git:

    ~/moodle/pledin$ git add config.php
    ~/moodle/pledin$ git commit -m "Fichero de configuración de moodle" 
    ~/moodle/pledin$ git push 

Y ya podemos terminar la instalación y configurar nuestra plataforma moodle.

### Automatizar tareas usando el cron

Para poder ejecutar tareas automatizadas en nuestro proyecto tenemos que instalar en nuestro gear el cartridge **Cron 1.4.** 

[<img class="aligncenter size-full wp-image-1129" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift9.png" alt="openshift9" width="1152" height="290" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift9.png 1152w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift9-300x75.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift9-1024x257.png 1024w" sizes="(max-width: 1152px) 100vw, 1152px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift9.png){.thumbnail}

Vamos a programar dos tareas con el cron:

  1. Ejecutar el cron de moodle una vez al día.
  2. Crear diariamente una copia de seguridad de la base de datos con la utilidad mysqldump.

Para ello vamos a crear un script _cron.sh_ en el directorio de nuestro repositorio local _.openshif/cron/daily_, con el siguiente contenido:

<pre>#!/bin/bash
php  ${OPENSHIFT_HOMEDIR}/app-root/repo/pledin/admin/cli/cron.php  &gt;&gt; ${OPENSHIFT_PHP_LOG_DIR}/cron.log
mysqldump --password=$OPENSHIFT_MYSQL_DB_PASSWORD -h $OPENSHIFT_MYSQL_DB_HOST -P $OPENSHIFT_MYSQL_DB_PORT -u $OPENSHIFT_MYSQL_DB_USERNAME $OPENSHIFT_GEAR_NAME --add-drop-table &gt; $OPENSHIFT_DATA_DIR/$OPENSHIFT_GEAR_NAME.sql</pre>

A continuación le damos permiso de ejecución y lo subimos a nuestro repositorio de openshift:

    ~/moodle/pledin/.openshift/cron/daily$ chmod +x cron.sh
    ~/moodle/pledin/.openshift/cron/daily$ git add cron.sh
    ~/moodle/pledin/.openshift/cron/daily$ git commit -m "tarea cron"
    ~/moodle/pledin/.openshift/cron/daily$ git push

## Redireccionar a las nuevas url

Lamentable al restaurar los cursos moodle se pierde el código identificador, que identifica a cada uno de los cursos, y que podemos ver cómo parámetro GET al acceder al curso, por ejemplo _http://www.josedomingo.org/web/course/view.php?id=64_, este curso es el 64 de la antigua plataforma, pero en la nueva plataforma va a tener otro id. Del mismo modo la referencia a los distintos recursos dentro de los cursos se pierde ya que de la misma manera se empiezan a numerar el código cada vez que restauramos los cursos.

Hay que tener en cuenta las siguientes cuestiones:

  *  La URL de la antigua moodle es http://www.josedomingo.org/web/, queremos mantener esta URL para redireccionar a las nuevas URL: _http://plataforma.josedomingo.org y http://pledin.gnomio.com._
  *  Cómo contaremos en el siguiente artículo, el blog wordpress lo vamos a migrar utilizando la misma URL www.josedomingo.org, por lo que es en esta página en donde tengo que crear un directorio _web_ donde alojaremos el script necesario para hacer la redirección.
  * Sin embargo en OpenShift, al crear un directorio llamado _web_ dentro del repositorio git, lo configura como DocumentRoot del servidor web, según la documentación <https://blog.openshift.com/openshift-online-march-2014-release-blog/>

> <p style="padding-left: 30px;">
>   The DocumentRoot is chosen by the cartridge control script logic depending on conditions in the following order:
> </p>
> 
> <p style="padding-left: 30px;">
>   IF php/ dir exists THEN DocumentRoot=php/<br /> ELSE IF public/ dir exists THEN DocumentRoot=public/<br /> ELSE IF public_html/ dir exists THEN DocumentRoot=public_html/<br /> ELSE IF web/ dir exists THEN DocumentRoot=web/<br /> ELSE IF www/ dir exists THEN DocumentRoot=www/<br /> ELSE DocumentRoot=/
> </p>

  * Solución: voy a utilizar un fichero de configuración de apache _**.htacces**_ para reescribir todas las URL que accedan al directorio _web_, para que redireccionen a un directorio llamado _web2_ que es donde estará nuestro script de redirección

<p style="padding-left: 30px;">
  El fichero .htacces que pondremos en la raíz del servidor quedará de esta forma:
</p>

<pre>RewriteEngine On
RewriteBase /
RewriteRule web/(.*)$ web2/$1
</pre>

Y el fichero que realizar la redirección a las nuevas url se llamara _view.php_, y estará localizado en el directorio _web2/course_ de nuestro gear donde instalaremos el blog wordpress:

<pre>&lt;?php
//Relación entre los identificadores de la antigua plataforma y de la nueva plataforma de openshift
$courses=array(4=&gt;4,18=&gt;5,23=&gt;6,28=&gt;7,31=&gt;8,43=&gt;9,46=&gt;10,48=&gt;11,51=&gt;12,60=&gt;13,63=&gt;14,64=&gt;15,65=&gt;16,66=&gt;17,67=&gt;18,68=&gt;19,69=&gt;20,70=&gt;21,71=&gt;22,41=&gt;23);
//Relación entre los identificadores de la antigua plataforma y de la nueva plataforma de gnomio
$oldcourses=array(2=&gt;2,40=&gt;3,39=&gt;4,38=&gt;5,17=&gt;6,34=&gt;7,56=&gt;8,58=&gt;9,53=&gt;10,52=&gt;11,50=&gt;12,49=&gt;13,5=&gt;14,6=&gt;15,12=&gt;16,14=&gt;17,20=&gt;18,21=&gt;19,37=&gt;20,26=&gt;21,10=&gt;22,9=&gt;25,15=&gt;27,27=&gt;28,44=&gt;31,22=&gt;32,42=&gt;33,13=&gt;34,25=&gt;35);
//Si el parámetro GET es una clave del array asociativo $courses redireccionamos a plataforma.josedomingo.org con el nuevo identificador
if (array_key_exists($_GET["id"],$courses))
 header("Location:http://plataforma.josedomingo.org/pledin/course/view.php?id=".$courses[$_GET["id"]]);
//Si el parámetro GET es una clave del array asociativo $oldcourses redireccionamos a pledin.gnomio.com con el nuevo identificado
elseif (array_key_exists($_GET["id"],$oldcourses))
 header("Location:http://pledin.gnomio.com/course/view.php?id=".$oldcourses[$_GET["id"]]);
else
//Si no se cumplen las dos anteriores condiciones redicreccionamos a plataforma.josedomingo.org
 header("Location:http://plataforma.josedomingo.org/pledin/");
?&gt;</pre>

# Conclusiones

La migración de la plataforma moodle ha sido complicada, por distintos factores:

  1. Un CMS que ocupa en su última versión casi 150 Mb, tiene demasiado tamaño, al menos para lo que yo lo he estado utilizando. Hay que tener en cuenta que cuando se sube a openshift tenemos dos copias del repositorio git, por lo que el tamaño se duplica.
  2. Desde la versión 2 de moodle el almacenamiento de ficheros en el directorio moodledata ha cambiado: <http://www.enovation.ie/blog/2011/01/moodle-2-0-file-storage/>, con lo que se ha perdido el control de los ficheros que están almacenados en cada curso.

Finalmente para que podamos acceder a nuestra nueva página desde internet tenemos que crear un nuevo registro CNAME en nuestro servidor DNS que relacione el nombre _plataforma_ con el nombre del gear _moodle-pledin.rhcloud.com_.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->