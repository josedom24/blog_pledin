---
id: 1140
title: 'Migrando Pledin. De hosting tradicional a PaaS OpenShift: WordPress'
date: 2014-12-11T20:20:28+00:00


guid: http://www.josedomingo.org/pledin/?p=1140
permalink: /2014/12/migrando-pledin-de-hosting-tradicional-a-paas-openshift-wordpress/


tags:
  - Hosting
  - OpenShift
  - PaaS
  - Pledin
  - wordpress
format: aside
---
![wp]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/wordpress.jpg)

En el [post anterior](http://www.josedomingo.org/pledin/2014/12/migrando-pledin-de-hosting-tradicional-a-paas-openshift-moodle/ "Migrando Pledin. De hosting tradicional a PaaS OpenShift: Moodle") comencé a explicar el proceso de migración de mis páginas web de un hosting tradicional a la infraestructura PaaS OpenShift que ofrece RedHat, más concretamente me centré en la migración de la plataforma moodle. En la entrada actual voy a explicar la migración del blog wordpress y para explicarlo voy a utilizar rhc, el cliente de línea de comandos que tenemos disponible para manejar nuestros proyectos en openshift. El blog está disponible en la dirección [www.josedomingo.org/pledin](http://www.josedomingo.org/pledin).

## Instalar OpenShift Client Tools

Como ya hemos visto en la [entrada anterior](http://www.josedomingo.org/pledin/2014/12/migrando-pledin-de-hosting-tradicional-a-paas-openshift-moodle/ "Migrando Pledin. De hosting tradicional a PaaS OpenShift: Moodle"), es posible crear un gear y añadir los cartridges a través de la web de OpenShift, ahora vamos a explicar la forma de hacerlo desde la línea de comandos del equipo cliente utilizando `rhc`. Las OpenShift Client Tools, conocidas como `rhc`, son unas aplicaciones escritas en Ruby y disponibles como gemas, por lo que la instalación en cualquier sistema es bastante sencilla: instalar `ruby`, `rubygems` y posteriormente instalar la gema `rhc`. En el caso de un sistema Debian sería algo como:

    root@equipo:~# apt-get install ruby rubygems git
    root@equipo:~# gem install rhc

Ya durante la instalación de rhc nos advierte que no hay una configuración previa, por lo que es necesario hacer una configuración de rhc.

## Configuración inicial de OpenShift Client Tools

Para realizar la configuración inicial de rhc, ejecutamos la instrucción:

    usuario@equipo:~$ rhc setup
    OpenShift Client Tools (RHC) Setup Wizard

    This wizard will help you upload your SSH keys, set your application namespace,
    and check that other programs like Git are properly installed.

    Login to openshift.redhat.com: [escribir correo-e]
    Password: ******

    Created local config file: /home/usuario/.openshift/express.conf
    The express.conf file contains user configuration, and can be transferred to
    different computers.

    We will now check to see if you have the necessary client tools installed.

    Checking for git ... found

    Checking for your namespace ... found namespace:

    Checking for applications ... None

    Thank you for setting up your system.  You can rerun this at any time by calling
    'rhc setup'.


## Creación de una nueva aplicación con rhc

Antes de crear nuestra nueva aplicación (gear) podemos obtener la lista de catridges que tenemos disponibles con la siguiente instrucción:

    $ rhc cartridge list
     jbossas-7                JBoss Application Server 7              web
     jboss-dv-6.0.0 (!)       JBoss Data Virtualization 6             web
     jbosseap-6 (*)           JBoss Enterprise Application Platform 6 web
     jboss-unified-push-1 (!) JBoss Unified Push Server 1.0.0.Beta1   web
     jenkins-1                Jenkins Server                          web
     nodejs-0.10              Node.js 0.10                            web
     perl-5.10                Perl 5.10                               web
     php-5.3                  PHP 5.3                                 web
     php-5.4                  PHP 5.4                                 web
     zend-6.1                 PHP 5.4 with Zend Server 6.1            web
     python-2.6               Python 2.6                              web
     python-2.7               Python 2.7                              web
     python-3.3               Python 3.3                              web
     ruby-1.8                 Ruby 1.8                                web
     ruby-1.9                 Ruby 1.9                                web
     ruby-2.0                 Ruby 2.0                                web
     jbossews-1.0             Tomcat 6 (JBoss EWS 1.0)                web
     jbossews-2.0             Tomcat 7 (JBoss EWS 2.0)                web
     jboss-vertx-2.1 (!)      Vert.x 2.1                              web
     jboss-wildfly-8 (!)      WildFly Application Server 8.1.0.Final  web
     diy-0.1                  Do-It-Yourself 0.1                      web
     10gen-mms-agent-0.1      10gen Mongo Monitoring Service Agent    addon
     cron-1.4                 Cron 1.4                                addon
     jenkins-client-1         Jenkins Client                          addon
     mongodb-2.4              MongoDB 2.4                             addon
     mysql-5.1                MySQL 5.1                               addon
     mysql-5.5                MySQL 5.5                               addon
     phpmyadmin-4             phpMyAdmin 4.0                          addon
     postgresql-8.4           PostgreSQL 8.4                          addon
     postgresql-9.2           PostgreSQL 9.2                          addon
     rockmongo-1.1            RockMongo 1.1                           addon
     switchyard-0             SwitchYard 0.8.0                        addon
     haproxy-1.4              Web Load Balancer                       addon

Y podemos crear un nuevo gear al que llamaremos _wordpress_ y basado en php 5.4:

    rhc create-app wordpress php-5.4
     Application Options
     -------------------
     Domain:     pledin
     Cartridges: php-5.4
     Gear Size:  default
     Scaling:    no
    Creating application 'wordpress' ... done
    Waiting for your DNS name to be available ... done
    Cloning into 'wordpress'...
    Your application 'wordpress' is now available.
    URL:        http://wordpress-pledin.rhcloud.com/
    SSH to:     xxxxxxxxxxxxxxxxxxxxxx@wordpress-pledin.rhcloud.com
    Git remote:     ssh://xxxxxxxxxxxxxxxxxxxx@wordpress-pledin.rhcloud.com/~/git/wordpress.git/

    Run 'rhc show-app wordpress' for more details about your app.

La instrucción ha creado el nuevo gear _wordpress_ y ha clonado el repositorio git en la carpeta con el mismo nombre. A continuación instalamos el cartridge mysql-5.5 en nuestro gear:

    $ rhc cartridge-add mysql-5.5 --app wordpress
     Adding mysql-5.5 to application 'wordpress' ... done
    mysql-5.5 (MySQL 5.5)
     ---------------------
     Gears:          Located with php-5.4
     Connection URL:    mysql://$OPENSHIFT_MYSQL_DB_HOST:$OPENSHIFT_MYSQL_DB_PORT/
     Database Name:  wordpress
     Password:       ************
     Username:       ************

## Creación de un alias

Como hicimos en el proyecto de la aplicación moodle no vamos a utilizar el nombre que se ha generado en la creación del gear (`wordpress-pledin.rhcloud.com`), en su lugar vamos a utilizar el nombre `www.josedomingo.org,` para ello es necesario crear un alias:

    $ rhc alias add wordpress www.josedomingo.org

## Despliegue de wordpress

A continuación vamos a copiar a nuestro repositorio local el código de nuestra wordpress (lo guardaremos en un directorio llamado `pledin`) a excepción del directorio `wp-content`, que contiene los ficheros que se pueden ir modificando en nuestra web (imágenes subidas, nuevos plugins y temas, actualizaciones de plugins y temas,...). El contenido de esta carpeta la guardaremos posteriormente en el  directorio `app-root/data` de openshift. Si estuviéramos haciendo una instalación nueva este paso no sería necesario, ya que no tendríamos ningún fichero en el directorio `wp-content`.

En el fichero `wp-config.php` tenemos la configuración de nuestra wordpress, vamos a utilizar las variables de entorno que se crean en OpenShift para indicar los datos sobre el acceso de la base de datos. El fragmento donde se configuran estos parámetros del fichero quedaría de la siguiente manera:

    // ** MySQL settings - You can get this info from your web host ** //
     /** The name of the database for WordPress */
     define('DB_NAME', $_ENV['OPENSHIFT_APP_NAME']);
     /** MySQL database username */
     define('DB_USER', $_ENV['OPENSHIFT_MYSQL_DB_USERNAME']);
     /** MySQL database password */
     define('DB_PASSWORD', $_ENV['OPENSHIFT_MYSQL_DB_PASSWORD']);
     /** MySQL hostname */
     define('DB_HOST', $_ENV['OPENSHIFT_DB_HOST']);
     /** Database Charset to use in creating database tables. */
     define('DB_CHARSET', 'utf8');
     /** The Database Collate type. Don't change this if in doubt. */
     define('DB_COLLATE', '');

A continuación podemos sincronizar nuestro repositorio local con el repositorio de openshift:

    ~wordpress/pledin$ git add *
    ~wordpress/pledin$ git commit -m "Primera instalación"
    ~wordpress/pledin $ git push

El siguiente paso que vamos a realizar es copiar el directorio `wp-content` al directorio `app-root/data`, que es el utilizado por openshift para guardar los ficheros que se van modificando como indicamos anteriormente:

    $ scp -r wp-content/* xxxxxxxxxxxxxxxxxxxxx@wordpress-pledin.rhcloud.com:app-root/data

Con esto nos aseguramos que si volvemos a actualizar el repositorio git con un `push,` esta información no se pierda.

Finalmente crearemos un enlace símbolico `wp-content` desde el repositorio git, guardado en openshift en el directorio `app-root/repo,` al directorio `wp-content` que acabamos de subir y que esta guardado en el directorio `app-root/data`, para ello vamos a utilizar un script que se ejecute cada vez que actualicemos el repositorio, a este tipo de script se le llaman `git action hook`.

El script que vamos a ejecutar creará enlaces símbolicos de los directorios de `repo/wp-content` a los directorios en `data/wp-content`, para realizar este script creamos el fichero `build` en el directorio de nuestro repositorio local `.openshift/action_hooks/`

    ln -sf $OPENSHIFT_DATA_DIR/uploads $OPENSHIFT_REPO_DIR/pledin/wp-content/uploads
    ln -sf $OPENSHIFT_DATA_DIR/plugins    $OPENSHIFT_REPO_DIR/pledin/wp-content/plugins
    ln -sf $OPENSHIFT_DATA_DIR/themes $OPENSHIFT_REPO_DIR/pledin/wp-content/themes
    ln -sf $OPENSHIFT_DATA_DIR/languages $OPENSHIFT_REPO_DIR/pledin/wp-content/languages
    ln -sf $OPENSHIFT_DATA_DIR/upgrade  $OPENSHIFT_REPO_DIR/pledin/wp-content/upgrade

Le damos permiso de ejecución, y lo subimos al repositorio:

    ~wordpress/.openshift/action_hooks$ chmod +x    .openshift/action_hooks/build
    ~wordpress/.openshift/action_hooks$ git add     .openshift/action_hooks/build
    ~wordpress/.openshift/action_hooks$  git commit -m "action hook"
    ~wordpress/.openshift/action_hooks$  git push

## Configuración de la base de datos

Vamos a copiar nuestra copia de la base de datos a nuestro proyecto openshift para posteriormente acceder por ssh  y hacer la exportación:

    $ scp jdmrwordpress.sql xxxxxxxxxxxxxxxxxxx@wordpress-pledin.rhcloud.com:app-root/data

    $ ssh xxxxxxxxxxxxxxxxxxx@wordpress-pledin.rhcloud.com
    ...
    [wordpress-pledin.rhcloud.com xxxxxxxxxxxxxxxxxxxx]\> cd app-root/data/
    [wordpress-pledin.rhcloud.com data]\> mysql -u usuario_base_datos -p*********** wordpress &lt; jdmrwordpress.sql

> En los asteriscos hay que poner la constraseña.

## Automatizar tareas usando el cron

Del mismo modo que con la aplicación moodle vamos a instalar el cartridge _**cron 1.4**_ que nos va a permitir la ejecución del cron:

    $ rhc cartridge-add cron-1.4 --app wordpress

Vamos a crear diariamente una copia de seguridad de la base de datos con la utilidad mysqldump, para ello usamos una tarea en el cron creando un fichero `cron.sh` en el directorio de nuestro repositorio local `.openshif/cron/daily`, con el siguiente contenido:

    #!/bin/bash
     mysqldump --password=$OPENSHIFT_MYSQL_DB_PASSWORD -h $OPENSHIFT_MYSQL_DB_HOST -P $OPENSHIFT_MYSQL_DB_PORT -u     $OPENSHIFT_MYSQL_DB_USERNAME $OPENSHIFT_GEAR_NAME --add-drop-table > $OPENSHIFT_DATA_DIR/$OPENSHIFT_GEAR_NAME.sql

A continuación le damos permiso de ejecución y lo subimos a nuestro repositorio de openshift:

    ~wordpress/.openshif/cron/daily$ chmod +x cron.sh
    ~wordpress/.openshif/cron/daily$ git add cron.sh
    ~wordpress/.openshif/cron/daily$ git commit -m "tarea cron"
    ~wordpress/.openshif/cron/daily$ git push

## Terminando

El último paso que queda es la modificación de nuestro servidor DNS. Tendremos que eliminar el registro A correspondiente al nombre `www` que apuntaba a la dirección ip del servidor de hosting antiguo y crear una nuevo registro CNAME para crear un alias llamado `www` que apunte al nombre `wordpress-pledin.rhcloud.com,` de esta forma estaremos siempre accediendo a la dirección ip de nuestro servidor de openshift aunque esté sea migrado a otra máquina.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->