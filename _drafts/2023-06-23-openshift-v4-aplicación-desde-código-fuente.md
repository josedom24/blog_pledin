---
title: 'Despliegue de aplicaciones desde código fuente en OpenShift v4'
permalink: /2023/06/openshift-v4-aplicacion-desde-codigo-fuente/
tags:
  - OpenShift
  - kubernetes
---

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/openshift2.png){: .align-center }

Como indicábamos en el artículo anterior, los principales métodos de despliegue de una aplicación web en OpenShift v4 son:

* Desplegar una aplicación a partir de una **imagen ya existente**.
* **Source-to-Image (s2i)**: Construir de forma automática una nueva imagen a partir de una aplicación que tengamos guardada en un repositorio git. A partir de la imagen que genera de forma automática se despliega la aplicación. 
* Construir una nueva imagen generada a partir de un fichero **Dockerfile**, y desplegar la aplicación desde esa imagen construida.
* Desplegar aplicaciones a partir de plantillas.
* Desplegar aplicaciones desde un pipeline de IC/DC.

En este artículo vamos a desplegar aplicaciones partiendo del código fuente de la misma guardado en un repositorio GitHub. OpenShift v4 es capaz de realizar una construcción automática de una imagen Docker a partir del código fuente y una **builder image** (imagen constructora).

En esta estrategia de despliegue donde se va a crear una imagen de forma automática, se crean dos nuevos recursos en OpenShift:

* **BuildConfig**: Cuando el método de despliegue conlleva la construcción automática de una imagen (Source-to-Image o Dockerfile), este recurso se utiliza para configurar el proceso de construcción de la imagen (build).
* **Build**: Cada vez que se hace una construcción automática de una imagen con la configuración del recurso **BuildConfig**, se creará un recurso del tipo **Build**. La construcción se realizará en un Pod cuyo nombre tendrá la palabra *build*.

<!--more-->

## Despliegue de aplicaciones desde código fuente con oc

El esquema para ver los recursos que se crean en OpenShift al realizar un despliegue desde código fuente es el siguiente:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/codigo.png){: .align-center }

Como vemos, el proceso es el siguiente:

1. Tenemos que indicar la URL del repositorio GitHub donde se encuentra la aplicación.
2. OpenShift examina el contenido del repositorio y si es posible, te sugiere la **Image builder** que podemos usar para construir la nueva imagen. Si no es posible o queremos usar otra, tendremos que indicarla.
3. Se crea un recuso **BuildConfig** responsable de realizar la construcción. 
4. La configuración de una construcción en concreto se guarda en un recurso **Build**.
5. El proceso de construcción se realizará en un **build pod**.

## Despliegue de una página estática con un servidor apache2

Queremos construir una imagen con un servidor web a partir de un repositorio donde tenemos una página web estática, para ello ejecutaremos:

    oc new-app https://github.com/josedom24/osv4_html.git --name=app1
    error: No language matched the source repository

Vemos que no es posible averiguar el lenguaje con el que está escrito, por lo que tendremos que indicar la **Builder Image** que vamos a utilizar. 

Las **Builder Image** están referenciadas por una **Image Stream**, por ejemplo, podemos buscar las **Builder Image** con el servidor web apache:

    oc new-app -S httpd
    ...
    Image streams ...
    -----
    httpd
      Project: openshift
      Tags:    2.4-el7, 2.4-ubi8, 2.4-ubi9, latest

Obtenemos además las distintas etiquetas que podemos usar, que corresponden a distintas versiones del servidor web. Por lo tanto si queremos generar una imagen con el código de nuestro repositorio usando de base una imagen basada en *httpd* (al no indicar la etiqueta se escogerá la *latest* que apunta a la última versión de la imagen), ejecutamos:

    oc new-app httpd~https://github.com/josedom24/osv4_html.git --name=app1
    
    ...
    --> Found image e54df11 (5 months old) in image stream "openshift/httpd" under tag "2.4-ubi8" for "httpd"
    ...
    --> Creating resources ...
        imagestream.image.openshift.io "app1" created
        buildconfig.build.openshift.io "app1" created
        deployment.apps "app1" created
        service "app1" created
    --> Success
        Build scheduled, use 'oc logs -f buildconfig/app1' to track its progress.
        Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
         'oc expose service/app1' 
        Run 'oc status' to view your app.
    
Como vemos se han creado varios recursos:

1. Un **ImageStream** `app1` que apuntará a la nueva imagen que vamos a generar, y que se utilizará en la definición del despliegue.
2. Un **BuildConfig**, que guardará la configuración necesaria para construir la nueva imagen. De forma automática creará un objeto **Build** responsable de crear la imagen. Este proceso se realizará en un **build pod**.
3. Un recurso **Deployment** responsable de desplegar los recursos necesario para ejecutar los Pods.
4. Un recurso **Service** que nos posibilita el acceso a la aplicación.
5. No ha creado un recurso **Route** para el acceso por medio de una URL, pero nos ha indicado el comando necesario para crearlo.

