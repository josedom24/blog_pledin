---
title: 'Contenedores rootles con Podman'
permalink: /2024/04/rootless-podman/
tags:
  - Podman
  - Virtualización
---

![podman]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/04/podman-logo2.png){: .align-center }

Los contenedores Podman tienen dos modos de ejecución:

* **Contenedor rootful**: es un contenedor ejecutado por el usuario `root` en el host. Por lo tanto, tiene acceso a toda la funcionalidad que el usuario `root` tiene. 
    * Este modo de funcionamiento puede tener problemas de seguridad, ya que si hay una vulnerabilidad en la funcionalidad, el usuario del contenedor será `root` con los posibles riesgos de seguridad que esto conlleva.
    * De todas maneras, es posible que algunos procesos ejecutados en el contenedor no se ejecuten como `root`. 
* **Contenedor rootless**: es un contenedor que puede ejecutarse sin privilegios de `root` en el host. 
    * Podman no utiliza ningún demonio y no necesita `root` para ejecutar contenedores.
    * Esto no significa que el usuario dentro del contenedor no sea `root`, aunque sea el usuario por defecto.
    * Si tenemos una vulnerabilidad en la ejecución del contenedor, el atacante no obtendrá privilegios de `root` en el host.

En este artículo vamos a trabajar con contenedores rootless, y lo primer que vamos a indicar son las limitaciones que tenemos al trabajr con este tipo de contenedores:

* No tienen acceso a todas las características del sistema operativo.
* No se pueden crear contenedores que se unan a puertos privilegiados (menores que 1024).
* Algunos modos de almacenamiento pueden dar problemas.
* Por defecto, no se puede hacer `ping` a servidores remotos.
* No pueden gestionar las redes del host.
* [Más limitaciones](https://github.com/containers/podman/blob/master/rootless.md)

Podemos crear un contenedor rootless con un usuario sin privilegios de manera similar a cómo lo haríamos con el usuario `root`. Tenemos en cuenta que no podemos utilizar los puertos privilegiados (menores del 1024), por lo que en este caso hemos mapeado el puerto 8080:

```
$ podman run -d --name my-apache-app -p 8080:80 docker.io/httpd:2.4
```

Cada usuario sin privilegios tiene sus imágenes en su registro local:

```
$ podman images
REPOSITORY                             TAG               IMAGE ID      CREATED        SIZE
docker.io/library/httpd                2.4               67c2fc9e3d84  2 weeks ago    151 MB
```

Podemos ver el contenedor que tenemos en ejecución:

```
$ podman ps
CONTAINER ID  IMAGE                        COMMAND           CREATED             STATUS             PORTS                 NAMES
cccf1c02229e  docker.io/library/httpd:2.4  httpd-foreground  About a minute ago  Up About a minute  0.0.0.0:8080->80/tcp  my-apache-app
```

Y podemos acceder a la dirección IP del host y al puerto que hemos mapeado para acceder al host:

![podman]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/04/web.png){: .align-center }

<!--more-->

## Modos de funcionamiento de los contenedores rootless

Cuando ejecutamos un contenedor rootful o rootless con Podman, los procesos que se ejecutan dentro del contenedor pueden estar ejecutados por el usuario `root`o por un un usuario sin privilegios. Nos vamos a centrar en este apartado en los dos modos de funcionamiento de los contenedores rootless.

Para hacer estos ejemplos vamos a usar el usuario `usuario` con UID 1000 para crear los contenedores. 

### Ejecución de contenedores rootless, con procesos en el contenedor ejecutándose como root

Veamos un ejemplo:

```
$ id
uid=1000(usuario) gid=1000(usuario) groups=1000(usuario),4(adm),10(wheel),190(systemd-journal) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023

$ podman run -d --rm --name contenedor1 alpine sleep 1000
f3961860f97280adf64c44a8b42dd39588712d3935469bf97d3ae7d71b8ffa97

$ podman exec contenedor1 id
uid=0(root) gid=0(root)

$ ps -ef | grep sleep
usuario     23234   23232  0 09:47 ?        00:00:00 sleep 1000

$ podman top contenedor1 huser user
HUSER       USER
1000        root
```

