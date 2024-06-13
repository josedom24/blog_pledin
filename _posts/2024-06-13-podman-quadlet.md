---
title: 'Integración de Podman con systemd usando Quadlet'
permalink: /2024/06/podman-quadlet/
tags:
  - Podman
  - Virtualización
---

![podman]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/06/podman-quadlet.png){: .align-center }

## Introducción a Quadlet

### Systemd

[Systemd](https://systemd.io/) es un sistema de inicio y administración de servicios para sistemas operativos basados en Linux. Además de ser el sistema de inicio que se usa actualmente en las distribuciones Linux, ofrece un conjunto de servicios básicos para el sistema.

Systemd utiliza las **Unidades de Servicios**: Cada servicio o recurso que Systemd administra está definido por un **archivo de unidad** (unit file) que especifica cómo debe ser gestionado. Estos archivos pueden configurar el comportamiento del servicio, sus dependencias, el entorno en el que se ejecuta y otras opciones.

### Política de reinicio de los contenedores Podman

Un inconveniente de que Podman no utilice un demonio que controla la ejecución de los contenedores, es que si reiniciamos el host, los contenedores no se inician.

Una posible solución es activar el servicio `podman-restart` que reinicia los contenedores cuya política de reinicio esté activa, con el parámetro `--restart=always` de `podman run`. Por ejemplo:

```
$ sudo podman run -d --name c1 --restart=always quay.io/libpod/banner
$ podman run -d --name c2 --restart=always quay.io/libpod/banner
```

Para activar el servicio:

* En entorno rootful:
  ```
  $ sudo systemctl enable podman-restart
  $ sudo systemctl start podman-restart
  ```
* En entorno rootless:
  ```
  $ systemctl --user enable podman-restart
  $ systemctl --user start podman-restart
  ```
Ahora puedes comprobar que los contenedores se inician de forma automática tras el reinicio del host.

Otra solución al inicio automático de los contenedores después de un reinicio sería integrar la ejecución de contenedores con Systemd. Para conseguir este objetivo vamos a usar Quadlet.

### Quadlet

Desde su inicio Podman se ha integrado muy bien con Systemd, posibilitando la gestión de contenedores con unidades de servicios. En un principio se creaban una unidad Systemd que llamaba a Podman con el subcomando `run`. Podman también proporcionaba `podman generate systemd` para crear fácilmente dicho archivo Systemd.

Sin embargo, esta opción no es la recomendada, y actualmente se prefiere el uso de Quadlet (que ha sido integrado en Podman) para gestionar la ejecución de contenedores Podman con Systemd.

**Quadlet** permite la generación automática de unidades de servicio de Systemd, a partir de unas plantillas que nos permiten definir de manera sencilla el recurso de Podman que queremos controlar con Systemd. Los recursos que actualmente podemos controlar con Quadlet y Systemd son los siguientes:

* Contenedores
* Volúmenes
* Redes
* Pods 

<!-- more -->

#### ¿Cómo funciona Quadlet?

Quadlet buscará ficheros de plantilla de unidades de sistemas Systemd, en los siguientes directorios:

* Si estamos trabajando con el usuario `root`, los directorio de búsqueda son: `/etc/containers/systemd/` y `/usr/share/containers/systemd/`.
* Si trabajamos con un usuario sin privilegios, el directorio de búsqueda será `$HOME/.config/containers/systemd/`.

Los ficheros de plantilla de unidades Systemd tienen distintas extensiones según el recurso que queremos controlar:

* `.container`: Nos permite definir las características de un contenedor que será gestionado por Systemd ejecutando `podman run`.
* `.volume`: Nos permite definir la definición de volúmenes que serán referenciados en la plantillas del tipo `.container`.
* `.network`: Nos permite definir la definición de redes que serán referenciados en la plantillas del tipo `.container` y `.kube`.
* `.pod`: Nos permite la definición de un Pod que será gestionado por Systemd. Sólo funciona en la versión Podman 5.
* `.kube`: Nos permite la definición de escenario creados a parir de ficheros YAML de Kubernetes con la instrucción `podman kube play`.

## Ejecución de contenedores con Systemd y Quadlet

En este ejemplo vamos a gestionar un contenedor  que ofrece un servidor web nginx, por lo tanto vamos a escribir la siguiente plantilla de unidad Systemd, en el directorio `/etc/containers/systemd`.

El nombre de la plantilla es `nginx.container` y tiene el siguiente contenido:

```
[Unit]
Description=Un contenedor con el servidor web nginx

[Container]
Image=docker.io/nginx
ContainerName=contenedor_nginx
PublishPort=8888:80

[Service]
Restart=always
TimeoutStartSec=900

[Install]
WantedBy=multi-user.target default.target
```

Como vemos el formato de la plantilla es similar al formato de una unidad de Systemd estándar:

* Las secciones y parámetros propias de la definición de una unidad Systemd, por ejemplo `[Unit]`, `[Service]` y `[Install]` se copiaran directamente en el fichero generado. Hemos puesto algunos parámetros comunes de ejemplo, pero podemos indicar los que nos interesen:
    * `Restart=always`: Política de reinicio. En este caso, se intentará reiniciar el servicio siempre que se detenga.
    * `TimeoutStartSec=900`: Tiempo máximo (en segundos) que Systemd esperará a que el servicio se inicie antes de considerarlo como un fallo.
    * `WantedBy=multi-user.target default.target`: El servicio será iniciado automáticamente durante el arranque del sistema.
* En esta plantilla donde vamos a definir la ejecución de un contenedor tenemos una sección especial que se llama `[Container]`. Dentro de esta sección pondremos distintos parámetros para especificar las características que tendrá el contenedor que vamos a gestionar. Esta sección no aparecerá en la unidad Systemd generada, pero los parámetros indicados se utilizarán para generar la configuración adecuada. Los parámetros más importantes que podemos indicar dentro de la sección `[Container]` son:
    * `Image`: Nos permite indicar la imagen desde la que se crea el contenedor.
    * `PublishPort`: Nos permite mapear puertos. Igual que la opción `-p` de `podman run`.
    * `ContainerName`: Nos permite indicar el nombre del contenedor.
    * `Environment`: Nos permite definir variables de entorno. Igual que la opción `-e` de `podman run`.
    * `Exec`: Nos permite indicar el comando que queremos que se ejecute en el contenedor. 
    * `Network`: Nos permite indicar la red donde se conecta el contenedor. Igual que la opción `--network` de `podman run`.
    * `Pod`: Nos permite añadir el contenedor en un Pod. Igual que la opción `--pod` de `podman run`.
    * `Volume`: Nos permite añadir almacenamiento al contenedor. Igual que la opción `--volume` de `podman run`.
    * `PodmanArgs`: nos permite añadir parámetros extras a la comando `podman run`.
    * Podemos indicar más parámetros que puedes consultar en la [documentación](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html).

Una vez que tenemos definida la plantilla, es decir, la hemos copiado al directorio `/etc/containers/systemd` y siempre que la modifiquemos, tendremos que reiniciar Systemd:

```
# systemctl daemon-reload
```

Y ya podemos trabajar con la unidad de Systemd que se ha generado:

```
# systemctl status nginx
○ nginx.service - Un contenedor con el servidor web nginx
     Loaded: loaded (/etc/containers/systemd/nginx.container; generated)
    Drop-In: /usr/lib/systemd/system/service.d
             └─10-timeout-abort.conf
     Active: inactive (dead)

# systemctl start nginx
# systemctl status nginx
● nginx.service - Un contenedor con el servidor web nginx
     Loaded: loaded (/etc/containers/systemd/nginx.container; generated)
    Drop-In: /usr/lib/systemd/system/service.d
             └─10-timeout-abort.conf
     Active: active (running) since Tue 2024-04-09 07:12:43 UTC; 30s ago
   Main PID: 74403 (conmon)
      Tasks: 4 (limit: 1087)
     Memory: 18.9M
        CPU: 864ms
     CGroup: /system.slice/nginx.service
             ├─libpod-payload-9687bac58d5c4d1606aa46af33d1a21c1d1652e0ac9fb3fc0fc86e3495f42869
             │ ├─74405 "nginx: master process nginx -g daemon off;"
             │ ├─74430 "nginx: worker process"
             │ └─74431 "nginx: worker process"
    ...

# podman ps
CONTAINER ID  IMAGE                           COMMAND               CREATED         STATUS         PORTS                 NAMES
0bacbe10921c  docker.io/library/nginx:latest  nginx -g daemon o...  4 seconds ago   Up 2 seconds   0.0.0.0:8888->80/tcp  contenedor_nginx


# curl http://localhost:8888
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...

# systemctl stop nginx
```

Por último si queremos obtener la unidad Systemd generada, podemos ejecutar:

```
# /usr/libexec/podman/quadlet -dryrun 

quadlet-generator[74499]: Loading source unit file /etc/containers/systemd/nginx.container
---nginx.service---
[Unit]
Description=Un contenedor con el servidor web nginx
SourcePath=/etc/containers/systemd/nginx.container
RequiresMountsFor=%t/containers

[X-Container]
Image=docker.io/nginx
ContainerName=contenedor_nginx
PublishPort=8888:80

[Service]
Restart=always
TimeoutStartSec=900
Environment=PODMAN_SYSTEMD_UNIT=%n
KillMode=mixed
ExecStop=/usr/bin/podman rm -v -f -i --cidfile=%t/%N.cid
ExecStopPost=-/usr/bin/podman rm -v -f -i --cidfile=%t/%N.cid
Delegate=yes
Type=notify
NotifyAccess=all
SyslogIdentifier=%N
ExecStart=/usr/bin/podman run --name=contenedor_nginx --cidfile=%t/%N.cid --replace --rm --cgroups=split --sdnotify=conmon -d --publish 8888:80 docker.io/nginx

[Install]
# Start by default on boot
WantedBy=multi-user.target default.target
```

## Ejemplo: Despliegue de WordPress + MariaDB con Systemd y Quadlet

Para poder desplegar WordPress + MariaDB necesitamos guardar las siguientes plantillas de unidades de sistemas en el directorio `$HOME/.config/containers/systemd/`. En este ejemplo vamos a trabajar en un entorno rootless.:

En primer lugar, definimos la red con la que vamos a trabajar en plantilla de unidad de Systemd `wordpress.network`:

```
[Network]
NetworkName=red-wordpress
```

También definimos los volúmenes que vamos a necesitar. En el fichero `wordpress.volume`:

```
[Volume]
VolumeName=wpvol
```

Y en el fichero `wordpress_mariadb.volume`:

```
[Volume]
VolumeName=dbvol
```

A continuación definimos los contenedores. En el fichero `wordpress.container` definimos el contenedor de WordPress:

```
[Unit]
Description=Un contenedor con WordPress

[Container]
Image=docker.io/wordpress
ContainerName=wordpress
PublishPort=8081:80
Network=wordpress.network
Volume=wordpress.volume:/var/www/html
Environment=WORDPRESS_DB_HOST=db
Environment=WORDPRESS_DB_USER=wordpress
Environment=WORDPRESS_DB_NAME=wordpress
Environment=WORDPRESS_DB_PASSWORD=wordpress

[Service]
Restart=always
TimeoutStartSec=900

[Install]
WantedBy=multi-user.target default.target
```
Y en el fichero `wordpress_mariadb.container` definimos el contenedor de MariaDB:

```
[Unit]
Description=Un contenedor con el servidor de base de datos MariaDB para Wordpress

[Container]
Image=docker.io/mariadb:10.5
ContainerName=db
Volume=wordpress_mariadb.volume:/usr/lib/mysql
Network=wordpress.network
Environment=MARIADB_ROOT_PASSWORD=my-secret-pw
Environment=MARIADB_USER=wordpress
Environment=MARIADB_DATABASE=wordpress
Environment=MARIADB_PASSWORD=wordpress

[Service]
Restart=always
TimeoutStartSec=900

[Install]
WantedBy=multi-user.target default.target
```

Ya podemos iniciar los servicios:

```
$ systemctl --user daemon-reload
$ systemctl --user start wordpress_mariadb
$ systemctl --user start wordpress
```

Podemos comprobar los recursos que hemos creado:

```
$ podman ps
CONTAINER ID  IMAGE                               COMMAND               CREATED             STATUS             PORTS                 NAMES
9800047ac022  docker.io/library/mariadb:10.5      mysqld                About a minute ago  Up About a minute                        db
eac1c9c70f7d  docker.io/library/wordpress:latest  apache2-foregroun...  11 seconds ago      Up 11 seconds      0.0.0.0:8081->80/tcp  wordpress

$ podman network ls
NETWORK ID    NAME           DRIVER
b53cd35e30fd  red-wordpress  bridge

$ podman volume ls
DRIVER      VOLUME NAME
local       dbvol
local       wpvol
```

Y podemos acceder a la aplicación para comprobar que está funcionando.