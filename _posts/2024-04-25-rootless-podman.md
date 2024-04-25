---
title: 'Introducción a los contenedores rootles con Podman'
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