Podemos comprobar todos los recursos que se han creado, ejecutando:

    oc status
    ...
    svc/app1 - 172.30.217.224 ports 8080, 8443
      deployment/app1 deploys istag/app1:latest <-
        bc/app1 source builds https://github.com/josedom24/osv4_html.git on openshift/httpd:2.4-ubi8 
        deployment #2 running for 30 seconds - 1 pod
        deployment #1 deployed about a minute ago

También podemos ver los recursos que hemos creado, ejecutando:

    oc get all

    NAME                       READY   STATUS      RESTARTS   AGE
    pod/app1-1-build           0/1     Completed   0          2m20s
    pod/app1-f55dbb8d7-r4bkx   1/1     Running     0          105s

    NAME                        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                               AGE
    service/app1                ClusterIP   172.30.217.224   <none>        8080/TCP,8443/TCP                     2m21s

    NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/app1   1/1     1            1           2m21s

    NAME                              DESIRED   CURRENT   READY   AGE
    replicaset.apps/app1-5bc9cfc7b9   0         0         0       2m21s
    replicaset.apps/app1-f55dbb8d7    1         1         1       106s

    NAME                                  TYPE     FROM   LATEST
    buildconfig.build.openshift.io/app1   Source   Git    1

    NAME                              TYPE     FROM          STATUS     STARTED         DURATION
    build.build.openshift.io/app1-1   Source   Git@5ae3b13   Complete   2 minutes ago   37s

    NAME                                  IMAGE REPOSITORY                                                                                      TAGS     UPDATED
    imagestream.image.openshift.io/app1   default-route-openshift-image-registry.apps.sandbox-m3.1530.p1.openshiftapps.com/josedom24-dev/app1   latest   About a minute ago

Finamente, creamos el recurso **Route**:

    oc expose service app1

Y accedemos a la aplicación:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/app1.png){: .align-center }

### Despliegue de una página estática con un servidor nginx

Si queremos crear una aplicación con la página web de nuestro repositorio con una imagen basada en *nginx*, podemos buscar los recursos **Images Stream** que tenemos en el catálogo:

    oc new-app -S nginx

Y posteriormente creamos la aplicación con el comando:

    oc new-app nginx~https://github.com/josedom24/osv4_html.git --name=app2

### Detección automática del Builder Image

OpenShift examina el repositorio y según los ficheros que tengamos es capaz de determinar con que lenguaje está escrito y te sugiere un **Builder Image** .

Si añadimos un fichero `index.php` a nuestro repositorio:

    echo '<?php phpinfo();?>'> index.php
    git add index.php 
    git commit -am "php"
    git push

Y ahora creamos la aplicación sin indicar la **Builder Image**:

    oc new-app https://github.com/josedom24/osv4_html.git --name=app3
    --> Found image b34c3d8 (5 months old) in image stream "openshift/php" under tag "8.0-ubi8" for "php"

        Apache 2.4 with PHP 8.0 
        ----------------------- 
        PHP 8.0 available as container is a base platform for building and running various PHP 8.0 applications and frameworks. PHP is an HTML-embedded scripting language. PHP attempts to make it easy for developers to write dynamically generated web pages. PHP also offers built-in database integration for several commercial and non-commercial database management systems, so writing a database-enabled webpage with PHP is fairly simple. The most common use of PHP coding is probably as a replacement for CGI scripts.

        Tags: builder, php, php80, php-80

        * The source repository appears to match: php
        * A source build using source code from https://github.com/josedom24/osv4_html.git will be created
          * The resulting image will be pushed to image stream tag "app3:latest"
          * Use 'oc start-build' to trigger a new build

    --> Creating resources ...
        imagestream.image.openshift.io "app3" created
        buildconfig.build.openshift.io "app3" created
        deployment.apps "app3" created
        service "app3" created
    --> Success
        Build scheduled, use 'oc logs -f buildconfig/app3' to track its progress.
        Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
         'oc expose service/app3' 
        Run 'oc status' to view your app.

Comprobamos que ha detectado que la aplicación está escrita en PHP, y nos ha seleccionado la **Builder Image** `php:8.0-ubi8`.  Una vez desplegada la aplicación, creamos el objeto **Route** y accedemos al fichero `index.php`:

    oc expose service app3

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/app3.png){: .align-center }

Si queremos usar otra versión de PHP, tendríamos que indicar la versión de la **builder image**, para ello buscamos las distintas versiones que nos ofrecen:

    oc new-app -S php
    ...
    Image streams (oc new-app --image-stream=<image-stream> [--code=<source>])
    -----
    php
      Project: openshift
      Tags:    7.3-ubi7, 7.4-ubi8, 8.0-ubi8, 8.0-ubi9, latest


Y ahora creamos una nueva aplicación con la versión `7.3-ubi7`:

    oc new-app php:7.3-ubi7~https://github.com/josedom24/osv4_html.git --name=app4

    oc expose service app4

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/app4.png){: .align-center }

