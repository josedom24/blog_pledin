---
title: 'Trabajando con Pods en Podman'
permalink: /2024/05/pod-podman/
tags:
  - Podman
  - Pod
  - Virtualización
---

![podman]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/05/podman-pod.png){: .align-center }

## ¿Qué es un Pod?

* Un Pod es un concepto que proviene de Kubernetes.
* En Kubernetes los contenedores se ejecutan en Pods. En inglés Pod significa "vaina", y podemos entender un Pod como una envoltura que contiene uno o varios contenedores.
* Un Pod representa un conjunto de contenedores que comparten almacenamiento y una única IP.
* Un Pod recibe una dirección IP que es compartida por todos los contenedores.
* Esto significa que todos los servicios que se ejecutan en los diferentes contenedores pueden referirse entre sí como localhost, mientras que los contenedores externos seguirán contactando con la dirección IP del Pod. 

## Gestión de Pods con Podman

![pod]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/05/podman-pod-architecture.png){: .align-center }

* Cada Pod en Podman incluye un contenedor llamado **"infra"**.   
    * Este contenedor no hace nada más que dormir. 
    * Su propósito es mantener los espacios de nombres asociados con el pod y permitir a Podman conectar otros contenedores al pod. 
    * Esto le permite iniciar y detener contenedores dentro del Pod.
    * El contenedor infra por defecto está basado en la imagen `localhost/podman-pause`.
* Como vemos en la imagen el Pod puede estar formada por varios contenedores:
    * Si seguimos la filosofía de Kubernetes cada Pod tendrá un contenedor principal encargado de ofrecer el servicio.
    * Si necesitamos realizar procesos auxiliares fuertemente acoplados con el principal, podemos tener contenedores secundarios que llamamos contenedores sidecar. Por ejemplo: Un servidor web nginx con un servidor de aplicaciones PHP-FPM, que se implementaría mediante un solo Pod, pero ejecutando un proceso de nginx en un contenedor y otro proceso de php-fpm en otro contenedor.
    * Evidentemente también podemos utilizar Pods multicontenedores para desplegar aplicaciones que necesitan más de un servicio para su funcionamiento.
* En el diagrama anterior, también observamos el proceso **conmon**, este es el monitor del contenedor.  Es un pequeño programa en C cuyo trabajo es monitorizar los contenedores y permitimos conectarnos a ellos. Cada contenedor tiene su propia instancia de conmon, independientemente se ejecute dentro de un Pod:
    ```
    $ podman run -d quay.io/libpod/banner
    
    $ pstree
    systemd─┬─...
            ├─conmon───nginx───2*[nginx]
    ```
* En Podman podemos trabajar con Pods en entornos rootful y rootless.

<!--more-->

## Gestión de Pods

La gestión de los Pods la realizaremos utilizando el comando `podman pod`. 

### Creación de un Pod

Para crear un Pod, usamos el comando `podman pod create`, por ejemplo para crear un Pod llamado `pod1`, ejecutamos:

```
$ podman pod create --name pod1
```

Podemos visualizar el Pod que hemos creado:

```
$ podman pod ps
POD ID        NAME        STATUS      CREATED        INFRA ID      # OF CONTAINERS
45d3c5f01747  pod1        Created     8 seconds ago  41f153d29f02  1
```
Como vemos esta compuesto por un contenedor, que será el contenedor **infra**. Si queremos mostrar los nombres de los contenedores de los que está formado, usamos el parámetro `--ctr-names`:

```
$ podman pod ps --ctr-names
POD ID        NAME        STATUS      CREATED         INFRA ID      NAMES
45d3c5f01747  pod1        Created     32 seconds ago  41f153d29f02  45d3c5f01747-infra
```

### Añadir contenedores a un Pod

Para añadir un contenedor a un Pod, a la hora de crearlo debemos indicar el nombre del Pod:

```
$ podman run -dt --pod pod1 --name principal alpine:latest top
```

Al iniciar el contenedor principal, el Pod se ha iniciado:

```
$ podman pod ps
POD ID        NAME        STATUS      CREATED        INFRA ID      # OF CONTAINERS
45d3c5f01747  pod1        Running     8 minutes ago  41f153d29f02  2
```

Comprobamos que tenemos dos contenedores en el Pod. Podemos visualizar los contenedores con la información del Pod al que pertenecen, ejecutando:

```
$ podman ps --pod
CONTAINER ID  IMAGE                                    COMMAND     CREATED        STATUS        PORTS       NAMES               POD ID        PODNAME
41f153d29f02  localhost/podman-pause:4.9.4-1711445992              9 minutes ago  Up 3 minutes              45d3c5f01747-infra  45d3c5f01747  pod1
dde078d7cf4e  docker.io/library/alpine:latest          top         3 minutes ago  Up 3 minutes              principal           45d3c5f01747  pod1
```

