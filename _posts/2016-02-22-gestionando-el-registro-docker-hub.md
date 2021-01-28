---
id: 1663
title: Gestionando el registro Docker Hub
date: 2016-02-22T18:29:52+00:00


guid: http://www.josedomingo.org/pledin/?p=1663
permalink: /2016/02/gestionando-el-registro-docker-hub/


tags:
  - docker
  - Virtualización
---
<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub.png" rel="attachment wp-att-1664"><img class="aligncenter size-full wp-image-1664" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub.png" alt="dockerhub" width="1022" height="467" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub.png 1022w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub-300x137.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub-768x351.png 768w" sizes="(max-width: 1022px) 100vw, 1022px" /></a>

En artículos anteriores hemos estudiado la <a href="http://www.josedomingo.org/pledin/2016/02/ejemplos-de-ficheros-dockerfile-creando-imagenes-docker/">generación de imágenes docker utilizando ficheros `Dockerfile`</a> y construyendo la nueva imagen con el comando `docker buid`. Las imágenes generadas por este método se crean en nuestro servidor docker. si queremos desplegar la aplicación o el servicio "dockerizado" desde nuestro entorno de prueba/desarrollo a nuestro entorno de producción, es necesario llevarnos la imagen de un entono a otro. Para transferir la imagen de un equipo a otro tenemos dos posibilidades:

* Podríamos guardar la imagen en un fichero tar, que podemos copiar al otro equipo para restaurarlo en él.
* Podríamos guardar la imagen en un registro docker. Podemos instalar un registro en nuestra infraestructura o utilizar docker hub, que es una aplicación web que nos proporciona la posibilidad de guardar nuestras imágenes. Una vez que la imagen esta guardada en el registro podemos descargarla desde el entorno de producción.

Para ver las distintas opciones que tenemos a nuestra disposición vamos a partir de la siguiente imagen que hemos creado:

    docker images 
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    josedom24/apache2   latest              04800781aed6        17 seconds ago      183.7 MB

## Exportación/importación de imágenes

Como hemos indicado anteriormente una imagen la podemos guardar en un fichero tar para exportarla a otro equipo.

Para exportar una imagen ejecutamos el siguiente comando:


    $ docker save -o apache2.tar josedom24/apache2

Y se genera un fichero tar, que podemos ver:

    $ ls -alh
    -rw-r--r-- 1 usuario usuario 184M feb 17 21:02 apache2.tar

Este fichero lo podemos guardar en cualquier medio de almacenamiento, o enviarlo por internet a otro equipo, donde realizaríamos la importación:

    $ docker load -i apache2.tar josedom24/apache2

## Guardando nuestras imágenes en docker hub

Otra opción que tenemos es guardar nuestra imagen en el registro docker hub, de esta forma sería muy sencillo descargarlo en otro equipo. Es necesario tener una cuenta en docker hub, nosotros ya tenemos una cuenta con el usuario `josedom24`.

Para poder subir una imagen a nuestra cuenta de docker hub es necesario autentificarnos, para ello:

    $ docker login
    Username: josedom24
    Password: 
    Email: xxxxxxxx@gmail.com
    WARNING: login credentials saved in /home/usuario/.docker/config.json
    Login Succeeded

Y podemos subir nuestra imagen con el comando:

    $ docker push josedom24/apache2
    The push refers to a repository [docker.io/josedom24/apache2]
    3155f6b09710: Pushed 
    67331ad8a75e: Pushed 
    5f70bf18a086: Pushed 
    78dbfa5b7cbc: Pushed
    latest: digest: sha256:bfe4d16f3e8d7f31b5f1bc0e1d989cbe6d762d1f4770fedf435685e24ee7bf8c size: 644

Podemos comprobar que la imagen se ha subido a docker hub: 

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub8.png" rel="attachment wp-att-1683"><img class="aligncenter size-full wp-image-1683" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub8.png" alt="dockerhub8" width="973" height="836" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub8.png 973w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub8-300x258.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub8-768x660.png 768w" sizes="(max-width: 973px) 100vw, 973px" /></a>

Ya podemos buscar la nueva imagen que hemos subido y bajarla en otro servidor:

    $ docker search josedom24
    NAME                DESCRIPTION   STARS     OFFICIAL   AUTOMATED
    josedom24/apache2                 0

    $ docker pull josedom24/apache2

## Generación automática de imágenes en docker hub

También podemos generar una imagen directamente en docker hub. Esta solución es mucho más cómoda, porque no es necesario generar la imagen en nuestro ordenador para posteriormente subirla al registro. Para realizar la generación automática vamos a guardar los ficheros de nuestro contexto (el fichero Dockerfile y los ficheros que vamos a guardar en la imagen) en un repositorio en GitHub. Para realizar este ejemplo vamos a utilizar el contexto que utilizamos en la <a href="http://www.josedomingo.org/pledin/2016/02/ejemplos-de-ficheros-dockerfile-creando-imagenes-docker/">entrada anterior</a> para crear la imagen con mysql. Lo primero que vamos a hacer es crear un repositorio en github donde vamos a guardar los ficheros del contexto:

    $ git clone git@github.com:josedom24/docker_mysql.git
    Cloning into 'docker_mysql'...
    $ cd docker_mysql

