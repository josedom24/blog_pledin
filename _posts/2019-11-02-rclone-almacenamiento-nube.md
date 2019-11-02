---
title: 'rclone: Gestionando nuestros servicios de almacenamiento en la nube'
permalink: /2019/11/rclone-almacenamiento-nube/
tags:
  - Cloud
  - rclone
---

![rclone]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2019/11/rclone.png){: .align-center }

[rclone](https://rclone.org/) es una herramienta que nos permite trabajar con los ficheros que tenemos almacenados en distintos servicios de almacenamiento en la nube (dropbox, google drive, mega, box, ... y muchos más que puedes ver en su página principal). Por lo tanto con `rclone` podemos gestionar y sincronizar los ficheros de nuestros servicios preferidos desde la línea de comandos. 

La versión que obtenemos de los repositorios de Debian Buster es la 1.45-3, pero si queremos muchos más proveedores cloud para configurar es recomendable bajarse la última versión (en el momento de escribir este artículo, la versión 1.49.5) que encontraremos en la [página de descarga](https://rclone.org/downloads/). Nos descargamos el fichero `deb` y los instalamos en nuestro servidor:

    $ wget https://downloads.rclone.org/v1.49.5/rclone-v1.49.5-linux-amd64.deb
    $ dpkg -i rclone-v1.49.5-linux-amd64.deb

    $ rclone version
    rclone v1.49.5
    - os/arch: linux/amd64
    - go version: go1.12.10

## Configuración de los proveedores cloud

A continuación vamos a configurar distintos proveedores cloud, para ello se utilizan distintas formas según la API del proveedor: usuario y contraseña del servicio, autentifcación oauth y autorización por parte del servicio, ...

<!--more-->

### Configuración de mega

Para configurar un nuevo proveedor ejecutamos:

    $ rclone config

Y elegimos la opción:

    n) New remote

Los datos que tenemos que indicar son los siguientes:

* Un nombre con el que vamos a identificar este proveedor.
* De las lista de proveedores elegimos el que nos interesa indicando el número, en el caso de mega es el 18.
* El nombre de usuario y la contraseña de la cuenta.
* Para nuestro ejemplo no vamos a introducir la configuración avanzada.

Por lo tanto los pasos serían:

    # rclone config
    n) New remote
    s) Set configuration password
    q) Quit config
    n/s/q> n
    name> mega1
    Type of storage to configure.
    Enter a string value. Press Enter for the default ("").
    Choose a number from below, or type in your own value
     ...
    18 / Mega
       \ "mega"
    ...
    Storage> 18
    ** See help for mega backend at: https://rclone.org/mega/ **

    User name
    Enter a string value. Press Enter for the default ("").
    user> tucorreo@correo.com
    Password.
    y) Yes type in my own password
    g) Generate random password
    y/g> y
    Enter the password:
    password:*********
    Confirm the password:
    password:*********
    Edit advanced config? (y/n)
    y) Yes
    n) No
    y/n> n

Vamos a verlo en un vídeo:

<script id="asciicast-E9nBhgIM9IHfvpEsYDhRgwkLC" src="https://asciinema.org/a/E9nBhgIM9IHfvpEsYDhRgwkLC.js" async></script>


### Configurando dropbox

Cuando hemos configurado una cuenta con mega hemos usado como método de autentificación el nombre de usuario y la contraseña. La mayoría de proveedores van a usar oAuth2 como método de autentificación, es el caso , por ejemplo de dropbox. en este caso tenemos dos formas de autentificarnos:

1. dando de alta una nueva aplicación en el servicio deseado, y obtener las credenciales (identificador de usuario, token de autentificación,...)
2. Desde un navegador web autentificarnos en el servicio y da permiso a la aplicación `rclone` para que gestione nuestros ficheros.

Nosotros vamos a optar por esta segunda opción, sin embargo si estamos instalando rclone en un sistema operativo sin entorno gráfico debemos autorizar la aplicación desde un ordenador con entorno gráfico donde podamos a acceder a una navegador, lo veremos a continuación (más opciones de configuración la puedes encontrar en la documentación: [Configuring rclone on a remote / headless machine](https://rclone.org/remote_setup/).

Para configurar un proveedor de dropbox:

    $ rclone config

Y elegimos la opción:

    n) New remote

    ...
    name> dropbox
    ...
    Choose a number from below, or type in your own value
     ...
    8 / Dropbox
      \ "dropbox"
    ...
    Storage> 8
    ...
    Use auto config?
     * Say Y if not sure
     * Say N if you are working on a remote or headless machine
    y) Yes
    n) No
    y/n> n
    For this to work, you will need rclone available on a machine that has a web browser available.
    Execute the following on your machine (same rclone version recommended) :
    	rclone authorize "dropbox"
    Then paste the result below:
    result> 


