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
![pledin]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/moodle.jpeg)

En estos días estoy llevando a cabo la migración de mis páginas web de un hosting tradicional a una infraestructura PaaS como es OpenShift. Además de algunas páginas estáticas, mi plataforma se basa en dos CMS: un blog realizado en WordPress y una plataforma educativa realizada con Moodle. En este primer artículo voy a explicar las diferentes decisiones que he tomado para realizar la migración de la plataforma moodle.

## Mi plataforma educativa Moodle

Haciendo un poco de historia tengo que decir que la plataforma Moodle es el primer CMS que utilicé para ir recopilando cursos e información sobre temas de informática y educación. En octubre de 2005 empecé este proyecto con una moodle versión 1.4, y después de más de 9 años y unas cuantas actualizaciones y migraciones, 59 cursos y más de 700 usuarios registrado, el directorio moodledata ocupa casi 2Gb de información. Por lo tanto la primera decisión que he tomado es hacer una instalación nueva de la última versión de moodle. Además en esta moodle (<http://plataforma.josedomingo.org>) sólo voy a poner los cursos más interesantes y actualizados que tengo en la plataforma, y los más antiguos y desactualizados lo voy a subir a una plataforma que he creado en la página [www.gnomio.com](http://www.gnomio.com), plataforma que te ofrece la posibilidad de crear una moodle de forma gratuita.

Por lo tanto después de un buen rato he conseguido hacer las copias de seguridad de todos los cursos, y he restaurado en la moodle de cursos antiguos (<http://pledin.gnomio.com>) los cursos más antiguos y desactualizados. Todos estos cursos tendrán acceso gratuito a los invitados de la plataforma, por lo tanto no va a ser necesario el registro de usuarios. Además uno de las preocupaciones que tengo es mantener la relación entre la antigua URL de acceso a los cursos con las nuevas URL, para ello he apuntado la relación de los identificadores de lo cursos en la plataforma actual y el identificador en esta nueva plataforma, posteriormente explicaré cómo voy a mantener la relación entre las url.

## Instalación de moodle en OpenShift Online

En este punto vamos a explicar los pasos que he seguido para desplegar la aplicación web Moodle en OpenShift Online.

### Conceptos previos {#conceptos-previos}

* **Gear**: Es un contenedor dentro de una máquina virtual con unos recursos limitados para que pueda ejecutar sus aplicaciones un usuario de OpenShift. En el caso de utilizar una cuenta gratuita se pueden crear como máximo tres gears de tipo “small”, cada uno de ellos puede utilizar un máximo de 512MB de RAM, 100MB de swap y 1GB de espacio en disco. Nuestra aplicación se desplegará y ejecutará utilizando estos recursos asociados al “gear”.
 * **Cartridge**: Son contenedores de software preparados para ejecutarse en un gear. En principio sobre cada gear pueden desplegarse varios cartridges, por ejemplo existen cartridges de php, ruby, jboss, MySQL, django, etc.

### Acceso a OpenShift Online y configuración inicial 

Accedemos a la URL <https://www.openshift.com/>, nos damos de alta y accedemos con nuestra cuenta.

![pledin]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift1.png)

Cada cuenta de usuario en OpenShift Online está asociada a un “espacio de nombres” para generar un FQDN único para cada gear. En la configuración inicial de la cuenta habrá que seleccionar un espacio de nombres que sea único, este espacio de nombres se aplicará automáticamente a todos los gears que se creen. En mi caso el espacio de nombres en OpenShift Online va a ser “pledin” y el gear que vamos a crear se va a llamar `moodle`, entonces esta aplicación será accesible a través de la url `http://moodle-pledin.rhcloud.com`. Sin embargo, y como veremos posteriormente nosotros vamos a utilizar un nombre de host [plataforma.josedomingo.org](http://plataforma.josedomingo.org) para acceder a nuestra aplicación.

![pledin]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift2.png)

### Acceso por ssh 

Una de las características interesantes que proporciona OpenShift es la posibilidad de acceder por ssh a la máquina en la que se está ejecutando nuestra aplicación web, aunque con un usuario con privilegios restringidos.

El acceso remoto a nuestras aplicaciones se hace usando el protocolo SSH. El mecanismo usado para la autentificación ssh es usando claves públicas ssh, y es necesario indicar las claves públicas ssh que queramos usar para poder acceder de forma remota. Además también es necesario hacer esta configuración para poder trabajar con el repositorio Git que tenemos a nuestra disposición. Si no posees un par de claves ssh, puedes generar un par de claves rsa, usando el siguiente comando:

    $ ssh-keygen

Por defecto en el directorio `~/.ssh`, se generan la clave pública y la privada: `id_rsa.pub` y `id_rsa`. El contenido del fichero `id_rsa.pub` es el que tienes que subir a OpenShift.

![pledin]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift3.png)

### Creando nuestra aplicación

Durante el proceso de creación de una nueva aplicación, tenemos que configurar los siguientes elementos:

1. Elegir el cartridge (paquete de software) que necesitas para la implantación de tu aplicación web. En el caso de Moodle podemos elegir el componente PHP 5.4.

