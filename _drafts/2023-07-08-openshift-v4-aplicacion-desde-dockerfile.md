---
title: 'Despliegue de aplicaciones desde Dockerfile en OpenShift v4'
permalink: /2023/06/openshift-v4-aplicacion-desde-dockerfile/
tags:
  - OpenShift
  - kubernetes
---

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/07/openshift3.png){: .align-center }

En este artículo vamos a estudiar otro método de despliegue de aplicaciones web que nos ofrece OpenShift V4: Construir una nueva imagen generada a partir de un fichero **Dockerfile**, y desplegar la aplicación desde esa imagen construida.

## Despliegue de aplicaciones desde Dockerfile con oc

El esquema para ver los recursos que se crean en OpenShift al realizar un despliegue desde un fichero `Dockerfile` es el siguiente:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/07/dockerfile.png){: .align-center }

Sigamos trabajando con el mismo repositorio que en el [artículo anterior](https://www.josedomingo.org/pledin/2023/06/openshift-v4-aplicacion-desde-codigo-fuente/) y ahora vamos a suponer que queremos ejecutar nuestra aplicación con otra imagen base y hacer una configuración extra en la creación de la imagen. Tendríamos que crear un fichero `Dockerfile` para especificar los pasos de creación de la imagen. Para ello, creamos un fichero `Dockerfile` en el repositorio con el siguiente contenido:

    FROM bitnami/nginx
    WORKDIR /app
    COPY . /app

Evidentemente, este fichero puede ser más complejo si la construcción de la imagen lo requiere. Ahora guardamos el fichero en el repositorio:

    git add Dockerfile
    git commit -am "php"
    git push

Y ahora al intentar crear una nueva aplicación, OpenShift detectará que hay un fichero `Dockerfile` en el repositorio y lo utilizará para la creación automática de la imagen:

    oc new-app https://github.com/josedom24/osv4_html.git --name=app1

Si queremos que la construcción se vuelva a realizar usando el mecanismo de **Source-to-Image**, tendremos que indicar la estrategia específicamente:

    oc new-app https://github.com/josedom24/osv4_html.git --name=app2 --strategy=source

Y volverá a usar el mecanismo anterior.

<!--more-->

## Despliegue de aplicaciones desde Dockerfile desde la consola web

Como indicábamos en el apartado anterior, ahora vamos a añadir un fichero `Dockerfile` (el mismo que vimos en el apartado anterior) al repositorio. En este caso, volvemos a elegir la opción **+Add** y elegimos el apartado **Git Repository**. Y comprobaremos que ahora nos sugiere la estrategia docker para construir la nueva imagen:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/07/dockerweb1.png){: .align-center }

Si queremos que la construcción se vuelva a realizar usando el mecanismos de **Source-to-Image**, tendremos que indicar la estrategia específicamente pulsando sobre la opción **Edit Import Strategy**:

![openshift]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/07/dockerweb2.png){: .align-center }