---
layout: post
status: publish
published: true
title: 'Migrando Pledin. De hosting tradicional a PaaS OpenShift: Moodle'
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1085
wordpress_url: http://www.josedomingo.org/pledin/?p=1085
date: '2014-12-10 13:52:38 +0000'
date_gmt: '2014-12-10 12:52:38 +0000'
categories:
- General
tags:
- Pledin
- Moodle
- OpenShift
- Hosting
- PaaS
comments: []
---
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/moodle.jpeg"><img class="size-full wp-image-1131 aligncenter" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/moodle.jpeg" alt="moodle" width="416" height="121" /></a>En estos d&iacute;as estoy llevando a cabo la migraci&oacute;n de mis p&aacute;ginas web de un hosting tradicional a una infraestructura PaaS como es OpenShift. Adem&aacute;s de algunas p&aacute;ginas est&aacute;ticas, mi plataforma se basa en dos CMS: un blog realizado en WordPress y una plataforma educativa realizada con Moodle. En este primer art&iacute;culo voy a explicar las diferentes decisiones que he tomado para realizar la migraci&oacute;n de la plataforma moodle.</p>
<h2>Mi plataforma educativa Moodle</h2>
<p>Haciendo un poco de historia tengo que decir que la plataforma Moodle es el primer CMS que utilic&eacute; para ir recopilando cursos e informaci&oacute;n sobre temas de inform&aacute;tica y educaci&oacute;n. En octubre de 2005 empec&eacute; este proyecto con una moodle versi&oacute;n 1.4, y despu&eacute;s de m&aacute;s de 9 a&ntilde;os y unas cuantas actualizaciones y migraciones, 59 cursos y m&aacute;s de 700 usuarios registrado, el directorio moodledata ocupa casi 2Gb de informaci&oacute;n. Por lo tanto la primera decisi&oacute;n que he tomado es hacer una instalaci&oacute;n nueva de la &uacute;ltima versi&oacute;n de moodle. Adem&aacute;s en esta moodle (<a href="http://plataforma.josedomingo.org">http://plataforma.josedomingo.org</a>) s&oacute;lo voy a poner los cursos m&aacute;s interesantes y actualizados que tengo en la plataforma, y los m&aacute;s antiguos y desactualizados lo voy a subir a una plataforma que he creado en la p&aacute;gina <a href="http://www.gnomio.com">www.gnomio.com</a>, plataforma que te ofrece la posibilidad de crear una moodle de forma gratuita.</p>
<p>Por lo tanto despu&eacute;s de un buen rato he conseguido hacer las copias de seguridad de todos los cursos, y he restaurado en la moodle de cursos antiguos (<a href="http://pledin.gnomio.com">http://pledin.gnomio.com</a>) los cursos m&aacute;s antiguos y desactualizados. Todos estos cursos tendr&aacute;n acceso gratuito a los invitados de la plataforma, por lo tanto no va a ser necesario el registro de usuarios. Adem&aacute;s uno de las preocupaciones que tengo es mantener la relaci&oacute;n entre la antigua URL de acceso a los cursos con las nuevas URL, para ello he apuntado la relaci&oacute;n de los identificadores de lo cursos en la plataforma actual y el identificador en esta nueva plataforma, posteriormente explicar&eacute; c&oacute;mo voy a mantener la relaci&oacute;n entre las url.<!--more--></p>
<h2>Instalaci&oacute;n de moodle en OpenShift Online</h2>
<p>En este punto vamos a explicar los pasos que he seguido para desplegar la aplicaci&oacute;n web Moodle en OpenShift Online.</p>
<h3 id="conceptos-previos">Conceptos previos</h3>
<ul>
<li><strong>Gear</strong>: Es un contenedor dentro de una m&aacute;quina virtual con unos recursos limitados para que pueda ejecutar sus aplicaciones un usuario de OpenShift. En el caso de utilizar una cuenta gratuita se pueden crear como m&aacute;ximo tres gears de tipo &ldquo;small&rdquo;, cada uno de ellos puede utilizar un m&aacute;ximo de 512MB de RAM, 100MB de swap y 1GB de espacio en disco. Nuestra aplicaci&oacute;n se desplegar&aacute; y ejecutar&aacute; utilizando estos recursos asociados al &ldquo;gear&rdquo;.</li>
<li><strong>Cartridge</strong>: Son contenedores de software preparados para ejecutarse en un gear. En principio sobre cada gear pueden desplegarse varios cartridges, por ejemplo existen cartridges de php, ruby, jboss, MySQL, django, etc.</li>
</ul>
<h3 id="acceso-a-openshift-online-y-configuracin-inicial">Acceso a OpenShift Online y configuraci&oacute;n inicial</h3>
<p>Accedemos a la URL <a href="https://www.openshift.com/">https://www.openshift.com/</a>, nos damos de alta y accedemos con nuestra cuenta.</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift1.png"><img class="aligncenter  wp-image-1121" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift1.png" alt="openshift1" width="551" height="249" /></a></p>
<p>Cada cuenta de usuario en OpenShift Online est&aacute; asociada a un &ldquo;espacio de nombres&rdquo; para generar un FQDN &uacute;nico para cada gear. En la configuraci&oacute;n inicial de la cuenta habr&aacute; que seleccionar un espacio de nombres que sea &uacute;nico, este espacio de nombres se aplicar&aacute; autom&aacute;ticamente a todos los gears que se creen. En mi caso el espacio de nombres en OpenShift Online va a ser &ldquo;pledin&rdquo; y el gear que vamos a crear se va a llamar "moodle", entonces esta aplicaci&oacute;n ser&aacute; accesible a trav&eacute;s de la url http://moodle-pledin.rhcloud.com.Sin embargo, y como veremos posteriormente nosotros vamos a utilizar un nombre de host <a href="http://plataforma.josedomingo.org">plataforma.josedomingo.org</a> para acceder a nuestra aplicaci&oacute;n.</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift2.png"><img class="aligncenter size-full wp-image-1122" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift2.png" alt="openshift2" width="612" height="219" /></a></p>
<h3 id="acceso-por-ssh">Acceso por ssh</h3>
<p>Una de las caracter&iacute;sticas interesantes que proporciona OpenShift es la posibilidad de acceder por ssh a la m&aacute;quina en la que se est&aacute; ejecutando nuestra aplicaci&oacute;n web, aunque con un usuario con privilegios restringidos.</p>
<p>El acceso remoto a nuestras aplicaciones se hace usando el protocolo SSH. El mecanismo usado para la autentificaci&oacute;n ssh es usando claves p&uacute;blicas ssh, y es necesario indicar las claves p&uacute;blicas ssh que queramos usar para poder acceder de forma remota. Adem&aacute;s tambi&eacute;n es necesario hacer esta configuraci&oacute;n para poder trabajar con el repositorio Git que tenemos a nuestra disposici&oacute;n. Si no posees un par de claves ssh, puedes generar un par de claves rsa, usando el siguiente comando:</p>
<pre><code>$ ssh-keygen
</code></pre>
<p>Por defecto en el directorio ~/.ssh, se generan la clave p&uacute;blica y la privada: id_rsa.pub y id_rsa. El contenido del fichero id_rsa.pub es el que tienes que subir a OpenShift.</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift3.png"><img class="aligncenter size-full wp-image-1123" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift3.png" alt="openshift3" width="993" height="250" /></a></p>
<h3 id="creando-nuestra-aplicacin">Creando nuestra aplicaci&oacute;n</h3>
<p>Durante el proceso de creaci&oacute;n de una nueva aplicaci&oacute;n, tenemos que configurar los siguientes elementos:</p>
<p style="padding-left: 30px;">1) Elegir el cartridge (paquete de software) que necesitas para la implantaci&oacute;n de tu aplicaci&oacute;n web. En el caso de Moodle podemos elegir el componente PHP 5.4.</p>
<p style="padding-left: 30px;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift4.png"><img class="aligncenter size-full wp-image-1124" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift4.png" alt="openshift4" width="949" height="984" /></a></p>
<p style="padding-left: 30px;">2) Debemos elegir la URL de acceso, teniendo en cuenta el espacio de nombres que hab&iacute;amos configurado.</p>
<p style="padding-left: 30px;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift5.png"><img class="aligncenter size-full wp-image-1125" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift5.png" alt="openshift5" width="980" height="735" /></a></p>
<p style="padding-left: 30px;">Una vez que se ha creado la aplicaci&oacute;n (gear), se nos ofrece informaci&oacute;n del repositorio Git que podemos clonar a nuestro equipo local para poder subir los ficheros al gear. Procedemos a seguir estas instrucciones para clonar el repositorio remoto de OpenShift en nuestro equipo.</p>
<p style="padding-left: 30px;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift6.png"><img class="aligncenter size-full wp-image-1126" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift6.png" alt="openshift6" width="688" height="484" /></a></p>
<p style="padding-left: 30px;">3) Podemos seguir a&ntilde;adiendo nuevos cartridges a nuestro gear, como por ejemplo a&ntilde;adir el cartridge MySQL 5.5 para ofrecer el servicio de base de datos a nuestra aplicaci&oacute;n.</p>
<p style="padding-left: 30px;"><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift7.png"><img class="aligncenter size-full wp-image-1127" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift7.png" alt="openshift7" width="1168" height="497" /></a></p>
<p style="padding-left: 30px;">Como vemos en la imagen nos ofrecen el nombre de usuario y la contrase&ntilde;a del usuario de mysql. La direcci&oacute;n IP y el puerto del servidor mysql nos lo ofrece en una variable de entono del sistema ($OPENSHIFT_MYSQL_DB_HOST y $OPENSHIFT_MYSQL_DB_PORT).</p>
<h3>Creaci&oacute;n de un alias</h3>
<p>Como hemos dicho anteriormente, no vamos a utilizar la url por defecto que se configur&oacute; al crear el gear (http://moodle-pledin.rhcloud.com). Vamos a utilizar la url <a href="http://plataforma.josedomingo.org">plataforma.josedomingo.org</a> para acceder a nuestra aplicaci&oacute;n, para ello tenemos que crear un alias: pulsamos la opci&oacute;n <em>"change" </em>que encontramos junto al nombre del gear, y creamos un nuevo alias:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift8.png"><img class="aligncenter size-full wp-image-1128" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift8.png" alt="openshift8" width="913" height="283" /></a></p>
<h3 id="despliegue-de-wordpress">Despliegue de moodle</h3>
<p>Ya tenemos nuestro gear preparado, a continuaci&oacute;n nos tenemos que bajar la &uacute;ltima versi&oacute;n de moodle y sincronizar los ficheros en nuestro repositorio git (el repositorio git lo hemos clonado en el directorio <em>moodle </em>y vamos a copiar los ficheros de moodle al directorio <em>moodle/pledin</em>).</p>
<pre><code>$ wget https://download.moodle.org/download.php/stable28/moodle-latest-28.zip
$ unzip moodle-latest-28.zip
$ cp -R moodle/* moodle/pledin
$ cd moodle 
~/moodle$ git add * 
~/moodle$ git commit -m "Despliegue inicial de moodle" 
~/moodle$ git push </code></pre>
<p>Vamos a crear un fichero de configuraci&oacute;n de moodle utilizando las variables de entornos que tenemos a nuestra disposici&oacute;n en nuestro gear, de este modo:</p>
<pre><code>~/moodle$ cd pledin
~/moodle/pledin$ nano config.php </code></pre>
<p>Y quedar&iacute;a con este contenido:</p>
<pre><?php // Moodle configuration file
unset($CFG);
global $CFG;
$CFG = new stdClass();
$CFG->dbtype = 'mysqli';
$CFG->dblibrary = 'native';
<strong>$CFG->dbhost = $_ENV['OPENSHIFT_DB_HOST'];
$CFG->dbname = $_ENV['OPENSHIFT_APP_NAME'];
$CFG->dbuser = $_ENV['OPENSHIFT_MYSQL_DB_USERNAME'];
$CFG->dbpass = $_ENV['OPENSHIFT_MYSQL_DB_PASSWORD'];</strong>
$CFG->prefix = 'mdl_';
$CFG->dboptions = array (
 'dbpersist' => 0,
 'dbport' => '',
 'dbsocket' => '',
);
<strong>$CFG->wwwroot = 'http://plataforma.josedomingo.org/pledin';
$CFG->dataroot = '/var/lib/openshift/54875bc55973ca9be00001e6/app-root/runtime/data/moodledata';</strong>
$CFG->admin = 'admin';
$CFG->directorypermissions = 0777;
require_once(dirname(__FILE__) . '/lib/setup.php');
// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!</pre>
<p>Posteriormente a&ntilde;adimos este nuevo fichero a nuestro repositorio git:</p>
<pre><code>~/moodle/pledin$ git add config.php
~/moodle/pledin$ git commit -m "Fichero de configuraci&oacute;n de moodle" 
~/moodle/pledin$ git push </code></pre>
<p>Y ya podemos terminar la instalaci&oacute;n y configurar nuestra plataforma moodle.</p>
<h3>Automatizar tareas usando el cron</h3>
<p>Para poder ejecutar tareas automatizadas en nuestro proyecto tenemos que instalar en nuestro gear el cartridge <strong>Cron 1.4. </strong></p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift9.png"><img class="aligncenter size-full wp-image-1129" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/openshift9.png" alt="openshift9" width="1152" height="290" /></a></p>
<p>Vamos a programar dos tareas con el cron:</p>
<ol>
<li>Ejecutar el cron de moodle una vez al d&iacute;a.</li>
<li>Crear diariamente una copia de seguridad de la base de datos con la utilidad mysqldump.</li>
</ol>
<p>Para ello vamos a crear un script <em>cron.sh</em> en el directorio de nuestro repositorio local <em>.openshif/cron/daily</em>, con el siguiente contenido:</p>
<pre>#!/bin/bash
php&nbsp; ${OPENSHIFT_HOMEDIR}/app-root/repo/pledin/admin/cli/cron.php&nbsp; >> ${OPENSHIFT_PHP_LOG_DIR}/cron.log
mysqldump --password=$OPENSHIFT_MYSQL_DB_PASSWORD -h $OPENSHIFT_MYSQL_DB_HOST -P $OPENSHIFT_MYSQL_DB_PORT -u $OPENSHIFT_MYSQL_DB_USERNAME $OPENSHIFT_GEAR_NAME --add-drop-table > $OPENSHIFT_DATA_DIR/$OPENSHIFT_GEAR_NAME.sql</pre>
<p>A continuaci&oacute;n le damos permiso de ejecuci&oacute;n y lo subimos a nuestro repositorio de openshift:</p>
<pre><code>~/moodle/pledin/.openshift/cron/daily$ </code>chmod +x cron.sh
<code>~/moodle/pledin/.openshift/cron/daily$ </code>git add cron.sh
<code>~/moodle/pledin/.openshift/cron/daily$</code> git commit -m "tarea cron"
<code>~/moodle/pledin/.openshift/cron/daily$</code> git push</pre>
<h2>Redireccionar a las nuevas url</h2>
<p>Lamentable al restaurar los cursos moodle se pierde el c&oacute;digo identificador, que identifica a cada uno de los cursos, y que podemos ver c&oacute;mo par&aacute;metro GET al acceder al curso, por ejemplo <em>http://www.josedomingo.org/web/course/view.php?id=64</em>, este curso es el 64 de la antigua plataforma, pero en la nueva plataforma va a tener otro id. Del mismo modo la referencia a los distintos recursos dentro de los cursos se pierde ya que de la misma manera se empiezan a numerar el c&oacute;digo cada vez que restauramos los cursos.</p>
<p>Hay que tener en cuenta las siguientes cuestiones:</p>
<ul>
<li>&nbsp;La URL de la antigua moodle es http://www.josedomingo.org/web/, queremos mantener esta URL para redireccionar a las nuevas URL: <em>http://plataforma.josedomingo.org y http://pledin.gnomio.com.</em></li>
<li>&nbsp;C&oacute;mo contaremos en el siguiente art&iacute;culo, el blog wordpress lo vamos a migrar utilizando la misma URL www.josedomingo.org, por lo que es en esta p&aacute;gina en donde tengo que crear un directorio <em>web</em> donde alojaremos el script necesario para hacer la redirecci&oacute;n.</li>
<li>Sin embargo en OpenShift, al crear un directorio llamado <em>web</em> dentro del repositorio git, lo configura como DocumentRoot del servidor web, seg&uacute;n la documentaci&oacute;n <a href="https://blog.openshift.com/openshift-online-march-2014-release-blog/">https://blog.openshift.com/openshift-online-march-2014-release-blog/</a></li>
</ul>
<blockquote>
<p style="padding-left: 30px;">The DocumentRoot is chosen by the cartridge control script logic depending on conditions in the following order:</p>
<p style="padding-left: 30px;">IF php/ dir exists THEN DocumentRoot=php/<br />
ELSE IF public/ dir exists THEN DocumentRoot=public/<br />
ELSE IF public_html/ dir exists THEN DocumentRoot=public_html/<br />
ELSE IF web/ dir exists THEN DocumentRoot=web/<br />
ELSE IF www/ dir exists THEN DocumentRoot=www/<br />
ELSE DocumentRoot=/</p>
</blockquote>
<ul>
<li>Soluci&oacute;n: voy a utilizar un fichero de configuraci&oacute;n de apache <em><strong>.htacces</strong></em> para reescribir todas las URL que accedan al directorio <em>web</em>, para que redireccionen a un directorio llamado <em>web2</em> que es donde estar&aacute; nuestro script de redirecci&oacute;n</li>
</ul>
<p style="padding-left: 30px;">El fichero .htacces que pondremos en la ra&iacute;z del servidor quedar&aacute; de esta forma:</p>
<pre>RewriteEngine On
RewriteBase /
RewriteRule web/(.*)$ web2/$1
</pre>
<p>Y el fichero que realizar la redirecci&oacute;n a las nuevas url se llamara <em>view.php</em>, y estar&aacute; localizado en el directorio <em>web2/course</em> de nuestro gear donde instalaremos el blog wordpress:</p>
<pre><?php
//Relaci&oacute;n entre los identificadores de la antigua plataforma y de la nueva plataforma de openshift
$courses=array(4=>4,18=>5,23=>6,28=>7,31=>8,43=>9,46=>10,48=>11,51=>12,60=>13,63=>14,64=>15,65=>16,66=>17,67=>18,68=>19,69=>20,70=>21,71=>22,41=>23);
//Relaci&oacute;n entre los identificadores de la antigua plataforma y de la nueva plataforma de gnomio
$oldcourses=array(2=>2,40=>3,39=>4,38=>5,17=>6,34=>7,56=>8,58=>9,53=>10,52=>11,50=>12,49=>13,5=>14,6=>15,12=>16,14=>17,20=>18,21=>19,37=>20,26=>21,10=>22,9=>25,15=>27,27=>28,44=>31,22=>32,42=>33,13=>34,25=>35);
//Si el par&aacute;metro GET es una clave del array asociativo $courses redireccionamos a plataforma.josedomingo.org con el nuevo identificador
if (array_key_exists($_GET["id"],$courses))
 header("Location:http://plataforma.josedomingo.org/pledin/course/view.php?id=".$courses[$_GET["id"]]);
//Si el par&aacute;metro GET es una clave del array asociativo $oldcourses redireccionamos a pledin.gnomio.com con el nuevo identificado
elseif (array_key_exists($_GET["id"],$oldcourses))
 header("Location:http://pledin.gnomio.com/course/view.php?id=".$oldcourses[$_GET["id"]]);
else
//Si no se cumplen las dos anteriores condiciones redicreccionamos a plataforma.josedomingo.org
 header("Location:http://plataforma.josedomingo.org/pledin/");
?></pre>
<h1>Conclusiones</h1>
<p>La migraci&oacute;n de la plataforma moodle ha sido complicada, por distintos factores:</p>
<ol>
<li>Un CMS que ocupa en su &uacute;ltima versi&oacute;n casi 150 Mb, tiene demasiado tama&ntilde;o, al menos para lo que yo lo he estado utilizando. Hay que tener en cuenta que cuando se sube a openshift tenemos dos copias del repositorio git, por lo que el tama&ntilde;o se duplica.</li>
<li>Desde la versi&oacute;n 2 de moodle el almacenamiento de ficheros en el directorio moodledata ha cambiado: <a href="http://www.enovation.ie/blog/2011/01/moodle-2-0-file-storage/">http://www.enovation.ie/blog/2011/01/moodle-2-0-file-storage/</a>, con lo que se ha perdido el control de los ficheros que est&aacute;n almacenados en cada curso.</li>
</ol>
<p>Finalmente para que podamos acceder a nuestra nueva p&aacute;gina desde internet tenemos que crear un nuevo registro CNAME en nuestro servidor DNS que relacione el nombre <em>plataforma </em>con el nombre del gear<em> moodle-pledin.rhcloud.com</em>.</p>