Copiamos los ficheros del contexto en nuestro repositorio:

    docker_mysql$ ls
    Dockerfile  my.cnf  script.sh

Y los subimos al repositorio github:

    docker_mysql$ git add *
    docker_mysql$ git commit -m "Contexto docker mysql"
    docker_mysql$ git push

A continuación desde docker hub tenemos que crear un **"Automated Build":**

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/*}{{ site.baseurl }}*assets/wp-content/uploads/2016/02/dockerhub3-300x189.png 300w" sizes="(max-width: 352px) 100vw, 352px" /></a>

La primera vez que lo hacemos tenemos que conectar docker con github y permitir que docker hub pueda acceder a nuestro repositorio, elegimos que nos vamos a conectar a github y seleccionamos la primera opción (Public and Private) donde permitamos más opciones de trabajo, finalmente desde github autorizamos a la aplicación docker hub. Para conseguir todo esto tenemos que seguir los siguiente pasos:

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub4.png" rel="attachment wp-att-1677"><img class="aligncenter size-large wp-image-1677" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub4-1024x283.png" alt="dockerhub4" width="770" height="213" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub4-1024x283.png 1024w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub4-300x83.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub4-768x212.png 768w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub4.png 1309w" sizes="(max-width: 770px) 100vw, 770px" /></a><a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub5.png" rel="attachment wp-att-1676"><img class="aligncenter size-large wp-image-1676" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub5-1024x409.png" alt="dockerhub5" width="770" height="308" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub5-1024x409.png 1024w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub5-300x120.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub5-768x306.png 768w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub5.png 1308w" sizes="(max-width: 770px) 100vw, 770px" /></a><a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub6.png" rel="attachment wp-att-1675"><img class="aligncenter size-large wp-image-1675" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub6-1024x508.png" alt="dockerhub6" width="770" height="382" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub6-1024x508.png 1024w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub6-300x149.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub6-768x381.png 768w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub6.png 1309w" sizes="(max-width: 770px) 100vw, 770px" /></a><a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub7.png" rel="attachment wp-att-1674"><img class="aligncenter size-large wp-image-1674" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub7-1024x536.png" alt="dockerhub7" width="770" height="403" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub7-1024x536.png 1024w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub7-300x157.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub7-768x402.png 768w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub7.png 1170w" sizes="(max-width: 770px) 100vw, 770px" /></a>Una vez realizado esta configuración, ya podemos crear un <strong>"Automated Build", </strong>elegimos un repositorio github:

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/* src="{{ site.url }}{{ site.baseurl }}*assets/wp-content/uploads/2016/02/dockerhub8-1-300x155.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub8-1-768x396.png 768w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub8-1.png 1312w" sizes="(max-width: 770px) 100vw, 770px" /></a>


A continuación configuro la imagen que voy a crear, como se puede observar si tengo distintas ramas en el repositorio github, se podrán crear distintas imágenes con tag distintos:

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub9.png" rel="attachment wp-att-1683"><img class="aligncenter size-full wp-image-1683" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub9.png" alt="dockerhub9" width="973" height="836" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub9.png 973w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub9-300x258.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub9-768x660.png 768w" sizes="(max-width: 973px) 100vw, 973px" /></a>

Y finalmente, tenemos nuestro nuevo repositorio. Si esperamos un tiempo prudencial para permitir que se cree la imagen o hacemos un nuevo push en el repositorio github, podremos obtener la siguiente información:

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub10.png" rel="attachment wp-att-1684"><img class="aligncenter size-large wp-image-1684" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub10-1024x558.png" alt="dockerhub10" width="770" height="420" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub10-1024x558.png 1024w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub10-300x163.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub10-768x418.png 768w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub10.png 1283w" sizes="(max-width: 770px) 100vw, 770px" /></a>


* **Build details**: Detalles de la construcción de la nueva imagen, por cada modificación que hagamos en el repositorio github (push) se creará una nueva tarea de construcción de la imagen.

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub12.png" rel="attachment wp-att-1687"><img class="aligncenter size-large wp-image-1687" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub12-1024x323.png" alt="dockerhub12" width="770" height="243" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub12-1024x323.png 1024w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub12-300x95.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub12-768x242.png 768w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub12.png 1288w" sizes="(max-width: 770px) 100vw, 770px" /></a>

* **Dockerfile**: Obtenemos el contenido del fichero utilizado para construir la imagen.

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub13.png" rel="attachment wp-att-1688"><img class="aligncenter size-large wp-image-1688" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub13-1024x494.png" alt="dockerhub13" width="770" height="371" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub13-1024x494.png 1024w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub13-300x145.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub13-768x371.png 768w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerhub13.png 1291w" sizes="(max-width: 770px) 100vw, 770px" /></a>

Por último podemos comprobar que tenemos acceso a la nueva imagen y que podemos descargarla:

    $ docker search josedom24
    NAME                     DESCRIPTION    STARS     OFFICIAL   AUTOMATED
    josedom24/docker_mysql   Docker mysql   0                    [OK]
    josedom24/apache2                       0                    
    $ docker pull josedom24/docker_mysql

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->