Como estamos configurando `rclone` en una máquina sin entorno gráfico, ahora es el momento en el que tenemos que ejecutar el comando `rclone authorize "dropbox"` en una máquina con entorno gráfico, acceder al navegador, autentificarse y configurar los permisos de la aplicación:

    $ rclone authorize "dropbox"
    If your browser doesn't open automatically go to the following link: http://127.0.0.1:53682/auth?state=212ac74326029a80a8d4aa0a707838ed
    Log in and authorize rclone for access
    Waiting for code...

Accdemos al navegador:

![dropbox]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2019/11/dropbox1.png){: .align-center }

Y damos permisos a la aplciación:
    
![dropbox]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2019/11/dropbox2.png){: .align-center }

Obtenemos una página que nos informa que todo ha ido bien ("Success!") y volvemos al terminal:
    
    Got code
    Paste the following into your remote machine --->
    {"access_token":"xxxxxxxxxxxxAAAAAAY2nfpKZKmI4tIDiy_ya37Tf1MT3no2rGW5PcV3znHJq0i","token_type":"bearer","expiry":"0001-01-01T00:00:00Z"}
    <---End paste

Y como se nos indica tenemos que copia y pegar la línea obtenida en nuestro servidor remoto donde estamos trabajando con `rclone`:

    result> {"access_token":"xxxxxxxxxxxxAAAAAAY2nfpKZKmI4tIDiy_ya37Tf1MT3no2rGW5PcV3znHJq0i","token_type":"bearer","expiry":"0001-01-01T00:00:00Z"}
    ...
    y) Yes this is OK
    ...
    y/e/d> y

Para finalizar podemos ver los proveedores que hemos configurado:

    $ rclone config
    Current remotes:

    Name                 Type
    ====                 ====
    dropbox              dropbox
    mega1                mega
    ...

Toda la información de estos servidores remotos los va almacenando en el fichero `~/.config/rclone/rclone.conf`.


Lo vemos en un vídeo:

<script id="asciicast-gw1K6n7ktaSu3AGTRgZPzKEzd" src="https://asciinema.org/a/gw1K6n7ktaSu3AGTRgZPzKEzd.js" async></script>

## Gestionando nuestros ficheros con rclone

Una vez que tenemos configurado el proveedor podríamos empezar a gestionalos ejecutando distintos subcomandos, por ejemplo usando nuestra cuenta de dropbox:

1. Podemos listar todos los ficheros del servicio:

        rclone ls dropbox:

2. Podemos listar los directorios que tenemos:

        rclone lsd dropbox:

3. Podemos crear un directorio:

        rclone mkdir dropbox:/prueba

4. Y copiar un fichero desde nuestro ordenador a la carpeta que hemos creado:

        rclone copy info.txt dropbox:/prueba
        rclone ls dropbox:/prueba
        2072006 info.txt

5. Tambien se pueden hacer operaciones entre varios servicios, por ejemplo copiar el fichero `info.txt` que acabamos de subir a dropbox, a un directorio de mega:

        rclone mkdir mega1:/prueba
        rclone copy dropbox:/prueba/info.txt mega1:/prueba
        rclone ls mega1:/prueba
        2072006 info.txt

Puedes ver todas las operaciones que puedes hacer con tus servicios de almacenmaineto en la nube en la [documentación de rclone](https://rclone.org/docs/).

Podemos ver estas operaciones en un vídeo:

<script id="asciicast-5GJmnlatyGvad57kH9ZxNPzs8" src="https://asciinema.org/a/5GJmnlatyGvad57kH9ZxNPzs8.js" async></script>

Como hemos visto `rclone` es una herramienta muy interesante para gestionar nuestros servicios de almacenamiento en la nube. En la próxima entrada veremos como podemos usarlo junto a Nextcloud para gestionar todo nuestro almacenamiento de forma centralizada.