![pledin]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift4.png)  

2. Debemos elegir la URL de acceso, teniendo en cuenta el espacio de nombres que habíamos configurado.

![pledin]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift5.png)

  Una vez que se ha creado la aplicación (gear), se nos ofrece información del repositorio Git que podemos clonar a nuestro equipo local para poder subir los ficheros al gear. Procedemos a seguir estas instrucciones para clonar el repositorio remoto de OpenShift en nuestro equipo.

![pledin](({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift6.png")

3. Podemos seguir añadiendo nuevos cartridges a nuestro gear, como por ejemplo añadir el cartridge MySQL 5.5 para ofrecer el servicio de base de datos a nuestra aplicación.

![pledin]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift7.png)

Como vemos en la imagen nos ofrecen el nombre de usuario y la contraseña del usuario de mysql. La dirección IP y el puerto del servidor mysql nos lo ofrece en una variable de entono del sistema ($OPENSHIFT_MYSQL_DB_HOST y $OPENSHIFT_MYSQL_DB_PORT).

### Creación de un alias

Como hemos dicho anteriormente, no vamos a utilizar la url por defecto que se configuró al crear el gear (`http://moodle-pledin.rhcloud.com`). Vamos a utilizar la url [`plataforma.josedomingo.org`](http://plataforma.josedomingo.org) para acceder a nuestra aplicación, para ello tenemos que crear un alias: pulsamos la opción _&#8220;change&#8221;_ que encontramos junto al nombre del gear, y creamos un nuevo alias:

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift8.png)

### Despliegue de moodle

Ya tenemos nuestro gear preparado, a continuación nos tenemos que bajar la última versión de moodle y sincronizar los ficheros en nuestro repositorio git (el repositorio git lo hemos clonado en el directorio `moodle` y vamos a copiar los ficheros de moodle al directorio `moodle/pledin`).

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

    <?php // Moodle configuration file
    unset($CFG);
    global $CFG;
    $CFG = new stdClass();
    $CFG->dbtype = 'mysqli';
    $CFG->dblibrary = 'native';
    $CFG->dbhost = $_ENV['OPENSHIFT_DB_HOST'];
    $CFG->dbname = $_ENV['OPENSHIFT_APP_NAME'];
    $CFG->dbuser = $_ENV['OPENSHIFT_MYSQL_DB_USERNAME'];
    $CFG->dbpass = $_ENV['OPENSHIFT_MYSQL_DB_PASSWORD'];
    $CFG->prefix = 'mdl_';
    $CFG->dboptions = array (
     'dbpersist' => 0,
     'dbport' => '',
     'dbsocket' => '',
    );
    $CFG->wwwroot = 'http://plataforma.josedomingo.org/pledin';
    $CFG->dataroot =    '/var/lib/openshift/54875bc55973ca9be00001e6/app-root/runtime/data/moodledata';
    $CFG->admin = 'admin';
    $CFG->directorypermissions = 0777;
    require_once(dirname(__FILE__) . '/lib/setup.php');
    // There is no php closing tag in this file,
    // it is intentional because it prevents trailing whitespace problems!

Posteriormente añadimos este nuevo fichero a nuestro repositorio git:

    ~/moodle/pledin$ git add config.php
    ~/moodle/pledin$ git commit -m "Fichero de configuración de moodle" 
    ~/moodle/pledin$ git push 

Y ya podemos terminar la instalación y configurar nuestra plataforma moodle.

### Automatizar tareas usando el cron

Para poder ejecutar tareas automatizadas en nuestro proyecto tenemos que instalar en nuestro gear el cartridge **Cron 1.4.** 

![pledin]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/openshift9.png)

Vamos a programar dos tareas con el cron:

1. Ejecutar el cron de moodle una vez al día.
2. Crear diariamente una copia de seguridad de la base de datos con la utilidad `mysqldump`.

Para ello vamos a crear un script `cron.sh` en el directorio de nuestro repositorio local `.openshif/cron/daily`, con el siguiente contenido:

    #!/bin/bash
    php  ${OPENSHIFT_HOMEDIR}/app-root/repo/pledin/admin/cli/cron.php  >> ${OPENSHIFT_PHP_LOG_DIR}    /cron.log
    mysqldump --password=$OPENSHIFT_MYSQL_DB_PASSWORD -h $OPENSHIFT_MYSQL_DB_HOST -P    $OPENSHIFT_MYSQL_DB_PORT -u $OPENSHIFT_MYSQL_DB_USERNAME $OPENSHIFT_GEAR_NAME   --add-drop-table > $OPENSHIFT_DATA_DIR/$OPENSHIFT_GEAR_NAME.sql

A continuación le damos permiso de ejecución y lo subimos a nuestro repositorio de openshift:

    ~/moodle/pledin/.openshift/cron/daily$ chmod +x cron.sh
    ~/moodle/pledin/.openshift/cron/daily$ git add cron.sh
    ~/moodle/pledin/.openshift/cron/daily$ git commit -m "tarea cron"
    ~/moodle/pledin/.openshift/cron/daily$ git push

## Redireccionar a las nuevas url

Lamentable al restaurar los cursos moodle se pierde el código identificador, que identifica a cada uno de los cursos, y que podemos ver cómo parámetro GET al acceder al curso, por ejemplo `http://www.josedomingo.org/web/course/view.php?id=64`, este curso es el 64 de la antigua plataforma, pero en la nueva plataforma va a tener otro id. Del mismo modo la referencia a los distintos recursos dentro de los cursos se pierde ya que de la misma manera se empiezan a numerar el código cada vez que restauramos los cursos.

Hay que tener en cuenta las siguientes cuestiones:

* La URL de la antigua moodle es `http://www.josedomingo.org/web/`, queremos mantener esta URL para redireccionar a las nuevas URL: `http://plataforma.josedomingo.org` y `http://pledin.gnomio.com`.
* Cómo contaremos en el siguiente artículo, el blog wordpress lo vamos a migrar utilizando la misma URL `www.josedomingo.org`, por lo que es en esta página en donde tengo que crear un directorio `web` donde alojaremos el script necesario para hacer la redirección.
* Sin embargo en OpenShift, al crear un directorio llamado `web` dentro del repositorio git, lo configura como `DocumentRoot` del servidor web, según la documentación <https://blog.openshift.com/openshift-online-march-2014-release-blog/>

>   The DocumentRoot is chosen by the cartridge control script logic depending on conditions in the following order:
>   IF php/ dir exists THEN DocumentRoot=php/
> ELSE IF public/ dir exists THEN DocumentRoot=public/
> ELSE IF public_html/ dir exists THEN DocumentRoot=public_html/
> ELSE IF web/ dir exists THEN DocumentRoot=web/
> ELSE IF www/ dir exists THEN DocumentRoot=www/
> ELSE DocumentRoot=/
 

* Solución: voy a utilizar un fichero de configuración de apache `**.htacces**` para reescribir todas las URL que accedan al directorio `web`, para que redireccionen a un directorio llamado `web2` que es donde estará nuestro script de redirección

El fichero `.htacces` que pondremos en la raíz del servidor quedará de esta forma:

    RewriteEngine On
    RewriteBase /
    RewriteRule web/(.*)$ web2/$1

Y el fichero que realizar la redirección a las nuevas url se llamara `view.php`, y estará localizado en el directorio `web2/course` de nuestro gear donde instalaremos el blog wordpress:

    <?php
    //Relación entre los identificadores de la antigua plataforma y de la nueva plataforma de openshift
    $courses=array(4=>4,18=>5,23=>6,28=>7,31=>8,43=>9,46=>10,48=>11,51=>12,60=>13,63=>14,64=>15,65=>16,66=>17,67=>18,68=>19,69=>20,70=>21,71=>22,41=>23);
    //Relación entre los identificadores de la antigua plataforma y de la nueva plataforma de gnomio
    $oldcourses=array(2=>2,40=>3,39=>4,38=>5,17=>6,34=>7,56=>8,58=>9,53=>10,52=>11,50=>12,49=>13,5=>14,6=>15,12=>16,14=>17,20=>18,21=>19,37=>20,26=>21,10=>22,9=>25,15=>27,27=>28,44=>31,  22=>32,42=>33,13=>34,25=>35);
    //Si el parámetro GET es una clave del array asociativo $courses redireccionamos a plataforma.josedomingo.org con el nuevo identificador
    if (array_key_exists($_GET["id"],$courses))
     header("Location:http://plataforma.josedomingo.org/pledin/course/view.php?id=".$courses[$_GET["id"]]);
    //Si el parámetro GET es una clave del array asociativo $oldcourses redireccionamos a pledin.gnomio.com con el nuevo identificado
    elseif (array_key_exists($_GET["id"],$oldcourses))
     header("Location:http://pledin.gnomio.com/course/view.php?id=".$oldcourses[$_GET["id"]]);
    else
    //Si no se cumplen las dos anteriores condiciones redicreccionamos a plataforma.josedomingo.org
     header("Location:http://plataforma.josedomingo.org/pledin/");
    ?>

## Conclusiones

La migración de la plataforma moodle ha sido complicada, por distintos factores:

1. Un CMS que ocupa en su última versión casi 150 Mb, tiene demasiado tamaño, al menos para lo que yo lo he estado utilizando. Hay que tener en cuenta que cuando se sube a openshift tenemos dos copias del repositorio git, por lo que el tamaño se duplica.
2. Desde la versión 2 de moodle el almacenamiento de ficheros en el directorio moodledata ha cambiado: <http://www.enovation.ie/blog/2011/01/moodle-2-0-file-storage/>, con lo que se ha perdido el control de los ficheros que están almacenados en cada curso.

Finalmente para que podamos acceder a nuestra nueva página desde internet tenemos que crear un nuevo registro CNAME en nuestro servidor DNS que relacione el nombre _plataforma_ con el nombre del gear _moodle-pledin.rhcloud.com_.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->