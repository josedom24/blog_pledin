---
id: 1875
title: Introducción a PHP-FPM
date: 2017-11-13T21:19:49+00:00


guid: https://www.josedomingo.org/pledin/?p=1875
permalink: /2017/11/introduccion-a-php-fpm/


tags:
  - php
  - Web
---
FPM (FastCGI Process Manager) es una implementación alternativa al PHP FastCGI. FPM se encarga de interpretar código PHP. Aunque normalmente se utiliza junto a un servidor web (Apache2 o ngnix), en este artículo vamos a hacer una introducción a PHP-FPM de manera aislada, vamos a estudiar algunos parámetros de configuración y estudiar su funcionamiento.

Para instalarlo en Debian 9:

    apt install php7.0-fpm php7.0
    

## Configuración de php-fpm

Con esto hemos instalado php 7.0 y php-fpm. Veamos primeros algunos ficheros de configuración de php:

La configuración de php está dividida según desde se use:

  * `/etc/php/7.0/cli`: Configuración de php para `php7.0-cli`, cuando se utiliza php desde la línea de comandos.
  * `/etc/php/7.0/fpm`: Configuración de php para php-fpm
  * `/etc/php/7.0/mods-available`: Módulos disponibles de php que puedes estar configurados en cualquiera de los escenarios anteriores.

<!--more-->

Si nos fijamos en la configuración de php para php-fpm:

  * `/etc/php/7.0/fpm/conf.d`: Módulos instalados en esta configuración de php (enlaces simbólicos a `/etc/php/7.0/mods-available`).
  * `/etc/php/7.0/fpm/php-fpm.conf`: Configuración general de php-fpm.
  * `/etc/php/7.0/fpm/php.ini`: Configuración de php para este escenario.
  * `/etc/php/7.0/fpm/pool.d`: Directorio con distintos pool de configuración. Cada aplicación puede tener una configuración distinta (procesos distintos) de php-fpm.

Por defecto tenemos un pool cuya configuración la encontramos en `/etc/php/7.0/fpm/pool.d/www.conf`, en este fichero podemos configurar muchos parámetros, los más importantes son:

  * `[www]`: Es el nombre del pool, si tenemos varios, cada uno tiene que tener un nombre.
  * `user` y `grorup`: Usuario y grupo con el que se va ejecutar los procesos.
  * `listen`: Se indica el socket unix o el socket TCP donde van a escuchar los procesos:
    
      * Por defecto, escucha por un socket unix: `listen = /run/php/php7.0-fpm.sock`
      * Si queremos que escuche por un socket TCP: `listen = 127.0.0.1:9000`
      * En el caso en que queramos que escuche en cualquier dirección: `listen = 9000`

  * Directivas de procesamiento, gestión de procesos:
    
      * `pm`: Por defecto igual a `dynamic` (el número de procesos se crean y destruyen de forma dinámica). Otros valores: `static` o `ondemand`.
      * Otras directivas: `pm.max_children`, `pm.start_servers`, `pm.min_spare_servers`,&#8230;

  * `pm.status_path = /status`: No es necesaria, pero vamos a activar la URL de `status` para comprobar el estado del proceso.

Por último reiniciamos el servicio:

    systemctl restart php7.0-fpm
    

## Pruebas de funcionamiento

1. Suponemos que tenemos configurado por defecto, por lo tanto los procesos están escuchando en un socket UNIX:
    
        listen = /run/php/php7.0-fpm.sock
        
    
    Para enviar ficheros php a los procesos para su interpretación vamos a utilizar el programa `cgi-fcgi`:
    
        apt-get install libfcgi0ldbl
        
    
    Y a continuación accedemos a la URL `/status`, para ello:
    
        SCRIPT_NAME=/status SCRIPT_FILENAME=/status REQUEST_METHOD=GET cgi-fcgi -bind -connect /run/php/php7.0-fpm.sock 
        
        Expires: Thu, 01 Jan 1970 00:00:00 GMT
        Cache-Control: no-cache, no-store, must-revalidate, max-age=0
        Content-type: text/plain;charset=UTF-8      
        
        pool:                 www
        process manager:      dynamic
        start time:           13/Nov/2017:19:32:50 +0000
        start since:          38
        accepted conn:        6
        listen queue:         0
        max listen queue:     0
        listen queue len:     0
        idle processes:       1
        active processes:     1
        total processes:      2
        max active processes: 1
        max children reached: 0
        slow requests:        0
        
    
    Si queremos ejecutar un fichero php, vamos a crear un directorio `/var/www` y vamos a guardar un fichero `holamundo.php` con el siguiente contenido:
    
        <?php echo "Hola Mundo!!!";?>
        
    
    A continuación vamos a indicar el directorio de trabajo en el fichero `/etc/php/7.0/fpm/pool.d/www.conf`:
    
        chroot = /var/www
        
    
    Inicializamos el servicio:
    
        systemctl restart php7.0-fpm
        
    
    Y podríamos ejecutar el fichero de la siguiente manera:
    
        SCRIPT_NAME=/holamundo.php SCRIPT_FILENAME=/holamundo.php REQUEST_METHOD=GET cgi-fcgi -bind -connect /run/php/php7.0-fpm.sock 
        
        Content-type: text/html; charset=UTF-8
        
        Hola Mundo!!!       
        

2. Si suponemos que hemos configurado php-fpm para que escuche en un socket TCP:
    
        listen = 127.0.0.1:9000
        
    
    Para realizar las pruebas que hemos probado anteriormente:
    
        SCRIPT_NAME=/status SCRIPT_FILENAME=/status REQUEST_METHOD=GET cgi-fcgi -bind -connect 127.0.0.1:9000
        
        SCRIPT_NAME=/holamundo.php SCRIPT_FILENAME=/holamundo.php REQUEST_METHOD=GET cgi-fcgi -bind -connect 127.0.0.1:9000
        

## Conclusiones

En muchas ocasiones cuando se instala apache2 o nginx junto a php-fpm nos cuesta entender como funciona la interpretación del código PHP por medio de php-fpm. en este artículo he tratado de hacer una introducción a este servicio de manera independiente al servidor web para que se entienda un poco mejor. Espero que haya sido de utilidad.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->