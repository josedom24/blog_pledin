---
id: 1645
title: Ejemplos de ficheros Dockerfile, creando imágenes docker
date: 2016-02-17T10:55:41+00:00


guid: http://www.josedomingo.org/pledin/?p=1645
permalink: /2016/02/ejemplos-de-ficheros-dockerfile-creando-imagenes-docker/


tags:
  - docker
  - Virtualización
---

En la entrada: <a href="http://www.josedomingo.org/pledin/2016/02/dockerfile-creacion-de-imagenes-docker/">Dockerfile: Creación de imágenes docker</a>, estudiamos el mecanismo de creación de imágenes docker, con el comando `docker buid` y los ficheros `Dockerfile`. En esta entrada vamos a estudiar algunos ejemplos de ficheros `Dockerfile` y cómo creamos y usamos las imágenes generadas a partir de ellos.

Tenemos dos imágenes en nuestro sistema, que son las que vamos a utilizar como imágenes base para crear nuestras imágenes:

    ```bash
    $ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    debian              latest              9a02f494bef8        2 weeks ago         125.1 MB
    ubuntu              14.04               3876b81b5a81        3 weeks ago         187.9 MB
    ```
    
## Creación una imagen con el servidor web Apache2

En este caso vamos a crear un directorio nuevo que va a ser el contexto donde podemos guardar los ficheros que se van a enviar al *docker engine*, en este caso el fichero `index.html` que vamos a copiar a nuestro servidor web:

    $ mkdir apache
    $ cd apache
    ~/apache$ echo "<h1>Prueba de funcionamiento contenedor docker</h1>">index.html

En ese directorio vamos a crear un fichero `Dockerfile`, con el siguiente contenido:

    FROM debian
    MAINTAINER José Domingo Muñoz "josedom24@gmail.com"

    RUN apt-get update && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*

    ENV APACHE_RUN_USER www-data
    ENV APACHE_RUN_GROUP www-data
    ENV APACHE_LOG_DIR /var/log/apache2

    EXPOSE 80
    ADD ["index.html","/var/www/html/"]

    ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

En este caso utilizamos la imagen base de debian, instalamos el servidor web apache2, para reducir el tamaño, borramos la caché de paquetes apt y la lista de paquetes descargada, creamos varias variables de entorno (en este ejemplo no se van a utilizar, pero se podrían utilizar en cualquier fichero del contexto, por ejemplo para configurar el servidor web), exponemos el puerto http TCP/80, copiamos el fichero index.html al `DocumentRoot` y finalmente indicamos el comando que se va a ejecutar al crear el contenedor, y además, al usar el comando `ENTRYPOINT`, no permitimos ejecutar ningún otro comando durante la creación.

Vamos a generar la imagen:

    ~/apache$ docker build -t josedom24/apache2:1.0 .
    Sending build context to Docker daemon 3.072 kB
    Step 1 : FROM debian
     ---> 9a02f494bef8
    Step 2 : MAINTAINER José Domingo Muñoz "josedom24@gmail.com"
     ---> Running in 76f3f8fe0719
     ---> fda7bdbf761c
    Removing intermediate container 76f3f8fe0719
    Step 3 : RUN apt-get update && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*
     ---> Running in c50b14cc967d
    Get:1 http://security.debian.org jessie/updates InRelease [63.1 kB]
    Get:2 http://security.debian.org jessie/updates/main amd64 Packages [256 kB]
    Ign http://httpredir.debian.org jessie InRelease
    ...
     ---> 0dedcfe17eb9
    Removing intermediate container c50b14cc967d
    Step 4 : ENV APACHE_RUN_USER www-data
     ---> Running in 85a85c09f96c
     ---> dac18d113b15
    Removing intermediate container 85a85c09f96c
    Step 5 : ENV APACHE_RUN_GROUP www-data
     ---> Running in 9e7511d92c74
     ---> 8f5824bdc71a
    Removing intermediate container 9e7511d92c74
    Step 6 : ENV APACHE_LOG_DIR /var/log/apache2
     ---> Running in 1b9173a822f8
     ---> 313e04f3a33a
    Removing intermediate container 1b9173a822f8
    Step 7 : EXPOSE 80
     ---> Running in 001ce73f08a6
     ---> 76f798e8d481
    Removing intermediate container 001ce73f08a6
    Step 8 : ADD index.html /var/www/html
     ---> 5ce11ae0b1e6
    Removing intermediate container c8f418d3a0f6
    Step 9 : ENTRYPOINT /usr/sbin/apache2ctl -D FOREGROUND
     ---> Running in 4ba6954632a5
     ---> 9109b0f27a08
    Removing intermediate container 4ba6954632a5
    Successfully built 9109b0f27a08