1. En primer lugar vemos que el usuario que va a crear el contenedor es `usuario`.
2. Comprobamos que el usuario que está ejecutando los procesos dentro del contenedor es `root`.
3. Comprobamos que en el host, el proceso lo ejecuta el usuario `usuario`.
4. Por último, vemos que el usuario correspondiente al host (`HUSER`) es `usuario` (UID 1000), y el usuario dentro del contenedor (`USER`) es `root`. **Hay una correspondencia entre nuestro usuario sin privilegios en el host y el usuario `root` dentro del contenedor**.

Podemos concluir: cuando ejecutamos un contenedor con un usuario sin privilegios, con el proceso del contenedor ejecutándose con `root`, el usuario real visible en el host que ejecuta el proceso es el usuario sin privilegios con su UID.

### Ejecución de contenedores rootful, con procesos en el contenedor ejecutándose con usuarios no privilegiados

En el caso de los contenedores rootless, también podemos indicar el usuario que ejecutara los procesos dentro del contenedor con el parámetro `--user` o `-u`, o utilizando una imagen donde venga definido. Veamos un ejemplo:

```
$ id
uid=1000(usuario) gid=1000(usuario) groups=1000(usuario),4(adm),10(wheel),190(systemd-journal) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023

$ podman run -d --rm -u sync --name contenedor1 alpine sleep 1000
96d64bf75b7998de86624dd699f450f83670b4a798e775585edc8c2607de94ca

$ podman exec contenedor1 id
uid=5(sync) gid=0(root)

$ ps -ef | grep sleep
524292     23377   23375  0 09:57 ?        00:00:00 sleep 1000

$ podman top contenedor1 huser user
HUSER       USER
524292      sync
```

En este caso:

1. En primer lugar vemos que el usuario que va a crear el contenedor es `usuario`.
2. Comprobamos que el usuario que está ejecutando los procesos dentro del contenedor es `sync`.
3. Comprobamos que en el host, el proceso lo ejecuta un usuario con UID 524292.
4. Por último, vemos que el usuario correspondiente al host (`HUSER`)es un usuario con UID 524292, y el usuario dentro del contenedor (`USER`) es `sync`. **Hay una correspondencia entre un usuario sin privilegios en el host y el usuario `sync` dentro del contenedor**.

Podemos concluir: cuando ejecutamos un contenedor con un usuario sin privilegios, con el proceso del contenedor ejecutándose con un usuario sin privilegios, el usuario real visible en el host que ejecuta el proceso es otro usuario sin privilegios con un UID propio.

## Espacio de nombres de usuario

Los espacios de nombres (**namespaces**) son un mecanismo que el kernel de Linux utiliza para aislar y restringir recursos del sistema operativo, como procesos, redes, sistemas de archivos, entre otros. Los namespaces permiten crear entornos de ejecución independientes

Cuando ejecutamos contenedores rootless, hemos visto que podemos ejecutar los procesos dentro del contenedor con otros usuarios. Además dentro de la imagen que estamos usando para crear el contenedor pueden estar definidos varios usuarios. Sin embargo, el kernel de Linux impide a un usuario sin privilegios usar más de un UID, por ello necesitamos un mecanismo que consiga que nuestro usuario sin privilegio pueda utilizar distintos UID y GID.

Es por todo ello, que se use un espacio de nombre de usuario (**user username**):

* Nos permite **asignar un rango de IDs de usuario y grupo** en un espacio de nombres aislado. Esto significa que los procesos que se ejecutan dentro de ese namespace tienen una visión limitada de los usuarios y grupos del sistema en comparación con el sistema anfitrión. 
* Nos permite establecer una correspondencia entre los ID de usuario del contenedor y los ID de usuario del host.
* En el espacio de nombres de usuario de Podman, hay un nuevo conjunto de IDs de usuario e IDs de grupo, que están separados de los UIDs y GIDs de su host.

Por ejemplo, como vimos en los ejemplos anteriores:

* Cuando creamos un contenedor rootless donde se ejecutan los procesos como `root` (uid = 0), en el host se están ejecutando con el usuario que ha creado el contenedor, en nuestro caso con el usuario `usuario` (uid = 1000).
* Cuando creamos un contenedor rootless donde se ejecutan los procesos con el usuario `sync` (uid = 5), en el host se están ejecutando con un usuario sin privilegios con uid = 524292.

![podman]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/04/rootless2.png){: .align-center }

Cada usuario no privilegiado que creemos en nuestro host, tendrá un conjunto de UID y GID que podrá mapear a usuarios y grupos dentro del contenedor:

* En el fichero `/etc/subuid`, por cada usuario tenemos el UID inicial y la cantidad de identificadores que puede mapear. Cada usuario tiene que tener un conjunto de identificadores diferentes.
    ```
    $ cat /etc/subuid
    usuario:524288:65536
    ```

    El usuario `usuario` puede mapear desde el UID 524288 y tiene asignado 65536 identificadores.
* En el fichero `/etc/subgid` está definido, con el mismo formato los identificadores de grupos que puede mapear cad usuario.

Podemos ver el mapeo de identificadores de usuario que se ha realizado leyendo el fichero `/proc/self/uid_amp` en el contenedor. Si ejecutamos la siguiente instrucción en el último ejemplo que hemos presentado (contenedor rootless cuyos procesos se ejecuta por el usuario `sync`):

```
$ podman exec contenedor1 cat /proc/self/uid_map
         0       1000          1
         1     524288      65536
```

El mapeo que se ha realizado es el siguiente:

* El usuario `root` (UID = 0) está mapeado con el usuario `usuario` (UID = 1000) para un rango de 1. 
* Luego el UID 1 está mapeado al UID 524288 para un rango de 65536 UIDS. Por eso el usuario `sync` con UID = 5, se mapea al UID = 524292.

Desde el punto de vista de la seguridad es un aspecto muy positivo, ya que la ejecución del contenedor y de los procesos dentro del contenedor se hace por usuarios diferentes y sin privilegios. El rango de IDs que mapea un usuario, no tiene ningún privilegios especial en el sistema, ni siquiera como el usuario `usuario` (UID = 1000). Esto significa que si un proceso en el contenedor tiene un problema de seguridad estará restringido en el host del contenedor.

Por lo tanto el uso de contenedores rootless aumenta la seguridad consiguiendo un **aislamiento de privilegios**, ya que al ejecutar contenedores en modo rootless, el usuario no necesita privilegios de superusuario para iniciar y administrar los contenedores. Además como se usan un conjunto de IDs de usuario y grupo dentro del contenedor que son diferentes de los IDs en el sistema anfitrión, nos proporciona una capa adicional de aislamiento de seguridad, ya que los procesos dentro del contenedor no tienen privilegios en el sistema anfitrión. Dicho de otro modo, se reduce el riesgo de que un contenedor comprometido pueda acceder o modificar recursos críticos del sistema anfitrión.

## podman unshare

La instrucción `podman unshare`, nos permite entrar en un espacio de nombres de usuario sin lanzar un contenedor. Le permite examinar lo que está sucediendo dentro del espacio de nombres de usuario, cambiado el conjuntos de IDs que se está usando para identificar a los usuarios y los grupos.

Por ejemplo, si ejecutamos la siguiente instrucción en el host:

```
$ cat /proc/self/uid_map
         0          0 4294967295
```

Se nos muestra el mapeo en los contenedores roorful, el ID 0 se mapea con el 0, y así sucesivamente con todos el rango de identificadores.

Sin embargo, podemos entrar en el espacio de nombre de usuario y ejecutar esa misma instrucción:

```
$ podman unshare cat /proc/self/uid_map
         0       1000          1
         1     524288      65536
```

Obteniendo el mismo resultado que al ejecutarla dentro del contenedor.

## Almacenamiento con contenedores rootless

De manera similar al trabajo con contenedores rootful, al trabajar con contenedores rootless tenemos principalmente dos medios para almacenar la información:

* **Volúmenes Podman**, directorios creados por Podman que podemos montar en el contenedor. Se gestionan con la instrucción `podman volume`.
* Los **bind mount**, montaje de un directorio o archivo desde el host en el contenedor. Si trabajamos con un sistema operativo que tiene activo SeLinux (Security-Enhanced Linux), los directorios que montamos no estarán configurados de forma predeterminada para ser accesibles por Podman y los contenedores, es posible que estos no puedan acceder a ellos debido a las políticas de seguridad de SELinux. A la hora del montaje tendremos que indicar las opciones necesarias para modificar el contexto de SELinux y que estos directorios sean accesibles desde el contenedor.

A la hora de indicar los puntos de montaje podemos usar dos sintaxis:

