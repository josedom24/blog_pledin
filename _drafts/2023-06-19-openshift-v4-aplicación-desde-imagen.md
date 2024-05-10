---
title: 'Despliegue de aplicaciones desde imágenes en OpenShift v4'
permalink: /2023/06/openshift-v4-aplicacion-desde-imagen/
tags:
  - OpenShift
  - kubernetes
---

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/openshift.png){: .align-center }

Una forma de trabajar con OpenShift es a partir de la definición de los recursos en fichero con formato YAML, y utilizar la herramienta de línea de comando **oc** (`oc apply...`) o la **consola web** para gestionar los recursos.

Sin embargo, lo que le da más potencialidad a OpenShift son los diferentes métodos de creación de despliegues de una forma automática. Esta funcionalidad es la que otorga a OpenShift las características de Cloud Computing PaaS, ya que nos ofrece la posibilidad de desplegar aplicaciones de una forma muy sencilla.

Los principales métodos de implementar una aplicación son:

* Desplegar una aplicación a partir de una **imagen ya existente**.
* **Source-to-Image (s2i)**: Construir de forma automática una nueva imagen a partir de una aplicación que tengamos guardada en un repositorio git. A partir de la imagen que genera de forma automática se despliega la aplicación. 
* Construir una nueva imagen generada a partir de un fichero **Dockerfile**, y desplegar la aplicación desde esa imagen construida.
* Desplegar aplicaciones a partir de plantillas.
* Desplegar aplicaciones desde un pipeline de IC/DC.

En este artículo vamos a desplegar aplicaciones partiendo de una imagen de contenedor. En este tipo de despliegues no se utiliza directamente una imagen que está almacenada en un registro, se utiliza un recurso llamado **ImageStream** que nos permite referenciar a las imágenes que tenemos en un registro externo o en el registro interno de imágenes de OpenShift. 

<!--more-->

## Despliegue de aplicaciones desde imágenes con oc

El esquema para ver los recursos que se crean en OpenShift al realizar un despliegue desde una imagen es el siguiente:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/despliegue-imagen.png){: .align-center }

Para crear un despliegue desde la imagen `josedom24/test_web:v1` que se llame `test-web` ejecutamos el comando:

    oc new-app josedom24/test_web:v1 --name test-web

    --> Found container image 4b01a27 (12 days old) from Docker Hub for "josedom24/test_web:v1"

        * An image stream tag will be created as "test-web:v1" that will track this image

    --> Creating resources ...
        imagestream.image.openshift.io "test-web" created
        deployment.apps "test-web" created
        service "test-web" created
    --> Success
        Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
         'oc expose service/test-web' 
        Run 'oc status' to view your app.

Como vemos se han creado varios recursos:

1. Ha encontrado una imagen llamada `josedom24/test_web:v1` en Docker Hub.
2. Ha creado un recurso **ImageStream** que ha llamado igual que la aplicación y la ha etiquetado con la misma etiqueta que tiene la imagen y que referencia a la imagen original.
3. Ha creado un recurso **Deployment** responsable de desplegar los recursos necesarios para ejecutar los Pods.
4. Ha creado un recurso **Service** que nos posibilita el acceso a la aplicación.
5. No ha creado un recurso **Route** para el acceso por medio de una URL, pero nos ha indicado el comando necesario para crearlo.

Creamos el recurso **Route**:

    oc expose service/test-web

Y comprobamos los recursos que se han creado:

    oc status
    ...
    http://test-web-josedom24-dev.apps.sandbox-m3.1530.p1.openshiftapps.com to pod port 8080-tcp (svc/test-web)
      deployment/test-web deploys istag/test-web:v1 
        deployment #2 running for about a minute - 1 pod
        deployment #1 deployed about a minute ago

También podemos ver los recursos que hemos creado, ejecutando:

    oc get all

    NAME                            READY   STATUS    RESTARTS   AGE
    pod/test-web-6f87bb78f9-9f2v5   1/1     Running   0          2m23s

    NAME                        TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                               AGE
    service/modelmesh-serving   ClusterIP   None           <none>        8033/TCP,8008/TCP,8443/TCP,2112/TCP   19d
    service/test-web            ClusterIP   172.30.75.17   <none>        8080/TCP,8443/TCP                     2m23s

    NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/test-web   1/1     1            1           2m23s

    NAME                                  DESIRED   CURRENT   READY   AGE
    replicaset.apps/test-web-6c944c9765   0         0         0       2m23s
    replicaset.apps/test-web-6f87bb78f9   1         1         1       2m23s

    NAME                                      IMAGE REPOSITORY                                                                                          TAGS   UPDATED
    imagestream.image.openshift.io/test-web   default-route-openshift-image-registry.apps.sandbox-m3.1530.p1.openshiftapps.com/josedom24-dev/test-web   v1     2 minutes ago

    NAME                                HOST/PORT                                                          PATH   SERVICES   PORT       TERMINATION   WILDCARD
    route.route.openshift.io/test-web   test-web-josedom24-dev.apps.sandbox-m3.1530.p1.openshiftapps.com          test-web   8080-tcp                 None