Generamos la nueva imagen con el comando `docker build` con la opción `-t` indicamos el nombre de la nueva imagen (para indicar el nombre de la imagen es recomendable usar nuestro nombre de usuario en el registro **docker hub**, para posteriormente poder guardarlas en el registro), mandamos todos los ficheros del contexto (indicado con el punto). Podemos comprobar que tenemos generado la nueva imagen:

    $ docker images 
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    josedom24/apache2   1.0                 9109b0f27a08        4 minutes ago       183.7 MB
    debian              latest              9a02f494bef8        2 weeks ago         125.1 MB
    ubuntu              14.04               3876b81b5a81        3 weeks ago         187.9 MB

A continuación podemos crear un nuevo contenedor a partir de la nueva imagen:

    $ docker run -p 80:80 --name servidor_web josedom24/apache2:1.0

Comprobamos que el contenedor está creado:

    $ docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
    67013f91ba65        josedom24/apache    "/usr/sbin/apache2ctl"   4 minutes ago       Up 4 minutes        0.0.0.0:80->80/tcp   servidor_web

Y podemos acceder al servidor docker, para ver la página web:
  
<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile1.png" rel="attachment wp-att-1647"><img class="aligncenter size-full wp-image-1647" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile1.png" alt="dockerfile1" width="862" height="126" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile1.png 862w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile1-300x44.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile1-768x112.png 768w" sizes="(max-width: 862px) 100vw, 862px" /></a>
  
## Creación una imagen con el servidor de base de datos mysql

En esta ocasión vamos a tener un contexto, un directorio con los siguientes ficheros:

    ~/mysql$ ls
    Dockerfile  my.cnf  script.sh

El fichero de configuración de mysql, `my.cnf`:

    [mysqld]
    bind-address=0.0.0.0
    console=1
    general_log=1
    general_log_file=/dev/stdout
    log_error=/dev/stderr

Un script bash, que va a ser el que se va a ejecutar por defecto cunado se crea un contenedor, `script.sh`:

    #!/bin/bash
    set -e

    chown -R mysql:mysql /var/lib/mysql
    mysql_install_db --user mysql > /dev/null

    MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-""}
    MYSQL_DATABASE=${MYSQL_DATABASE:-""}
    MYSQL_USER=${MYSQL_USER:-""}
    MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

    tfile=`mktemp`
    if [[ ! -f "$tfile" ]]; then
        return 1
    fi

    cat << EOF > $tfile
    USE mysql;
    FLUSH PRIVILEGES;
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
    UPDATE user SET password=PASSWORD("$MYSQL_ROOT_PASSWORD") WHERE user='root';
    EOF

    if [[ $MYSQL_DATABASE != "" ]]; then
        echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

        if [[ $MYSQL_USER != "" ]]; then
            echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
        fi
    fi

    /usr/sbin/mysqld --bootstrap --verbose=0 < $tfile
    rm -f $tfile

    exec /usr/sbin/mysqld

Podemos ver que hace uso de varias variables de entorno:

    MYSQL_ROOT_PASSWORD
    MYSQL_DATABASE
    MYSQL_USER
    MYSQL_PASSWORD

