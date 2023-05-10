---
title: 'Hello Minikube'
permalink: /2023/05/hello-minikube/
tags:
  - kubernetes
---

![k8s]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/kubernetes-horizontal-color.png){: .align-center }


**Hello Minikube** es un [tutorial de iniciación sobre el uso básico de Kubernetes](https://kubernetes.io/es/docs/tutorials/hello-minikube/). ¿Por qué escribo un artículo en Pledin sobre este tutorial? Porque desde la página del tutorial podemos ejecutar un clúster de minikube en una máquina remota y podemos gestionarlo desde un terminal desde la propia página web.

[minikube](https://minikube.sigs.k8s.io/docs/start/) es un software que crea un clúster de Kubernetes en una máquina virtual o en un contenedor Docker con un propósito educativo y permitirnos hacer pruebas del orquestador de contenedores Kuberentes.

[Katacoda](https://www.oreilly.com/online-learning/leveraging-katacoda-technology.html) es una plataforma perteneciente a O'Reilly y que proporciona entornos operativos de diferentes tecnologías con un propósito formativo y que nos ofrece en el tutorial [Hello Minikube](https://kubernetes.io/es/docs/tutorials/hello-minikube/) la posibilidad de ejecutar en una máquina remota un clúster de Kubernetes usando minikube.

Para ello, tan sólo tenemos que pulsar sobre el botón **Launch Terminal** en la página de **Hello Minikube**:

![minikube]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/minikube1.png){: .align-center }

<!--more-->

## Uso de minikube en "Hello Minikube"

Una vez hemos pulsado el el botón de creación del terminal, nos aparece una ventana en la parte inferior, donde vemos el proceso de la instalación de minikube:

![minikube]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/minikube2.png){: .align-center }

Por ejemplo si queremos acceder al dashboard de Kubernetes, tenemos que ejecutar `minikube dashboard` y acceder al puerto `30000` del host, para ello accedemos a la pestaña **Preview Port 30000**:

![minikube]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/minikube3.png){: .align-center }

Y accedemos a la página web donde gestionamos Kubernetes desde su dashboard:

![minikube]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/minikube4.png){: .align-center }

## Tutorial "Hello Minikube"

Vamos a seguir los pasos del ejercicio que nos propone el tutorial **Hello Minikube**. Creamos un **Deployment** a partir de una imagen docker de ejemplo:

	kubectl create deployment hello-node --image=registry.k8s.io/echoserver:1.4

![minikube]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/minikube5.png){: .align-center }

A continuación, creamos un **Service** de tipo **LoadBalancer**:

	kubectl expose deployment hello-node --type=LoadBalancer --port=8080

![minikube]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/minikube6.png){: .align-center }

Para los proveedores Cloud que soportan balanceadores de carga, una dirección IP externa será provisionada para acceder al servicio, para el Minikube proporcionado por Katacoda que estamos usando nos interesa el puerto que ha asignado al **Service** y que hará la redirección al puerto `8080` donde está respondiendo la aplicación, en nuestro caso es el puerto  **31251**.

Ahora, hacemos clic sobre el símbolo **+**, y luego en **Select port to view on Host 1**, en la página que nos sale tenemos que poner el puerto que se ha asignado al servicio:

![minikube]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/minikube7.png){: .align-center }

Y al pulsar sobre el botón **Display Port** se accederá a la aplicación:

![minikube]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/minikube8.png){: .align-center }

## Habilitar extensiones en Minikube

Podemos habilitar y deshabilitar las extensiones de minikube. Por ejemplo, para ver las extensiones, ejecutamos:

	minikube addons list

Si queremos habilitar la extensión que nos aporta las métricas de recursos, podemos ejecutar:

	minikube addons enable metrics-server

Y para ver los recursos que se han creado:

	kubectl get pod,svc -n kube-system

![minikube]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/minikube9.png){: .align-center }

## Desplegando una aplicación guardada en un repositorio GitHub

En la máquina virtual que se crea, tenemos muchas herramientas instaladas, por ejemplo `git`, esto nos ofrece la posibilidad de clonar cualquier repositorio que tengamos y poder trabajar con los manifiestos YAML de Kubernetes que nos permiten el despliegue de una aplicación.

Por ejemplo, voy a trabajar con el repositorio `https://github.com/josedom24/example-hello-minikube`, donde tenemos un fichero YAML para crear un despliegue usando la imagen `paulbouwer/hello-kubernetes:1` que crea una aplicación en node.js que muestra un mensaje **Hello world!** y alguna otra información. Para más información sobre esta imagen, puedes estudiar el [repositorio de la aplicación](https://github.com/paulbouwer/hello-kubernetes) y el repositorio en [Docker Hub](https://hub.docker.com/r/paulbouwer/hello-kubernetes/).

Vamos a clonar el repositorio y creamos los recursos a a partir de los ficheros YAML:

	git clone https://github.com/josedom24/example-hello-minikube.git
	cd example-hello-minikube/
	kubectl apply -f deployment.yaml 
	kubectl apply -f service.yaml 

![minikube]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/minikube10.png){: .align-center }

Podemos ver los recursos creados, ejecutando `kubectl get all`:

![minikube]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/minikube11.png){: .align-center }

eY para acceder, pulsamos sobre el símbolo **+**, y luego en **Select port to view on Host 1**, en la página que nos sale ponemos el puerto que han asignado al servicio, en este ejmplo el **30025** y pulsando sobre el botón **Display Port**, accedemos a la aplicación:

![minikube]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/05/minikube12.png){: .align-center }

## Conclusiones

Si tienes que hacer alguna prueba con Kubernetes y no tienes tu ordenador personal a mamo, puedes usar esta instalación de minikube totalmente operativa y online. Un saludo a todos.