Veamos algunos aspectos con detalle:

1. Vemos que se han creado dos despliegues, dos recursos **ReplicaSet**: En realidad, en el proceso interno de creación del despliegue se crea un **ReplicaSet** pero no tiene indicada la imagen, por eso falla y a continuación se vuelve a crear otro que ya si funciona y crea el pod.
2. Vemos como se ha creado un recurso **ImageStream** que apunta a la imagen que hemos indicado. Podemos ver los detalles de este recurso ejecutando:

        oc describe is test-web

3. El recurso **Deployment** hace referencia en su definición al recurso **ImageStream**:

        oc describe deploy test-web
        ...
        Containers:
         test-web:
         Image:        josedom24/test_web@sha256:99db6f7fdcd6aa338d80b5cd926dff8bae50062c49f82c79a3d67d048efb13a4
        ...

4. Podemos comprobar que si accedemos a la URL generada por el recurso **Route**, la aplicación está funcionando:

    ![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/imagen1.png){: .align-center }

5. Para eliminar la aplicación, tenemos que borrar los recursos que hemos creado:

        oc delete deploy test-web
        oc delete service test-web
        oc delete route test-web
        oc delete is test-web

## Despliegue de aplicaciones desde imágenes desde la consola web

Vamos a realizar el mismo ejercicio pero desde la consola web. Para ello accedemos desde la vista **Developer** a la opción de **+Add** y elegimos el apartado **Container Images**:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/imagenweb1.png){: .align-center }

A continuación vamos a configurar las propiedades del despliegue:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/imagenweb2.png){: .align-center }

* Indicamos la imagen que se va a desplegar.
* El icono con el que se va a representar el despliegue en la topología.
* El nombre de la aplicación que nos va permitir agrupar distintos recursos con un mismo nombre.
* El nombre del despliegue.

Continuamos con la configuración:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/imagenweb3.png){: .align-center }

* El puerto donde se ofrece el servicio, normalmente es el 8080, pero dependerá de la imagen que estamos desplegando.
* Indicamos que se cree un objeto **Route** para acceder a la aplicación por medio de una URL.
* Pulsamos sobre la opción **Resource type** y elegimos **Deployment**.

Finalmente le damos al botón **Create** para crear el despliegue, esperamos unos segundos y accedemos al apartado **Topology** y comprobamos que se han creado los distintos recursos:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/imagenweb4.png){: .align-center }

Podemos ver que tenemos varias secciones en el icono que representa el despliegue:

1. Representa la aplicación. Es una agrupación de recursos. Si borramos la aplicación, se borrarán todos los recursos.
2. Representa el **Deployment**: En la pantalla lateral, podemos acceder a algunos de los recursos que se han creado.
3. Si pulsamos sobre "la flechita" se abrirá una nueva página web con la URL del objeto **Route** que nos permitirá el acceso a la aplicación.

Si pulsamos sobre los tres puntos verticales del cuadro del **Deployment** o sobre el botón **Actions**, obtendremos un menú con todas las acciones que podemos realizar sobre el objeto:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/imagenweb5.png){: .align-center }

Nos queda por comprobar que se ha creado un objeto **ImageStream**, para ello en la vista **Administrator**, en la opción **Builds -> ImageStreams** la podemos encontrar:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/imagenweb6.png){: .align-center }

Al acceder a la URL de la ruta accedemos a la aplicación:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/imagenweb7.png){: .align-center }

Por último podemos borrar todos los recursos creados, eliminando la aplicación:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/06/imagenweb8.png){: .align-center }

## Conclusiones

En este artículo hemos introducido la estrategia dde despliegue de aplicaciones web en OpenShift v4 utilizando una imagen de contenedor. Lo hemos hecho desde la terminal, con el cliente de línea de comandos `oc` y desde el dashboard. En próximos artículos haremos la introducción a otros métodos de despliegue como por ejemplo: **Source-to-Image (s2i)**, **Dockerfile**,...

