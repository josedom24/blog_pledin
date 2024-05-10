---
title: 'Introducción a OpenShift v4'
permalink: /2023/05/introduccion-openshift-v4/
tags:
  - OpenShift
  - kubernetes
---

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/openshift.png){: .align-center }

[OpenShift v4](https://www.redhat.com/es/openshift-4) es una plataforma de contenedores desarrollada por RedHat y de código abierto basada en Kubernetes que proporciona una solución completa de orquestación de contenedores y servicios de aplicaciones para desarrolladores y equipos de operaciones. 

Por lo tanto nos ofrece muchas de las ventajas de usar un orquestador de contenedores como Kubernetes:

* Desplegar aplicaciones de forma muy sencilla.
* Tolerancia a fallos.
* Escalalabilidad de las aplicaciones.
* Actualizaciones automáticas de las aplicaciones.
* Permite limitar los recursos a utilizar.
* Enrutamiento a nuestras aplicaciones.
* Uso de volúmenes para guardar la información.
* ...

Pero lo más importante, es que podemos considerar OpenShift como una plataforma **PaaS**, que permite a los desarrolladores centrarse en el desarrollo del código, para que posteriormente de una manera muy sencilla y automática sean capaces de desplegar sus aplicaciones en contenedores y con las ventajas que obtenemos de tenerlos gestionados por Kubernetes.

¿Qué aspectos caracterizan a OpenShift para considerarlo una plataforma PaaS?

* No es necesario diseñar la definición YAML de los recursos de kubernetes que vamos a gestionar.
* Tenemos a nuestra disposición herramientas de despliegue de aplicaciones que crean y gestionan los recursos kubernetes por nosotros.
* Tiene procesos de construcción automática de imágenes de contenedores.
* Nos simplifica el ciclo de vida de implantación de nuestras aplicaciones.
* Es muy fácil de implementar un despliegue continúo que haga que una modificación del código conlleve, de forma automática, el despliegue de una nueva versión de la aplicación.
* Permite la integración con herramienta de IC/DC, que nos facilita la gestión del ciclo de vida de la aplicación.
* Nos permite de forma sencilla desplegar aplicaciones en distintos entornos: Desarrollo, Pruebas, Producción,...
* Tenemos a nuestra disposición distintas herramientas de métrica y monitorización.
* Despliegue sencillo de aplicación con el uso de Plantillas.
* Tenemos varios mecanismos para interactuar con OpenShift: entorno web, cliente de línea de comandos o uso de la API.
* Se integra con muchas herramientas de ecosistema de Kubernetes que nos ofrecen distintas funcionalidades: Tekton (integración y despliegue continuo), Knative (aplicaciones Serverless), Helm (despliegue y gestión del ciclo de vida de aplicaciones),...

<!--more-->

## Red Hat OpenShift Dedicated Developer Sandbox

La versión **Developer Sandbox** de **OpenShift Dedicated** nos permite probar OpenShift v4 en una plataforma con las siguientes características:

* Accedemos a un clúster de OpenShift administrado por Red Hat. Tenemos a nuestra disposición un proyecto para trabajar con un usuario sin privilegios.
* El uso de esta plataforma no tiene ningún coste (no hace falta introducir la tarjeta de crédito para darte de alta).
* Para acceder a la plataforma es necesario tener una cuenta en el portal de Red Hat y es necesario validar tu número de teléfono.
* El periodo de uso es de un mes. Una vez terminada la prueba se borrará el proyecto, pero siempre puedes volver a crear uno nuevo para tener otro mes de prueba.
* Nos ofrece la mayoría de las funcionalidades de OpenShift. Aunque como es administrada por Red Hat, si falta alguna funcionalidad no podemos instalarla.
* La cuota de recursos que podemos usar en nuestro proyecto es de 7 GB RAM, y 15 GB de almacenamiento.
* La idea es que no se utilice esta plataforma como entorno de producción, por lo que las aplicaciones se paran a las 12 horas de su creación. Aunque siempre podemos volver a activarlas.
* La plataforma está implementada sobre un clúster de instancias de AWS. En este caso, cuando trabajemos con el almacenamiento tendremos a nuestra disposición los medios de almacenamiento que ofrece el proveedor: AWS Elastic Block Store (EBS).
* Al usar un usuario sin privilegios, no tendremos acceso a algunos recursos: la gestión de proyectos, los nodos del clúster, los volúmenes de almacenamiento,...

[Acceso a Red Hat OpenShift Dedicated Developer Sandbox](https://developers.redhat.com/developer-sandbox)

## Visión general de la consola web

Podemos usar la **consola web** (aplicación web) para interactuar con el clúster de OpenShift y nos permite gestionar todos los recursos del clúster. La consola web, nos permite trabajar con ella usando dos vistas distintas: la de **Administrador** y la de **Desarrollador**.

### Consola web: vista Developer

**En la vista Developer**, los usuarios tienen acceso a herramientas para desarrollar, implementar y supervisar aplicaciones en el clúster de OpenShift.

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/developer.png){: .align-center }

Algunas de las opciones que tenemos disponibles en esta vista son:

* **+Add**: Tenemos a nuestra disposición una página donde podemos escoger entre los distintos mecanismos que nos ofrece OpenShift para crear aplicaciones en el clúster: desde un repositorio Git, desde el catálogo de aplicaciones, desde imágenes de contenedores, desde ficheros YAML,... 
* **Topology**: En este apartado vemos gráficamente los recursos que tenemos creados en el clúster y de una manera sencilla podemos acceder a ellos para su gestión.
* **Observe**: En este apartado tenemos las herramientas de monitorización y supervisión. Podemos ver paneles gráficos con el consumo de recursos (CPU, memoria, uso de la red,...), elegir distintas métricas, las alertas que hemos definido o los eventos que han ocurrido en el clúster.
* **Search**: Nos permite, de una manera sencilla, buscar los recursos que hemos creado en el clúster, pudiendo filtrar por las etiquetas.
* **Build**: En esta opción accedemos a los recursos **Builds** que hemos creado y que nos permiten la construcción automática de imágenes.
* **Pipelines**: Nos permite gestionar los flujos de IC/DC que hemos definido.
* **Helm**: Nos permite la configuración de la herramienta Helm, que nos proporciona una manera rápida y sencilla de realizar instalaciones en nuestro clúster.
* **Project**: Nos permite gestionar los proyectos a los que tenemos acceso.
* Desde la opción **Search**, podemos escoger un recurso de la API y "engancharlo" en el menú de navegación de la vista Developer, por defecto nos encontramos los recursos **ConfigMaps** y **Secrets**.

### Consola web: vista Administrator

**En la vista Administrator**, los usuarios tienen acceso a herramientas para administrar el clúster de OpenShift y las aplicaciones que se ejecutan en él. 

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/administrator.png){: .align-center }

