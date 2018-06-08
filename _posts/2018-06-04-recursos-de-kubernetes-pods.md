---

status: publish
published: true
title: 'Recursos de Kubernetes: Pods'
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 2001
wordpress_url: https://www.josedomingo.org/pledin/?p=2001
date: '2018-06-04 18:36:07 +0000'
date_gmt: '2018-06-04 16:36:07 +0000'
categories:
- General
tags:
- Cloud Computing
- kubernetes
comments: []
---
<p>La unidad m&aacute;s peque&ntilde;a de kubernetes son los <a href="https://kubernetes.io/docs/concepts/workloads/pods/pod/"><code>Pods</code></a>, con los que podemos correr contenedores. Un <strong>pod</strong> representa un conjunto de contenedores que comparten almacenamiento y una &uacute;nica IP. <strong>Los pods son ef&iacute;meros</strong>, cuando se destruyen se pierde toda la informaci&oacute;n que conten&iacute;a. Si queremos desarrollar aplicaciones persistentes tenemos que utilizar vol&uacute;menes.</p>
<p><a class="thumbnail" href="https://www.josedomingo.org/pledin/wp-content/uploads/2018/06/pod.png"><img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/06/pod.png" alt="" width="960" height="384" class="aligncenter size-full wp-image-2002" /></a></p>
<p>Por lo tanto, aunque Kubernetes es un orquestador de contenedores, la unidad m&iacute;nima de ejecuci&oacute;n son los pods:</p>
<ul>
<li>Si seguimos el principio de <em>un proceso por contenedor</em>, nos evitamos tener sistemas (como m&aacute;quinas virtuales) ejecutando docenas de procesos, </li>
<li>pero en determinadas circunstancias necesito m&aacute;s de un proceso para que se ejecute mi servicio. </li>
</ul>
<p>Por lo tanto parece razonable que podamos tener m&aacute;s de un contenedor compartiendo almacenamiento y direccionamiento, que llamamos <em>Pod</em>. Adem&aacute;s existen mas razones:</p>
<ul>
<li>Kubernetes puede trabajar con distintos contenedores (Docker, Rocket, cri-o,...) por lo tanto es necesario a&ntilde;adir una capa de abstracci&oacute;n que maneje las distintas clases de contenedores.</li>
<li>Adem&aacute;s esta capa de abstracci&oacute;n a&ntilde;ade informaci&oacute;n adicional necesaria en Kubernetes como por ejemplo, pol&iacute;ticas de reinicio, comprobaci&oacute;n de que la aplicaci&oacute;n est&eacute; inicializada (readiness probe), comprobaci&oacute;n de que la aplicaci&oacute;n haya realizado alguna acci&oacute;n especificada (liveness probe), ...</li>
</ul>
<p><strong>Ejemplos de implementaci&oacute;n en pods</strong></p>
<ol>
<li>Un servidor web nginx con un servidor de aplicaciones PHP-FPM, lo podemos implementar en un pod, y cada servicio en un contenedor. </li>
<li>Una aplicaci&oacute;n Wordpress con una base de datos mariadb, lo implementamos en dos pods diferenciados, uno para cada servicio.</li>
</ol>
<p><!--more--></p>
<h2>Esqueleto YAML de un pod</h2>
<p>Podemos describir la estructura de un pod en un fichero con formato Yaml, por ejemplo el fichero <code>nginx.yaml</code>:</p>
  ```
  apiVersion: v1
  kind: Pod
  metadata:
    name: nginx
    namespace: default
    labels:
      app: nginx
  spec:
    containers:
      - image:  nginx
        name:  nginx
  ```
