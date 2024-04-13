---
title: 'Introducción a Podman'
permalink: /2024/04/introduccion-podman/
tags:
  - Podman
 
---

![podman]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/04/podman-logo.png){: .align-center }

## Open Container Initiative

La [**Open Container Initiative (OCI)**](https://opencontainers.org/), es un proyecto de la **Linux Foundation** para diseñar un estándar abierto para **virtualización basada en contenedores**. El objetivo de estos estándares es asegurar que las plataformas de contenedores no estén vinculadas a ninguna empresa o proyecto concreto.

Se funda en 2015, y actualmente son muchas las empresas que forman parte de esta iniciativa, y cuyo objetivo es desarrollar las siguientes especificaciones:​

* Una especificación de **entorno de ejecución de contenedores** (Open Container Initiative Runtime Specification normalmente abreviado en OCI Runtime Specification). Describe cómo debe proceder un OCI Runtime para crear un contenedor a partir de una imagen. Los OCI runtime más utilizados son **runC** y **crun**.
* Una especificación de **formato de imagen** (Open Container Initiative Image Format normalmente abreviado en OCI Image Format). Determina el formato para empaquetar la imagen del contenedor de software.
* Una especificación de **distribución de imágenes**(Open Container Initiative Distribution Specification normalmente abreviado en OCI Distribution Specification''). Su objetivo es estandarizar la distribución de imágenes de contenedores.

## Aplicaciones para trabajar con contenedores OCI

Antes de definir las distintas aplicaciones que nos proporciona Red Hat para trabajar con contenedores OCI, vamos a definir una serie de conceptos:

### Terminología sobre contenedores

* **Orquestador de contenedores**: es un programa que gestiona los contenedores que se ejecutan en un clúster de servidores. Nos ofrece muchas características: actualizaciones automáticas, balanceo de carga, tolerancia a fallos, escalabilidad,...

![orquestadores]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/04/orquestador.png){: .align-center }

* **Motor de contenedores**: Software que nos permite gestionar contenedores en un nodo local. Los contenedores puedes ser creados por orquestadores, en ese caso se usan motores como **containerd** o **cri-o**, o pueden ser gestionados por usuarios, en este caso se utilizan motores como **Docker** o **Podman**.

![motores]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/04/motor.png){: .align-center }

* **Entorno de ejecución de contenedores (runtime container)**: Software encargado de configurar el sistema para ejecutar los contenedores. Lo más utilizados son **runc** y **crun**. Otros ejemplos de entornos de ejecución puedes ser **Kata** y **gVisor**.

![entorno]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/04/entorno.png){: .align-center }

### Conceptos relacionados con el trabajo con contenedores

* **Contenedor OCI**:
    * Cumplen la especificación desarrollada por la OCI.
    * Entorno aislado donde se ejecuta una aplicación. 
    * Tiene su propio sistema de ficheros con todas las dependencias que necesita la aplicación para funcionar. 
    * Puede estar conectado a una red virtual y utilizar almacenamiento adicional para no perder la información importante.
    * Utiliza los recursos del servidor donde se está ejecutando (núcleo del sistema operativo, CPU, RAM).    
    * Los contenedores suelen ejecutar un sólo proceso.
    * Los contenedores son efímeros.
* **Imagen OCI**: 
    * El formato de las imágenes cumplen la especificación desarrollado por la OCI. Del mismo modo, la distribución de dichas imágenes cumplen con la especificación OCI.
    * Una imagen es una plantilla de sólo lectura con instrucciones para crear un contenedor OCI. 
    * Contiene el sistema de fichero que tendrá el contenedor. 
    * Además establece el comando que ejecutará el contenedor por defecto. 
    * Podemos crear nuestras propias imágenes o utilizar las creadas por otros y publicadas en un registro. 
    * Un contenedor es una instancia ejecutable de una imagen. 
* **Registros de Imágenes**:
    * Un registro almacena imágenes.
    * Los registros pueden ser públicos o privados.
    * Tenemos un registro local donde se descargan las imágenes desde la que vamos a crear los contenedores.
    * Tenemos registros remotos desde donde podemos bajar las imágenes, o subirlas para su distribución.
    * Podemos trabajar con distintos registros:
        * `docker.io`: El es registro público de Docker, llamado Docker Hub.
        * `quay.io`: Es un registro público de imágenes proporcionado por Red Hat.
        * `registry.access.redhat.com`: Es otro registro ofrecido por Red Hat, que ofrece imágenes de contenedores certificadas y soportadas por Red Hat Enterprise Linux (RHEL), OpenShift y otras tecnologías relacionadas con Red Hat.
        * `registry.fedoraproject.org`: Es un registro de imágenes de contenedores OCI mantenido por el Proyecto Fedora. Contiene imágenes de contenedores basadas en Fedora y otras tecnologías relacionadas con Fedora.
        * Amazon Elastic Container Registry (ECR)
        * Google Container Registry (GCR)
        * Azure Container Registry (ACR)
        * GitLab Container Registry