Al estar usando un usuario sin privilegios en **Red Hat OpenShift Dedicated Developer Sandbox**, algunas de las opciones no nos dan todas las funcionalidades de administración.

Algunas de las opciones que tenemos disponibles en esta vista son:

* **Home**: Nos da acceso a los proyectos definidos en el clúster, a la opción de búsqueda de recursos, a un explorador de los recursos de la API y a los eventos que han ocurrido en el clúster.
* **Operators**: Los operadores nos permiten añadir funcionalidades a nuestro clúster. En el caso del uso de **Red Hat OpenShift Dedicated Developer Sandbox**, al ser un clúster administrado por Red Hat, no tenemos permisos para añadir nuevos operadores.
* **Workloads**: Nos permite la gestión de los recursos de la API relacionados con el despliegue de aplicaciones: **Deployment**, **ReplicaSet**, **Pod**, ...
* **Serverless**: Nos proporciona la posibilidad de gestionar las aplicaciones que hemos desplegado como Serverless, que nos permite desplegar aplicaciones sin tener que preocuparse por el número de réplicas en ejecución. En lugar de utilizar réplicas, la aplicación se ejecuta en un **pod autoscaling** que se adapta automáticamente según la demanda.
* **Networking**: Nos permite la gestión de todos los recursos de la API que nos permiten el acceso a las aplicaciones: **Service**, **Routes**,...
* **Storage**: Nos da acceso a la gestión de los recursos relacionados con el almacenamiento: **PersistentVolumeClaim**, **PersitentVolume**,...
* **Build**: En esta opción accedemos a los recursos **Builds** que hemos creado y que nos permiten la construcción automática de imágenes. Nos ofrece más opciones que en la vista Developer.
* **Pipelines**: Nos permite acceder a los flujos de IC/DC que hemos definido. Nos ofrece más opciones que en la vista Developer.
* **User Management**: Gestión de los usuarios del clúster. 
* **Administration**: Configuración general del clúster.

## Instalación del CLI de OpenShift: oc

La herramienta `oc` nos permite gestionar los recursos de nuestro clúster de OpenShift desde la línea de comandos.

Para más información de esta herramienta puedes acceder a la [documentación oficial](https://docs.openshift.com/container-platform/4.12/cli_reference/openshift_cli/getting-started-cli.html).

Tenemos varios métodos de instalación de esta herramienta, nosotros vamos a hacerlo desde la consola web de OpenShift.

### Instalación de oc desde la consola web

Accedemos a la consola web y escogemos el icono de ayuda en la parte superior derecha, y posteriormente elegimos la opción **Command Line Tools**:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/oc.png){: .align-center }

Nos aparecerá una página donde podremos descargarnos las distintas versiones de la herramienta, en mi caso he escogido la versión Linux x86_64.

Nos descargamos un fichero comprimido `oc.tar`, lo descomprimimos y lo copiamos con permisos de ejecución en un directorio del PATH:

    tar xvf oc.tar
    sudo install oc /usr/local/bin

Y comprobamos la versión que hemos instalado:

    oc version
    Client Version: 4.12.0-202303081116.p0.g846602e.assembly.stream-846602e
    Kustomize Version: v4.5.7

Si ejecutamos cualquier comando con la herramienta `oc` nos recuerda que nos tenemos que loguear:

    oc get deploy
    error: You must be logged in to the server (Unauthorized)

