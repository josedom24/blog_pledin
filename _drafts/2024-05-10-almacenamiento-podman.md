---
title: 'Almacenamiento en los contenedores rootless con Podman'
permalink: /2024/04/rootless-podman/
tags:
  - Podman
  - Virtualización
---

![podman]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/04/podman-logo3.png){: .align-center }

Cuando se elimina un contenedor, la capa del contenedor de lectura y escritura también se elimina, por lo que podemos afirmar que los **contenedores son efímeros**. Sus datos se pierden al ser eliminados.

Podman nos proporciona varias soluciones para persistir los datos de los contenedores, los más importantes son:

* **Volúmenes Podman**, directorios creados por Podman que podemos montar en el contenedor.
    * Un volumen corresponde a un directorio en el host, por tanto, la información se almacena en una parte del sistema de ficheros que es gestionada por Podman.
        * Si lo creamos con el usuario `root`: `/var/lib/containers/storage/volumes`.
        * Si lo creamos con un usuario sin privilegios: `$HOME/.local/share/containers/storage/volumes`.
    * Cuando se usa un volumen en un contenedor, el directorio correspondiente se monta en el sistema de archivo del contenedor.
    * Los procesos ajenos a Podman no deben modificar esta parte del sistema de archivos.
    * Un volumen dado puede ser montado en múltiples contenedores simultáneamente. 
    * Cuando ningún contenedor en ejecución está utilizando un volumen, el volumen sigue estando disponible para Podman y no se elimina automáticamente. 
    * Cuando creas un volumen, puede tener nombre o ser anónimo. 
    * A los volúmenes anónimos se les da un nombre aleatorio que se garantiza que sea único dentro del host.
    * La gestión de los volúmenes se hace con el comando `podman volume`.
    * Cuando usar los volúmenes:
* Los **bind mount**, montaje de un directorio o archivo desde el host en el contenedor.
    * Nos permite que un archivo o directorio del host se monte en un contenedor.
    * El archivo o directorio es referenciado por su ruta completa en el host.
    * No es necesario que el archivo o directorio ya exista en el host. Se crea bajo demanda si aún no existe.
    * No puedes utilizar el cliente Podman para gestionarlos.
    * Al realizar cambios sobre los ficheros del bind mount en el anfitrión, se cambian directamente en el contenedor.

## Almacenamiento y SELinux

SELinux, que significa "Security-Enhanced Linux" (Linux con seguridad mejorada), es una función de seguridad para sistemas operativos Linux que proporciona un control avanzado sobre los permisos de acceso del sistema. 

Cuando trabajamos con Podman en un sistema operativo en que SELinux está activo, tenemos que tener en cuenta algunas consideraciones a la hora de montar directorios en los contenedores.

SELinux configura ciertos directorios de manera adecuada para que puedan ser accesibles por Podman y los contenedores. Esto se hace para garantizar que los contenedores puedan funcionar correctamente y acceder a los recursos necesarios.

Sin embargo, cuando se trata de otros directorios que no están configurados de forma predeterminada para ser accesibles por Podman y los contenedores, es posible que estos no puedan acceder a ellos debido a las políticas de seguridad de SELinux. SELinux puede aplicar restricciones sobre qué procesos pueden acceder a qué recursos, y si un directorio no está configurado adecuadamente o si está fuera del contexto permitido por SELinux, los contenedores pueden tener dificultades para acceder a él.

Deberemos aplicar etiquetas de contexto adecuadas a los directorios para permitir el acceso de los contenedores según sea necesario. 

## Uso de almacenamiento en contenedores

En la creación de contenedores con `podman run` puedo indicar que vamos a usar almacenamiento para guardar la información de ciertos directorios. Tanto en el caso de uso de volúmenes como en el caso del uso de bind mount podemos indicar el uso de almacenamiento en la creación de un contenedor con las siguientes parámetros del comando `podman run`:

* El parámetro `--volume` o `-v`
* El parámetro `--mount`

En general, `--mount` es más explícito y detallado. La mayor diferencia es que la sintaxis `-v` combina todas las opciones en un solo campo, mientras que la sintaxis `--mount` las separa.