* `-v <nombre volumen o directorio bind mount>:<directorio_de_montaje_en_el_contenedor>:<opciones>`
  * Las opciones más interesantes pueden ser las siguientes:
    * `:ro`: Para indicar que el montaje es de sólo lectura.
    * `:z`: Cuando trabajamos en sistemas operativos con SELinux nos permite cambiar la etiqueta del contexto de seguridad del directorio para que sea accesible desde el contenedor. Además el directorio podrá ser compartido con otros contenedores.
    * `:Z`: Cuando trabajamos en sistemas operativos con SELinux nos permite cambiar la etiqueta del contexto de seguridad del directorio para que sea accesible desde el contenedor, pero de forma privada, no se podrá compartir con otros contenedores.
* `--mount type=<volume o bind>,src=<nombre volumen o directorio bind mount>,dst=<directorio_de_montaje_en_el_contenedor>,<opciones>`
  * Las opciones más interesantes pueden ser las siguientes:
    * La opción `readonly` o `ro` es optativa, e indica que el montaje es de sólo lectura.
    * `relabel`, puede tener dos valores: `shared` funcionaría de forma similar a cómo lo hace la opción `:z` en el caso de utilizar la sintaxis `-v`, y `private` funcionaría de forma similar a utilizar la opción `:Z`.

Veamos algunos ejemplos:

### Trabajando con volúmenes Podman

Podemos crear un volumen indicando su nombre:

```
$ podman volume create miweb
```

Podemos ejecutar distintas operaciones sobre los volúmenes: listarlos (`podman volume ls`), inspeccionarlos (`podman volume inspect`), borrarlos (`podman volume rm`),...

A continuación, creamos un contenedor con el volumen asociado, estás dos instrucciones serían similares:

```
$ podman run -d --name my-apache-app --mount type=volume,src=miweb,dst=/usr/local/apache2/htdocs -p 8080:80 docker.io/httpd:2.4
$ podman run -d --name my-apache-app -v miweb:/usr/local/apache2/htdocs -p 8080:80 docker.io/httpd:2.4
```

A continuación, creamos un fichero `index.html` en el directorio donde hemos montado el volumen, por lo tanto esta información no se perderá:

```
$ podman exec my-apache-app bash -c 'echo "<h1>Hola</h1>" > /usr/local/apache2/htdocs/index.html'
```

Podemos comprobar el acceso al servidor web usando un navegado web o en este caso usando el comando `curl`:

```
$ curl http://localhost:8080
<h1>Hola</h1>
```

Si borramos el contenedor y lo volvemos a crear podemos comprobar que el fichero `index.hrml` no se ha borrado.

### Trabajando con bind mount

En este caso, vamos a crear un directorio en el sistema de archivos del host, donde vamos a crear un fichero `index.html`:

```
$ mkdir web
$ cd web
/web$ echo "<h1>Hola</h1>" > index.html
```

Vamos a trabajar con un sistema operativo donde tenemos activo SELinux, por lo tanto a la hora de indicar el punto de montaje tendremos que indicar la opción apropiada para configurar el contexto de SELinux. Tendremos que usar la opción `:z` si dicho directorio lo queremos montar en otros contenedores o `:Z` si sólo se va a montar en este contenedor.

```
$ sudo podman run -d --name my-apache-app -v /home/usuario/web:/usr/local/apache2/htdocs:Z -p 8080:80 docker.io/httpd:2.4
```


De manera similar, usando la opción `--mount`, para montar un directorio compartido (similar a usar la opción `:z`), utilizaríamos la opción `relabel=shared`. Si queremos hacer un montaje privado, sólo para el contenedor (similar a la opción `:Z`) usaremos la opción `relabel=private`

```
$ sudo podman run -d --name my-apache-app --mount type=bind,src=/home/fedora/web,dst=/usr/local/apache2/htdocs,relabel=private -p 8080:80 httpd:2.4
```

Podemos acceder a la dirección IP del contenedor para comprobar la información que se está sirviendo:

```
$ curl http://localhost:8080
<h1>Hola</h1>
```

## Funcionamiento interno del almacenamiento en contenedores rootless

Cuando trabajamos con volúmenes con un usuario no privilegiado el directorio donde se crean los volúmenes es `$HOME/.local/share/containers/storage/volumes/`.

### Uso de volúmenes con contenedores rootless con procesos en el contenedor ejecutándose como root

Si creamos un volumen y lo montamos en un contenedor rootless cuyos procesos se están ejecutando con el usuario `root`, vamos los usuarios propietarios de los ficheros:

```
$ podman volume create vol1

$ podman run -dit -v vol1:/destino --name alpine1 alpine

$ podman exec alpine1 ls -ld /destino
drwxr-xr-x    1 root     root             0 Jan 26 17:53 /destino
```