### Ciclo de vida de un Pod

Aunque podemos controlar el ciclo de vida independientemente de cada contenedor, al operar sobre el Pod estaremos actuando sobre todos los contenedores. Por ejemplo, para pausar y continuar los contenedores de un Pod:

```
$ podman pod pause pod1
$ podman pod unpause pod1
```

Para parar e iniciar todos los contenedores:

```
$ podman pod stop pod1
$ podman pod start pod1
```

Para reiniciar los contenedores de un Pod:

```
$ podman pod restart pod1
```

### Obteniendo información de un Pod

Podemos obtener la información detallada de un Pod ejecutando:

```
$ podman pod inspect pod1
```

Si tenemos un sólo contenedor principal en el Pod podemos ver los logs de salida, ejecutando:

```
$ podman pod logs pod1
```

Sin embargo, si añadimos un segundo contenedor:

```
$ podman run -dt --pod pod1 --name secundario alpine:latest top

$ podman ps  --pod
CONTAINER ID  IMAGE                                    COMMAND     CREATED             STATUS             PORTS       NAMES               POD ID        PODNAME
41f153d29f02  localhost/podman-pause:4.9.4-1711445992              19 minutes ago      Up 13 minutes                  45d3c5f01747-infra  45d3c5f01747  pod1
dde078d7cf4e  docker.io/library/alpine:latest          top         13 minutes ago      Up 13 minutes                  primario            45d3c5f01747  pod1
b220cb7dfdf1  docker.io/library/alpine:latest          top         About a minute ago  Up About a minute              secundario          45d3c5f01747  pod1
```

Para obtener los logs hay que especificar el contenedor con el parámetro `-c`:

```
$ podman pod logs -c secundario pod1
```

Finalmente para ver los procesos que se están ejecutando en los distintos contenedores:

```
$ podman pod top pod1
USER        PID         PPID        %CPU        ELAPSED           TTY         TIME        COMMAND
0           1           0           0.000       14m54.557309601s  ?           0s          /catatonit -P 
root        1           0           0.000       14m54.559080387s  pts/0       0s          top 
root        1           0           0.000       2m55.562434639s   pts/0       0s          top 
```

### Eliminar los Pods

Al borrar un Pod, se eliminaran todos los contenedores que forman parte de él. Si queremos borrar un Pod debe estar parado:

```
$ podman pod stop pod1
$ podman pod rm pod1
```

Si queremos forzar la eliminación de un Pod aunque este en ejecución:

```
$ podman pod rm -f pod1
```

Si queremos borrar todos los Pods parados y en ejecución:

```
$ podman pod rm --all
$ podman pod rm -f --all
```

Por último para eliminar los Pods que están parados:

``` 
$ podman pod prune
WARNING! This will remove all stopped/exited pods..
Are you sure you want to continue? [y/N]
```

## Configuración de red en los contenedores de un Pod

Cuando creamos un Pod, este recibe una dirección IP, que será compartida con todos los contenedores. 

* En el caso de Pods rootful, si no indicamos lo contrario, el Pod se conectará con la red bridge por defecto. 
* En el caso de Pods rootless, por defecto se conectará a la red slirp4netns. 

A la hora de trabajar con Pods tenemos que tener en cuenta las siguientes características.

* Si queremos ofrecer algún servicio en un puerto, el mapeo del puerto se indicará en la creación del Pod.
* Los contenedores se pueden comunicar entre ellos usando la interfaz loopback: la dirección IP `127.0.0.1` o el nombre `localhost`.

Podemos crear un Pod conectado a cualquier otra red:

```
$ podman network create mired
$ podman pod create --name pod2 --network mired
$ podman pod ps
POD ID        NAME        STATUS      CREATED         INFRA ID      # OF CONTAINERS
1f6ed1602460  pod2        Created     6 minutes ago   be8baecabdc2  1
$  podman pod start pod2
$ podman inspect --format='{{range \.NetworkSettings.Networks }}{{.IPAddress}}{{end}}' be8baecabdc2
10.89.0.2
```

### Exponer un servicio en un Pod

Al crear un Pod indicamos el puerto que vamos a mapear con la opción `-p` o `--publish`. Evidentemente sólo podremos tener un contenedor que ofrezca el servicio en el puerto que estamos mapeando:

```
$ podman pod create --name pod3 -p 8080:80
```

A continuación añadimos un contenedor que ofrece un servicio web en el puerto 80:

```
$ podman run -d --pod pod3 --name webserver quay.io/libpod/banner
```

Vemos el Pod y el contenedor que hemos creado:

```
$ podman pod ps --ctr-names
POD ID        NAME        STATUS      CREATED         INFRA ID      NAMES
688e66fd19dd  pod3        Running     2 minutes ago   2d994796c3f2  688e66fd19dd-infra,webserver

$ podman ps --pod
CONTAINER ID  IMAGE                                    COMMAND               CREATED             STATUS             PORTS                 NAMES               POD ID        PODNAME
2d994796c3f2  localhost/podman-pause:4.9.4-1711445992                        2 minutes ago       Up About a minute  0.0.0.0:8080->80/tcp  688e66fd19dd-infra  688e66fd19dd  pod3
b7f0b9aa1aa0  quay.io/libpod/banner:latest             nginx -g daemon o...  About a minute ago  Up About a minute  0.0.0.0:8080->80/tcp  webserver           688e66fd19dd  pod3
```

Podríamos crear un Pod y añadir un contenedor en la misma instrucción, para ello al indicar el nombre del Pod donde se crea el contenedor ponemos el valor `new`:

```
$ podman run -d --pod new:pod4 --name webserver2 -p 8081:80 quay.io/libpod/banner
```

Para acceder al servicio, utilizamos la IP del host y el puerto que hemos mapeado:

```
$ curl http://localhost:8080
   ___          __              
  / _ \___  ___/ /_ _  ___ ____ 
 / ___/ _ \/ _  /  ' \/ _ `/ _ \
/_/   \___/\_,_/_/_/_/\_,_/_//_/
```

### Comunicación entre contenedores dentro del Pod

Como hemos indicado para que un contenedor acceda al servicio de otro contenedor dentro del Pod, deberá usar la interfaz loopback: la dirección IP `127.0.0.1` o el nombre `localhost`:

```
$ podman run -it --pod pod3 --name cliente quay.io/libpod/banner curl http://localhost
   ___          __              
  / _ \___  ___/ /_ _  ___ ____ 
 / ___/ _ \/ _  /  ' \/ _ `/ _ \
/_/   \___/\_,_/_/_/_/\_,_/_//_/
```

## Almacenamiento compartido entre los contenedores de un Pod

Aunque cada contenedor puede tener su medio de almacenamiento independiente. Al crear un Pod podemos indicar un punto de montaje, que será compartido entre todos los contenedores del Pod. 

El punto de montaje se puede indicar usando volúmenes o usando bind mount.

### Ejemplo de almacenamiento compartido en un Pod

En este ejemplo vamos a tener el siguiente escenario:

* Creamos un Pod, llamado `pod5` donde vamos a mapear el puerto 8082 al puerto 80 del Pod, y vamos a indicar un punto de montaje con un volumen.
* El contenedor `web` se crea a partir de la imagen nginx, es el contenedor principal, encargado de servir la web. En este contenedor montamos el volumen en su *DocumentRoot* (`/usr/share/nginx/html`). Este servidor web va a servir el fichero `index.html` que está modificando el otro contenedor.
* El contenedor `sidecar` es el auxiliar. En este caso, cada segundo, va a modificar el fichero `index.html` que sirve el contenedor principal.

Para ello primero creamos el Pod, en el este caso usando un volumen:

```
$ podman pod create --name pod5 -p 8082:80 -v vol1:/usr/share/nginx/html
```

Utilizando bind mount, quedaría de la siguiente forma. Utilizaremos la opción `:z` si estamos usando SELinux:

```
$ podman pod create --name pod5 -p 8082:80 -v ${PWD}/directorio_compartido:/usr/share/nginx/html:z
```

A continuación añadimos los contenedores:

```
$ podman run --pod pod5 -d --name web docker.io/nginx
$ podman run --pod pod5 -d --name sidecar docker.io/debian bash -c "while true; do date >> /usr/share/nginx/html/index.html;sleep 1;done"
```

Podemos comprobar que los dos contenedores tienen el volumen montado en el directorio indicado:

```
$ podman inspect --format='{{json .Mounts | escape_once}}' web
[{"Type":"volume","Name":"vol1","Source":"/var/lib/containers/storage/volumes/vol1/_data","Destination":"/usr/share/nginx/html","Driver":"local","Mode":"","Options":["nosuid","nodev","rbind"],"RW":true,"Propagation":"rprivate"}]

$ podman inspect --format='{{json .Mounts | escape_once}}' sidecar
[{"Type":"volume","Name":"vol1","Source":"/var/lib/containers/storage/volumes/vol1/_data","Destination":"/usr/share/nginx/html","Driver":"local","Mode":"","Options":["nosuid","nodev","rbind"],"RW":true,"Propagation":"rprivate"}]
```

Por último, podemos acceder al puerto 8082 de la dirección IP del host, para acceder al servicio web:

```
$ curl http://localhost:8082
Thu Apr  4 18:03:12 UTC 2024
Thu Apr  4 18:04:44 UTC 2024
Thu Apr  4 18:04:45 UTC 2024
...
```