* Si usamos `-v` se debe indicar tres campos separados por dos puntos:
    * El primer campo es el nombre del volumen, debe ser único en una determinada máquina. Para volúmenes anónimos, el primer campo se omite.
    * El segundo campo es la ruta donde se montan el archivo o directorio en el contenedor.
    * El tercer campo es opcional, y es una lista de opciones separadas por comas, la más utilizadas son:
        * `:ro`: Para indicar que el montaje es de sólo lectura.
        * `:z`: Cuando trabajamos en sistemas operativos con SELinux nos permite cambiar la etiqueta del contexto de seguridad del directorio para que sea accesible desde el contenedor. Además el directorio podrá ser compartido con otros contenedores.
        * `:Z`: Cuando trabajamos en sistemas operativos con SELinux nos permite cambiar la etiqueta del contexto de seguridad del directorio para que sea accesible desde el contenedor, pero de forma privada, no se podrá compartir con otros contenedores.
* Si usamos `--mount` hay que indicar un conjunto de datos de la forma `clave=valor`, separados por coma.
    * Clave `type`: Indica el tipo de montaje. Los valores pueden ser `bind`, `volume`, `tmpfs` `devpts`, `glob`, `image` o `ramfs`.
    * Clave `source` o `src`: La fuente del montaje. Se indica el volumen o el directorio que se va montar con bind mount.
    * Clave `dst` o `target`: Será la ruta donde está montado el fichero o directorio en el contenedor. 
    * Se pueden indicar opciones según el tipo de la fuente de montaje, en el caso de los volúmenes y los bind mount, las opciones más utilizadas son:
        * La opción `readonly` o `ro` es optativa, e indica que el montaje es de sólo lectura.
        * `relabel`, puede tener dos valores: `shared` funcionaría de forma similar a cómo lo hace la opción `:z` en el caso de utilizar la sintaxis `-v`, y `private` funcionaría de forma similar a utilizar la opción `:Z`.


## Trabajando con almacenamiento en contenedores rootless

### Gestionando volúmenes

Algunos comandos útiles para trabajar con volúmenes, son los siguientes.

Podemos crear un volumen indicando su nombre:

```
$ podman volume create my-vol
```

Para listar los volúmenes que tenemos creados:

```
$ podman volume ls
DRIVER      VOLUME NAME
local       my-vol
```

Para obtener información de un volumen:

```
$ podman volume inspect my-vol
[
     {
          "Name": "my-vol",
          "Driver": "local",
          "Mountpoint": "/var/lib/containers/storage/volumes/my-vol/_data",
          "CreatedAt": "2024-03-31T18:14:36.528093953Z",
          "Labels": {},
          "Scope": "local",
          "Options": {},
          "MountCount": 0,
          "NeedsCopyUp": true,
          "NeedsChown": true,
          "LockNumber": 0
     }
]
```

Y para eliminar un volumen, ejecutamos:

```
$ podman volume rm my-vol
```

Si queremos borrar todos los volúmenes que no están siendo usados por al menos un contenedor:

```
$ podman volume prune
WARNING! This will remove all volumes not used by at least one container. 
...
Are you sure you want to continue? [y/N]
```

También podemos ejecutar:

```
$ podman volume rm --all
```

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

Podemos ver el propietario del directorio: dentro del contenedor pertenece al usuario que hemos indicado, en este caso es `ntp` que tiene UID y GID igual a 123; fuera del contenedor el directorio donde se guarda la información del volumen pertenece al usuario con UID 524410, que corresponde al UID que se ha mapeado fuera del contenedor.

```
$ podman exec -it alpine3 ls -ld destino
drwxr-xr-x    1 ntp      ntp             16 Apr  2 11:30 destino


$ ls -l .local/share/containers/storage/volumes/vol2
total 0
drwxr-xr-x. 1 524410 524410 16 Apr  2 11:30 _data

```

##  Uso de bind mount con contenedores rootless con procesos en el contenedor ejecutándose con usuario sin privilegios

Creamos un directorio con un fichero que pertenecen al usuario sin privilegios, en nuestro caso `usuario`:

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