<p>Donde indicamos:</p>
<ul>
<li><code>apiVersion: v1</code>: La versi&oacute;n de la API que vamos a usar.</li>
<li><code>kind: Pod</code>: La clase de recurso que estamos definiendo.</li>
<li><code>metadata</code>: Informaci&oacute;n que nos permite identificar un&iacute;vocamente al recurso.</li>
<li><code>spec</code>: Definimos las caracter&iacute;sticas del recurso. En el caso de un pod indicamos los contenedores que van a formar el pod, en este caso s&oacute;lo uno.</li>
</ul>
<p>Para m&aacute;s informaci&oacute;n acerca de la estructura de la definici&oacute;n de los objetos de Kubernetes: <a href="https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/">Understanding Kubernetes Objects</a>.</p>
<h2>Creaci&oacute;n y gesti&oacute;n de un pod</h2>
<p>Para crear el pod desde el fichero yaml anterior, ejecutamos:</p>
<pre><code>kubectl create -f nginx.yaml
pod "nginx" created
</code></pre>
<p>Y podemos ver que el pod se ha creado:</p>
<pre><code>kubectl get pods
NAME      READY     STATUS    RESTARTS   AGE
nginx     1/1       Running   0          19s
</code></pre>
<p>Si queremos saber en que nodo del cluster se est&aacute; ejecutando:</p>
<pre><code>kubectl get pod -o wide
NAME      READY     STATUS    RESTARTS   AGE       IP                   NODE
nginx     1/1       Running   0          1m       192.168.13.129    k8s-3
</code></pre>
<p>Para obtener informaci&oacute;n m&aacute;s detallada del pod:</p>
<pre><code>kubectl describe pod nginx
Name:         nginx
Namespace:    default
Node:         k8s-3/10.0.0.3
Start Time:   Sun, 13 May 2018 21:17:34 +0200
Labels:       app=nginx
Annotations:  <none>
Status:       Running
IP:           192.168.13.129
Containers:
...
</code></pre>
<p>Para eliminar el pod:</p>
<pre><code>kubectl delete pod nginx
pod "nginx" deleted
</code></pre>
<h2>Accediendo al pod con kubectl</h2>
<p>Para obtener los logs del pod:</p>
<pre><code>$ kubectl logs nginx
127.0.0.1 - - [13/May/2018:19:23:57 +0000] "GET / HTTP/1.1" 200 612     "-" "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101    Firefox/60.0" "-"
...
</code></pre>
<p>Si quiero conectarme al contenedor:</p>
<pre><code>kubectl exec -it nginx -- /bin/bash
root@nginx:/# 
</code></pre>
<p>Podemos acceder a la aplicaci&oacute;n, redirigiendo un puerto de localhost al puerto de la aplicaci&oacute;n:</p>
<pre><code>kubectl port-forward nginx 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
</code></pre>
<p>Y accedemos al servidor web en la url <code>http://localhost:8080</code>.</p>
<h2>Labels</h2>
<p>Las <a href="https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/">Labels</a> nos permiten etiquetar los recursos de kubernetes (por ejemplo un pod) con informaci&oacute;n del tipo clave/valor.</p>
<p>Para obtener las labels de los pods que hemos creado:</p>
<pre><code>kubectl get pods --show-labels
NAME      READY     STATUS    RESTARTS   AGE       LABELS
nginx     1/1       Running   0          10m       app=nginx
</code></pre>
<p>Los <code>Labels</code> lo hemos definido en la secci&oacute;n <code>metada</code> del fichero yaml, pero tambi&eacute;n podemos a&ntilde;adirlos a los pods ya creados:</p>
<pre><code>kubectl label pods nginx service=web
pod "nginx" labeled

kubectl get pods --show-labels
NAME      READY     STATUS    RESTARTS   AGE       LABELS
nginx     1/1       Running   0          12m       app=nginx,service=web
</code></pre>
<p>Los <code>Labels</code> me van a permitir seleccionar un recurso determinado, por ejemplo para visualizar los pods que tienen un <code>label</code> con un determinado valor:</p>
<pre><code>kubectl get pods -l service=web
NAME      READY     STATUS    RESTARTS   AGE
nginx     1/1       Running   0          13m
</code></pre>
<p>Tambi&eacute;n podemos visualizar los valores delos <code>labels</code> como una nueva columna:</p>
<pre><code>kubectl get pods -Lservice
NAME      READY     STATUS    RESTARTS   AGE       SERVICE
nginx     1/1       Running   0          15m       web
</code></pre>
<h2>Modificando las caracter&iacute;sticas de un pod creado</h2>
<p>Podemos modificar las caracter&iacute;sticas de cualquier recurso de kubernetes una vez creado, por ejemplo podemos modificar la definici&oacute;n del pod de la siguiente manera:</p>
<pre><code>kubectl edit pod nginx
</code></pre>
<p>se abrir&aacute; un editor de texto donde veremos el fichero Yaml que define el recurso, podemos ver todos los par&aacute;metros que se han definido con valores por defecto, al no tenerlo definidos en el fichero de creaci&oacute;n del pod <code>nginx.yaml</code>.</p>