Cómo cabría esperar, comprobamos que el directorio que hemos montado pertenece al usuario `root`.
Podemos inspeccionar el volumen y obtenemos el directorio donde se ha creado en el host:

```
$ podman volume inspect vol1
[
     {
          "Name": "vol1",
          "Driver": "local",
          "Mountpoint": "/home/usuario/.local/share/containers/storage/volumes/vol1/_data",
          "CreatedAt": "2024-04-02T08:11:05.344065435Z",
          "Labels": {},
          "Scope": "local",
          "Options": {},
          "MountCount": 0,
          "NeedsCopyUp": true,
          "LockNumber": 0
     }
]
```

Estamos utilizando un usuario sin privilegios en el host con UID = 1000. Veamos el propietario del directorio donde se almacenan los ficheros del volumen en el host:

```
$ id
uid=1000(usuario) gid=1000(usuario) groups=1000(usuario),4(adm),10(wheel),190(systemd-journal) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023

$ ls -ld .local/share/containers/storage/volumes/vol1/_data/
drwxr-xr-x. 1 usuario usuario 0 Jan 26 17:53 .local/share/containers/storage/volumes/vol1/_data/
```

Comprobamos que en el host el propietario es nuestro usuario sin privilegios.
Si creamos un fichero en el volumen desde el host o desde el contenedor:

```
$ touch .local/share/containers/storage/volumes/vol1/_data/fichero1
$ podman exec alpine1 touch /destino/fichero2
```

Comprobamos que dentro del contenedor pertenecen a `root`:

```
$ podman exec alpine1 ash -c "ls -l /destino"
total 0
-rw-r--r--    1 root     root             0 Apr  2 08:14 fichero1
-rw-r--r--    1 root     root             0 Apr  2 08:15 fichero2
```
Y que en el host pertenecen al usuario `usuario`:

```
$ ls -l .local/share/containers/storage/volumes/vol1/_data/
total 0
-rw-r--r--. 1 usuario usuario 0 Apr  2 08:14 fichero1
-rw-r--r--. 1 usuario usuario 0 Apr  2 08:15 fichero2
```

### Uso de bind mount con contenedores rootless con procesos en el contenedor ejecutándose como root

En este caso el uso de bind mount no tiene ninguna dificultad, ya que los usuarios del host y del contenedor están relacionados: el directorio que queremos montar pertenece al usuario `usuario` en el host y pertenece al usuario `root` en el contenedor.

Si tenemos activo SELinux tendremos que usar la opción `:z` o `:Z` según nos interese. El el directorio `web` tenemos un fichero `index.html`:

``` 
$ ls -l web
total 4
-rw-r--r--. 1 usuario usuario 15 Apr  2 07:53 index.html
```
Creamos el contenedor y comprobamos el propietario del fichero:

```
$ podman run -dit -v ${PWD}/web:/destino:Z --name alpine2 alpine

$ podman exec -it alpine2 ls -l /destino
total 4
-rw-r--r--    1 root     root            15 Apr  2 07:53 index.html
```

En resumen, el uso de volúmenes o bind mount en contenedores rootless cuando se ejecutan los procesos como `root` es muy similar a hacerlo con contenedores rootful. Simplemente tenemos que tener en cuenta que el directorio donde se crean los volúmenes se encuentra en el home del usuario: `$HOME/.local/share/containers/storage/volumes/`.

### Uso de volúmenes con contenedores rootless con procesos en el contenedor ejecutándose con usuario sin privilegios

El volumen lo crea el usuario del host, pero dentro del contenedor es propiedad del usuario del contenedor. Por lo tanto desde contenedor se puede escribir, pero desde fuera no se pueda escribir.

```
$ podman volume create vol2

$ podman run -dit -u 123:123 -v vol2:/destino --name alpine3 alpine

$ podman exec alpine3 touch /destino/fichero1

$ touch .local/share/containers/storage/volumes/vol2/_data/fichero2
touch: cannot touch '.local/share/containers/storage/volumes/vol2/_data/fichero2': Permission denied
```

Podemos ver el propietario del directorio: dentro del contenedor pertenece al usuario que hemos indicado, en este caso es `ntp` que tiene UID y GID igual a 123; fuera del contenedor el directorio donde se guarda la información del volumen pertenece al usuario cou UID 524410, que corresponde al UID que se ha mapeado fuera del contenedor.