## Configuración de oc para el Developer Sandbox

Una vez que tenemos instalado la herramienta `oc`, el siguiente paso el realizar el login en nuestro clúster. En el caso de **Red Hat OpenShift Dedicated Developer Sandbox**, la autentificación se hace por medio de un token.

Para obtener este token accedemos al menú que aparece al pulsar sobre nuestro nombre de usuario (parte superior derecha), eligiendo la opción **Copy login command**:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/oclogin1.png){: .align-center }

Copiamos la instrucción de login:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/oclogin2.png){: .align-center }

Y la ejecutamos:

    oc login --token=sha256~xxxxxxxxxxxxx... --server=https://api.sandbox-m3.1530.p1.openshiftapps.com:6443

    Logged into "https://api.sandbox-m3.1530.p1.openshiftapps.com:6443" as "josedom24" using the token provided.

    You have one project on this server: "josedom24-dev"

    Using project "josedom24-dev".

Como vemos, hemos accedido con el usuario y estamos usando un proyecto, que en mi caso se llama `josedom24-dev`.

Al igual que en kubernetes, la configuración de acceso se guarda en el fichero `~/.kube/config`:

```yaml
apiVersion: v1
clusters:
- cluster:
    server: https://api.sandbox-m3.1530.p1.openshiftapps.com:6443
  name: api-sandbox-m3-1530-p1-openshiftapps-com:6443
contexts:
- context:
    cluster: api-sandbox-m3-1530-p1-openshiftapps-com:6443
    namespace: josedom24-dev
    user: josedom24/api-sandbox-m3-1530-p1-openshiftapps-com:6443
  name: josedom24-dev/api-sandbox-m3-1530-p1-openshiftapps-com:6443/josedom24
current-context: josedom24-dev/api-sandbox-m3-1530-p1-openshiftapps-com:6443/josedom24
kind: Config
preferences: {}
users:
- name: josedom24/api-sandbox-m3-1530-p1-openshiftapps-com:6443
  user:
    token: sha256~UDgHaWXrosaNOAJEFxjhqZMPgH8ksbREvd8LZ_7mFYw
```

Donde vemos que se ha creado un contexto, donde se guarda el servidor al que nos conectamos (`cluster`), el namespace o proyecto que estamos usando (`namespace`) y el usuario (`user`). Como hemos indicado el usuario utiliza el token para autentificarse sobre el clúster.

Esta operación habrá que repetirla cada vez que el token se caduque.

Como hemos indicado anteriormente el proyecto que estamos usando se corresponde con un recurso `namespace` que nos permite agrupar todos nuestros recursos. Con el usuario que usamos tenemos acceso a nuestro proyecto, pero no podemos acceder a los recurso `namespaces` que están definidos en el clúster:

    oc get project
    NAME            DISPLAY NAME    STATUS
    josedom24-dev   josedom24-dev   Active
    
    oc get namespace
    Error from server (Forbidden): namespaces is forbidden: User "josedom24" cannot list resource "namespaces" in API group "" at the cluster scope

### Terminal desde la consola web

Si pulsamos sobre el siguiente icono en la parte superior derecha de la consola web:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/oclogin3.png){: .align-center }

Nos permitirá abrir eun terminal en la consola web:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/oclogin4.png){: .align-center }

Debemos indicar el proyecto donde se creará un recurso **DevWorkspace** donde se creará un **Deployment** que creará un Pod donde se ejecutará el terminal que estamos usando:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/oclogin5.png){: .align-center }

## Visión general del proyecto de trabajo

Un proyecto permite a OpenShift agrupar distintos recursos. Es similar al recurso **namespace** de Kubernetes, pero guarda información adicional.

De hecho, cada vez que se crea un nuevo proyecto, se crea un recursos **namespace** con el mismo nombre.

En **Red Hat OpenShift Dedicated Developer Sandbox**, no podemos crear nuevos proyectos y se nos asigna de forma automática un proyecto con el mismo nombre que el de nuestro usuario.

Para acceder a la información de nuestro proyecto, en la **Vista Administrator**, escogemos la opción **Home -> Projects**:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/proyecto1.png){: .align-center }

Si pulsamos sobre el nombre del proyecto, obtendremos los detalles del mismo: definición, inventario, uso de recursos, métricas, cuotas, eventos,...

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/proyecto2.png){: .align-center }

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/proyecto3.png){: .align-center }

Tenemos varias opciones:

* **Details**: Detalles de la definición del proyecto.
* **YAML**: Definición YAML del recurso proyecto.
* **Workloads**: Acceso a todos los recursos definidos en este proyecto.
* **RoleBindings**: Permisos definidos para este proyecto.

## Conclusiones

En esta entrada hemos estudiado las características fundamentales de la plataforma OpenShift v4. Hemos visto los dos métodos fundamentales de interactuar con ella: la **consola web** y la herramienta de línea de comandos **oc**. En el próximo articulo veremos algunos ejemplos ppara enseñar como desplegar aplicaciones en contenedores usando OpenShift v4.