Que nos permiten especificar la contraseña del root, el nombre de una base de datos a crear, el nombre y contraseña de un nuevo usuario a crear.  Estas variables de entorno se pueden indicar en el fichero `Dockerfile`, o con el parámetro `--env` en el comando `docker run`.

El fichero `Dockerfile` tendrá el siguiente contenido:

    FROM ubuntu:14.04 
    MAINTAINER José Domingo Muñoz "josedom24@gmail.com"

    RUN apt-get update && apt-get -y upgrade
    RUN apt-get install -y mysql-server

    ADD my.cnf /etc/mysql/conf.d/my.cnf 
    ADD script.sh /usr/local/bin/script.sh
    RUN chmod +x /usr/local/bin/script.sh

    EXPOSE 3306

    CMD ["/usr/local/bin/script.sh"]

Como vemos se instala mysql, se copia el fichero de configuración y el script en bash que es el comando que se va a ejecutar por defecto al crear los contenedores. Generamos la imagen:

    ~/mysql$ docker build -t josedom24/mysql:1.0 .

Y creamos un contenedor indicando la contraseña del root:

    $ docker run -d -p 3306:3306 --env MYSQL_ROOT_PASSWORD=asdasd --name servidor_mysql jose/mysql:1.0

    $ docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
    8635e1392523        josedom24/mysq      "/usr/local/bin/scrip"   3 seconds ago       Up 3 seconds        0.0.0.0:3306->3306/tcp   servidor_mysql

Y accedemos al servidor mysql, utilizando la ip del servidor docker:

    mysql -u root -p -h 192.168.0.100

Este ejemplo se basa en la imagen mysql que podemos encontrar en docker hub: <https://hub.docker.com/r/mysql/mysql-server/>

## Creación una imagen con con php a partir de nuestra imagen con apache2

En este último ejemplo, vamos a crear una imagen con php5 a partir de nuestra imagen con apache: `josedom24/apache2:1.0`, para ello en el directorio php creamos un fichero `index.php`:

    ~/php$ echo "<?php echo phpinfo();?>">index.php

Y el fichero `Dockerfile`, con el siguiente contenido:

    FROM josedom24/apache2:1.0
    MAINTAINER José Domingo Muñoz "josedom24@gmail.com"

    RUN apt-get update && apt-get install -y php5 && apt-get clean && rm -rf /var/lib/apt/lists/*

    EXPOSE 80
    ADD ["index.php","/var/www/html/"]

    ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

Generamos la nueva imagen:

    ~/php$ docker build -y josedom24/php5:1.0 .

Creamos un nuevo contenedor, y realizamos la prueba de funcionamiento:

    $ docker run -d -p 8080:80 --name servidor_php josedom24/php5:1.0

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile2.png" rel="attachment wp-att-1650"><img class="aligncenter size-full wp-image-1650" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile2.png" alt="dockerfile2" width="992" height="309" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile2.png 992w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile2-300x93.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile2-768x239.png 768w" sizes="(max-width: 992px) 100vw, 992px" /></a>

## Conclusiones

En esta entrada hemos visto una introducción a la creación de imágenes docker utilizando ficheros `Dockerfile`. Para avanzar más sobre la utilización de este mecanismo de creación de imágenes os sugiero que estudiéis los ficheros `Dockerfile` y los repositorios que podemos encontrar en el registro Docker Hub:


<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile3.png" rel="attachment wp-att-1652"><img class="aligncenter size-large wp-image-1652" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile3-1024x474.png" alt="dockerfile3" width="770" height="356" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile3-1024x474.png 1024w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile3-300x139.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile3-768x356.png 768w" sizes="(max-width: 770px) 100vw, 770px" /></a>En la siguiente entrada vamos a hacer una introducción al uso del registro docker hub, para guardar nuestras imágenes y poderlas desplegar en nuestro entorno de producción.


<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->