```
$ podman exec -it alpine3 ls -ld destino
drwxr-xr-x    1 ntp      ntp             16 Apr  2 11:30 destino


$ ls -l .local/share/containers/storage/volumes/vol2
total 0
drwxr-xr-x. 1 524410 524410 16 Apr  2 11:30 _data

```

### Uso de bind mount con contenedores rootless con procesos en el contenedor ejecutándose con usuario sin privilegios

Creamos un directorio con un fichero que pertenecen al usuario sin privilegios, ne nuestro caso `usuario`:

```
$ mkdir origen
$ touch origen/fichero1
```

Creamos un contador y montamos el directorio `origen` con la opción `:Z` para configurar de forma adecuada SELinux y sea accesible desde el contenedor. Comprobamos que al pertenecer el directorio `origen` a nuestro usuario `usuario`, el directorio `destino` será propiedad del `root` (mapeo de `usuario`) y por lo tanto el usuario con UID 123 no podrá acceder al directorio:

```
$ podman run -dit -u 123:123 -v ./origen:/destino:Z --name alpine4 alpine

$ podman exec -it alpine4 ls -ld destino
drwxr-xr-x    1 root     root            16 Apr  2 14:28 destino

$ podman exec alpine4 touch /destino/fichero2
touch: /destino/fichero2: Permission denied
```

Para que el usuario con UID 123 pueda acceder al directorio tenemos que asegurarnos que el directorio `destino` le pertenece. Para conseguir esto lo podemos hacer de dos formas distintas:

1. A la hora de montar el directorio utilizar la opción `:U` que cambia el usuario y grupo de forma recursiva al directorio montado dentro del contenedor con el usuario y grupo que se esté ejecutando dentro del contenedor. En nuestro caso, creamos un nuevo contenedor con dicha opción:

     ```
     $ podman run -dit -u 123:123 -v ./origen:/destino:Z,U --name alpine4 alpine

     $ podman exec -it alpine2 ls -ld destino
     drwxr-xr-x    1 ntp      ntp             16 Apr  2 14:28 destino
     
     $ podman exec alpine4 touch /destino/fichero2
     ```

2. Otra opción sería cambiar el propietario del directorio `origen` en el host con el UID y GID del usuario que se ejecuta dentro del contenedor. Para ello es necesario que esa instrucción la ejecutemos en el espacio de nombres de usuario del contenedor, para ello usaremos la instrucción `podman unshare`:

     ```
     $ podman unshare chown -R 123:123 origen
     ```

     Comprobamos que en fuera del contenedor el UID que se asigna es el correspondiente al mapeo de UID realizado:

     ```
     $ ls -ld origen
     drwxr-xr-x. 1 524410 524410 32 Apr  2 14:39 origen
     ```

     Creamos un nuevo contenedor y comprobamos que dentro del contenedor el cambio de propietario se refleja de forma y correcta (pertenece al usuario `ntp:ntp`, que corresponde con el UID y GID 123) y ahora si podemos acceder al directorio:

     ```
     $ podman run -dit -u 123:123 -v ./origen:/destino:Z --name alpine5 alpine

     $ podman exec -it alpine5 ls -ld destino
     drwxr-xr-x    1 ntp      ntp             32 Apr  2 14:39 destino

     $ podman exec -it alpine5 ls -l destino
     total 0
     -rw-r--r--    1 ntp      ntp              0 Apr  2 14:28 fichero1
     -rw-r--r--    1 ntp      ntp              0 Apr  2 14:39 fichero2

     $ podman exec -it alpine5 touch destino/fichero3
     ```

## Redes en contenedores rootless

Cuando trabajamos con contenedores rootless tenemos varios mecanismos para ofrecer conectividad al contenedor:

### Red slirp4netns

Es el mecanismo de red que se utiliza por defecto. 

