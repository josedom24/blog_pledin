# Almacenamiento en la nube: nextcloud, rclone, webdav, backup, ...

En este artículo os cuento mis entretenimiento en las últimas semanas, jugando con nextcloud y ampliando su espacio de almacenamiento usando la aplicación `rclone`. Con estas herramientas, y otras como un servidor `webdav` podemos automatizar fácilmente nuestras copias de seguridad en la nube. Veamos cada una de estas aplicaciones:

## Nextcloud

[Nextcloud](https://nextcloud.com/) es una aplicación web escrita en PHP cuyo objetivo es crear un servidor de alojamiento de archivos en cualquier servidor personal. Tiene la misma funcionalidad de otros servicios de almacenamiento en la nube, como Dropbox, pero la gran diferencia es que Nextcloud es de código abierto, por lo que podemos instalarlo y adaptarlos a nuestras necesidades.

Para poder instalar la aplicación Nextcloud necesitamos instalar un servidor LAMP, que podemos hacer de forma sencilla en *Debian Buster* de la siguiente forma:

1. Instalamos Apache2 como servidor web:

        apt install apache2

2. Instalamos el servidor de base de datos:

        apt install mariadb-server

    A continuación accedemos al servidor y creamos la base de datos y el usuario con el que nos vamos a conectar a la base de datos:

        $ mysql -u root -p

        > CREATE DATABASE nextcloud;
        > CREATE USER 'usernextcloud'@'localhost' IDENTIFIED BY 'passnextcloud';
        > GRANT ALL PRIVILEGES ON nextcloud.* to 'usernextcloud'@'localhost';
        > FLUSH PRIVILEGES;
        > quit

3. Instalamos la versión de php, así como la libería para que php pueda conectarse a la base de datos (por dependencia se instala el módulos de apache2 `libapache2-mod-php7.3` que permite que el servidor web ejecute código php):

        apt install php7.3 php7.3-mysql

A continuación nos bajamos la aplicación Nextcloud de la página oficial de descargas y lo descomprimimos en el el DocumentRoot, en nuestro caso como vamos a usar el virtualhost `default` será el directorio `/var/www/html/`.

Accedemos a nuestro servidor y comenzamos con la configuración de la aplicación:

Siguiendo la documentación necesitamos instalar algunas librerías más de php:

    apt install php-zip php-xml php-gd php-curl php-mbstring

Ya tenemos instalada nuestra aplicación Nextcloud.

## rclone

[rclone](https://rclone.org/) es una herramienta que nos permite trabajar con los ficheros que tenemos almacenados en distintos servicios de almacenamiento en la nube (dropbox, google drive, mega, box, ... y muchos más que puedes ver en su página principal). Por lo tanto con `rclone` podemos gestionar y sincronizar los ficheros de nuestro servicios preferidos desde la línea de comandos. 

La versión que obtenemos de los repositorios de Debian Buster es la 1.45-3, pero si queremos muchos más proovedores cloud para configurar es recomendable bajarse la última versión (en el momento de escribir este artículo la versión 1.49.5) que encontraremos en la [página de descarga](https://rclone.org/downloads/). Nos descarghamos el fichero `deb` y los instalamos en nuestro servidor:

    $ wget https://downloads.rclone.org/v1.49.5/rclone-v1.49.5-linux-amd64.deb
    $ dpkg -i rclone-v1.49.5-linux-amd64.deb

    $ rclone version
    rclone v1.49.5
    - os/arch: linux/amd64
    - go version: go1.12.10




### Configuración de loc proveedores cloud

A continuación vamos a configurar distintos proveedores cloud, para ello se utilizan distintas formas según la API del proveedor: usuario y contraseña del servicio, autentifcación oauth y autorización por parte del servicio, ...

#### Configuración de mega

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
    user> tucorreo@gmail.com
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

Una vez que tenemos configurado el proveedor podríamos empezar a gestionarlo ejecutando distintos subcomandos, por ejemplo: 




#### Configurando dropbox

Para configurar un nuevo proveedor ejecutamos:

    $ rclone config

Y elegimos la opción:

    n) New remote

A continuación indicamos el nombre con el que vamos a identifica al servicio, elegimos el proveedor de una lista y en el caso de dropbox indicamos el nombre de usuario y la contraseña (la contraseña se guardará cifrada en el fichero de configuración):


https://rclone.org/remote_setup/