### Eliminar la aplicación

Por ejemplo, para eliminar la aplicación `app1` tendríamos que eliminar todos los recursos generados:

    oc delete deploy app1
    oc delete service app1
    oc delete route app1
    oc delete is app1
    oc delete bc app1

## Despliegue de aplicaciones desde código fuente desde la consola web

Vamos a realizar el mismo ejercicio pero desde la consola web. Para ello accedemos desde la vista **Developer** a la opción de **+Add** y elegimos el apartado **Git Repository**:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/codigoweb1.png){: .align-center }

### Despliegue de una página estática con un servidor apache2

Queremos construir una imagen con un servidor web a partir de un repositorio donde tenemos una página web estática, para ello vamos a configurar el despliegue:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/codigoweb2.png){: .align-center }

Indicamos el repositorio donde se encuentra la aplicación (`https://github.com/josedom24/osv4_html.git`). Y vemos que nos detecta una **Builder Image** para construir la nueva imagen, pero no nos muestra la que nos recomienda. Como pasaba en el apartado anterior, OpenShift no puede determinar el lenguaje con el que está escrita la aplicación, por lo que tendremos que indicar la **Builder Image** que vamos a utilizar. Para ello pulsamos sobre la opción **Edit Import Strategy**:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/codigoweb3.png){: .align-center }

Vemos que ha seleccionado la estrategia de construcción (**Builder Image**) pero, como indicábamos, no se ha seleccionado ninguna. Nosotros podemos seleccionar una imagen para construir la nueva imagen (en nuestro caso *httpd*) y podemos elegir la versión de la imagen que hemos escogido.

Una vez lo hemos hecho, seguimos con la configuración de forma similar al despliegue de una imagen:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/codigoweb4.png){: .align-center }

* El nombre de la aplicación que nos va permitir agrupar distintos recursos con un mismo nombre.
* El nombre del despliegue.

Continuamos con la configuración:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/codigoweb5.png){: .align-center }

* El puerto donde se ofrece el servicio, normalmente es el 8080, pero dependerá de la imagen que estamos desplegando.
* Indicamos que se cree un objeto **Route** para acceder a la aplicación por medio de una URL.
* Pulsamos sobre la opción **Resource type** y elegimos **Deployment**.

Finalmente le damos al botón **Create** para crear el despliegue, esperamos unos segundos y accedemos al apartado **Topology** y comprobamos que se han creado los distintos recursos:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/codigoweb6.png){: .align-center }

Podemos ver que tenemos varias secciones en el icono que representa el despliegue:

1. Representa la aplicación. Es una agrupación de recursos. Si borramos la aplicación, se borrarán todos los recursos.
2. Representa el **Deployment**: En la pantalla lateral, podemos acceder a algunos de los recursos que se han creado.
3. Si pulsamos sobre "la flechita" se abrirá una nueva página web con la URL del objeto **Route** que nos permitirá el acceso a la aplicación.
4. El estado de la construcción (**Build**), podemos ver si se está produciendo una construcción, o si ha finalizado con éxito.

En la pantalla lateral, ahora tenemos una sección de **Builds** donde tenemos la lista de las últimas construcciones y un botón que nos permite iniciar una nueva construcción de imagen.

Se ha creado un objeto **ImageStream** Y un objeto **BuildConfig**:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/codigoweb7.png){: .align-center }
![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/codigoweb8.png){: .align-center }

Al acceder a la URL de la ruta accedemos a la aplicación:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/codigoweb9.png){: .align-center }

## Despliegue de una página estática con un servidor nginx

En este caso al escoger la **Builder Image** elegimos la imagen de *nginx*:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/codigoweb10.png){: .align-center }

### Detección automática del Builder Image

En este caso, si creamos un fichero `index.php` en el repositorio, como se indicaba en el apartado anterior, OpenShift podrá detectar la **Builder Image** que necesita para construir la nueva imagen:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/codigoweb11.png){: .align-center }

Podríamos pulsar sobre la opción **Edit Import Strategy** para cambiar la **Builder Image**, o cambiar la versión de la imagen seleccionada.

### Eliminar la aplicación

Finalmente, hemos hecho tres despliegues agrupados en la aplicación `aplicacion1`.

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/codigoweb12.png){: .align-center }

Si eliminamos la aplicación, se eliminarán todos los recursos que tenemos agrupados.

## Conclusiones 

Ya hemos estudiado dos métodos de despliegues de aplicaciones web en OpenShift v4: [Despliegue de aplicaciones desde imágenes en OpenShift v4](https://www.josedomingo.org/pledin/2023/06/openshift-v4-aplicacion-desde-imagen/) y el método **source-2-image** que nos permite a partir del código fuente guardado en repositorio, crear una nueva imagen y desplegar la aplicación.
En el próximo artículo estudiaremos otra estrategia de despliegue que utiliza un fichero **Dockerfile** para construir la nueva imagen.