El proyecto [**slirp4netns**](https://github.com/rootless-containers/slirp4netns) crea un entorno de red aislado para el contenedor y utilizando el módulo `slirp` del kernel para realizar la traducción de direcciones de red (NAT), lo que permite que el contenedor acceda a internet a través de la conexión de red del host.

Tenemos algunas limitaciones, la más importante es que los usuarios no privilegiados no pueden usar puertos privilegiados (menores que 1024). 

```
$ podman run -dt --name webserver -p 80:80 quay.io/libpod/banner
Error: rootlessport cannot expose privileged port 80, you can add 'net.ipv4.ip_unprivileged_port_start=80' to /etc/sysctl.conf (currently 1024), or choose a larger port number (>= 1024): listen tcp 0.0.0.0:80: bind: permission denied
```

Podríamos cambiar ese comportamiento cambiando con `sysctl` el valor de `net.ipv4.ip_unprivileged_port_start` que por defecto tiene el valor de 1024.

```
sysctl net.ipv4.ip_unprivileged_port_start
net.ipv4.ip_unprivileged_port_start = 1024
```

Volvemos a crear el contenedor, teniendo en cuenta lo anterior:

```
$ podman run -dt --name webserver -p 8080:80 quay.io/libpod/banner
```

Y comprobamos su configuración de red:

```
$ podman exec webserver ip a
...
2: tap0: <BROADCAST,UP,LOWER_UP> mtu 65520 qdisc fq_codel state UNKNOWN qlen 1000
    link/ether 86:b3:30:2a:85:0e brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.100/24 brd 10.0.2.255 scope global tap0

$ podman exec webserver ip r
default via 10.0.2.2 dev tap0 
...
```
Vemos que se ha creado una interfaz virtual `tap0` con dirección 10.0.2.100 y puerta de enlace 10.0.2.2, que nos proporciona una conexión con la red del host, para permitir que este contenedor tenga conectividad con el exterior.

A continuación, vamos a crear un nuevo contenedor y volvemos a comprobar su configuración de red:

```
$ podman run -it --name cliente alpine
/ # ip a
...
2: tap0: <BROADCAST,UP,LOWER_UP> mtu 65520 qdisc fq_codel state UNKNOWN qlen 1000
    link/ether 12:ef:67:bd:21:1f brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.100/24 brd 10.0.2.255 scope global tap0
/ # ip r
default via 10.0.2.2 dev tap0 
```

Como podemos comprobar dicho contenedor tiene la misma configuración de red que el anterior. Los dos contenedores utilizan el mismo **espacio de nombres de red**, como consecuencia **los contenedores están completamente aislados unos de otros**, por lo que tendrán que utilizar los puertos expuestos para comunicarse y la dirección IP del host (en mi caso la 10.0.0.67):

```
/ # apk add curl
/ # curl http://10.0.0.67:8080
   ___          __              
  / _ \___  ___/ /_ _  ___ ____ 
 / ___/ _ \/ _  /  ' \/ _ `/ _ \
/_/   \___/\_,_/_/_/_/\_,_/_//_/
```

#### Red por defecto en contenedores rootless con Podman 5.0

En la nueva versión de Podman, se ha cambiado el mecanismo de red de slirp4netns a [pasta](https://passt.top/passt/about/#pasta-pack-a-subtle-tap-abstraction). Este nuevo mecanismo ofrece mejor rendimiento y más funciones.

En este caso la configuración de red de todos los contenedores rootless sería la siguiente:

```
$ podman run -it --rm alpine ip a
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 65520 qdisc fq_codel state UNKNOWN qlen 1000
    link/ether 42:61:0e:89:08:41 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.40/24 brd 10.0.0.255 scope global noprefixroute eth0
...
$ podman run -it --rm alpine ip r
default via 10.0.0.1 dev eth0  metric 100 
10.0.0.0/24 dev eth0 scope link  metric 100 
...
```

### Red bridge por defecto

El uso de una **Red Bridge**, nos permite que los contenedores estén conectados a una red privada, con un direccionamiento privado conectado al host mediante un Linux Bridge. 

Existen dos tipos de redes bridge:

* La red **bridge** creada por defecto por Podman para que de forma predeterminada los contenedores tengan conectividad.
* Y las **redes bridge definidas por el usuario**.

Las características más importantes de la **red bridge por defecto** son las siguientes:
    
* Se crea en el host un *Linux Bridge* llamado **podman0**.
* El direccionamiento de esta red es 10.88.0.0/16.
* Usamos el parámetro `--publish` o `-p` en `podman run` para exponer algún puerto. Se crea una regla DNAT para tener acceso al puerto.
* Los contenedores conectados a un red **bridge** tiene acceso a internet por medio de una regla SNAT.
* Es la red por defecto donde se conectan los contenedores rootful.
* Un contenedor rootless se puede conectar a esta red indicándolo con el parámetro `--network=podman` del comando `podman run`.
* Por compatibilidad con las red por defecto que crea Docker, esta red no tiene un servidor DNS activo.
Como hemos visto anteriormente podemos conectar nuestros contenedores rootless a la red bridge por defecto:

```
$ podman run -d -p 8080:80 --network=podman --name contenedor1 quay.io/libpod/banner

$ $ podman exec -it contenedor1 ip a
...
2: eth0@if5: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP qlen 1000
    link/ether ee:93:61:6b:47:ca brd ff:ff:ff:ff:ff:ff
    inet 10.88.0.3/16 brd 10.88.255.255 scope global eth0
...
```

Y comprobamos el acceso al servidor web:

```
$ curl http://localhost:8080
```

## Red bridge definida por el usuario

Un usuario sin privilegios pueden definir sus propias redes bridge. Estas redes se crearán en el espacio de nombres de red del usuario:

```
$ podman network create mi_red

$ podman run -d -p 8081:80 --name servidorweb --network mi_red docker.io/nginx
$ podman run -it --name cliente --network mi_red alpine
```

Teste tipo de redes ofrecen un servidor DNS, que nos permite usar el nombre de los contenedores es para conectarnos entre ellos:

```
# ping servidorweb
PING servidorweb (10.89.2.3): 56 data bytes
64 bytes from 10.89.2.3: seq=0 ttl=42 time=0.370 ms
...
```
Una característica que tenemos que tener en cuenta, es que esta nueva red se ha creado en el espacio de nombres de red del usuario, por lo tanto desde el host no tenemos conectividad con el contenedor:

```
$ ping 10.89.2.3
PING 10.89.2.3 (10.89.2.3) 56(84) bytes of data.
...
```

Sin embargo, si podemos acceder a la IP del host y al puerto que hemos mapeado para acceder a la aplicación:

```
$ curl http://localhost:8081
```

En este caso el *Linux Bridge* que se ha creado con la nueva red, no se ha creado en el espacio de red del host. Podemos comprobar que el bridge `podman3` no se ha creado en el host ejecutando `sudo ip a`.

Sin embargo, podemos acceder al espacio de nombres de red del usuario ejecutando la siguiente instrucción:

```
$ podman unshare --rootless-netns ip a
...
2: tap0: <BROADCAST,UP,LOWER_UP> mtu 65520 qdisc fq_codel state UNKNOWN group default qlen 1000
    link/ether 76:eb:49:a9:64:2a brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.100/24 brd 10.0.2.255 scope global tap0
   ...
3: podman3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 1a:3a:83:8d:1e:b9 brd ff:ff:ff:ff:ff:ff
    inet 10.89.2.1/24 brd 10.89.2.255 scope global podman3
    ...
```

Con el parámetro `--rootless-netns` de `podman unshare` accedemos al espacio de nombres de red del usuario, donde comprobamos la interfaz de red de tipo tap usada por slirp4netns, y los Linux Bridge que se van creando con cada una de las redes bridge definidas por el usuario sin privilegios.

Por ejemplo, accediendo al espacio de nombres de red del usuario, comprobamos que si tenemos conectividad con el contenedor:

```
$ podman unshare --rootless-netns ping 10.89.2.3
PING 10.89.2.3 (10.89.2.3) 56(84) bytes of data.
64 bytes from 10.89.2.3: icmp_seq=1 ttl=64 time=0.135 ms
...
```


## Red host

Si al crear un contenedor indicamos `--network=host`, la pila de red de ese contenedor no está aislada del host, es decir, el contenedor no tiene asignada su propia dirección IP. Por ejemplo, si ejecutas un contenedor que ofrece su servicio en al puerto 80/tcp y utilizas el modo de red host, la aplicación del contenedor estará disponible en el puerto 80/tcp de la dirección IP del host.

Teniendo en cuenta las limitaciones que tenemos al crear contenedores rootless, en este caso un usuario sin privilegios no puede usar puertos no privilegiados, por debajo del 1024. Por lo tanto vamos a usar una imagen de nginx que ejecuta el servidor nginx con un usuario sin privilegios y por lo tanto lo levanta en el puerto 8080/tcp.

Vamos a usar la imagen de nginx ofrecida por la empresa Bitnami, esta imagen tienen como característica que los procesos que se ejecutan al crear el contenedor son ejecutados por usuarios no privilegiados.

```
$ podman run -d --network host --name my_nginx docker.io/bitnami/nginx
```

Y podemos acceder al puerto 8080/tcp para comprobar que podemos acceder al servicio web.