### Herramientas de Red Hat para trabajar con contenedores

Podman, Buildah y Skopeo son tres herramientas relacionadas que se utilizan en el mundo de los contenedores. Aunque tienen funcionalidades diferentes, trabajan en conjunto para facilitar la construcción, ejecución y administración de contenedores. 

* **Podman**: Es un **motor de contenedores OCI**, que permite a los usuarios crear, ejecutar y gestionar contenedores sin necesidad de un demonio (daemon) centralizado. Podman utiliza un enfoque basado en procesos, lo que lo hace más seguro y adecuado para entornos donde se requiere aislamiento y seguridad. 
* **Buildah**: Es una herramienta para la **construcción de imágenes de contenedores** sin necesidad de ejecutar un demonio. Permite a los usuarios construir imágenes de contenedores OCI desde cero o a partir de un contenedor existente sin necesidad de un fichero `Dockerfile`. 
* **Skopeo**: Es una herramienta que facilita la **gestión de imágenes de contenedores**. Permite a los usuarios copiar imágenes de un registro a otro, inspeccionar imágenes y firmas, y realizar otras operaciones relacionadas con imágenes sin necesidad de descargarlas en el sistema local. 

<!--more-->

## Podman

[**Podman (the POD MANager)**](https://podman.io/) es una herramienta para gestionar contenedores e imágenes OCI, volúmenes montados en esos contenedores y Pods (grupos de contenedores). Podman ejecuta contenedores en **Linux**, pero también puede utilizarse en sistemas **Mac y Windows** utilizando una máquina virtual gestionada por Podman. 

Podman se basa en **libpod**, una biblioteca para la gestión del ciclo de vida de los contenedores. La librería libpod proporciona APIs para la gestión de contenedores, Pods, imágenes de contenedores y volúmenes.

Podman es una herramienta nativa de Linux, de **código abierto** y **sin demonio**, diseñada para facilitar la búsqueda, ejecución, creación, uso compartido y despliegue de aplicaciones mediante contenedores e imágenes OCI. Podman proporciona una interfaz de línea de comandos (CLI) familiar para cualquiera que haya utilizado el motor de contenedores Docker. 

## Características principales de Podman

### Línea de comandos amigable

Podman se ha desarrollado después de Docker, por lo que sus creadores se han basado en muchas de sus funcionalidades. Entre ellas, el CLI, las opciones de línea de comandos de Podman son muy similares al CLI de Docker, por lo que en un primer momento basta con cambiar el comando `docker` por `podman` y podemos empezar a trabajar con contenedores. Muchas distribuciones Linux ofrecen un paquete llamado `podman-docker` que añade un alias para que al poner el comando `docker` se ejecute el comando `podman`.

Por ejemplo para crear un servidor web en un contenedor Podman, podemos ejecutar:

```bash
$ podman run -d -p 8080:80 --name servidor_web quay.io/libpod/banner
```

Y podemos ver el contenedor en ejecución:

```bash
$ podman ps
CONTAINER ID  IMAGE                           COMMAND               CREATED        STATUS        PORTS                 NAMES
45beec76a967  quay.io/libpod/banner:latest    nginx -g daemon o...  4 seconds ago  Up 4 seconds  0.0.0.0:8080->80/tcp  servidor_web
```

Y podemos acceder al servidor web en el puerto 8080/tcp accediendo a la dirección IP del servidor donde tenemos instalado Podman:

```bash
$ curl http://localhost:8080
   ___          __              
  / _ \___  ___/ /_ _  ___ ____ 
 / ___/ _ \/ _  /  ' \/ _ `/ _ \
/_/   \___/\_,_/_/_/_/\_,_/_//_/
```

### Contenedores rootless

Probablemente la característica más significativa de Podman es su capacidad para ejecutar contenedores por un usuario sin privilegios. No es necesario usar `root` para la ejecución de contenedores.

Esto es útil, cuando queremos que cualquier usuario del sistema pueda ejecutar contenedores y construir imágenes de contenedores, sin requerir acceso de `root`. 

Esta característica nos ofrece un alto grado de seguridad en la ejecución de contenedores.

Aunque en Docker también se puede hacer uso de esta [característica](https://docs.docker.com/engine/security/rootless/), su implantación se ha introducido en versiones más nuevas del producto. Sin embargo, en Podman está característica fue desarrolla desde el comienzo del proyecto.

### Arquitectura Fork/Exec

Docker posee una arquitectura cliente-servidor. El cliente Docker se conecta al demonio Docker para gestionar el contenedor. Podemos entender el demonio Docker como un intermediario entre el cliente Docker y el OCI runtime que gestiona el contenedor. Veamos el diagrama:

![docker](img/docker.png)

En resumen, el cliente Docker se comunica con el demonio Docker, que a su vez se comunica con el demonio *containerd*, que finalmente lanza un OCI runtime como *runc* para lanzar el contenedor. La gestión de contenedores es compleja, y cualquier fallo en los elementos involucrados pueden hacer que el contenedor no funcione de manera adecuada.

Podman sigue el modelo Fork/Exec, que tradicionalmente ha funcionado en los sistemas Unix: cuando ejecutamos un nuevo programa, un proceso padre (por ejemplo, `bash`) ejecuta el nuevo programa como un proceso hijo.

En el caso de Podman, al crear un contenedor se crea un proceso hijo, del proceso correspondiente al OCI runtime. Veamos un esquema de este mecanismo:

![podman](img/podman.png)

Este mecanismo de creación de contenedores es mucho más sencillo y nos proporciona una manera más segura de trabajar con contenedores.

### Podman no tiene demonio

Como hemos visto anteriormente, Podman es un software *daemonless*. La diferencia fundamental entre Podman y Docker, es que Podman no tiene un demonio en ejecución. Podman realiza las mismas operaciones que Docker sin necesidad de tener un proceso demonio en ejecución que gestione el ciclo de vida de los contenedores.

Sin embargo para permitir que otros programas puedan usar Podman como gestor de contenedores, Podman puede ofrecer una API REST compatible con la ofrecida por Docker. 

### Integración con systemd

Systemd es el principal sistema de inicialización en los sistemas operativos Linux. Es el responsable de crear el proceso `init` que inicializa el espacio de usuario durante el proceso de arranque de Linux y gestionar posteriormente todos los demás procesos.

Podman puede integrar completamente la ejecución de contenedores con el sistema de systemd. Por lo tanto, podemos usar systemd para gestionar el ciclo de vida de los contenedores.

Los contenedores trabajan como unidades de systemd que podemos invocar como si fueran cualquier otro proceso.

### Pods

Una de las ventajas de Podman se el trabajo con Pods. Un Pod es una envoltura ("vaina") de uno o más contenedores, con recursos compartidos de almacenamiento y red, y una especificación de cómo ejecutar los contenedores.

Podman puede trabajar con un solo contenedor a la vez, o puede gestionar grupos de contenedores juntos en un Pod. Los Pods permiten agrupar varios servicios para formar un servicio mayor gestionado como una entidad única. 

Además, Podman es capaz de generar archivos YAML de de Kubernetes a partir de contenedores y Pods en ejecución.

### Registros de contenedores personalizables

Con Podman podemos gestionar imágenes OCI usando su nombre corto, sin necesidad de indicar el nombre del registro. 

Por ejemplo, el nombre de imagen `ubi8` corresponde al nombre completo `registry.access.redhat.com/library/ubi8:latest`, donde se indica los nombres del registro, del repositorio, de la imagen y de la etiqueta.

En Podman podemos especificar múltiples registros, de tal forma que cuando indicamos el nombre de una imagen, se nos da a elegir entre los distintos registros que tenemos configurados.

```
podman pull nginx
? Please select an image: 
  ▸ registry.fedoraproject.org/nginx:latest
    registry.access.redhat.com/nginx:latest
    docker.io/library/nginx:latest
    quay.io/nginx:latest
```
Al elegir la imagen concreta que queremos descargar, se creará un alias para recordar la selección.

## Conclusiones

Podman es un gestor de contenedores de aplicación que nos ofrece muchas características y funciones muy interesantes. Como lo estoy aprendiendo, escribiré algunos artículos en el blog centrándome en las funcionalidades más interesantes: contenedores rootless, trabajo con Pods, integración con systemd,...
